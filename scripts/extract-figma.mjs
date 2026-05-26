#!/usr/bin/env node

/**
 * extract-figma.mjs
 *
 * Custom Figma REST extractor — works on Free/Pro plans.
 *
 * Strategy (2 lightweight API calls, no rate limit issues):
 *   1. GET /v1/files/:key?depth=0       → check lastModified (skip if unchanged)
 *   2. GET /v1/files/:key/nodes?ids=...  → fetch ONLY the 2 relevant pages
 *
 * Outputs:
 *   kb/registries/colors.json
 *   kb/registries/typography.json
 *   kb/registries/effects.json
 *   kb/meta.json (version + lastModified for drift detection)
 */

import {
  readFileSync,
  writeFileSync,
  mkdirSync,
  existsSync,
  statSync,
} from 'node:fs';
import { join, resolve } from 'node:path';

// ── Config ─────────────────────────────────────────────────────
const ROOT = resolve(import.meta.dirname, '..');
const CONFIG_PATH = join(ROOT, 'config', 'figma-map.json');
const KB_DIR = join(ROOT, 'kb', 'registries');
const META_PATH = join(ROOT, 'kb', 'meta.json');

const FIGMA_TOKEN = process.env.FIGMA_TOKEN;
if (!FIGMA_TOKEN) {
  console.error('❌ FIGMA_TOKEN env var required');
  process.exit(1);
}

const config = JSON.parse(readFileSync(CONFIG_PATH, 'utf8'));
const FILE_KEY = config.figma_file_key;
if (!FILE_KEY) {
  console.error('❌ figma_file_key missing in config/figma-map.json');
  process.exit(1);
}

// Pages to fetch (only the relevant DS pages, not the full 136k-node file)
const DS_PAGE_IDS = config.figma_page_ids || ['58558:395', '58558:363'];

// ── Cache ──────────────────────────────────────────────────────
const CACHE_DIR = join(ROOT, '.cache');
const CACHE_TTL_MS = 60 * 60 * 1000; // 1 hour

function readCache(key) {
  const path = join(CACHE_DIR, `${key}.json`);
  if (!existsSync(path)) return null;
  const stat = statSync(path);
  if (Date.now() - stat.mtimeMs > CACHE_TTL_MS) return null;
  console.log(
    `   📦 Using cached ${key} (${Math.round((Date.now() - stat.mtimeMs) / 60000)}min old)`,
  );
  return JSON.parse(readFileSync(path, 'utf8'));
}

function writeCache(key, data) {
  mkdirSync(CACHE_DIR, { recursive: true });
  writeFileSync(join(CACHE_DIR, `${key}.json`), JSON.stringify(data), 'utf8');
}

// ── Figma API ──────────────────────────────────────────────────
const BASE = 'https://api.figma.com/v1';
const headers = { 'X-Figma-Token': FIGMA_TOKEN };

async function figmaGet(endpoint, retries = 7) {
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

// ── Walk node tree → index by ID ───────────────────────────────
function indexNodesById(node, index = {}) {
  if (node.id) index[node.id] = node;
  if (node.children) {
    for (const child of node.children) {
      indexNodesById(child, index);
    }
  }
  return index;
}

// ── Parsers ────────────────────────────────────────────────────
function toHex(n) {
  return Math.round(n * 255)
    .toString(16)
    .padStart(2, '0')
    .toUpperCase();
}

function parseColor(node) {
  if (!node) return null;
  const fills = node.fills || [];
  const solidFill = fills.find(
    (f) => f.type === 'SOLID' && f.visible !== false,
  );
  if (!solidFill?.color) return null;

  const { r, g, b } = solidFill.color;
  const a = solidFill.opacity ?? solidFill.color.a ?? 1;

  return {
    r: Math.round(r * 255),
    g: Math.round(g * 255),
    b: Math.round(b * 255),
    a: Math.round(a * 100) / 100,
    hex: `#${toHex(r)}${toHex(g)}${toHex(b)}`,
  };
}

function parseTypography(node) {
  if (!node?.style) return null;
  const s = node.style;
  return {
    fontFamily: s.fontFamily || null,
    fontWeight: s.fontWeight || null,
    fontSize: s.fontSize || null,
    lineHeight: s.lineHeightPx || null,
    letterSpacing: s.letterSpacing || 0,
    textCase: s.textCase || 'ORIGINAL',
  };
}

function parseEffects(node) {
  if (!node?.effects?.length) return null;
  return node.effects
    .filter((e) => e.visible !== false)
    .map((e) => ({
      type: e.type,
      color: e.color
        ? {
            r: Math.round(e.color.r * 255),
            g: Math.round(e.color.g * 255),
            b: Math.round(e.color.b * 255),
            a: Math.round((e.color.a ?? 1) * 100) / 100,
          }
        : null,
      offset: e.offset || { x: 0, y: 0 },
      radius: e.radius || 0,
      spread: e.spread || 0,
    }));
}

// ── Main ───────────────────────────────────────────────────────
async function main() {
  console.log('🔄 Figma KB extraction starting...\n');

  // ── Step 1: lightweight check — has the file changed? ────────
  console.log('📡 Step 1: checking file metadata (lightweight)...');
  const fileMeta = await figmaGet(`/files/${FILE_KEY}?depth=0`);
  console.log(`   File: "${fileMeta.name}"`);
  console.log(`   Last modified: ${fileMeta.lastModified}`);

  // Skip if unchanged since last extraction
  if (existsSync(META_PATH)) {
    const prevMeta = JSON.parse(readFileSync(META_PATH, 'utf8'));
    if (prevMeta.lastModified === fileMeta.lastModified) {
      console.log('\n✅ No changes since last extraction. Skipping.');
      process.exit(0);
    }
    console.log(
      `   Changed! Previous: ${prevMeta.lastModified} → Current: ${fileMeta.lastModified}`,
    );
  }

  // ── Step 2: fetch only the relevant DS pages ─────────────────
  const idsParam = DS_PAGE_IDS.join(',');
  console.log(
    `\n📡 Step 2: fetching ${DS_PAGE_IDS.length} DS pages (${idsParam})...`,
  );

  let pagesData = readCache('figma-pages');
  if (!pagesData) {
    pagesData = await figmaGet(
      `/files/${FILE_KEY}/nodes?ids=${encodeURIComponent(idsParam)}`,
    );
    writeCache('figma-pages', pagesData);
  }

  // ── Index nodes from fetched pages ───────────────────────────
  console.log('\n📇 Indexing nodes from DS pages...');
  const nodeIndex = {};
  const pageStyles = {};

  for (const [pageId, pageData] of Object.entries(pagesData.nodes || {})) {
    if (!pageData?.document) continue;

    const pageName = pageData.document.name;
    console.log(
      `   Page "${pageName}" (${pageId}): ${pageData.document.children?.length || 0} top-level children`,
    );

    // Index all nodes in this page
    indexNodesById(pageData.document, nodeIndex);

    // Collect styles from this page's response
    if (pageData.styles) {
      Object.assign(pageStyles, pageData.styles);
    }
  }

  const nodeCount = Object.keys(nodeIndex).length;
  console.log(`   Total: ${nodeCount} nodes indexed`);

  // ── Resolve styles ───────────────────────────────────────────
  // Use styles from the pages response, OR scan nodes for style references
  const styleEntries = Object.entries(pageStyles);
  console.log(`\n📋 Styles found: ${styleEntries.length}`);

  // If no styles in page response, scan nodes for fills/text/effects directly
  const colors = {};
  const typography = {};
  const effects = {};

  if (styleEntries.length > 0) {
    // Strategy A: resolve via file.styles map
    const byType = { FILL: [], TEXT: [], EFFECT: [], GRID: [] };
    for (const [nodeId, info] of styleEntries) {
      const type = info.styleType;
      if (byType[type]) byType[type].push({ nodeId, ...info });
    }

    console.log(
      `   FILL: ${byType.FILL.length}, TEXT: ${byType.TEXT.length}, EFFECT: ${byType.EFFECT.length}`,
    );
    console.log('\n🔗 Resolving style properties...');

    for (const style of byType.FILL) {
      const node = nodeIndex[style.nodeId];
      const parsed = parseColor(node);
      if (parsed) {
        colors[style.name] = {
          node_id: style.nodeId,
          key: style.key,
          description: style.description || '',
          ...parsed,
        };
      }
    }

    for (const style of byType.TEXT) {
      const node = nodeIndex[style.nodeId];
      const parsed = parseTypography(node);
      if (parsed) {
        typography[style.name] = {
          node_id: style.nodeId,
          key: style.key,
          description: style.description || '',
          ...parsed,
        };
      }
    }

    for (const style of byType.EFFECT) {
      const node = nodeIndex[style.nodeId];
      const parsed = parseEffects(node);
      if (parsed) {
        effects[style.name] = {
          node_id: style.nodeId,
          key: style.key,
          description: style.description || '',
          effects: parsed,
        };
      }
    }
  } else {
    // Strategy B: no styles map — scan all nodes for fills/text/effects
    console.log('   No styles map — scanning nodes directly...');

    for (const [nodeId, node] of Object.entries(nodeIndex)) {
      // Colors: nodes with fills and a named style reference
      if (node.fills?.length && node.styles?.fill) {
        const parsed = parseColor(node);
        if (parsed) {
          const name = node.name || `color-${nodeId}`;
          colors[name] = { node_id: nodeId, ...parsed };
        }
      }

      // Typography: text nodes with style properties
      if (node.type === 'TEXT' && node.style) {
        const parsed = parseTypography(node);
        if (parsed) {
          const name = node.name || `text-${nodeId}`;
          typography[name] = { node_id: nodeId, ...parsed };
        }
      }

      // Effects: nodes with effects
      if (node.effects?.length) {
        const parsed = parseEffects(node);
        if (parsed?.length) {
          const name = node.name || `effect-${nodeId}`;
          effects[name] = { node_id: nodeId, effects: parsed };
        }
      }
    }
  }

  console.log(
    `   Colors: ${Object.keys(colors).length}, Typography: ${Object.keys(typography).length}, Effects: ${Object.keys(effects).length}`,
  );

  // ── Write registries ─────────────────────────────────────────
  mkdirSync(KB_DIR, { recursive: true });

  const writeRegistry = (name, data) => {
    const path = join(KB_DIR, `${name}.json`);
    writeFileSync(path, JSON.stringify(data, null, 2) + '\n', 'utf8');
    console.log(`  ✅ ${name}.json — ${Object.keys(data).length} tokens`);
  };

  console.log('\n📁 Writing registries...');
  writeRegistry('colors', colors);
  writeRegistry('typography', typography);
  writeRegistry('effects', effects);

  // ── Write meta ───────────────────────────────────────────────
  const meta = {
    file_key: FILE_KEY,
    file_name: fileMeta.name,
    version: fileMeta.version,
    lastModified: fileMeta.lastModified,
    extracted_at: new Date().toISOString(),
    page_ids: DS_PAGE_IDS,
    counts: {
      colors: Object.keys(colors).length,
      typography: Object.keys(typography).length,
      effects: Object.keys(effects).length,
    },
  };
  writeFileSync(META_PATH, JSON.stringify(meta, null, 2) + '\n', 'utf8');
  console.log('  ✅ meta.json');

  const total =
    Object.keys(colors).length +
    Object.keys(typography).length +
    Object.keys(effects).length;
  console.log(`\n✨ Done. ${total} tokens extracted from ${nodeCount} nodes.`);
}

main().catch((err) => {
  console.error('💥 Fatal:', err.message);
  process.exit(1);
});
