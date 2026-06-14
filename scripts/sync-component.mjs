#!/usr/bin/env node

/**
 * sync-component.mjs
 *
 * Detects Figma component spec changes and uses Claude to modify
 * existing Dart widget code while preserving business logic.
 *
 * Flow:
 *   1. Re-extract Figma component spec (or read from --spec-dir)
 *   2. Diff new spec vs saved kb/components/{name}.json
 *   3. Build structured change summary
 *   4. Send changes + current Dart code to Claude API
 *   5. Apply edits with allowlist validation
 *   6. Run flutter analyze to validate
 *
 * Usage:
 *   FIGMA_TOKEN=... ANTHROPIC_API_KEY=... node scripts/sync-component.mjs --component avatar
 *   FIGMA_TOKEN=... ANTHROPIC_API_KEY=... node scripts/sync-component.mjs --all
 *   node scripts/sync-component.mjs --component avatar --spec-dir /tmp/new-specs
 *   node scripts/sync-component.mjs --dry-run --component dialog-modal
 *
 * Options:
 *   --component <name>   Sync a single component
 *   --all                Sync all implemented components with detected changes
 *   --spec-dir <path>    Use pre-extracted specs instead of fetching from Figma
 *   --dry-run            Show diff + proposed prompt without calling Claude
 *   --skip-analyze       Skip flutter analyze validation step
 *   --force              Apply even if no diff detected (re-sync from current spec)
 */

import { readFileSync, writeFileSync, mkdirSync, existsSync, copyFileSync } from 'node:fs';
import { join, resolve } from 'node:path';
import { execSync } from 'node:child_process';
import Anthropic from '@anthropic-ai/sdk';
import { createFigmaClient, extractComponentSpec, findComponents, rgbaToHex, sleep } from './lib/figma-api.mjs';

// ── Config ─────────────────────────────────────────────────────
const ROOT = resolve(import.meta.dirname, '..');
const MAP_PATH = join(ROOT, 'config', 'component-map.json');
const SPECS_DIR = join(ROOT, 'kb', 'components');
const BACKUP_DIR = join(ROOT, 'kb', 'components', '_previous');
const SYNC_LOG_DIR = join(ROOT, 'kb', 'sync-logs');

const MODEL = 'claude-sonnet-4-6';
const MAX_TOKENS = 16384;
const TIMEOUT_MS = 10 * 60 * 1000; // 10 min — widget edits are more complex

const FIGMA_TOKEN = process.env.FIGMA_TOKEN;
const RATE_DELAY = 4200;

const componentMap = JSON.parse(readFileSync(MAP_PATH, 'utf8'));
const FILE_KEY = componentMap.figma_file;
const { figmaGet, figmaGetImage } = createFigmaClient(FIGMA_TOKEN, FILE_KEY);

// ── Parse args ─────────────────────────────────────────────────
const args = process.argv.slice(2);
function argVal(flag) {
  const i = args.indexOf(flag);
  return i >= 0 ? args[i + 1] : null;
}
const componentArg = argVal('--component');
const specDirArg = argVal('--spec-dir');
const syncAll = args.includes('--all');
const dryRun = args.includes('--dry-run');
const skipAnalyze = args.includes('--skip-analyze');
const forceSync = args.includes('--force');
const visualOnly = args.includes('--visual-only');
const fixVisual = args.includes('--fix-visual');
const targetScore = parseInt(argVal('--target-score') || '90');
const maxFixAttempts = parseInt(argVal('--max-attempts') || '3');

if (!componentArg && !syncAll) {
  console.error('Usage: node scripts/sync-component.mjs --component <name> | --all [--visual-only] [--fix-visual] [--target-score 90] [--max-attempts 3]');
  process.exit(1);
}

// ── Allowlist — derived from component-map.json dart_files ─────
function buildAllowlist() {
  const dirs = new Set();
  for (const cfg of Object.values(componentMap.components)) {
    for (const f of cfg.dart_files) {
      // Extract directory: "lib/avatar/round_avatar.dart" → "lib/avatar/"
      const dir = f.substring(0, f.lastIndexOf('/') + 1);
      dirs.add(dir);
    }
  }
  return [...dirs];
}

const ALLOWED_PATHS = buildAllowlist();

// ── Fetch fresh spec from Figma ────────────────────────────────
async function fetchComponentSpec(name, cfg) {
  console.log(`  📡 Fetching ${name} from Figma (page ${cfg.page_id})...`);
  const data = await figmaGet(`/files/${FILE_KEY}/nodes?ids=${cfg.page_id}&depth=5`);

  const nodeData = data.nodes[cfg.page_id];
  if (!nodeData?.document) {
    return { name: cfg.figma_name, status: 'empty', variants: [] };
  }

  const page = nodeData.document;
  const spec = {
    name: cfg.figma_name,
    page_id: cfg.page_id,
    dart_files: cfg.dart_files,
    has_implementation: cfg.dart_files.length > 0,
    variants: [],
    components: findComponents(page),
  };

  spec.pageSpec = extractComponentSpec(page, 0);

  return spec;
}

// ── Structural diff between two specs ──────────────────────────
function diffSpecs(oldSpec, newSpec) {
  const changes = {
    hasChanges: false,
    summary: [],
    componentSets: { added: [], removed: [], modified: [] },
    variants: { added: [], removed: [], modified: [] },
    properties: [],
  };

  if (!oldSpec || oldSpec.status === 'empty') {
    changes.hasChanges = true;
    changes.summary.push('New component — no previous spec');
    return changes;
  }

  const oldComponents = (oldSpec.components || []).reduce((m, c) => { m[c.name] = c; return m; }, {});
  const newComponents = (newSpec.components || []).reduce((m, c) => { m[c.name] = c; return m; }, {});

  // Added/removed component sets
  for (const name of Object.keys(newComponents)) {
    if (!oldComponents[name]) {
      changes.componentSets.added.push(name);
      changes.hasChanges = true;
    }
  }
  for (const name of Object.keys(oldComponents)) {
    if (!newComponents[name]) {
      changes.componentSets.removed.push(name);
      changes.hasChanges = true;
    }
  }

  // Modified component sets — compare variants
  for (const [name, newComp] of Object.entries(newComponents)) {
    const oldComp = oldComponents[name];
    if (!oldComp) continue;

    const oldVariants = (oldComp.variants || []).reduce((m, v) => { m[v.name] = v; return m; }, {});
    const newVariants = (newComp.variants || []).reduce((m, v) => { m[v.name] = v; return m; }, {});

    for (const vn of Object.keys(newVariants)) {
      if (!oldVariants[vn]) {
        changes.variants.added.push(`${name} → ${vn}`);
        changes.hasChanges = true;
      }
    }
    for (const vn of Object.keys(oldVariants)) {
      if (!newVariants[vn]) {
        changes.variants.removed.push(`${name} → ${vn}`);
        changes.hasChanges = true;
      }
    }

    // Deep compare matching variants for property changes
    for (const [vn, newV] of Object.entries(newVariants)) {
      const oldV = oldVariants[vn];
      if (!oldV) continue;

      const propChanges = diffVariantProperties(oldV, newV, `${name} → ${vn}`);
      if (propChanges.length > 0) {
        changes.properties.push(...propChanges);
        changes.variants.modified.push(`${name} → ${vn}`);
        changes.hasChanges = true;
      }
    }
  }

  // Build summary
  if (changes.componentSets.added.length) changes.summary.push(`Added component sets: ${changes.componentSets.added.join(', ')}`);
  if (changes.componentSets.removed.length) changes.summary.push(`Removed component sets: ${changes.componentSets.removed.join(', ')}`);
  if (changes.variants.added.length) changes.summary.push(`Added variants: ${changes.variants.added.length}`);
  if (changes.variants.removed.length) changes.summary.push(`Removed variants: ${changes.variants.removed.length}`);
  if (changes.variants.modified.length) changes.summary.push(`Modified variants: ${changes.variants.modified.length} (${changes.properties.length} property changes)`);

  return changes;
}

function diffVariantProperties(oldV, newV, path) {
  const changes = [];
  const FLOAT_EPSILON = 0.01;
  const floatEq = (a, b) => typeof a === 'number' && typeof b === 'number' ? Math.abs(a - b) <= FLOAT_EPSILON : a === b;

  // Dimensions
  if (!floatEq(oldV.width, newV.width)) changes.push({ path, prop: 'width', old: oldV.width, new: newV.width });
  if (!floatEq(oldV.height, newV.height)) changes.push({ path, prop: 'height', old: oldV.height, new: newV.height });

  // Corner radius
  if (!floatEq(oldV.cornerRadius, newV.cornerRadius)) changes.push({ path, prop: 'cornerRadius', old: oldV.cornerRadius, new: newV.cornerRadius });

  // Layout
  if (oldV.layout && newV.layout) {
    if (!floatEq(oldV.layout.spacing, newV.layout.spacing)) changes.push({ path, prop: 'layout.spacing', old: oldV.layout.spacing, new: newV.layout.spacing });
    if (oldV.layout.mode !== newV.layout.mode) changes.push({ path, prop: 'layout.mode', old: oldV.layout.mode, new: newV.layout.mode });
    for (const side of ['top', 'right', 'bottom', 'left']) {
      if (!floatEq(oldV.layout.padding?.[side], newV.layout.padding?.[side])) {
        changes.push({ path, prop: `layout.padding.${side}`, old: oldV.layout.padding?.[side], new: newV.layout.padding?.[side] });
      }
    }
  }

  // Fills
  const oldFills = JSON.stringify(oldV.fills || []);
  const newFills = JSON.stringify(newV.fills || []);
  if (oldFills !== newFills) changes.push({ path, prop: 'fills', old: oldV.fills, new: newV.fills });

  // Strokes
  const oldStrokes = JSON.stringify(oldV.strokes || []);
  const newStrokes = JSON.stringify(newV.strokes || []);
  if (oldStrokes !== newStrokes) changes.push({ path, prop: 'strokes', old: oldV.strokes, new: newV.strokes });

  // Effects
  const oldEffects = JSON.stringify(oldV.effects || []);
  const newEffects = JSON.stringify(newV.effects || []);
  if (oldEffects !== newEffects) changes.push({ path, prop: 'effects', old: oldV.effects, new: newV.effects });

  // Text style
  if (oldV.textStyle || newV.textStyle) {
    const oldTs = JSON.stringify(oldV.textStyle || {});
    const newTs = JSON.stringify(newV.textStyle || {});
    if (oldTs !== newTs) changes.push({ path, prop: 'textStyle', old: oldV.textStyle, new: newV.textStyle });
  }

  // Recurse into children — match by name, deep-compare properties
  const oldChildMap = new Map((oldV.children || []).map(c => [c.name, c]));
  const newChildMap = new Map((newV.children || []).map(c => [c.name, c]));

  for (const [cName, newChild] of newChildMap) {
    if (!oldChildMap.has(cName)) {
      changes.push({ path, prop: `children[${cName}]`, old: undefined, new: 'added' });
      continue;
    }
    const childChanges = diffVariantProperties(oldChildMap.get(cName), newChild, `${path} → ${cName}`);
    changes.push(...childChanges);
  }
  for (const cName of oldChildMap.keys()) {
    if (!newChildMap.has(cName)) {
      changes.push({ path, prop: `children[${cName}]`, old: 'removed', new: undefined });
    }
  }

  return changes;
}

// ── Truncate spec for Claude context ───────────────────────────
// pageSpec is the full page tree (huge, mostly noise) — truncate aggressively
// components array is what Claude needs — keep deeper
function truncateSpec(spec) {
  function truncate(obj, depth, maxDepth) {
    if (depth > maxDepth) return '[truncated]';
    if (Array.isArray(obj)) {
      if (obj.length > 10) return [...obj.slice(0, 5).map(i => truncate(i, depth + 1, maxDepth)), `... ${obj.length - 5} more`];
      return obj.map(i => truncate(i, depth + 1, maxDepth));
    }
    if (obj && typeof obj === 'object') {
      const result = {};
      for (const [k, v] of Object.entries(obj)) {
        result[k] = truncate(v, depth + 1, maxDepth);
      }
      return result;
    }
    return obj;
  }

  const result = { ...spec };
  // Components: keep 8 levels deep (component → variant → children → properties → nested)
  if (result.components) {
    result.components = truncate(result.components, 0, 8);
  }
  // pageSpec: truncate aggressively — it's just context
  if (result.pageSpec) {
    result.pageSpec = truncate(result.pageSpec, 0, 3);
  }
  return result;
}

// ── Load Dart source files ─────────────────────────────────────
function loadDartFiles(dartPaths) {
  const files = {};
  for (const p of dartPaths) {
    const full = join(ROOT, p);
    if (existsSync(full)) {
      files[p] = readFileSync(full, 'utf8');
    }
  }
  return files;
}

// ── System prompt for component sync ───────────────────────────
function getSystemPrompt() {
  return `You are a Flutter widget engineer for the Linagora Design Flutter package.

You receive:
1. A DIFF showing what changed in a Figma component specification
2. The NEW full Figma spec (JSON)
3. The CURRENT Dart implementation files

Your job: MODIFY the existing Dart widget code to reflect the Figma design changes.

## CRITICAL RULES

### Preserve business logic
- NEVER remove or modify: callback signatures, state management, navigation logic, Riverpod providers, event handlers
- NEVER change constructor parameter NAMES or TYPES that are used by consumers
- You MAY add new parameters (with defaults) or deprecate old ones
- Functional behavior (onTap, onChanged, onDismissed, etc.) must be 100% preserved

### What you CAN change
- Visual constants: colors, spacing, padding, margin, border radius, font sizes, font weights
- Layout structure: Row/Column ordering, Flex properties, alignment
- Widget tree: add/remove decorative widgets (Container, Padding, DecoratedBox, etc.)
- New variants: add new enum values, new optional constructor params
- Size presets: update or add named size constants
- Theme integration: replace hardcoded values with theme references

### What you MUST NOT change
- Public API: don't rename classes, don't change required parameter types
- State management: don't alter setState, Notifier, or Provider logic
- Imports that reference business logic packages
- Test files — you only edit lib/ files

### Conventions
- Classes use Linagora* prefix (LinagoraSysColors, LinagoraHoverStyle, etc.)
- Twake* prefix for consumer-facing widgets (TwakeListItem, TwakeInkWell)
- All colors via LinagoraSysColors, LinagoraRefColors, or Theme.of(context)
- const constructors, const Color(0xFF...), const EdgeInsets
- Singleton pattern: static final _instance + factory .material()
- Font styles reference LinagoraTextStyle when available

## Output format (strict JSON, no markdown fences)

[
  {
    "path": "lib/avatar/round_avatar.dart",
    "action": "edit",
    "content": "// full file content after changes",
    "changes_made": ["Changed cornerRadius from 16 to 28", "Added size enum XS"]
  }
]

If NO code changes are needed (design matches implementation), return an empty array: []

Be conservative. Only change what the diff indicates. Do not "improve" code beyond what the Figma diff requires.

CRITICAL OUTPUT RULE: Your response MUST be ONLY a JSON array. No explanation, no analysis, no markdown. Start with [ and end with ]. Any text before the [ or after the ] will cause a parse failure.`;
}

// ── System prompt for visual fix mode ─────────────────────────
function getVisualFixPrompt() {
  return `You are a Flutter widget engineer fixing visual discrepancies between Flutter implementation and Figma design.

You receive:
1. A visual QA report listing specific discrepancies (from comparing Flutter golden test screenshots against Figma reference)
2. The Figma component specification (JSON)
3. The current Dart implementation files

Your job: Fix EVERY discrepancy listed in the QA report by modifying the Dart code.

## CRITICAL RULES

### Fix strategy
- Each discrepancy must be addressed: wrong color → fix the color, wrong padding → fix the padding, wrong radius → fix the radius
- Match the Figma spec values exactly: use the hex colors, pixel sizes, border radii from the spec
- Replace hardcoded colors (Colors.white, Color(0xFF...)) with proper theme references when the Figma spec uses design tokens
- Fix layout issues: alignment (left vs center), direction (horizontal vs vertical), spacing

### Preserve business logic
- NEVER remove or modify: callback signatures, state management, navigation logic, event handlers
- NEVER change constructor parameter NAMES or TYPES that are used by consumers
- Functional behavior (onTap, onChanged, onDismissed, etc.) must be 100% preserved

### What you CAN change
- Visual constants: colors, spacing, padding, margin, border radius, font sizes, font weights
- Layout structure: Row/Column ordering, Flex properties, alignment
- Widget tree: add/remove decorative widgets (Container, Padding, DecoratedBox, etc.)

### Conventions
- Classes use Linagora* prefix, Twake* prefix for consumer widgets
- All colors via LinagoraSysColors, LinagoraRefColors, or Theme.of(context).colorScheme
- const constructors, const Color(0xFF...), const EdgeInsets

## Output format (strict JSON array, no markdown)

[
  {
    "path": "lib/dialog/confirmation_dialog_builder.dart",
    "action": "edit",
    "content": "// full file content after fixes",
    "changes_made": ["Fixed title alignment from center to left", "Changed padding from 32px to 24px"]
  }
]

If somehow nothing needs fixing, return []. But given a QA report with discrepancies, you MUST fix them.

CRITICAL: Start with [ end with ]. No other text.`;
}

// ── Build user prompt ──────────────────────────────────────────
function buildUserPrompt(name, diff, newSpec, dartFiles) {
  let prompt = `## Component: ${name}\n\n`;

  // Change summary
  prompt += `### Detected Changes\n`;
  if (diff.summary.length > 0) {
    prompt += diff.summary.map(s => `- ${s}`).join('\n') + '\n\n';
  } else {
    prompt += `- Force sync: re-aligning implementation to current Figma spec (no structural diff detected)\n\n`;
  }

  // Property-level changes table
  if (diff.properties.length > 0) {
    prompt += `### Property Changes\n`;
    prompt += `| Location | Property | Old Value | New Value |\n`;
    prompt += `|----------|----------|-----------|-----------|\n`;
    for (const p of diff.properties) {
      const oldVal = typeof p.old === 'object' ? JSON.stringify(p.old) : String(p.old ?? '—');
      const newVal = typeof p.new === 'object' ? JSON.stringify(p.new) : String(p.new ?? '—');
      prompt += `| ${p.path} | ${p.prop} | ${oldVal.slice(0, 60)} | ${newVal.slice(0, 60)} |\n`;
    }
    prompt += '\n';
  }

  // New variant details
  if (diff.variants.added.length > 0) {
    prompt += `### New Variants\n`;
    for (const v of diff.variants.added) {
      prompt += `- ${v}\n`;
    }
    prompt += '\n';
  }

  // Removed variants
  if (diff.variants.removed.length > 0) {
    prompt += `### Removed Variants\n`;
    for (const v of diff.variants.removed) {
      prompt += `- ${v}\n`;
    }
    prompt += '\n';
  }

  // Full new spec (truncated)
  prompt += `### Current Figma Spec (full)\n\`\`\`json\n`;
  prompt += JSON.stringify(truncateSpec(newSpec), null, 2);
  prompt += `\n\`\`\`\n\n`;

  // Current Dart files
  prompt += `### Current Dart Implementation\n`;
  for (const [path, content] of Object.entries(dartFiles)) {
    prompt += `#### ${path}\n\`\`\`dart\n${content}\n\`\`\`\n\n`;
  }

  prompt += `Apply the Figma changes to the Dart code. Preserve all business logic. Output ONLY the JSON array of edits.`;

  return prompt;
}

// ── Validate edits against allowlist ───────────────────────────
function validateEdits(edits) {
  for (const edit of edits) {
    // Canonicalize the path to prevent traversal attacks (e.g. "lib/buttons/../../main.dart")
    const resolved = resolve(ROOT, edit.path);
    const canonical = resolved.replace(ROOT + '/', '');
    // Reject if resolved path escapes the project root
    if (!resolved.startsWith(ROOT + '/')) {
      throw new Error(`🚫 Edit blocked — path escapes project root: ${edit.path} → ${resolved}`);
    }
    // Check canonical path against allowlist
    const allowed = ALLOWED_PATHS.some(prefix => canonical.startsWith(prefix));
    if (!allowed) {
      throw new Error(`🚫 Edit blocked — path outside allowlist: ${edit.path} (resolved: ${canonical})\n   Allowed: ${ALLOWED_PATHS.join(', ')}`);
    }
    // Replace edit.path with the canonical version
    edit.path = canonical;
  }
}

// ── Run flutter analyze ────────────────────────────────────────
function runFlutterAnalyze() {
  console.log('  🔍 Running flutter analyze...');
  try {
    execSync('fvm flutter analyze --no-fatal-infos', {
      cwd: ROOT,
      stdio: 'pipe',
      timeout: 120_000,
    });
    console.log('  ✅ flutter analyze passed');
    return true;
  } catch (err) {
    const output = err.stdout?.toString() || err.stderr?.toString() || '';
    console.error('  ❌ flutter analyze failed:');
    const errors = output.split('\n').filter(l => l.includes('error') || l.includes('Error'));
    for (const e of errors.slice(0, 10)) console.error(`     ${e}`);
    return false;
  }
}

// ── Run golden tests ──────────────────────────────────────────
function runGoldenTests(goldenTestPath, updateGoldens = false) {
  const flag = updateGoldens ? '--update-goldens' : '';
  const label = updateGoldens ? 'update goldens' : 'check goldens (regression)';
  console.log(`  🖼️  Running ${label}...`);
  try {
    execSync(`fvm flutter test ${goldenTestPath} ${flag}`.trim(), {
      cwd: ROOT,
      stdio: 'pipe',
      timeout: 180_000,
    });
    console.log(`  ✅ Golden tests ${updateGoldens ? 'updated' : 'passed'}`);
    return { ok: true };
  } catch (err) {
    const output = (err.stdout?.toString() || '') + (err.stderr?.toString() || '');
    // Count failures
    const failMatch = output.match(/(\d+) test[s]? failed/);
    const failCount = failMatch ? parseInt(failMatch[1]) : 0;
    const passMatch = output.match(/(\d+) test[s]? passed/);
    const passCount = passMatch ? parseInt(passMatch[1]) : 0;
    if (!updateGoldens) {
      console.log(`  📋 Golden tests: ${failCount} failed, ${passCount} passed (expected — rendering changed)`);
    } else {
      console.error(`  ❌ Golden update failed:`);
      const errors = output.split('\n').filter(l => l.includes('Error') || l.includes('EXCEPTION'));
      for (const e of errors.slice(0, 5)) console.error(`     ${e}`);
    }
    return { ok: false, failCount, passCount, output };
  }
}

// ── Download image URL to Buffer ──────────────────────────────
function downloadImage(url) {
  const http = require('node:http');
  return new Promise((res, rej) => {
    const follow = (u) => {
      const mod = u.startsWith('https') ? https : http;
      mod.get(u, (resp) => {
        if (resp.statusCode >= 300 && resp.statusCode < 400 && resp.headers.location) {
          follow(resp.headers.location);
          return;
        }
        if (resp.statusCode !== 200) { rej(new Error(`HTTP ${resp.statusCode}`)); return; }
        const chunks = [];
        resp.on('data', c => chunks.push(c));
        resp.on('end', () => res(Buffer.concat(chunks)));
      }).on('error', rej);
    };
    follow(url);
  });
}

// ── Spec compliance check: Figma spec vs Dart code ────────────
// This compares DESIGN VALUES (colors, sizes, radii, padding, typography)
// extracted from the Figma spec JSON against the actual Dart source code.
// NOT a pixel comparison — layout differences between Figma canvas and
// Flutter test renders are expected and ignored.
async function visualCompare(name, goldenFiles, figmaImagePath, figmaSpec) {
  console.log('  👁️  Spec compliance check: Figma spec vs Dart code...');

  const client = new Anthropic();
  const content = [];

  // Load Dart source files for this component
  const cfg = componentMap.components[name];
  const dartFiles = loadDartFiles(cfg?.dart_files || []);

  // Add Figma spec JSON (the source of truth)
  if (figmaSpec) {
    content.push({
      type: 'text',
      text: `## Figma Component Spec (source of truth)\n\`\`\`json\n${JSON.stringify(truncateSpec(figmaSpec), null, 2)}\n\`\`\``,
    });
  }

  // Add current Dart implementation
  for (const [path, code] of Object.entries(dartFiles)) {
    content.push({
      type: 'text',
      text: `## Dart Implementation: ${path}\n\`\`\`dart\n${code}\n\`\`\``,
    });
  }

  // Add Figma reference image as visual context
  if (existsSync(figmaImagePath)) {
    const figmaImg = readFileSync(figmaImagePath);
    content.push({
      type: 'image',
      source: { type: 'base64', media_type: 'image/png', data: figmaImg.toString('base64') },
    });
    content.push({ type: 'text', text: '☝️ Figma page screenshot — visual context only.' });
  }

  // Add one golden as visual context (optional, just to see what Flutter renders)
  const existingGoldens = goldenFiles.filter(f => existsSync(join(ROOT, f)));
  if (existingGoldens.length > 0) {
    const goldenImg = readFileSync(join(ROOT, existingGoldens[0]));
    content.push({
      type: 'image',
      source: { type: 'base64', media_type: 'image/png', data: goldenImg.toString('base64') },
    });
    content.push({ type: 'text', text: `☝️ Flutter golden render (${existingGoldens[0].split('/').pop()}) — visual context only.` });
  }

  // Compliance check prompt
  content.push({
    type: 'text',
    text: `## Spec Compliance Audit

You are auditing whether the Flutter Dart code correctly implements the Figma component spec.

Compare DESIGN VALUES in the Dart code against the Figma spec JSON. Check:

1. **Colors**: Are hex values / Color(0xFF...) in Dart matching the fills.hex in Figma spec?
2. **Border radius**: Does cornerRadius in code match cornerRadius in spec?
3. **Spacing/Padding**: Do EdgeInsets values match layout.padding in spec?
4. **Sizes**: Do height/width constants match spec dimensions?
5. **Typography**: Do fontSize, fontWeight match textStyle in spec?
6. **Effects**: Are shadows (BoxShadow) matching effects in spec?
7. **Layout direction**: Does Row/Column match layout.mode HORIZONTAL/VERTICAL?

IMPORTANT:
- Score ONLY based on whether Dart code values match Figma spec values
- Do NOT penalize for layout differences between golden screenshots and Figma page screenshots (they have different presentation formats)
- Do NOT penalize for text content differences (test data vs design placeholder)
- Focus on: actual hardcoded values in the code vs what the spec defines
- A component that uses all correct values from the spec but presents them in a test showcase layout should score 90+
- IGNORE any spec values that appear as "[truncated]", "{}", or "... N more" — these are artifacts of depth-limiting the spec JSON and do NOT represent actual values. Do NOT report them as discrepancies
- For shadow effects: the "opacity" field (0-1) and hex color with alpha suffix (e.g. #00000014) are the ground truth for shadow color opacity. Use Color.withOpacity() or Color.withAlpha() in Dart
- When the spec has no explicit padding value (missing or truncated), do NOT penalize the Dart code for using any reasonable padding

Output ONLY this JSON:
{
  "verdict": "PASS" or "FAIL",
  "score": 0-100,
  "matches": ["list of correctly matching properties"],
  "discrepancies": [
    {
      "property": "what property is wrong",
      "figma": "value from Figma spec",
      "flutter": "value found in Dart code",
      "severity": "critical" or "minor",
      "file": "which .dart file",
      "fix_hint": "what to change"
    }
  ],
  "recommendation": "one sentence summary"
}`,
  });

  try {
    const response = await client.messages.create({
      model: MODEL,
      max_tokens: 4096,
      system: [{ type: 'text', text: 'You are a design system QA engineer. Compare Dart code against Figma spec JSON. Score based on VALUE MATCHING (colors, sizes, radii, padding, shadows), NOT layout similarity. SKIP any spec value that is "[truncated]", "{}", or missing — only score properties with concrete values in the spec. For shadows, check opacity field (float 0-1) and hex color with alpha suffix. Output ONLY valid JSON, no markdown.' }],
      messages: [{ role: 'user', content }],
    });

    const raw = response.content[0]?.text;
    console.log(`     Compliance tokens — input: ${response.usage.input_tokens}, output: ${response.usage.output_tokens}`);

    const jsonMatch = raw.match(/\{[\s\S]*\}/);
    if (jsonMatch) {
      try { return JSON.parse(jsonMatch[0]); } catch { /* fall through */ }
    }
    return { verdict: 'UNKNOWN', raw: raw.slice(0, 500) };
  } catch (err) {
    console.error(`  ⚠️  Compliance check failed: ${err.message}`);
    return { verdict: 'ERROR', error: err.message };
  }
}

// ── Fix visual issues via Claude ──────────────────────────────
async function fixVisualIssues(name, visualResult, figmaSpec, dartFiles, cfg) {
  console.log(`  🔧 Sending visual discrepancies to Claude for fix...`);

  const client = new Anthropic();
  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), TIMEOUT_MS);

  // Build fix prompt with the discrepancies
  let userPrompt = `## Component: ${name} (${cfg.figma_name})\n\n`;
  userPrompt += `### Visual QA Report — Score: ${visualResult.score}/100\n\n`;

  if (visualResult.discrepancies?.length) {
    userPrompt += `### Discrepancies to Fix\n`;
    for (const d of visualResult.discrepancies) {
      userPrompt += `- **[${d.severity}] ${d.property}**: Figma="${d.figma}" → Flutter="${d.flutter}"\n`;
    }
    userPrompt += '\n';
  }
  if (visualResult.recommendation) {
    userPrompt += `### QA Recommendation\n${visualResult.recommendation}\n\n`;
  }

  // Add Figma spec (truncated)
  userPrompt += `### Figma Spec\n\`\`\`json\n${JSON.stringify(truncateSpec(figmaSpec), null, 2)}\n\`\`\`\n\n`;

  // Add current Dart files
  userPrompt += `### Current Dart Implementation\n`;
  for (const [path, content] of Object.entries(dartFiles)) {
    userPrompt += `#### ${path}\n\`\`\`dart\n${content}\n\`\`\`\n\n`;
  }
  userPrompt += `Fix ALL the discrepancies listed above. Match the Figma spec exactly. Output ONLY the JSON array of edits.`;

  try {
    const response = await client.messages.create(
      {
        model: MODEL,
        max_tokens: MAX_TOKENS,
        system: [{ type: 'text', text: getVisualFixPrompt(), cache_control: { type: 'ephemeral' } }],
        messages: [{ role: 'user', content: userPrompt }],
      },
      { signal: controller.signal },
    );
    clearTimeout(timeout);

    const raw = response.content[0]?.text;
    if (!raw) return null;

    console.log(`  📊 Fix tokens — input: ${response.usage.input_tokens}, output: ${response.usage.output_tokens}`);

    const edits = extractJsonArray(raw);
    if (!edits) {
      console.error('  ❌ Failed to parse fix response');
      writeFileSync(join(SYNC_LOG_DIR, `${name}_fix-failed.txt`), raw, 'utf8');
      return null;
    }
    return edits;
  } catch (err) {
    clearTimeout(timeout);
    console.error(`  ❌ Fix call failed: ${err.message}`);
    return null;
  }
}

// ── Run visual-only comparison for a component ────────────────
async function runVisualCheck(name, cfg) {
  if (!cfg.golden_test || !cfg.golden_files?.length) {
    return { verdict: 'SKIP', score: 0, reason: 'No golden test configured' };
  }

  const goldenTestPath = join(ROOT, cfg.golden_test);
  if (!existsSync(goldenTestPath)) {
    return { verdict: 'SKIP', score: 0, reason: 'Golden test file missing' };
  }

  // Ensure goldens exist (generate if needed)
  const anyMissing = cfg.golden_files.some(f => !existsSync(join(ROOT, f)));
  if (anyMissing) {
    console.log(`  🖼️  Generating golden PNGs...`);
    runGoldenTests(cfg.golden_test, true);
  }

  // Check Figma reference image
  const figmaImgPath = join(ROOT, 'kb', 'components', 'images', `${name}.png`);
  if (!existsSync(figmaImgPath)) {
    if (FIGMA_TOKEN) {
      console.log('  📸 Downloading Figma reference screenshot...');
      try {
        const imgData = await figmaGet(`/images/${FILE_KEY}?ids=${cfg.page_id}&format=png&scale=2`);
        const imgUrl = imgData.images?.[cfg.page_id];
        if (imgUrl) {
          const imgBuf = await downloadImage(imgUrl);
          mkdirSync(join(ROOT, 'kb', 'components', 'images'), { recursive: true });
          writeFileSync(figmaImgPath, imgBuf);
        }
        await sleep(RATE_DELAY);
      } catch (err) {
        console.log(`  ⚠️  Figma screenshot failed: ${err.message}`);
      }
    }
    if (!existsSync(figmaImgPath)) {
      return { verdict: 'SKIP', score: 0, reason: 'No Figma reference image' };
    }
  }

  // Load spec for context
  const specPath = join(SPECS_DIR, `${name}.json`);
  const spec = existsSync(specPath) ? JSON.parse(readFileSync(specPath, 'utf8')) : null;

  return visualCompare(name, cfg.golden_files, figmaImgPath, spec);
}

// ── Extract JSON array from Claude response ───────────────────
// Claude sometimes wraps JSON in markdown or adds explanatory text
function extractJsonArray(raw) {
  // Strategy 1: direct parse
  const trimmed = raw.trim();
  try {
    const parsed = JSON.parse(trimmed);
    if (Array.isArray(parsed)) return parsed;
  } catch { /* continue */ }

  // Strategy 2: strip markdown fences
  const stripped = trimmed.replace(/^```json\n?/m, '').replace(/\n?```$/m, '').trim();
  try {
    const parsed = JSON.parse(stripped);
    if (Array.isArray(parsed)) return parsed;
  } catch { /* continue */ }

  // Strategy 3: find JSON array with bracket matching
  const start = raw.indexOf('[');
  if (start >= 0) {
    let depth = 0;
    let inString = false;
    let escape = false;
    for (let i = start; i < raw.length; i++) {
      const ch = raw[i];
      if (escape) { escape = false; continue; }
      if (ch === '\\') { escape = true; continue; }
      if (ch === '"') { inString = !inString; continue; }
      if (inString) continue;
      if (ch === '[') depth++;
      if (ch === ']') {
        depth--;
        if (depth === 0) {
          try {
            const parsed = JSON.parse(raw.slice(start, i + 1));
            if (Array.isArray(parsed)) return parsed;
          } catch { /* continue scanning */ }
        }
      }
    }
  }

  return null;
}

// ── Main ───────────────────────────────────────────────────────
async function main() {
  mkdirSync(BACKUP_DIR, { recursive: true });
  mkdirSync(SYNC_LOG_DIR, { recursive: true });

  const components = Object.entries(componentMap.components);

  // Filter to target components
  let targets;
  if (componentArg) {
    const cfg = componentMap.components[componentArg];
    if (!cfg) {
      console.error(`❌ Unknown component: ${componentArg}`);
      console.error(`   Available: ${components.map(([n]) => n).join(', ')}`);
      process.exit(1);
    }
    if (cfg.dart_files.length === 0) {
      console.error(`❌ ${componentArg} has no Dart implementation (dart_files is empty)`);
      console.error(`   Use figma-to-widget.mjs to generate a new widget, not sync-component.mjs`);
      process.exit(1);
    }
    targets = [[componentArg, cfg]];
  } else {
    // --all: only implemented components
    targets = components.filter(([, cfg]) => cfg.dart_files.length > 0);
    console.log(`🔄 Scanning ${targets.length} implemented components for changes...`);
  }

  const results = [];

  for (const [name, cfg] of targets) {
    console.log(`\n━━━ ${name} (${cfg.figma_name}) ━━━`);

    // ── VISUAL-ONLY mode: just compare and report ─────────────
    if (visualOnly) {
      const vr = await runVisualCheck(name, cfg);
      const icon = vr.verdict === 'PASS' ? '✅' : vr.verdict === 'FAIL' ? '❌' : '⚠️';
      console.log(`  ${icon} Score: ${vr.score ?? '?'}/100 — ${vr.verdict}`);
      if (vr.discrepancies?.length) {
        for (const d of vr.discrepancies.slice(0, 5)) {
          console.log(`     ${d.severity === 'critical' ? '🔴' : '🟡'} ${d.property}`);
        }
      }
      results.push({ name, status: vr.verdict, visual: { verdict: vr.verdict, score: vr.score } });
      continue;
    }

    // ── FIX-VISUAL mode: iterative fix loop ───────────────────
    if (fixVisual) {
      let attempt = 0;
      let lastVisual = null;

      while (attempt < maxFixAttempts) {
        attempt++;
        console.log(`\n  🔄 Fix attempt ${attempt}/${maxFixAttempts}`);

        // Step 1: Check current visual score
        const vr = await runVisualCheck(name, cfg);
        lastVisual = vr;

        if (vr.verdict === 'SKIP') {
          console.log(`  ⚠️  ${vr.reason}`);
          break;
        }

        console.log(`  📊 Current score: ${vr.score}/100`);
        if (vr.score >= targetScore) {
          console.log(`  ✅ Score ${vr.score} >= target ${targetScore} — done!`);
          break;
        }

        // Step 2: Load current Dart files
        const dartFiles = loadDartFiles(cfg.dart_files);
        if (Object.keys(dartFiles).length === 0) {
          console.log('  ⚠️  No Dart files found');
          break;
        }

        // Step 3: Load Figma spec
        const specPath = join(SPECS_DIR, `${name}.json`);
        const figmaSpec = existsSync(specPath) ? JSON.parse(readFileSync(specPath, 'utf8')) : null;

        // Step 4: Send discrepancies to Claude for fix
        const edits = await fixVisualIssues(name, vr, figmaSpec, dartFiles, cfg);
        if (!edits || edits.length === 0) {
          console.log('  ⚠️  Claude returned no fixes');
          break;
        }

        // Step 5: Validate + apply
        try { validateEdits(edits); } catch (err) {
          console.error(`  ${err.message}`);
          break;
        }

        // Backup
        for (const edit of edits) {
          const srcPath = join(ROOT, edit.path);
          if (existsSync(srcPath)) {
            const bak = join(BACKUP_DIR, `${name}_${edit.path.replace(/\//g, '_')}_attempt${attempt}.bak`);
            copyFileSync(srcPath, bak);
          }
        }

        // Apply
        for (const edit of edits) {
          const fullPath = join(ROOT, edit.path);
          mkdirSync(join(ROOT, edit.path.substring(0, edit.path.lastIndexOf('/'))), { recursive: true });
          writeFileSync(fullPath, edit.content, 'utf8');
          console.log(`  ✏️  ${edit.path}`);
          if (edit.changes_made) {
            for (const c of edit.changes_made) console.log(`     → ${c}`);
          }
        }

        // Step 6: flutter analyze
        if (!skipAnalyze) {
          if (!runFlutterAnalyze()) {
            console.error('  ❌ Analyze failed — rolling back');
            // Restore from backup
            for (const edit of edits) {
              const bak = join(BACKUP_DIR, `${name}_${edit.path.replace(/\//g, '_')}_attempt${attempt}.bak`);
              if (existsSync(bak)) copyFileSync(bak, join(ROOT, edit.path));
            }
            break;
          }
        }

        // Step 7: Update goldens after fix
        runGoldenTests(cfg.golden_test, true);
      }

      // Final score
      const finalVr = await runVisualCheck(name, cfg);
      const icon = finalVr.score >= targetScore ? '✅' : '❌';
      console.log(`\n  ${icon} Final score: ${finalVr.score}/100 (target: ${targetScore}) after ${attempt} attempt(s)`);
      results.push({
        name,
        status: finalVr.score >= targetScore ? 'FIXED' : 'BELOW_TARGET',
        visual: { verdict: finalVr.verdict, score: finalVr.score },
        attempts: attempt,
      });
      continue;
    }

    // ── 1. Get new spec ────────────────────────────────────────
    let newSpec;
    if (specDirArg) {
      const specPath = join(specDirArg, `${name}.json`);
      if (!existsSync(specPath)) {
        console.log(`  ⚠️  No spec at ${specPath}, skipping`);
        results.push({ name, status: 'NO_SPEC' });
        continue;
      }
      newSpec = JSON.parse(readFileSync(specPath, 'utf8'));
    } else {
      if (!FIGMA_TOKEN) {
        console.error('❌ FIGMA_TOKEN required for live Figma extraction');
        process.exit(1);
      }
      try {
        newSpec = await fetchComponentSpec(name, cfg);
      } catch (err) {
        console.error(`  ❌ Figma fetch failed: ${err.message}`);
        results.push({ name, status: 'FETCH_ERROR', error: err.message });
        continue;
      }
      await sleep(RATE_DELAY);
    }

    if (newSpec.status === 'empty') {
      console.log('  ⚠️  Empty Figma page, skipping');
      results.push({ name, status: 'EMPTY_PAGE' });
      continue;
    }

    // ── 2. Load old spec + diff ────────────────────────────────
    const oldSpecPath = join(SPECS_DIR, `${name}.json`);
    const oldSpec = existsSync(oldSpecPath)
      ? JSON.parse(readFileSync(oldSpecPath, 'utf8'))
      : null;

    const diff = diffSpecs(oldSpec, newSpec);

    if (!diff.hasChanges && !forceSync) {
      console.log('  ✅ No changes detected — spec matches saved version');
      results.push({ name, status: 'NO_CHANGES' });
      continue;
    }

    console.log(`  📋 Changes detected:`);
    for (const s of diff.summary) console.log(`     ${s}`);
    if (diff.properties.length > 0) {
      console.log(`     ${diff.properties.length} property-level changes`);
    }

    // ── 3. Load Dart source ────────────────────────────────────
    const dartFiles = loadDartFiles(cfg.dart_files);
    if (Object.keys(dartFiles).length === 0) {
      console.log('  ⚠️  No Dart files found on disk, skipping');
      results.push({ name, status: 'NO_DART_FILES' });
      continue;
    }

    console.log(`  📂 Dart files: ${Object.keys(dartFiles).join(', ')}`);

    // ── 4. Build prompt ────────────────────────────────────────
    const userPrompt = buildUserPrompt(name, diff, newSpec, dartFiles);

    if (dryRun) {
      console.log('\n  🏁 DRY RUN — prompt built but not sent to Claude');
      console.log(`     Prompt size: ${userPrompt.length} chars`);

      // Save prompt for inspection
      const dryPath = join(SYNC_LOG_DIR, `${name}_dry-run.md`);
      writeFileSync(dryPath, `# Dry Run: ${name}\n\n${userPrompt}`, 'utf8');
      console.log(`     Saved to: ${dryPath}`);

      results.push({ name, status: 'DRY_RUN', promptSize: userPrompt.length });
      continue;
    }

    // ── 5. Call Claude ─────────────────────────────────────────
    console.log('  🤖 Sending to Claude...');
    const client = new Anthropic();
    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), TIMEOUT_MS);

    let edits;
    try {
      const response = await client.messages.create(
        {
          model: MODEL,
          max_tokens: MAX_TOKENS,
          system: [{ type: 'text', text: getSystemPrompt(), cache_control: { type: 'ephemeral' } }],
          messages: [{ role: 'user', content: userPrompt }],
        },
        { signal: controller.signal },
      );

      clearTimeout(timeout);

      const raw = response.content[0]?.text;
      if (!raw) throw new Error('Empty response from Claude');

      // Parse — try multiple strategies to extract JSON
      edits = extractJsonArray(raw);
      if (!edits) {
        console.error('  ❌ Failed to extract JSON array from Claude response:');
        console.error(raw.slice(0, 500));
        writeFileSync(join(SYNC_LOG_DIR, `${name}_failed-response.txt`), raw, 'utf8');
        results.push({ name, status: 'PARSE_ERROR' });
        continue;
      }

      if (!Array.isArray(edits)) throw new Error('Expected JSON array');

      console.log(`  📊 Tokens — input: ${response.usage.input_tokens}, output: ${response.usage.output_tokens}`);
      if (response.usage.cache_read_input_tokens) {
        console.log(`     Cache hit: ${response.usage.cache_read_input_tokens}`);
      }
    } catch (err) {
      clearTimeout(timeout);
      if (err.name === 'AbortError') {
        console.error('  ⏰ Claude call timed out');
        results.push({ name, status: 'TIMEOUT' });
        continue;
      }
      throw err;
    }

    // ── 6. Validate + apply ────────────────────────────────────
    let syncStatus = null;
    if (edits.length === 0) {
      console.log('  ✅ Claude determined no code changes needed');
      syncStatus = 'NO_EDITS_NEEDED';
    } else {
      try {
        validateEdits(edits);
      } catch (err) {
        console.error(`  ${err.message}`);
        results.push({ name, status: 'BLOCKED' });
        continue;
      }

      // Backup current Dart files before overwrite
      for (const edit of edits) {
        const srcPath = join(ROOT, edit.path);
        if (existsSync(srcPath)) {
          const backupPath = join(BACKUP_DIR, `${name}_${edit.path.replace(/\//g, '_')}.bak`);
          copyFileSync(srcPath, backupPath);
        }
      }

      // Apply edits
      const { dirname } = await import('node:path');
      for (const edit of edits) {
        const fullPath = join(ROOT, edit.path);
        mkdirSync(dirname(fullPath), { recursive: true });
        writeFileSync(fullPath, edit.content, 'utf8');
        console.log(`  ✏️  ${edit.action}: ${edit.path}`);
        if (edit.changes_made) {
          for (const c of edit.changes_made) console.log(`     → ${c}`);
        }
      }

      // Run flutter analyze
      if (!skipAnalyze) {
        const analyzeOk = runFlutterAnalyze();
        if (!analyzeOk) {
          console.log('  ⚠️  Analyze failed — edits applied but may need manual review');
          results.push({ name, status: 'ANALYZE_FAILED', edits: edits.length });
          continue;
        }
      }

      syncStatus = 'SYNCED';
    }

    // ── 7. Visual validation: golden tests + Figma comparison ──
    let visualResult = null;
    if (cfg.golden_test && !dryRun) {
      const goldenTestPath = join(ROOT, cfg.golden_test);
      if (existsSync(goldenTestPath)) {
        // Step A: Run goldens WITHOUT update → detect what changed
        if (edits?.length > 0) {
          const checkResult = runGoldenTests(cfg.golden_test);
          if (!checkResult.ok) {
            // Expected: rendering changed because code changed
            // Step B: Update goldens to get new baseline PNGs
            const updateResult = runGoldenTests(cfg.golden_test, true);
            if (!updateResult.ok) {
              console.error('  ❌ Golden update failed — code edits may have broken the widget');
              results.push({ name, status: 'GOLDEN_BROKEN', edits: edits.length });
              continue;
            }
          } else {
            console.log('  ℹ️  Goldens still pass — code changes may not affect rendering');
          }
        }

        // Step C: Compare golden PNGs vs Figma reference image
        if (cfg.golden_files?.length > 0) {
          // Ensure Figma reference image exists
          const figmaImgPath = join(ROOT, 'kb', 'components', 'images', `${name}.png`);
          if (!existsSync(figmaImgPath) && FIGMA_TOKEN) {
            console.log('  📸 Downloading Figma reference screenshot...');
            try {
              const imgData = await figmaGet(`/images/${FILE_KEY}?ids=${cfg.page_id}&format=png&scale=2`);
              const imgUrl = imgData.images?.[cfg.page_id];
              if (imgUrl) {
                const imgBuf = await downloadImage(imgUrl);
                mkdirSync(join(ROOT, 'kb', 'components', 'images'), { recursive: true });
                writeFileSync(figmaImgPath, imgBuf);
                console.log(`  ✅ Saved Figma reference: ${figmaImgPath}`);
              }
              await sleep(RATE_DELAY);
            } catch (err) {
              console.log(`  ⚠️  Figma screenshot failed: ${err.message}`);
            }
          }

          if (existsSync(figmaImgPath)) {
            visualResult = await visualCompare(name, cfg.golden_files, figmaImgPath, newSpec);

            if (visualResult.verdict === 'PASS') {
              console.log(`  ✅ Visual match: ${visualResult.score}/100`);
              if (visualResult.matches?.length) {
                console.log(`     Matches: ${visualResult.matches.slice(0, 5).join(', ')}`);
              }
            } else if (visualResult.verdict === 'FAIL') {
              console.log(`  ⚠️  Visual discrepancies: ${visualResult.score}/100`);
              for (const d of (visualResult.discrepancies || []).slice(0, 5)) {
                const sev = d.severity === 'critical' ? '🔴' : '🟡';
                console.log(`     ${sev} ${d.property}: Figma=${d.figma}, Flutter=${d.flutter}`);
              }
              if (visualResult.recommendation) {
                console.log(`     💡 ${visualResult.recommendation}`);
              }
            } else {
              console.log(`  ❓ Visual comparison inconclusive`);
            }
          } else {
            console.log('  ⚠️  No Figma reference image — skipping visual comparison');
          }
        }
      }
    }

    results.push({
      name,
      status: syncStatus || 'NO_EDITS_NEEDED',
      edits: edits?.length || 0,
      visual: visualResult ? { verdict: visualResult.verdict, score: visualResult.score } : null,
    });

    // ── 8. Save new spec (update baseline) ─────────────────────
    if (!dryRun) {
      if (existsSync(oldSpecPath)) {
        const ts = new Date().toISOString().replace(/[:.]/g, '-').slice(0, 19);
        copyFileSync(oldSpecPath, join(BACKUP_DIR, `${name}_${ts}.json`));
      }
      writeFileSync(oldSpecPath, JSON.stringify(newSpec, null, 2), 'utf8');
    }

    // ── 9. Save sync log ───────────────────────────────────────
    const log = {
      component: name,
      timestamp: new Date().toISOString(),
      diff: { summary: diff.summary, propertyChanges: diff.properties.length, variantsAdded: diff.variants.added, variantsRemoved: diff.variants.removed },
      editsApplied: edits?.length || 0,
      changesMade: (edits || []).flatMap(e => e.changes_made || []),
      visual: visualResult || null,
    };
    const logPath = join(SYNC_LOG_DIR, `${name}_${new Date().toISOString().replace(/[:.]/g, '-').slice(0, 19)}.json`);
    writeFileSync(logPath, JSON.stringify(log, null, 2), 'utf8');
  }

  // ── Summary ──────────────────────────────────────────────────
  console.log('\n━━━ Sync Summary ━━━');
  for (const r of results) {
    const icon = {
      SYNCED: '✅', NO_CHANGES: '⏭️ ', DRY_RUN: '🏁', NO_EDITS_NEEDED: '✅',
      FIXED: '✅', BELOW_TARGET: '❌', PASS: '✅', FAIL: '❌', SKIP: '⚠️ ',
      FETCH_ERROR: '❌', PARSE_ERROR: '❌', TIMEOUT: '⏰', BLOCKED: '🚫',
      ANALYZE_FAILED: '⚠️ ', GOLDEN_BROKEN: '💥', EMPTY_PAGE: '⚠️ ', NO_SPEC: '⚠️ ', NO_DART_FILES: '⚠️ ',
    }[r.status] || '❓';
    const extra = r.edits ? ` (${r.edits} files)` : '';
    const vis = r.visual ? ` | Visual: ${r.visual.verdict} ${r.visual.score ?? '?'}/100` : '';
    console.log(`  ${icon} ${r.name}: ${r.status}${extra}${vis}`);
  }

  const synced = results.filter(r => r.status === 'SYNCED').length;
  const noChanges = results.filter(r => r.status === 'NO_CHANGES').length;
  const errors = results.filter(r => ['FETCH_ERROR', 'PARSE_ERROR', 'TIMEOUT', 'BLOCKED', 'ANALYZE_FAILED', 'GOLDEN_BROKEN'].includes(r.status)).length;
  const visualFails = results.filter(r => r.visual?.verdict === 'FAIL').length;

  console.log(`\n  Total: ${results.length} | Synced: ${synced} | No changes: ${noChanges} | Errors: ${errors}`);
  if (visualFails > 0) console.log(`  ⚠️  ${visualFails} component(s) with visual discrepancies — review sync logs`);

  if (errors > 0) process.exit(1);
}

main().catch(err => {
  console.error('💥 Fatal:', err.message);
  process.exit(1);
});
