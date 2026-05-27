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
import { createFigmaClient, extractComponentSpec, findComponents, sleep } from './lib/figma-api.mjs';

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
const { figmaGet } = createFigmaClient(TOKEN, FILE_KEY);

// Parse --only filter
const onlyArg = process.argv.find(a => a.startsWith('--only'));
const onlyFilter = onlyArg ? onlyArg.split('=')[1]?.split(',') || process.argv[process.argv.indexOf('--only') + 1]?.split(',') : null;

// ── Helpers ──────────────────────────────────────────────────
const RATE_DELAY = 4200; // ~14 req/min to stay safe under 15/min

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
          components: findComponents(page),
        };

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
