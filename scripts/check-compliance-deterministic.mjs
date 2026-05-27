#!/usr/bin/env node

/**
 * check-compliance-deterministic.mjs
 *
 * Deterministic design-token compliance checker.
 * Parses concrete values from Dart source and Figma spec JSON,
 * then compares them numerically — no LLM involved.
 *
 * Usage:
 *   node scripts/check-compliance-deterministic.mjs --component badges
 *   node scripts/check-compliance-deterministic.mjs              # all components
 *   node scripts/check-compliance-deterministic.mjs --json       # machine-readable
 */

import { readFileSync, existsSync, readdirSync } from 'node:fs';
import { join, resolve } from 'node:path';

const ROOT = resolve(import.meta.dirname, '..');
const MAP_PATH = join(ROOT, 'config', 'component-map.json');
const KB_DIR = join(ROOT, 'kb', 'components');

// ─── CLI args ────────────────────────────────────────────────────────────────

const args = process.argv.slice(2);
const componentArg = args.find(a => a.startsWith('--component'));
const componentFilter = componentArg
  ? (componentArg.includes('=')
      ? componentArg.split('=')[1]
      : args[args.indexOf('--component') + 1])
  : null;
const jsonOutput = args.includes('--json');

// ─── Dart source parsers ─────────────────────────────────────────────────────

/**
 * Extract design tokens from Dart source code.
 * Returns an array of { property, value, line }.
 */
function parseDartTokens(source, filePath) {
  const tokens = [];
  const lines = source.split('\n');

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    const lineNum = i + 1;

    // Colors: Color(0xFFxxxxxx) or Color(0x...)
    for (const m of line.matchAll(/Color\((0x[0-9A-Fa-f]+)\)/g)) {
      const raw = m[1].toUpperCase();
      // Normalise to #RRGGBB (strip alpha prefix if 0xAARRGGBB)
      const hex = raw.length === 10
        ? '#' + raw.slice(4)           // 0xAARRGGBB → #RRGGBB
        : '#' + raw.slice(2);          // shorter forms
      tokens.push({ property: 'color', value: hex, line: lineNum, file: filePath });
    }

    // EdgeInsets.all(N)
    for (const m of line.matchAll(/EdgeInsets\.all\(\s*([\d.]+)\s*\)/g)) {
      const v = parseFloat(m[1]);
      tokens.push({ property: 'padding.all', value: v, line: lineNum, file: filePath });
    }

    // EdgeInsets.symmetric(horizontal: N, vertical: N)
    for (const m of line.matchAll(/EdgeInsets\.symmetric\(([^)]+)\)/g)) {
      const body = m[1];
      const h = body.match(/horizontal:\s*([\d.]+)/);
      const v = body.match(/vertical:\s*([\d.]+)/);
      if (h) tokens.push({ property: 'padding.horizontal', value: parseFloat(h[1]), line: lineNum, file: filePath });
      if (v) tokens.push({ property: 'padding.vertical', value: parseFloat(v[1]), line: lineNum, file: filePath });
    }

    // EdgeInsets.only(left: N, top: N, right: N, bottom: N)
    for (const m of line.matchAll(/EdgeInsets\.only\(([^)]+)\)/g)) {
      const body = m[1];
      for (const side of ['left', 'top', 'right', 'bottom']) {
        const sm = body.match(new RegExp(`${side}:\\s*([\\d.]+)`));
        if (sm) tokens.push({ property: `padding.${side}`, value: parseFloat(sm[1]), line: lineNum, file: filePath });
      }
    }

    // BorderRadius.circular(N)
    for (const m of line.matchAll(/BorderRadius\.circular\(\s*([\d.]+)\s*\)/g)) {
      tokens.push({ property: 'borderRadius', value: parseFloat(m[1]), line: lineNum, file: filePath });
    }

    // BorderRadius.only(topLeft: Radius.circular(N), ...)
    for (const m of line.matchAll(/BorderRadius\.only\(([^)]*(?:\([^)]*\)[^)]*)*)\)/g)) {
      const body = m[1];
      for (const corner of ['topLeft', 'topRight', 'bottomLeft', 'bottomRight']) {
        const cm = body.match(new RegExp(`${corner}:\\s*Radius\\.circular\\(\\s*([\\d.]+)\\s*\\)`));
        if (cm) tokens.push({ property: `borderRadius.${corner}`, value: parseFloat(cm[1]), line: lineNum, file: filePath });
      }
    }

    // fontSize: N (both in TextStyle constructor and standalone)
    for (const m of line.matchAll(/fontSize:\s*([\d.]+)/g)) {
      tokens.push({ property: 'fontSize', value: parseFloat(m[1]), line: lineNum, file: filePath });
    }

    // fontWeight: FontWeight.wNNN
    for (const m of line.matchAll(/fontWeight:\s*FontWeight\.w(\d+)/g)) {
      tokens.push({ property: 'fontWeight', value: parseInt(m[1], 10), line: lineNum, file: filePath });
    }

    // SizedBox(width: N, height: N) — extract both
    for (const m of line.matchAll(/SizedBox\(([^)]+)\)/g)) {
      const body = m[1];
      const w = body.match(/width:\s*([\d.]+)/);
      const h = body.match(/height:\s*([\d.]+)/);
      if (w) tokens.push({ property: 'spacing.width', value: parseFloat(w[1]), line: lineNum, file: filePath });
      if (h) tokens.push({ property: 'spacing.height', value: parseFloat(h[1]), line: lineNum, file: filePath });
    }

    // BoxShadow(color: ..., blurRadius: N, offset: Offset(x, y), spreadRadius: N)
    for (const m of line.matchAll(/BoxShadow\(([^)]*(?:\([^)]*\)[^)]*)*)\)/g)) {
      const body = m[1];
      const blur = body.match(/blurRadius:\s*([\d.]+)/);
      const spread = body.match(/spreadRadius:\s*([\d.]+)/);
      const offset = body.match(/Offset\(\s*([\d.-]+)\s*,\s*([\d.-]+)\s*\)/);
      if (blur) tokens.push({ property: 'shadow.blurRadius', value: parseFloat(blur[1]), line: lineNum, file: filePath });
      if (spread) tokens.push({ property: 'shadow.spreadRadius', value: parseFloat(spread[1]), line: lineNum, file: filePath });
      if (offset) {
        tokens.push({ property: 'shadow.offsetX', value: parseFloat(offset[1]), line: lineNum, file: filePath });
        tokens.push({ property: 'shadow.offsetY', value: parseFloat(offset[2]), line: lineNum, file: filePath });
      }
    }

    // Explicit width/height on Container or style constants
    // Matches: double someSize = 6.0; or width: 16 inside Container
    // We capture named size constants: `static const double xxxSize = N`
    for (const m of line.matchAll(/static\s+const\s+double\s+(\w+)\s*=\s*([\d.]+)/g)) {
      const name = m[1];
      const val = parseFloat(m[2]);
      if (name.toLowerCase().includes('size') || name.toLowerCase().includes('width') || name.toLowerCase().includes('height')) {
        tokens.push({ property: `dimension.${name}`, value: val, line: lineNum, file: filePath });
      }
      if (name.toLowerCase().includes('radius')) {
        tokens.push({ property: 'borderRadius', value: val, line: lineNum, file: filePath });
      }
    }
  }

  return tokens;
}

// ─── Figma spec parsers ──────────────────────────────────────────────────────

/**
 * Recursively collect design tokens from a Figma component spec node.
 */
function collectFigmaTokens(node, tokens = [], path = '') {
  const prefix = path ? `${path}.` : '';

  // fills → colors
  if (node.fills && Array.isArray(node.fills)) {
    for (const fill of node.fills) {
      if (fill.type === 'SOLID' && fill.hex) {
        tokens.push({ property: 'color', value: fill.hex.toUpperCase() });
      }
    }
  }

  // cornerRadius
  if (node.cornerRadius != null && node.cornerRadius !== 0) {
    tokens.push({ property: 'borderRadius', value: node.cornerRadius });
  }

  // width / height (component-level dimensions)
  if (node.width != null) {
    tokens.push({ property: 'dimension.width', value: node.width });
  }
  if (node.height != null) {
    tokens.push({ property: 'dimension.height', value: node.height });
  }

  // layout padding
  if (node.layout && node.layout.padding) {
    const p = node.layout.padding;
    if (p.top != null) tokens.push({ property: 'padding.top', value: p.top });
    if (p.right != null) tokens.push({ property: 'padding.right', value: p.right });
    if (p.bottom != null) tokens.push({ property: 'padding.bottom', value: p.bottom });
    if (p.left != null) tokens.push({ property: 'padding.left', value: p.left });
  }

  // layout spacing
  if (node.layout && node.layout.spacing != null) {
    tokens.push({ property: 'spacing', value: node.layout.spacing });
  }

  // fontSize (from style or direct)
  if (node.style && node.style.fontSize != null) {
    tokens.push({ property: 'fontSize', value: node.style.fontSize });
  }
  if (node.fontSize != null) {
    tokens.push({ property: 'fontSize', value: node.fontSize });
  }

  // fontWeight
  if (node.style && node.style.fontWeight != null) {
    tokens.push({ property: 'fontWeight', value: node.style.fontWeight });
  }

  // effects → shadows
  if (node.effects && Array.isArray(node.effects)) {
    for (const fx of node.effects) {
      if (fx.type === 'DROP_SHADOW' || fx.type === 'INNER_SHADOW') {
        if (fx.radius != null) tokens.push({ property: 'shadow.blurRadius', value: fx.radius });
        if (fx.spread != null) tokens.push({ property: 'shadow.spreadRadius', value: fx.spread });
        if (fx.offset) {
          if (fx.offset.x != null) tokens.push({ property: 'shadow.offsetX', value: fx.offset.x });
          if (fx.offset.y != null) tokens.push({ property: 'shadow.offsetY', value: fx.offset.y });
        }
        if (fx.color && fx.color.hex) {
          tokens.push({ property: 'color.shadow', value: fx.color.hex.toUpperCase() });
        }
      }
    }
  }

  // opacity
  if (node.opacity != null && node.opacity !== 1) {
    tokens.push({ property: 'opacity', value: node.opacity });
  }

  // Recurse children
  if (node.children && Array.isArray(node.children)) {
    for (const child of node.children) {
      collectFigmaTokens(child, tokens, `${prefix}${child.name || ''}`);
    }
  }

  return tokens;
}

/**
 * Extract a deduplicated set of Figma spec values grouped by property.
 * Returns Map<property, Set<value>>
 */
function parseFigmaSpec(specJson) {
  const byProp = new Map();

  for (const comp of (specJson.components || [])) {
    for (const variant of (comp.variants || [])) {
      const tokens = collectFigmaTokens(variant);
      for (const t of tokens) {
        if (!byProp.has(t.property)) byProp.set(t.property, new Set());
        byProp.get(t.property).add(typeof t.value === 'string' ? t.value : t.value);
      }
    }
  }

  return byProp;
}

// ─── Comparison engine ───────────────────────────────────────────────────────

/**
 * Normalise a hex colour to uppercase #RRGGBB.
 */
function normalizeHex(hex) {
  let h = String(hex).toUpperCase().replace(/^#/, '');
  // Handle 3-char shorthand
  if (h.length === 3) h = h[0] + h[0] + h[1] + h[1] + h[2] + h[2];
  // Handle 8-char with alpha
  if (h.length === 8) h = h.slice(2);
  return '#' + h;
}

/**
 * Check whether a Dart token value matches any value in the Figma spec set.
 */
function tokenMatches(dartToken, figmaValues, tolerance) {
  const prop = dartToken.property;
  const actual = dartToken.value;

  for (const expected of figmaValues) {
    if (prop.startsWith('color')) {
      // Exact hex match
      if (normalizeHex(actual) === normalizeHex(expected)) return { matched: true };
    } else if (prop === 'fontSize' || prop === 'fontWeight') {
      // Exact numeric match
      if (actual === expected) return { matched: true };
    } else {
      // Dimension tolerance (±1px)
      if (typeof actual === 'number' && typeof expected === 'number') {
        if (Math.abs(actual - expected) <= tolerance) return { matched: true };
      }
      // Fallback exact
      if (actual === expected) return { matched: true };
    }
  }

  return { matched: false, expected: [...figmaValues], actual };
}

/**
 * Run compliance check for a single component.
 */
function checkComponent(componentName, componentMap) {
  const entry = componentMap.components[componentName];
  if (!entry) return null;

  const specPath = join(KB_DIR, `${componentName}.json`);
  if (!existsSync(specPath)) {
    return { component: componentName, error: `Spec not found: ${specPath}` };
  }

  const dartFiles = entry.dart_files || [];
  if (dartFiles.length === 0) {
    return { component: componentName, error: 'No dart_files defined' };
  }

  // Parse Figma spec
  const specJson = JSON.parse(readFileSync(specPath, 'utf8'));
  const figmaTokens = parseFigmaSpec(specJson);

  // Parse all Dart files
  const allDartTokens = [];
  for (const relPath of dartFiles) {
    const absPath = join(ROOT, relPath);
    if (!existsSync(absPath)) continue;
    const source = readFileSync(absPath, 'utf8');
    allDartTokens.push(...parseDartTokens(source, relPath));
  }

  if (allDartTokens.length === 0) {
    return { component: componentName, error: 'No tokens extracted from Dart files' };
  }

  // Compare: for each Dart token, check if its value appears in the Figma spec.
  // We use a strict matching strategy:
  //   1. Exact property match (e.g. borderRadius ↔ borderRadius)
  //   2. Category fallback ONLY for color and padding (safe categories)
  //   3. dimension.* and spacing.* use the full numeric pool from Figma
  //      (all widths, heights, padding, spacing values) since Dart constant
  //      names don't map 1:1 to Figma node structure.

  // Build a pool of dimensional numeric values from Figma for dimension/spacing checks.
  // Only includes values from dimension.*, padding.*, spacing.*, borderRadius — NOT opacity.
  const dimensionalProps = ['dimension', 'padding', 'spacing', 'borderRadius'];
  const allFigmaDimensionValues = new Set();
  for (const [fp, fv] of figmaTokens) {
    const cat = fp.split('.')[0];
    if (dimensionalProps.includes(cat) || dimensionalProps.includes(fp)) {
      for (const v of fv) {
        if (typeof v === 'number') allFigmaDimensionValues.add(v);
      }
    }
  }

  const matched = [];
  const mismatched = [];
  const seen = new Set(); // dedupe by property+value+file+line

  for (const dt of allDartTokens) {
    const dedupeKey = `${dt.property}|${dt.value}|${dt.file}|${dt.line}`;
    if (seen.has(dedupeKey)) continue;
    seen.add(dedupeKey);

    const category = dt.property.split('.')[0];

    // Find the best Figma value set to compare against
    let figmaValues = figmaTokens.get(dt.property);

    if (!figmaValues) {
      if (category === 'color') {
        // Pool all Figma color values
        const candidates = new Set();
        for (const [fp, fv] of figmaTokens) {
          if (fp.startsWith('color')) {
            for (const v of fv) candidates.add(v);
          }
        }
        if (candidates.size > 0) figmaValues = candidates;
      } else if (category === 'padding') {
        // Pool all Figma padding values
        const candidates = new Set();
        for (const [fp, fv] of figmaTokens) {
          if (fp.startsWith('padding')) {
            for (const v of fv) candidates.add(v);
          }
        }
        if (candidates.size > 0) figmaValues = candidates;
      } else if (category === 'dimension' || category === 'spacing') {
        // For dimensions/spacing, check against ALL numeric Figma values.
        // A Dart `static const double smallSize = 6.0` should match
        // Figma component width: 6, not be compared only to width: 48.
        figmaValues = allFigmaDimensionValues;
      }
      // borderRadius, fontSize, fontWeight: require exact property match
    }

    if (!figmaValues || figmaValues.size === 0) continue;

    const TOLERANCE = 1; // ±1px for dimensions
    const result = tokenMatches(dt, figmaValues, TOLERANCE);

    if (result.matched) {
      matched.push(dt);
    } else {
      mismatched.push({
        property: dt.property,
        expected: result.expected,
        actual: result.actual,
        file: dt.file,
        line: dt.line,
      });
    }
  }

  const totalTokens = matched.length + mismatched.length;
  const score = totalTokens > 0 ? Math.round((matched.length / totalTokens) * 100) : 100;

  return {
    component: componentName,
    score,
    total_tokens: totalTokens,
    matched: matched.length,
    mismatched: mismatched.length,
    mismatches: mismatched.map(m => ({
      property: m.property,
      expected: Array.isArray(m.expected) ? m.expected.join(' | ') : m.expected,
      actual: m.actual,
      file: m.file,
      line: m.line,
    })),
  };
}

// ─── Main ────────────────────────────────────────────────────────────────────

function main() {
  if (!existsSync(MAP_PATH)) {
    console.error(`Component map not found: ${MAP_PATH}`);
    process.exit(1);
  }

  const componentMap = JSON.parse(readFileSync(MAP_PATH, 'utf8'));
  const componentNames = componentFilter
    ? [componentFilter]
    : Object.keys(componentMap.components);

  const results = [];

  for (const name of componentNames) {
    const result = checkComponent(name, componentMap);
    if (result) results.push(result);
  }

  if (jsonOutput) {
    console.log(JSON.stringify(results.length === 1 ? results[0] : results, null, 2));
    return;
  }

  // Pretty-print
  console.log('\n╔══════════════════════════════════════════════════════════════╗');
  console.log('║         Deterministic Compliance Report                     ║');
  console.log('╚══════════════════════════════════════════════════════════════╝\n');

  let totalScore = 0;
  let scoredCount = 0;

  for (const r of results) {
    if (r.error) {
      console.log(`  ⚠  ${r.component}: ${r.error}`);
      continue;
    }

    const bar = scoreBar(r.score);
    console.log(`  ${bar} ${r.component}  ${r.score}%  (${r.matched}/${r.total_tokens} tokens)`);

    if (r.mismatches.length > 0) {
      for (const m of r.mismatches) {
        console.log(`       ✗ ${m.property}: expected ${m.expected}, got ${m.actual}`);
        console.log(`         ${m.file}:${m.line}`);
      }
    }

    totalScore += r.score;
    scoredCount++;
  }

  if (scoredCount > 1) {
    const avg = Math.round(totalScore / scoredCount);
    console.log(`\n  Average score: ${avg}% across ${scoredCount} components\n`);
  }
  console.log('');
}

function scoreBar(score) {
  const filled = Math.round(score / 5);
  const empty = 20 - filled;
  const color = score >= 90 ? '\x1b[32m' : score >= 70 ? '\x1b[33m' : '\x1b[31m';
  return `${color}[${'█'.repeat(filled)}${'░'.repeat(empty)}]\x1b[0m`;
}

main();
