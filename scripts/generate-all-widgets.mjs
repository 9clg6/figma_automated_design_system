#!/usr/bin/env node

/**
 * generate-all-widgets.mjs
 *
 * Batch-generate Flutter widgets for all unimplemented Figma components.
 * Reads component-map.json, skips components with existing dart_files,
 * and calls Claude API to generate the widget + golden test for each.
 *
 * Usage:
 *   FIGMA_TOKEN=... ANTHROPIC_API_KEY=... node scripts/generate-all-widgets.mjs
 *   FIGMA_TOKEN=... ANTHROPIC_API_KEY=... node scripts/generate-all-widgets.mjs --component badges
 *   FIGMA_TOKEN=... ANTHROPIC_API_KEY=... node scripts/generate-all-widgets.mjs --dry-run
 */

import { readFileSync, writeFileSync, mkdirSync, existsSync } from 'node:fs';
import { join, resolve } from 'node:path';
import https from 'node:https';
import Anthropic from '@anthropic-ai/sdk';

// ── Config ─────────────────────────────────────────────────────
const ROOT = resolve(import.meta.dirname, '..');
const MAP_PATH = join(ROOT, 'config', 'component-map.json');

const FIGMA_TOKEN = process.env.FIGMA_TOKEN;
if (!FIGMA_TOKEN) { console.error('❌ FIGMA_TOKEN required'); process.exit(1); }

const MODEL = 'claude-sonnet-4-6';
const MAX_TOKENS = 16384;
const RATE_DELAY = 5000; // 5s between Figma API calls

const componentMap = JSON.parse(readFileSync(MAP_PATH, 'utf8'));
const FILE_KEY = componentMap.figma_file;

// ── Parse args ─────────────────────────────────────────────────
const args = process.argv.slice(2);
function argVal(flag) { const i = args.indexOf(flag); return i >= 0 ? args[i + 1] : null; }
const targetComponent = argVal('--component');
const dryRun = args.includes('--dry-run');

// ── Figma API (with 429 retry + exponential backoff) ──────────
function figmaGetOnce(path) {
  return new Promise((res, rej) => {
    const url = `https://api.figma.com/v1${path}`;
    https.get(url, { headers: { 'X-Figma-Token': FIGMA_TOKEN } }, (resp) => {
      let data = '';
      resp.on('data', chunk => data += chunk);
      resp.on('end', () => {
        if (resp.statusCode === 429) {
          const retryAfter = parseInt(resp.headers['retry-after'] || '0', 10);
          rej({ rateLimited: true, retryAfter });
          return;
        }
        if (resp.statusCode !== 200) {
          rej(new Error(`HTTP ${resp.statusCode}: ${data.slice(0, 200)}`));
          return;
        }
        try { res(JSON.parse(data)); }
        catch (e) { rej(new Error('JSON parse error: ' + e.message)); }
      });
    }).on('error', rej);
  });
}

async function figmaGet(path, retries = 5) {
  for (let attempt = 1; attempt <= retries; attempt++) {
    try {
      return await figmaGetOnce(path);
    } catch (err) {
      if (err.rateLimited && attempt < retries) {
        const wait = Math.max((err.retryAfter || 0) * 1000, 2 ** attempt * 5000);
        const capped = Math.min(wait, 60000);
        console.log(`  ⏳ Rate limited, waiting ${capped / 1000}s (attempt ${attempt}/${retries})...`);
        await new Promise(r => setTimeout(r, capped));
        continue;
      }
      if (err.rateLimited) throw new Error(`Figma API ${path}: rate limited after ${retries} retries`);
      throw err;
    }
  }
}

function figmaGetImage(nodeId, scale = 2) {
  return new Promise((res, rej) => {
    const url = `https://api.figma.com/v1/images/${FILE_KEY}?ids=${encodeURIComponent(nodeId)}&format=png&scale=${scale}`;
    https.get(url, { headers: { 'X-Figma-Token': FIGMA_TOKEN } }, (resp) => {
      let data = '';
      resp.on('data', chunk => data += chunk);
      resp.on('end', () => {
        if (resp.statusCode !== 200) { res(null); return; }
        try {
          const json = JSON.parse(data);
          const imageUrl = json.images?.[nodeId];
          if (!imageUrl) { res(null); return; }
          // Fetch the actual image
          https.get(imageUrl, (imgResp) => {
            const chunks = [];
            imgResp.on('data', c => chunks.push(c));
            imgResp.on('end', () => {
              const buf = Buffer.concat(chunks);
              // If image > 3.5MB raw (~4.7MB base64), retry with scale=1 (Claude limit: 5MB base64)
              if (buf.length > 3_500_000 && scale > 1) {
                console.log(`     ⚠️ Image too large (${Math.round(buf.length/1024)}KB), retrying scale=1...`);
                figmaGetImage(nodeId, 1).then(res).catch(() => res(null));
                return;
              }
              res(buf.toString('base64'));
            });
            imgResp.on('error', () => res(null));
          }).on('error', () => res(null));
        } catch { res(null); }
      });
    }).on('error', () => res(null));
  });
}

function sleep(ms) { return new Promise(r => setTimeout(r, ms)); }

// ── Extract component spec from Figma node data ────────────────
function extractComponentInfo(nodeData) {
  const doc = nodeData.document;

  function findComponents(node) {
    if (node.type === 'COMPONENT_SET' || node.type === 'COMPONENT') return node;
    if (node.children) {
      for (const child of node.children) {
        const found = findComponents(child);
        if (found) return found;
      }
    }
    return null;
  }

  const target = (doc.type === 'COMPONENT_SET' || doc.type === 'COMPONENT')
    ? doc
    : findComponents(doc);

  if (!target) {
    return { name: doc.name, type: doc.type, variants: [], properties: {}, isEmpty: true };
  }

  const info = {
    name: target.name,
    type: target.type,
    properties: {},
    variants: [],
  };

  // Layout
  info.layout = {
    width: target.absoluteBoundingBox?.width,
    height: target.absoluteBoundingBox?.height,
    layoutMode: target.layoutMode,
    padding: {
      top: target.paddingTop, right: target.paddingRight,
      bottom: target.paddingBottom, left: target.paddingLeft,
    },
    itemSpacing: target.itemSpacing,
  };

  // Properties
  if (target.componentPropertyDefinitions) {
    for (const [key, def] of Object.entries(target.componentPropertyDefinitions)) {
      info.properties[key] = {
        type: def.type,
        defaultValue: def.defaultValue,
        variantOptions: def.variantOptions || [],
      };
    }
  }

  // Variants
  if (target.type === 'COMPONENT_SET' && target.children) {
    for (const variant of target.children.slice(0, 20)) { // Cap at 20 variants
      const variantProps = {};
      if (variant.name) {
        for (const part of variant.name.split(',').map(p => p.trim())) {
          const [k, v] = part.split('=').map(s => s.trim());
          if (k && v) variantProps[k] = v;
        }
      }
      info.variants.push({
        name: variant.name,
        id: variant.id,
        properties: variantProps,
        width: variant.absoluteBoundingBox?.width,
        height: variant.absoluteBoundingBox?.height,
        childCount: variant.children?.length || 0,
      });
    }
  } else {
    info.variants.push({
      name: target.name,
      id: target.id,
      properties: {},
      width: info.layout.width,
      height: info.layout.height,
      childCount: target.children?.length || 0,
    });
  }

  return info;
}

// ── Name helpers ───────────────────────────────────────────────
function slugify(name) {
  return name.replace(/[❖]/g, '').trim().toLowerCase()
    .replace(/[^a-z0-9]+/g, '_').replace(/^_|_$/g, '');
}

function pascalCase(name) {
  return name.replace(/[❖]/g, '').trim()
    .split(/[\s_-]+/)
    .map(w => w.charAt(0).toUpperCase() + w.slice(1).toLowerCase())
    .join('');
}

// ── Build Claude prompt ────────────────────────────────────────
function buildPrompt(componentInfo, screenshotBase64, existingCode) {
  const systemPrompt = `You are a Flutter widget engineer for the Linagora Design Flutter package.
You generate production-ready Flutter widgets from Figma component data.

## STRICT CONVENTIONS

### Architecture
- One widget per file
- Presentation only — NO business logic, NO Riverpod, NO providers
- Callbacks via constructor (onTap, onChanged, etc.)
- setState ONLY for local UI state (hover, pressed, focused)
- const constructors

### Theme & Style
- Colors from LinagoraSysColors.material() or Theme.of(context).colorScheme
- Text styles from LinagoraTextStyle or Theme.of(context).textTheme
- Use const Color(0xFF...) for design tokens not in theme
- All spacing as const EdgeInsets

### Naming
- Classes: Linagora* prefix for style/token classes, Twake* for consumer widgets
- Singleton pattern: static final _instance + factory .material()
- File names: snake_case.dart

### From Figma variants to Dart
- Each variant property → Dart enum or typed parameter
- Boolean variant → bool parameter with default
- Size variants → enum (e.g. BadgeSize.small, .medium, .large)

### Code quality
- /// dartdoc on widget class
- Group constructor params logically
- required for non-optional, defaults for optional
- Extract sub-widgets as private classes if complex

## EXISTING PACKAGE CODE
The following files already exist in the package — use the SAME import style and patterns:
${existingCode}

## OUTPUT FORMAT — strict JSON, no markdown
{
  "widget_name": "PascalCase",
  "file_name": "snake_case.dart",
  "directory": "lib/component_name",
  "widget_code": "full Dart file content",
  "test_code": "full golden test Dart file content",
  "test_file_name": "component_name_golden_test.dart",
  "golden_names": ["golden_file_1.png", "golden_file_2.png"],
  "analysis": {
    "variant_count": 0,
    "properties_detected": ["prop1"],
    "description": "one line description"
  }
}

CRITICAL: Start with { end with }. No other text.`;

  const userContent = [];

  if (screenshotBase64) {
    userContent.push({
      type: 'image',
      source: { type: 'base64', media_type: 'image/png', data: screenshotBase64 },
    });
    userContent.push({
      type: 'text',
      text: '☝️ Figma screenshot of this component with all variants.',
    });
  }

  userContent.push({
    type: 'text',
    text: `## Component: ${componentInfo.name}

\`\`\`json
${JSON.stringify(componentInfo, null, 2)}
\`\`\`

Generate the Flutter widget + golden test for this component.
- Directory should be: lib/${slugify(componentInfo.name)}/
- Golden test in: test/goldens/components/
- Match the Figma design exactly
- Keep it simple — don't over-engineer`,
  });

  return { systemPrompt, userContent };
}

// ── Load a few existing files as style reference ───────────────
function loadExistingCodeSample() {
  const samples = [
    'lib/avatar/round_avatar.dart',
    'lib/style/linagora_hover_style.dart',
    'lib/list_item/twake_list_item.dart',
  ];
  let code = '';
  for (const p of samples) {
    const full = join(ROOT, p);
    if (existsSync(full)) {
      const content = readFileSync(full, 'utf8');
      code += `\n### ${p}\n\`\`\`dart\n${content.slice(0, 1500)}\n\`\`\`\n`;
    }
  }
  return code;
}

// ── Main ───────────────────────────────────────────────────────
async function main() {
  const existingCode = loadExistingCodeSample();
  const components = Object.entries(componentMap.components);

  // Find unimplemented components
  let targets;
  if (targetComponent) {
    const cfg = componentMap.components[targetComponent];
    if (!cfg) {
      console.error(`❌ Unknown component: ${targetComponent}`);
      process.exit(1);
    }
    targets = [[targetComponent, cfg]];
  } else {
    targets = components.filter(([, cfg]) => cfg.dart_files.length === 0);
    console.log(`🏗️  Generating ${targets.length} unimplemented components...\n`);
  }

  const results = [];
  let generated = 0, skipped = 0, errors = 0;

  for (const [name, cfg] of targets) {
    console.log(`\n━━━ ${name} (${cfg.figma_name}) ━━━`);

    // Fetch from Figma
    console.log('  📡 Fetching Figma data...');
    let nodeData;
    try {
      const data = await figmaGet(`/files/${FILE_KEY}/nodes?ids=${cfg.page_id}&depth=5`);
      nodeData = data.nodes?.[cfg.page_id];
      if (!nodeData?.document) {
        console.log('  ⚠️  Empty page, skipping');
        skipped++;
        results.push({ name, status: 'EMPTY' });
        await sleep(RATE_DELAY);
        continue;
      }
    } catch (err) {
      console.error(`  ❌ Fetch failed: ${err.message}`);
      errors++;
      results.push({ name, status: 'FETCH_ERROR', error: err.message });
      await sleep(RATE_DELAY);
      continue;
    }

    const componentInfo = extractComponentInfo(nodeData);
    console.log(`  📋 ${componentInfo.variants.length} variants, ${Object.keys(componentInfo.properties).length} properties`);

    if (componentInfo.isEmpty) {
      console.log('  ⚠️  No component/component_set found on page, skipping');
      skipped++;
      results.push({ name, status: 'NO_COMPONENT' });
      await sleep(RATE_DELAY);
      continue;
    }

    // Fetch screenshot — always use scale=1 (scale=2 often exceeds 8000px or 5MB limits)
    // Skip screenshot for components with known oversized images
    const skipScreenshot = args.includes('--no-screenshot');
    const imgScale = 1;
    let screenshot = null;
    if (!skipScreenshot) {
      console.log(`  📸 Fetching screenshot (scale=${imgScale})...`);
      try {
        screenshot = await figmaGetImage(cfg.page_id, imgScale);
        if (screenshot) console.log(`     ${Math.round(screenshot.length / 1024)}KB`);
        else console.log('     ⚠️ No screenshot');
      } catch { console.log('     ⚠️ Screenshot failed'); }
    } else {
      console.log('  📸 Skipping screenshot (--no-screenshot)');
    }

    await sleep(RATE_DELAY);

    if (dryRun) {
      console.log('  🏁 DRY RUN — would generate widget');
      results.push({ name, status: 'DRY_RUN', variants: componentInfo.variants.length });
      continue;
    }

    // Call Claude (with retry on JSON parse errors)
    console.log('  🤖 Generating widget with Claude...');
    const { systemPrompt, userContent } = buildPrompt(componentInfo, screenshot, existingCode);

    try {
      const client = new Anthropic();
      let result;
      const MAX_RETRIES = 2;
      for (let attempt = 0; attempt <= MAX_RETRIES; attempt++) {
        if (attempt > 0) console.log(`  🔄 Retry ${attempt}/${MAX_RETRIES}...`);
        const response = await client.messages.create({
          model: MODEL,
          max_tokens: MAX_TOKENS,
          system: [{ type: 'text', text: systemPrompt, cache_control: { type: 'ephemeral' } }],
          messages: [{ role: 'user', content: userContent }],
        });

        const raw = response.content[0]?.text;
        if (!raw) throw new Error('Empty response');

        console.log(`  📊 Tokens — input: ${response.usage.input_tokens}, output: ${response.usage.output_tokens}`);
        if (response.usage.cache_read_input_tokens) {
          console.log(`     Cache hit: ${response.usage.cache_read_input_tokens}`);
        }

        // Parse JSON
        const jsonMatch = raw.match(/\{[\s\S]*\}/);
        if (!jsonMatch) {
          if (attempt < MAX_RETRIES) { console.log('  ⚠️ No JSON in response, retrying...'); continue; }
          throw new Error('No JSON in response after retries');
        }
        try {
          result = JSON.parse(jsonMatch[0]);
          break; // success
        } catch (parseErr) {
          if (attempt < MAX_RETRIES) { console.log(`  ⚠️ JSON parse error, retrying...`); continue; }
          throw parseErr;
        }
      }

      // Write files
      const dir = result.directory || `lib/${slugify(componentInfo.name)}`;
      const fullDir = join(ROOT, dir);
      mkdirSync(fullDir, { recursive: true });

      // Widget code
      const widgetPath = join(ROOT, dir, result.file_name);
      writeFileSync(widgetPath, result.widget_code, 'utf8');
      console.log(`  ✅ ${dir}/${result.file_name}`);

      // Golden test
      if (result.test_code) {
        const testDir = join(ROOT, 'test', 'goldens', 'components');
        mkdirSync(testDir, { recursive: true });
        const testFile = result.test_file_name || `${slugify(componentInfo.name)}_golden_test.dart`;
        writeFileSync(join(testDir, testFile), result.test_code, 'utf8');
        console.log(`  ✅ test/goldens/components/${testFile}`);
      }

      // Save screenshot as reference
      if (screenshot) {
        const imgDir = join(ROOT, 'kb', 'components', 'images');
        mkdirSync(imgDir, { recursive: true });
        writeFileSync(join(imgDir, `${name}.png`), Buffer.from(screenshot, 'base64'));
      }

      // Update component-map.json
      const dartFiles = [`${dir}/${result.file_name}`];
      cfg.dart_files = dartFiles;
      if (result.test_code) {
        const testFile = result.test_file_name || `${slugify(componentInfo.name)}_golden_test.dart`;
        cfg.golden_test = `test/goldens/components/${testFile}`;
        cfg.golden_files = (result.golden_names || []).map(g => `test/goldens/components/${g}`);
      }

      generated++;
      results.push({
        name,
        status: 'GENERATED',
        widget: result.widget_name,
        variants: result.analysis?.variant_count,
        props: result.analysis?.properties_detected,
      });

    } catch (err) {
      console.error(`  ❌ Generation failed: ${err.message}`);
      errors++;
      results.push({ name, status: 'ERROR', error: err.message });
    }
  }

  // Save updated component-map.json
  writeFileSync(MAP_PATH, JSON.stringify(componentMap, null, 2) + '\n', 'utf8');

  // Summary
  console.log('\n━━━ Summary ━━━');
  for (const r of results) {
    const icon = r.status === 'GENERATED' ? '✅' : r.status === 'DRY_RUN' ? '🏁' : r.status === 'EMPTY' || r.status === 'NO_COMPONENT' ? '⚠️' : '❌';
    console.log(`  ${icon} ${r.name}: ${r.status}${r.widget ? ` → ${r.widget}` : ''}${r.variants ? ` (${r.variants} variants)` : ''}`);
  }
  console.log(`\n  Generated: ${generated} | Skipped: ${skipped} | Errors: ${errors}`);
}

main().catch(err => {
  console.error('💥 Fatal:', err.message);
  process.exit(1);
});
