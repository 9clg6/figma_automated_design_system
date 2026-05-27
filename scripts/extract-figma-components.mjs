#!/usr/bin/env node

/**
 * extract-figma-components.mjs
 *
 * Fetches component page data from Figma REST API and exports
 * reference images. Saves structured specs to kb/components/.
 *
 * Usage:
 *   FIGMA_TOKEN=... node scripts/extract-figma-components.mjs [--only avatar,lists]
 *
 * Outputs:
 *   kb/components/{name}.json   — component structure + properties
 *   kb/components/images/{name}.png — rendered reference image
 */

import { readFileSync, writeFileSync, mkdirSync, existsSync } from 'node:fs';
import { join, resolve } from 'node:path';
import http from 'node:http';
import https from 'node:https';
import { createWriteStream } from 'node:fs';

const ROOT = resolve(import.meta.dirname, '..');
const MAP_PATH = join(ROOT, 'config', 'component-map.json');
const OUT_DIR = join(ROOT, 'kb', 'components');
const IMG_DIR = join(OUT_DIR, 'images');

const TOKEN = process.env.FIGMA_TOKEN;
if (!TOKEN) {
  console.error('❌ Set FIGMA_TOKEN env var');
  process.exit(1);
}

const componentMap = JSON.parse(readFileSync(MAP_PATH, 'utf8'));
const FILE_KEY = componentMap.figma_file;

// Parse --only filter
const onlyArg = process.argv.find(a => a.startsWith('--only'));
const onlyFilter = onlyArg ? onlyArg.split('=')[1]?.split(',') || process.argv[process.argv.indexOf('--only') + 1]?.split(',') : null;

// ── Figma API helper ─────────────────────────────────────────
const RATE_DELAY = 4200; // ~14 req/min to stay safe under 15/min

function figmaGetOnce(path) {
  return new Promise((resolve, reject) => {
    const url = `https://api.figma.com/v1${path}`;
    https.get(url, { headers: { 'X-Figma-Token': TOKEN } }, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        if (res.statusCode === 429) {
          const retryAfter = parseInt(res.headers['retry-after'] || '0', 10);
          reject({ rateLimited: true, retryAfter });
          return;
        }
        if (res.statusCode !== 200) {
          reject(new Error(`HTTP ${res.statusCode}: ${data.slice(0, 200)}`));
          return;
        }
        try { resolve(JSON.parse(data)); }
        catch (e) { reject(new Error('JSON parse error: ' + e.message)); }
      });
    }).on('error', reject);
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
}

function sleep(ms) { return new Promise(r => setTimeout(r, ms)); }

function downloadFile(url, dest) {
  return new Promise((resolve, reject) => {
    const follow = (u) => {
      const mod = u.startsWith('https') ? https : http;
      mod.get(u, (res) => {
        if (res.statusCode >= 300 && res.statusCode < 400 && res.headers.location) {
          follow(res.headers.location);
          return;
        }
        if (res.statusCode !== 200) {
          reject(new Error(`Download failed: HTTP ${res.statusCode}`));
          return;
        }
        const ws = createWriteStream(dest);
        res.pipe(ws);
        ws.on('finish', () => { ws.close(); resolve(); });
        ws.on('error', reject);
      }).on('error', reject);
    };
    follow(url);
  });
}

// ── Extract component properties from node tree ──────────────
function extractComponentSpec(node, depth = 0) {
  const spec = {
    name: node.name,
    type: node.type,
    id: node.id,
  };

  // Dimensions
  if (node.absoluteBoundingBox) {
    spec.width = Math.round(node.absoluteBoundingBox.width);
    spec.height = Math.round(node.absoluteBoundingBox.height);
  }

  // Visual properties
  if (node.cornerRadius) spec.cornerRadius = node.cornerRadius;
  if (node.rectangleCornerRadii) spec.cornerRadii = node.rectangleCornerRadii;
  if (node.opacity !== undefined && node.opacity !== 1) spec.opacity = node.opacity;
  if (node.blendMode && node.blendMode !== 'PASS_THROUGH') spec.blendMode = node.blendMode;

  // Layout
  if (node.layoutMode) {
    spec.layout = {
      mode: node.layoutMode,
      spacing: node.itemSpacing,
      padding: {
        top: node.paddingTop,
        right: node.paddingRight,
        bottom: node.paddingBottom,
        left: node.paddingLeft,
      },
      align: node.primaryAxisAlignItems,
      crossAlign: node.counterAxisAlignItems,
    };
  }

  // Fills
  if (node.fills?.length) {
    spec.fills = node.fills.filter(f => f.visible !== false).map(f => {
      const fill = { type: f.type };
      if (f.color) {
        fill.hex = rgbaToHex(f.color);
        if (f.color.a !== undefined && f.color.a < 1) fill.opacity = f.color.a;
      }
      if (f.gradientStops) {
        fill.gradient = f.gradientStops.map(s => ({
          position: s.position,
          hex: rgbaToHex(s.color),
        }));
      }
      return fill;
    });
  }

  // Strokes
  if (node.strokes?.length) {
    spec.strokes = node.strokes.filter(s => s.visible !== false).map(s => ({
      type: s.type,
      hex: s.color ? rgbaToHex(s.color) : undefined,
    }));
    if (node.strokeWeight) spec.strokeWeight = node.strokeWeight;
  }

  // Effects (shadows, blur)
  if (node.effects?.length) {
    spec.effects = node.effects.filter(e => e.visible !== false).map(e => ({
      type: e.type,
      radius: e.radius,
      offset: e.offset,
      color: e.color ? rgbaToHex(e.color) : undefined,
      opacity: e.color?.a !== undefined ? Math.round(e.color.a * 100) / 100 : 1,
    }));
  }

  // Text properties
  if (node.type === 'TEXT') {
    spec.text = node.characters?.substring(0, 50);
    if (node.style) {
      spec.textStyle = {
        fontFamily: node.style.fontFamily,
        fontSize: node.style.fontSize,
        fontWeight: node.style.fontWeight,
        letterSpacing: node.style.letterSpacing,
        lineHeight: node.style.lineHeightPx,
        textAlign: node.style.textAlignHorizontal,
      };
    }
  }

  // Style references (links to DS tokens)
  if (node.styles) {
    spec.styleRefs = node.styles;
  }

  // Component properties (variants)
  if (node.componentProperties) {
    spec.componentProperties = node.componentProperties;
  }

  // Children (recursive, limit depth)
  if (node.children && depth < 6) {
    spec.children = node.children.map(c => extractComponentSpec(c, depth + 1));
  }

  return spec;
}

function rgbaToHex(c) {
  const r = Math.round((c.r || 0) * 255);
  const g = Math.round((c.g || 0) * 255);
  const b = Math.round((c.b || 0) * 255);
  const hex = '#' + [r, g, b].map(v => v.toString(16).padStart(2, '0')).join('').toUpperCase();
  // Include alpha when not fully opaque (Figma uses 0-1 float)
  if (c.a !== undefined && c.a < 1) {
    const a8 = Math.round(c.a * 255);
    return hex + a8.toString(16).padStart(2, '0').toUpperCase();
  }
  return hex;
}

// Polyfill padLeft for older node
if (!String.prototype.padLeft) {
  String.prototype.padLeft = function(len, ch) { return this.padStart(len, ch); };
}

// ── Main ─────────────────────────────────────────────────────
async function main() {
  mkdirSync(OUT_DIR, { recursive: true });
  mkdirSync(IMG_DIR, { recursive: true });

  const components = Object.entries(componentMap.components);
  const filtered = onlyFilter
    ? components.filter(([name]) => onlyFilter.includes(name))
    : components;

  console.log(`📦 Extracting ${filtered.length} components from Figma...`);

  // ── Phase 1: Fetch node data ─────────────────────────────
  // Batch into groups of 5 to reduce API calls
  const batches = [];
  for (let i = 0; i < filtered.length; i += 5) {
    batches.push(filtered.slice(i, i + 5));
  }

  const allSpecs = {};

  for (let bi = 0; bi < batches.length; bi++) {
    const batch = batches[bi];
    const ids = batch.map(([, cfg]) => cfg.page_id).join(',');
    console.log(`  📡 Batch ${bi + 1}/${batches.length}: fetching ${batch.map(b => b[0]).join(', ')}...`);

    try {
      const data = await figmaGet(`/files/${FILE_KEY}/nodes?ids=${ids}&depth=5`);

      for (const [name, cfg] of batch) {
        const nodeData = data.nodes[cfg.page_id];
        if (!nodeData || !nodeData.document) {
          console.log(`    ⚠️  ${name}: no data`);
          allSpecs[name] = { name: cfg.figma_name, status: 'empty', variants: [] };
          continue;
        }

        const page = nodeData.document;
        const spec = {
          name: cfg.figma_name,
          page_id: cfg.page_id,
          dart_files: cfg.dart_files,
          has_implementation: cfg.dart_files.length > 0,
          variants: [],
          components: [],
        };

        // Walk the tree to find COMPONENT_SET and COMPONENT nodes
        function findComponents(node, parentType = null) {
          if (node.type === 'COMPONENT_SET') {
            const set = {
              name: node.name,
              id: node.id,
              variants: [],
            };
            if (node.children) {
              set.variants = node.children
                .filter(c => c.type === 'COMPONENT')
                .map(c => extractComponentSpec(c, 0));
            }
            spec.components.push(set);
          } else if (node.type === 'COMPONENT' && parentType !== 'COMPONENT_SET') {
            spec.components.push({
              name: node.name,
              id: node.id,
              variants: [extractComponentSpec(node, 0)],
            });
          }
          if (node.children) node.children.forEach(c => findComponents(c, node.type));
        }

        findComponents(page);

        // Also extract the full page spec for context
        spec.pageSpec = extractComponentSpec(page, 0);

        allSpecs[name] = spec;
        console.log(`    ✅ ${name}: ${spec.components.length} component sets`);
      }
    } catch (err) {
      console.error(`    ❌ Batch ${bi + 1} failed: ${err.message}`);
      for (const [name] of batch) {
        allSpecs[name] = { name, status: 'fetch_error', error: err.message };
      }
    }

    // Rate limit pause between batches
    if (bi < batches.length - 1) {
      await sleep(RATE_DELAY);
    }
  }

  // ── Phase 2: Save component specs ────────────────────────
  for (const [name, spec] of Object.entries(allSpecs)) {
    const outPath = join(OUT_DIR, `${name}.json`);
    writeFileSync(outPath, JSON.stringify(spec, null, 2), 'utf8');
  }
  console.log(`\n💾 Saved ${Object.keys(allSpecs).length} component specs to ${OUT_DIR}/`);

  // ── Phase 3: Export reference images ─────────────────────
  console.log('\n🖼️  Exporting reference images...');
  const allPageIds = filtered.map(([, cfg]) => cfg.page_id);

  // Batch image exports (max 20 IDs per call)
  for (let i = 0; i < allPageIds.length; i += 20) {
    const batch = allPageIds.slice(i, i + 20);
    const batchNames = filtered.slice(i, i + 20).map(([n]) => n);
    const ids = batch.join(',');

    try {
      console.log(`  📸 Image batch ${Math.floor(i / 20) + 1}: ${batchNames.length} components...`);
      const imgData = await figmaGet(`/images/${FILE_KEY}?ids=${ids}&format=png&scale=1`);

      if (imgData.images) {
        for (let j = 0; j < batch.length; j++) {
          const pageId = batch[j];
          const name = batchNames[j];
          const url = imgData.images[pageId];
          if (url) {
            const imgPath = join(IMG_DIR, `${name}.png`);
            try {
              await downloadFile(url, imgPath);
              console.log(`    ✅ ${name}.png`);
            } catch (dlErr) {
              console.log(`    ⚠️  ${name}: download failed: ${dlErr.message}`);
            }
          } else {
            console.log(`    ⚠️  ${name}: no image URL (page may be empty)`);
          }
        }
      }
    } catch (err) {
      console.error(`  ❌ Image batch failed: ${err.message}`);
    }

    if (i + 20 < allPageIds.length) await sleep(RATE_DELAY);
  }

  // ── Summary ──────────────────────────────────────────────
  const implemented = filtered.filter(([, c]) => c.dart_files.length > 0);
  const notImpl = filtered.filter(([, c]) => c.dart_files.length === 0);
  console.log(`\n✨ Done.`);
  console.log(`   Total components: ${filtered.length}`);
  console.log(`   With Flutter impl: ${implemented.length} (${implemented.map(([n]) => n).join(', ')})`);
  console.log(`   Not implemented: ${notImpl.length}`);
}

main().catch(err => {
  console.error('💥 Fatal:', err.message);
  process.exit(1);
});
