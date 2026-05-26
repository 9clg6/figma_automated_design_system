#!/usr/bin/env node

/**
 * figma-to-widget.mjs
 *
 * Per-component Figma → Flutter widget generator.
 * Inspired by VGV's 6-phase workflow.
 *
 * Usage:
 *   node scripts/figma-to-widget.mjs <figma-url>
 *   node scripts/figma-to-widget.mjs https://www.figma.com/design/Cu4NB44bcURKEy40DEfwWi/Design-system-1.0?node-id=58558-395
 *
 * Phases:
 *   1. Parse URL → extract file_key + node_id
 *   2. Fetch component data (variants, properties) + screenshot via REST
 *   3. Claude analyzes variants → deduces Dart props/enums
 *   4. Claude generates widget + golden test
 *   5. Write files
 *   6. (Future) Visual comparison loop
 *
 * Widget conventions:
 *   - Presentation only — no business logic, no Riverpod
 *   - Callbacks via constructor (onTap, onChanged, etc.)
 *   - setState for local UI state only (hover, pressed, etc.)
 *   - One widget per file
 *   - All values from theme (ColorScheme, TextTheme, AppSpacing)
 */

import { readFileSync, writeFileSync, mkdirSync, existsSync } from 'node:fs';
import { join, resolve, dirname } from 'node:path';
import Anthropic from '@anthropic-ai/sdk';

// ── Config ─────────────────────────────────────────────────────
const ROOT = resolve(import.meta.dirname, '..');
const CONFIG_PATH = join(ROOT, 'config', 'figma-map.json');
const WIDGETS_DIR = join(ROOT, 'lib', 'widgets');
const TESTS_DIR = join(ROOT, 'test', 'widgets');

const FIGMA_TOKEN = process.env.FIGMA_TOKEN;
const ANTHROPIC_API_KEY = process.env.ANTHROPIC_API_KEY;

if (!FIGMA_TOKEN) {
  console.error('❌ FIGMA_TOKEN env var required');
  process.exit(1);
}
if (!ANTHROPIC_API_KEY) {
  console.error('❌ ANTHROPIC_API_KEY env var required');
  process.exit(1);
}

const MODEL = 'claude-sonnet-4-20250514';
const MAX_TOKENS = 16384;

// ── Parse Figma URL ────────────────────────────────────────────
function parseFigmaUrl(url) {
  // Formats:
  //   https://www.figma.com/design/FILE_KEY/Name?node-id=123-456
  //   https://www.figma.com/file/FILE_KEY/Name?node-id=123-456
  const match = url.match(
    /figma\.com\/(?:design|file)\/([a-zA-Z0-9]+)\/[^?]*\?.*node-id=([0-9]+-[0-9]+)/,
  );
  if (!match) {
    throw new Error(`Invalid Figma URL: ${url}`);
  }
  return {
    fileKey: match[1],
    nodeId: match[2].replace('-', ':'), // URL format: 123-456 → API format: 123:456
  };
}

// ── Figma API ──────────────────────────────────────────────────
const BASE = 'https://api.figma.com/v1';
const headers = { 'X-Figma-Token': FIGMA_TOKEN };

async function figmaGet(endpoint, retries = 5) {
  const url = `${BASE}${endpoint}`;
  for (let attempt = 1; attempt <= retries; attempt++) {
    const res = await fetch(url, { headers });
    if (res.status === 429) {
      const wait = Math.min(2 ** attempt * 5000, 60000);
      console.log(
        `   ⏳ Rate limited, waiting ${wait / 1000}s (attempt ${attempt}/${retries})...`,
      );
      await new Promise((r) => setTimeout(r, wait));
      continue;
    }
    if (!res.ok) {
      throw new Error(
        `Figma API ${endpoint}: ${res.status} ${res.statusText}`,
      );
    }
    return res.json();
  }
  throw new Error(
    `Figma API ${endpoint}: rate limited after ${retries} retries`,
  );
}

async function figmaGetImage(fileKey, nodeId) {
  const data = await figmaGet(
    `/images/${fileKey}?ids=${encodeURIComponent(nodeId)}&format=png&scale=2`,
  );
  const imageUrl = data.images?.[nodeId];
  if (!imageUrl) return null;

  const res = await fetch(imageUrl);
  if (!res.ok) return null;
  const buffer = Buffer.from(await res.arrayBuffer());
  return buffer.toString('base64');
}

// ── Extract component info ─────────────────────────────────────
function extractComponentInfo(nodeData) {
  const doc = nodeData.document;
  const isComponentSet = doc.type === 'COMPONENT_SET';
  const isComponent = doc.type === 'COMPONENT';

  if (!isComponentSet && !isComponent) {
    // Navigate to find the component set or component
    const found = findFirstComponent(doc);
    if (found) return extractComponentData(found, nodeData);
    throw new Error(
      `Node is type "${doc.type}", not a COMPONENT or COMPONENT_SET. Navigate to the component in Figma.`,
    );
  }

  return extractComponentData(doc, nodeData);
}

function findFirstComponent(node) {
  if (node.type === 'COMPONENT_SET' || node.type === 'COMPONENT') return node;
  if (node.children) {
    for (const child of node.children) {
      const found = findFirstComponent(child);
      if (found) return found;
    }
  }
  return null;
}

function extractComponentData(node, fullData) {
  const info = {
    name: node.name,
    type: node.type,
    properties: {},
    variants: [],
    layout: {
      width: node.absoluteBoundingBox?.width,
      height: node.absoluteBoundingBox?.height,
      layoutMode: node.layoutMode,
      padding: {
        top: node.paddingTop,
        right: node.paddingRight,
        bottom: node.paddingBottom,
        left: node.paddingLeft,
      },
      itemSpacing: node.itemSpacing,
    },
  };

  // Extract component properties (from component set)
  if (node.componentPropertyDefinitions) {
    for (const [key, def] of Object.entries(
      node.componentPropertyDefinitions,
    )) {
      info.properties[key] = {
        type: def.type,
        defaultValue: def.defaultValue,
        variantOptions: def.variantOptions || [],
      };
    }
  }

  // Extract variants (children of component set)
  if (node.type === 'COMPONENT_SET' && node.children) {
    for (const variant of node.children) {
      const variantProps = {};
      // Parse variant name: "Size=40, Type=Icon, Status=Online"
      if (variant.name) {
        const parts = variant.name.split(',').map((p) => p.trim());
        for (const part of parts) {
          const [key, value] = part.split('=').map((s) => s.trim());
          if (key && value) variantProps[key] = value;
        }
      }

      info.variants.push({
        name: variant.name,
        id: variant.id,
        properties: variantProps,
        layout: {
          width: variant.absoluteBoundingBox?.width,
          height: variant.absoluteBoundingBox?.height,
          layoutMode: variant.layoutMode,
        },
        fills: variant.fills,
        effects: variant.effects,
        childCount: variant.children?.length || 0,
      });
    }
  } else if (node.type === 'COMPONENT') {
    // Single component, no variants
    info.variants.push({
      name: node.name,
      id: node.id,
      properties: {},
      layout: info.layout,
      fills: node.fills,
      effects: node.effects,
      childCount: node.children?.length || 0,
    });
  }

  // Collect style references
  info.styleRefs = {};
  if (fullData.styles) {
    info.styleRefs = fullData.styles;
  }

  return info;
}

// ── Slugify component name ─────────────────────────────────────
function slugify(name) {
  return name
    .replace(/[❖]/g, '')
    .trim()
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '_')
    .replace(/^_|_$/g, '');
}

function pascalCase(name) {
  return name
    .replace(/[❖]/g, '')
    .trim()
    .split(/[\s_-]+/)
    .map((w) => w.charAt(0).toUpperCase() + w.slice(1).toLowerCase())
    .join('');
}

// ── Build prompt ───────────────────────────────────────────────
function buildPrompt(componentInfo, screenshotBase64) {
  const systemPrompt = `You are a Flutter widget engineer. You generate production-ready, presentation-only Flutter widgets from Figma component data.

## Widget conventions — STRICT

### Architecture
- One widget per file
- Presentation only — NO business logic, NO Riverpod, NO providers
- All callbacks via constructor parameters (onTap, onChanged, onDismissed, etc.)
- setState ONLY for local UI state (hover, pressed, focused, expanded)
- Use const constructors wherever possible

### Theme integration
- ALL colors from Theme.of(context).colorScheme or ThemeExtension
- ALL text styles from Theme.of(context).textTheme
- ALL spacing from constants (e.g. AppSpacing.sm, AppSpacing.md)
- NEVER hardcode Color(0xFF...) in the widget — only in theme definitions
- NEVER hardcode font sizes or padding values

### From Figma variants to Dart
- Each Figma variant property → a Dart enum or typed parameter
- Variant property "Size=40,60,96" → enum with values
- Boolean variant "Loading?=True/False" → bool parameter
- Conditional rendering based on variant values → if/switch in build()
- Name enums descriptively (e.g. AvatarSize.small, not AvatarSize.s40)

### Code quality
- Extract sub-widgets as private StatelessWidget classes (not _build methods)
- Document the widget class with /// dartdoc
- Group parameters logically in the constructor
- Use required for non-optional params, provide defaults where sensible

## Output format

Return a JSON object with these fields:
{
  "widget_name": "PascalCase widget name",
  "file_name": "snake_case.dart",
  "enums": [
    {
      "name": "EnumName",
      "values": ["value1", "value2"],
      "file_name": "enum_name.dart"
    }
  ],
  "widget_code": "full Dart file content for the widget",
  "enum_code": ["full Dart file content for each enum"],
  "test_code": "full Dart test file content with golden tests for key variants",
  "analysis": {
    "variant_count": 0,
    "properties_detected": ["prop1", "prop2"],
    "conditional_logic": "description of conditional rendering"
  }
}

No markdown fences. No explanations. Just the JSON.`;

  const userContent = [];

  // Screenshot if available
  if (screenshotBase64) {
    userContent.push({
      type: 'image',
      source: {
        type: 'base64',
        media_type: 'image/png',
        data: screenshotBase64,
      },
    });
    userContent.push({
      type: 'text',
      text: 'Above: Figma screenshot of the component with all its variants.',
    });
  }

  userContent.push({
    type: 'text',
    text: `## Component data from Figma

\`\`\`json
${JSON.stringify(componentInfo, null, 2)}
\`\`\`

Analyze the component, deduce the Dart props/enums from the variant properties, and generate the Flutter widget + golden test.
Focus on what Figma defines — don't invent extra variants or states.`,
  });

  return { systemPrompt, userContent };
}

// ── Main ───────────────────────────────────────────────────────
async function main() {
  const url = process.argv[2];
  if (!url) {
    console.error(
      'Usage: node scripts/figma-to-widget.mjs <figma-url>',
    );
    console.error(
      'Example: node scripts/figma-to-widget.mjs "https://www.figma.com/design/Cu4NB44bcURKEy40DEfwWi/Design-system-1.0?node-id=58558-395"',
    );
    process.exit(1);
  }

  // ── Phase 1: Parse URL ───────────────────────────────────────
  console.log('🔗 Phase 1: Parsing Figma URL...');
  const { fileKey, nodeId } = parseFigmaUrl(url);
  console.log(`   File: ${fileKey}`);
  console.log(`   Node: ${nodeId}`);

  // ── Phase 2: Fetch component data + screenshot ───────────────
  console.log('\n📡 Phase 2: Fetching component data...');
  const nodeData = await figmaGet(
    `/files/${fileKey}/nodes?ids=${encodeURIComponent(nodeId)}`,
  );

  const pageData = nodeData.nodes?.[nodeId];
  if (!pageData?.document) {
    throw new Error(`Node ${nodeId} not found in file ${fileKey}`);
  }

  const componentInfo = extractComponentInfo(pageData);
  console.log(`   Component: "${componentInfo.name}"`);
  console.log(`   Type: ${componentInfo.type}`);
  console.log(
    `   Properties: ${Object.keys(componentInfo.properties).length}`,
  );
  console.log(`   Variants: ${componentInfo.variants.length}`);

  if (Object.keys(componentInfo.properties).length > 0) {
    console.log('   Properties detail:');
    for (const [key, def] of Object.entries(componentInfo.properties)) {
      const opts = def.variantOptions?.length
        ? `: ${def.variantOptions.join(', ')}`
        : '';
      console.log(`     ${key} (${def.type})${opts}`);
    }
  }

  // Fetch screenshot
  console.log('\n📸 Fetching screenshot...');
  const screenshot = await figmaGetImage(fileKey, nodeId);
  if (screenshot) {
    console.log(
      `   Screenshot: ${Math.round(screenshot.length / 1024)}KB (base64)`,
    );
  } else {
    console.log('   ⚠️ No screenshot available — continuing without');
  }

  // ── Phase 3+4: Claude analyzes + generates ───────────────────
  console.log('\n🤖 Phase 3-4: Claude analyzing variants and generating widget...');
  const { systemPrompt, userContent } = buildPrompt(
    componentInfo,
    screenshot,
  );

  const client = new Anthropic();
  const response = await client.messages.create({
    model: MODEL,
    max_tokens: MAX_TOKENS,
    system: [
      {
        type: 'text',
        text: systemPrompt,
        cache_control: { type: 'ephemeral' },
      },
    ],
    messages: [{ role: 'user', content: userContent }],
  });

  const raw = response.content[0]?.text;
  if (!raw) throw new Error('Empty response from Claude');

  // Parse response
  const cleaned = raw
    .replace(/^```json\n?/m, '')
    .replace(/\n?```$/m, '')
    .trim();

  let result;
  try {
    result = JSON.parse(cleaned);
  } catch {
    console.error('❌ Failed to parse Claude response:');
    console.error(cleaned.slice(0, 500));
    process.exit(1);
  }

  // ── Phase 5: Write files ─────────────────────────────────────
  console.log('\n📁 Phase 5: Writing files...');

  const slug = slugify(componentInfo.name);
  const widgetDir = join(WIDGETS_DIR, slug);
  const testDir = join(TESTS_DIR, slug);

  mkdirSync(widgetDir, { recursive: true });
  mkdirSync(testDir, { recursive: true });

  // Write enum files
  if (result.enums?.length) {
    for (let i = 0; i < result.enums.length; i++) {
      const enumDef = result.enums[i];
      const enumPath = join(widgetDir, enumDef.file_name);
      writeFileSync(enumPath, result.enum_code[i], 'utf8');
      console.log(`  ✅ ${enumPath}`);
    }
  }

  // Write widget file
  const widgetPath = join(widgetDir, result.file_name);
  writeFileSync(widgetPath, result.widget_code, 'utf8');
  console.log(`  ✅ ${widgetPath}`);

  // Write test file
  if (result.test_code) {
    const testPath = join(testDir, `${slug}_test.dart`);
    writeFileSync(testPath, result.test_code, 'utf8');
    console.log(`  ✅ ${testPath}`);
  }

  // Save Figma reference screenshot
  if (screenshot) {
    const refPath = join(testDir, 'figma_reference.png');
    writeFileSync(refPath, Buffer.from(screenshot, 'base64'));
    console.log(`  ✅ ${refPath} (Figma reference)`);
  }

  // ── Summary ──────────────────────────────────────────────────
  console.log('\n📊 Analysis:');
  console.log(`   Variants: ${result.analysis?.variant_count || 'N/A'}`);
  console.log(
    `   Properties: ${result.analysis?.properties_detected?.join(', ') || 'N/A'}`,
  );
  console.log(
    `   Conditional logic: ${result.analysis?.conditional_logic || 'N/A'}`,
  );

  // Token usage
  const usage = response.usage;
  console.log(
    `\n📊 Tokens — input: ${usage.input_tokens}, output: ${usage.output_tokens}`,
  );
  if (usage.cache_read_input_tokens) {
    console.log(`   Cache hit: ${usage.cache_read_input_tokens}`);
  }

  console.log(`\n✨ Widget "${result.widget_name}" generated.`);
  console.log(
    '   Next: review the generated code, then run `flutter test test/widgets/${slug}/`',
  );
}

main().catch((err) => {
  console.error('💥 Fatal:', err.message);
  process.exit(1);
});
