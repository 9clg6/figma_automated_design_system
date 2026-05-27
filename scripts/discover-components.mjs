#!/usr/bin/env node

/**
 * discover-components.mjs
 *
 * Scans the Figma file for all pages matching the "❖ Name" pattern,
 * compares against component-map.json, and adds any new components.
 *
 * Usage:
 *   FIGMA_TOKEN=... node scripts/discover-components.mjs
 *   FIGMA_TOKEN=... node scripts/discover-components.mjs --dry-run
 */

import { readFileSync, writeFileSync } from 'node:fs';
import { join, resolve } from 'node:path';
import https from 'node:https';

const ROOT = resolve(import.meta.dirname, '..');
const MAP_PATH = join(ROOT, 'config', 'component-map.json');
const FIGMA_TOKEN = process.env.FIGMA_TOKEN;
if (!FIGMA_TOKEN) { console.error('FIGMA_TOKEN required'); process.exit(1); }

const dryRun = process.argv.includes('--dry-run');

const componentMap = JSON.parse(readFileSync(MAP_PATH, 'utf8'));
const FILE_KEY = componentMap.figma_file;

// ── Figma API ─────────────────────────────────────────────────
function figmaGet(path) {
  return new Promise((res, rej) => {
    const url = `https://api.figma.com/v1${path}`;
    https.get(url, { headers: { 'X-Figma-Token': FIGMA_TOKEN } }, (resp) => {
      let data = '';
      resp.on('data', chunk => data += chunk);
      resp.on('end', () => {
        if (resp.statusCode !== 200) {
          rej(new Error(`HTTP ${resp.statusCode}: ${data.slice(0, 200)}`));
          return;
        }
        try { res(JSON.parse(data)); }
        catch (e) { rej(new Error('JSON parse: ' + e.message)); }
      });
    }).on('error', rej);
  });
}

// ── Slug helper ───────────────────────────────────────────────
function slugify(name) {
  return name.replace(/[❖]/g, '').trim().toLowerCase()
    .replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '');
}

// ── Main ──────────────────────────────────────────────────────
async function main() {
  console.log('Fetching Figma file structure...');
  const file = await figmaGet(`/files/${FILE_KEY}?depth=1`);

  const pages = file.document?.children || [];
  console.log(`Found ${pages.length} pages in Figma file\n`);

  // Build set of existing page_ids
  const existingPageIds = new Set();
  const existingSlugs = new Set();
  for (const [slug, cfg] of Object.entries(componentMap.components)) {
    existingPageIds.add(cfg.page_id);
    existingSlugs.add(slug);
  }

  const newComponents = [];

  for (const page of pages) {
    // Only consider pages starting with ❖
    if (!page.name.startsWith('❖')) continue;

    const slug = slugify(page.name);
    const pageId = page.id;

    if (existingPageIds.has(pageId) || existingSlugs.has(slug)) {
      continue; // Already known
    }

    newComponents.push({
      slug,
      figma_name: page.name,
      page_id: pageId,
    });
  }

  if (newComponents.length === 0) {
    console.log('No new components found.');
    return;
  }

  console.log(`Discovered ${newComponents.length} new component(s):\n`);
  for (const c of newComponents) {
    console.log(`  + ${c.slug} (${c.figma_name}) [${c.page_id}]`);
  }

  if (dryRun) {
    console.log('\n--dry-run: no changes written.');
    return;
  }

  // Add to component-map.json
  for (const c of newComponents) {
    componentMap.components[c.slug] = {
      figma_name: c.figma_name,
      page_id: c.page_id,
      dart_files: [],
      golden_test: '',
      golden_files: [],
    };
  }

  writeFileSync(MAP_PATH, JSON.stringify(componentMap, null, 2) + '\n', 'utf8');
  console.log(`\nUpdated component-map.json (+${newComponents.length} components)`);

  // Output machine-readable list for CI
  const slugList = newComponents.map(c => c.slug).join(',');
  console.log(`\nNEW_COMPONENTS=${slugList}`);
}

main().catch(err => {
  console.error('Fatal:', err.message);
  process.exit(1);
});
