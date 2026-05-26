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
const DS_PAGE_IDS = config.figma_page_ids || ['49823:12141', '58558:389', '58558:391'];

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
  const fileMeta = await figmaGet(`/files/${FILE_KEY}?depth=1`);
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
  // Build reverse lookup: style_id → { name, styleType, key, description }
  // Then walk nodes: node.styles.fill/text/effect → style_id → name + extract value from node
  const styleEntries = Object.entries(pageStyles);
  console.log(`\n📋 Styles definitions found: ${styleEntries.length}`);

  const styleLookup = {}; // style_id → info
  const byType = { FILL: 0, TEXT: 0, EFFECT: 0 };
  for (const [styleId, info] of styleEntries) {
    styleLookup[styleId] = info;
    if (byType[info.styleType] !== undefined) byType[info.styleType]++;
  }
  console.log(
    `   FILL: ${byType.FILL}, TEXT: ${byType.TEXT}, EFFECT: ${byType.EFFECT}`,
  );

  const colors = {};
  const typography = {};
  const effects = {};

  console.log('\n🔗 Resolving styles via node references...');

  for (const [nodeId, node] of Object.entries(nodeIndex)) {
    if (!node.styles) continue;

    // ── Colors: node.styles.fill or node.styles.fills → style_id
    const fillStyleId = node.styles.fill || node.styles.fills;
    if (fillStyleId && styleLookup[fillStyleId]) {
      const info = styleLookup[fillStyleId];
      const parsed = parseColor(node);
      if (parsed && !colors[info.name]) {
        colors[info.name] = {
          node_id: nodeId,
          style_id: fillStyleId,
          key: info.key || '',
          description: info.description || '',
          ...parsed,
        };
      }
    }

    // ── Typography: node.styles.text → style_id
    const textStyleId = node.styles.text;
    if (textStyleId && styleLookup[textStyleId]) {
      const info = styleLookup[textStyleId];
      const parsed = parseTypography(node);
      if (parsed && !typography[info.name]) {
        typography[info.name] = {
          node_id: nodeId,
          style_id: textStyleId,
          key: info.key || '',
          description: info.description || '',
          ...parsed,
        };
      }
    }

    // ── Effects: node.styles.effect → style_id
    const effectStyleId = node.styles.effect;
    if (effectStyleId && styleLookup[effectStyleId]) {
      const info = styleLookup[effectStyleId];
      const parsed = parseEffects(node);
      if (parsed?.length && !effects[info.name]) {
        effects[info.name] = {
          node_id: nodeId,
          style_id: effectStyleId,
          key: info.key || '',
          description: info.description || '',
          effects: parsed,
        };
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
