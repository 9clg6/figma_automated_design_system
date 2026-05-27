#!/usr/bin/env node

/**
 * detect-drift.mjs
 *
 * Structural drift detection for Figma → KB component specs.
 *
 * Compares LIVE Figma component data against locally cached specs in
 * kb/components/<slug>.json. Uses design-aware diffing that ignores
 * noise (key ordering, float precision, positions, timestamps, IDs)
 * and only flags components where design-relevant values changed.
 *
 * Usage:
 *   FIGMA_TOKEN=... node scripts/detect-drift.mjs
 *   FIGMA_TOKEN=... node scripts/detect-drift.mjs --component badges
 *   FIGMA_TOKEN=... node scripts/detect-drift.mjs --component badges,buttons
 *
 * Outputs:
 *   stdout — human-readable summary
 *   kb/sync-logs/drift-report.json — machine-readable report for CI
 */

import { readFileSync, writeFileSync, mkdirSync, existsSync } from 'node:fs';
import { join, resolve } from 'node:path';
import { createFigmaClient, extractComponentSpec, findComponents, sleep } from './lib/figma-api.mjs';

// ── Config ────────────────────────────────────────────────────
const ROOT = resolve(import.meta.dirname, '..');
const MAP_PATH = join(ROOT, 'config', 'component-map.json');
const COMPONENTS_DIR = join(ROOT, 'kb', 'components');
const LOGS_DIR = join(ROOT, 'kb', 'sync-logs');
const REPORT_PATH = join(LOGS_DIR, 'drift-report.json');

const TOKEN = process.env.FIGMA_TOKEN;
if (!TOKEN) {
  console.error('FIGMA_TOKEN env var required');
  process.exit(1);
}

const componentMap = JSON.parse(readFileSync(MAP_PATH, 'utf8'));
const FILE_KEY = componentMap.figma_file;
const { figmaGet } = createFigmaClient(TOKEN, FILE_KEY);

// Parse --component filter
const compArg = process.argv.find((a) => a.startsWith('--component'));
const compFilter = compArg
  ? (compArg.includes('=')
      ? compArg.split('=')[1]
      : process.argv[process.argv.indexOf('--component') + 1]
    )?.split(',')
  : null;

// ── Build live spec from Figma page ──────────────────────────
function buildLiveSpec(page, cfg) {
  return {
    name: cfg.figma_name,
    page_id: cfg.page_id,
    dart_files: cfg.dart_files,
    has_implementation: cfg.dart_files.length > 0,
    variants: [],
    components: findComponents(page),
  };
}

// ── Structural comparison ─────────────────────────────────────

/** Fields ignored entirely during comparison. */
const IGNORED_FIELDS = new Set([
  'id',
  'page_id',
  'dart_files',
  'has_implementation',
  'status',
  'error',
  'pageSpec',        // full page tree — too noisy, only used for context
  'node_id',
  'style_id',
  'key',
  'extracted_at',
]);

/** Fields where position (x/y) is ignored; only size matters. */
const POSITION_FIELDS = new Set(['absoluteBoundingBox']);

/** Float comparison tolerance. */
const FLOAT_EPSILON = 0.01;

/**
 * Recursively compares two values in a design-relevant way.
 * Returns an array of human-readable diff strings.
 */
function structuralDiff(a, b, path = '') {
  const diffs = [];

  // Skip ignored fields
  const fieldName = path.split('.').pop();
  if (IGNORED_FIELDS.has(fieldName)) return diffs;

  // Both null/undefined → same
  if (a == null && b == null) return diffs;
  if (a == null || b == null) {
    diffs.push(`${path}: ${a == null ? 'added' : 'removed'}`);
    return diffs;
  }

  // Primitive types
  if (typeof a !== typeof b) {
    diffs.push(`${path}: type changed ${typeof a} → ${typeof b}`);
    return diffs;
  }

  if (typeof a === 'number' && typeof b === 'number') {
    if (Math.abs(a - b) > FLOAT_EPSILON) {
      diffs.push(`${path}: ${a} → ${b}`);
    }
    return diffs;
  }

  if (typeof a === 'string') {
    if (a !== b) diffs.push(`${path}: "${a}" → "${b}"`);
    return diffs;
  }

  if (typeof a === 'boolean') {
    if (a !== b) diffs.push(`${path}: ${a} → ${b}`);
    return diffs;
  }

  // Arrays — compare element-wise (order matters for variants)
  if (Array.isArray(a) && Array.isArray(b)) {
    // Match by name when available (variant reordering isn't drift)
    const aByName = new Map();
    const bByName = new Map();
    const aHasNames = a.every((item) => item && typeof item === 'object' && item.name);
    const bHasNames = b.every((item) => item && typeof item === 'object' && item.name);

    if (aHasNames && bHasNames) {
      for (const item of a) aByName.set(item.name, item);
      for (const item of b) bByName.set(item.name, item);

      // Removed
      for (const name of aByName.keys()) {
        if (!bByName.has(name)) {
          diffs.push(`${path}[${name}]: removed`);
        }
      }
      // Added
      for (const name of bByName.keys()) {
        if (!aByName.has(name)) {
          diffs.push(`${path}[${name}]: added`);
        }
      }
      // Changed
      for (const [name, aItem] of aByName) {
        const bItem = bByName.get(name);
        if (bItem) {
          diffs.push(...structuralDiff(aItem, bItem, `${path}[${name}]`));
        }
      }
    } else {
      // No names — positional compare
      const maxLen = Math.max(a.length, b.length);
      if (a.length !== b.length) {
        diffs.push(`${path}: array length ${a.length} → ${b.length}`);
      }
      for (let i = 0; i < Math.min(a.length, b.length); i++) {
        diffs.push(...structuralDiff(a[i], b[i], `${path}[${i}]`));
      }
    }
    return diffs;
  }

  // Objects
  if (typeof a === 'object' && typeof b === 'object') {
    const allKeys = new Set([...Object.keys(a), ...Object.keys(b)]);
    for (const key of allKeys) {
      if (IGNORED_FIELDS.has(key)) continue;
      diffs.push(...structuralDiff(a[key], b[key], path ? `${path}.${key}` : key));
    }
    return diffs;
  }

  return diffs;
}

/**
 * Filters diffs to only design-relevant changes.
 * Returns { designDiffs, noiseDiffs }.
 */
function classifyDiffs(diffs) {
  const designDiffs = [];
  const noiseDiffs = [];

  // Patterns that indicate design-relevant fields
  const DESIGN_PATTERNS = [
    /\.fills/,
    /\.strokes/,
    /\.effects/,
    /\.hex/,
    /\.opacity/,
    /\.color/,
    /\.gradient/,
    /\.cornerRadius/,
    /\.cornerRadii/,
    /\.strokeWeight/,
    /\.fontSize/,
    /\.fontWeight/,
    /\.fontFamily/,
    /\.letterSpacing/,
    /\.lineHeight/,
    /\.textAlign/,
    /\.textStyle/,
    /\.width(?!\.)/,        // size — not position
    /\.height(?!\.)/,       // size — not position
    /\.layout/,
    /\.spacing/,
    /\.padding/,
    /\.mode/,
    /\.align/,
    /\.crossAlign/,
    /\.blendMode/,
    /\.componentProperties/,
    /\.text(?!Style)/,      // actual text content
    /\.type(?!\.)/,         // node type changes
    /variants\[/,           // variant added/removed
    /components\[/,         // component added/removed
    /: added$/,
    /: removed$/,
  ];

  for (const diff of diffs) {
    if (DESIGN_PATTERNS.some((p) => p.test(diff))) {
      designDiffs.push(diff);
    } else {
      noiseDiffs.push(diff);
    }
  }

  return { designDiffs, noiseDiffs };
}

// ── Main ──────────────────────────────────────────────────────
async function main() {
  console.log('Drift detection starting...\n');

  const allComponents = Object.entries(componentMap.components);
  const components = compFilter
    ? allComponents.filter(([name]) => compFilter.includes(name))
    : allComponents;

  if (components.length === 0) {
    console.error('No components matched the filter.');
    process.exit(1);
  }

  console.log(`Checking ${components.length} components for drift...\n`);

  const changed = [];
  const unchanged = [];
  const newComps = [];
  const errors = [];
  const details = {};

  // Batch API calls (5 components per request, matching extract-figma-components.mjs)
  const BATCH_SIZE = 5;
  const RATE_DELAY = 4200;
  const batches = [];
  for (let i = 0; i < components.length; i += BATCH_SIZE) {
    batches.push(components.slice(i, i + BATCH_SIZE));
  }

  for (let bi = 0; bi < batches.length; bi++) {
    const batch = batches[bi];
    const ids = batch.map(([, cfg]) => cfg.page_id).join(',');
    console.log(
      `  Batch ${bi + 1}/${batches.length}: ${batch.map(([n]) => n).join(', ')}`,
    );

    let data;
    try {
      data = await figmaGet(`/files/${FILE_KEY}/nodes?ids=${ids}&depth=5`);
    } catch (err) {
      console.error(`    Batch failed: ${err.message}`);
      for (const [name] of batch) {
        errors.push({ name, error: err.message });
      }
      if (bi < batches.length - 1) await sleep(RATE_DELAY);
      continue;
    }

    for (const [name, cfg] of batch) {
      // Load current spec
      const specPath = join(COMPONENTS_DIR, `${name}.json`);
      if (!existsSync(specPath)) {
        console.log(`    ${name}: NEW (no local spec)`);
        newComps.push(name);
        continue;
      }

      let currentSpec;
      try {
        currentSpec = JSON.parse(readFileSync(specPath, 'utf8'));
      } catch {
        console.log(`    ${name}: NEW (invalid local spec)`);
        newComps.push(name);
        continue;
      }

      // Build live spec from Figma response
      const nodeData = data.nodes[cfg.page_id];
      if (!nodeData?.document) {
        console.log(`    ${name}: SKIP (no Figma data)`);
        errors.push({ name, error: 'no Figma data' });
        continue;
      }

      const liveSpec = buildLiveSpec(nodeData.document, cfg);

      // Compare only the components array (the design-relevant part)
      const rawDiffs = structuralDiff(
        currentSpec.components || [],
        liveSpec.components || [],
        'components',
      );

      const { designDiffs, noiseDiffs } = classifyDiffs(rawDiffs);

      if (designDiffs.length > 0) {
        console.log(`    ${name}: DRIFTED (${designDiffs.length} design changes)`);
        changed.push(name);
        details[name] = {
          designChanges: designDiffs.length,
          noiseChanges: noiseDiffs.length,
          diffs: designDiffs.slice(0, 20), // cap for readability
        };
      } else {
        const label = noiseDiffs.length > 0 ? `OK (${noiseDiffs.length} noise-only)` : 'OK';
        console.log(`    ${name}: ${label}`);
        unchanged.push(name);
      }
    }

    if (bi < batches.length - 1) await sleep(RATE_DELAY);
  }

  // ── Report ────────────────────────────────────────────────
  const report = {
    timestamp: new Date().toISOString(),
    changed,
    unchanged,
    new: newComps,
    errors: errors.length > 0 ? errors : undefined,
    details: Object.keys(details).length > 0 ? details : undefined,
    summary: buildSummary(changed, unchanged, newComps, errors),
    stats: {
      total: components.length,
      changed: changed.length,
      unchanged: unchanged.length,
      new: newComps.length,
      errors: errors.length,
    },
  };

  // Write report
  mkdirSync(LOGS_DIR, { recursive: true });
  writeFileSync(REPORT_PATH, JSON.stringify(report, null, 2) + '\n', 'utf8');

  // Human-readable output
  console.log('\n' + '='.repeat(60));
  console.log(report.summary);
  console.log('='.repeat(60));

  if (changed.length > 0) {
    console.log(`\nDrifted: ${changed.join(', ')}`);
    for (const name of changed) {
      const d = details[name];
      if (d?.diffs) {
        console.log(`\n  ${name} (${d.designChanges} changes):`);
        for (const diff of d.diffs.slice(0, 5)) {
          console.log(`    - ${diff}`);
        }
        if (d.diffs.length > 5) {
          console.log(`    ... and ${d.diffs.length - 5} more`);
        }
      }
    }
  }

  if (newComps.length > 0) {
    console.log(`\nNew components: ${newComps.join(', ')}`);
  }

  console.log(`\nReport written to ${REPORT_PATH}`);

  // Exit code: 0 = no drift, 1 = drift detected (for CI)
  // Use 0 always — the report itself indicates drift; CI reads the JSON
  process.exit(0);
}

function buildSummary(changed, unchanged, newComps, errors) {
  const parts = [];
  if (changed.length > 0) parts.push(`${changed.length} drifted`);
  if (unchanged.length > 0) parts.push(`${unchanged.length} unchanged`);
  if (newComps.length > 0) parts.push(`${newComps.length} new`);
  if (errors.length > 0) parts.push(`${errors.length} errors`);
  return parts.join(', ');
}

main().catch((err) => {
  console.error('Fatal:', err.message);
  process.exit(1);
});
