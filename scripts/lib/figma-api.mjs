/**
 * figma-api.mjs — Shared Figma API client, spec extraction, and helpers.
 *
 * Eliminates duplication across sync-component, detect-drift,
 * extract-figma-components, generate-all-widgets, and discover-components.
 *
 * Usage:
 *   import { createFigmaClient, extractComponentSpec, findComponents, rgbaToHex, slugify, sleep } from './lib/figma-api.mjs';
 *   const { figmaGet, figmaGetImage } = createFigmaClient(process.env.FIGMA_TOKEN);
 */

import https from 'node:https';

// ── Figma REST API client ────────────────────────────────────────

/**
 * Create a Figma API client with 429 retry + exponential backoff.
 * @param {string} token - Figma personal access token
 * @param {string} [fileKey] - Figma file key (needed for figmaGetImage)
 * @returns {{ figmaGet: Function, figmaGetImage: Function }}
 */
export function createFigmaClient(token, fileKey = '') {
  if (!token) throw new Error('FIGMA_TOKEN is required');

  function figmaGetOnce(path) {
    return new Promise((resolve, reject) => {
      const url = `https://api.figma.com/v1${path}`;
      https.get(url, { headers: { 'X-Figma-Token': token } }, (resp) => {
        let data = '';
        resp.on('data', chunk => data += chunk);
        resp.on('end', () => {
          if (resp.statusCode === 429) {
            const retryAfter = parseInt(resp.headers['retry-after'] || '0', 10);
            reject({ rateLimited: true, retryAfter });
            return;
          }
          if (resp.statusCode !== 200) {
            reject(new Error(`HTTP ${resp.statusCode}: ${data.slice(0, 200)}`));
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

  /**
   * Fetch a rendered PNG image of a Figma node as base64.
   * Auto-downscales to scale=1 if image exceeds 3.5MB.
   * @param {string} nodeId - Figma node ID
   * @param {number} [scale=2] - Render scale (1 or 2)
   * @returns {Promise<string|null>} base64-encoded PNG, or null on failure
   */
  function figmaGetImage(nodeId, scale = 2) {
    if (!fileKey) throw new Error('figmaGetImage requires fileKey in createFigmaClient()');
    return new Promise((resolve) => {
      const url = `https://api.figma.com/v1/images/${fileKey}?ids=${encodeURIComponent(nodeId)}&format=png&scale=${scale}`;
      https.get(url, { headers: { 'X-Figma-Token': token } }, (resp) => {
        let data = '';
        resp.on('data', chunk => data += chunk);
        resp.on('end', () => {
          if (resp.statusCode !== 200) { resolve(null); return; }
          try {
            const json = JSON.parse(data);
            const imageUrl = json.images?.[nodeId];
            if (!imageUrl) { resolve(null); return; }
            https.get(imageUrl, (imgResp) => {
              const chunks = [];
              imgResp.on('data', c => chunks.push(c));
              imgResp.on('end', () => {
                const buf = Buffer.concat(chunks);
                if (buf.length > 3_500_000 && scale > 1) {
                  console.log(`     ⚠️ Image too large (${Math.round(buf.length / 1024)}KB), retrying scale=1...`);
                  figmaGetImage(nodeId, 1).then(resolve).catch(() => resolve(null));
                  return;
                }
                resolve(buf.toString('base64'));
              });
              imgResp.on('error', () => resolve(null));
            }).on('error', () => resolve(null));
          } catch { resolve(null); }
        });
      }).on('error', () => resolve(null));
    });
  }

  return { figmaGet, figmaGetImage };
}

// ── Spec extraction ──────────────────────────────────────────────

/**
 * Convert Figma RGBA color (0-1 floats) to hex string.
 * Includes alpha channel as 2 extra hex digits when not fully opaque.
 */
export function rgbaToHex(c) {
  const r = Math.round((c.r || 0) * 255);
  const g = Math.round((c.g || 0) * 255);
  const b = Math.round((c.b || 0) * 255);
  const hex = '#' + [r, g, b].map(v => v.toString(16).padStart(2, '0')).join('').toUpperCase();
  if (c.a !== undefined && c.a < 1) {
    const a8 = Math.round(c.a * 255);
    return hex + a8.toString(16).padStart(2, '0').toUpperCase();
  }
  return hex;
}

/**
 * Extract a design spec from a Figma node tree.
 * Captures dimensions, layout, fills, strokes, effects, text styles,
 * style references, component properties, and children (up to maxDepth).
 *
 * @param {object} node - Figma node from REST API
 * @param {number} [depth=0] - Current recursion depth
 * @param {number} [maxDepth=6] - Maximum recursion depth
 * @returns {object} Structured spec
 */
export function extractComponentSpec(node, depth = 0, maxDepth = 6) {
  const spec = { name: node.name, type: node.type, id: node.id };

  if (node.absoluteBoundingBox) {
    spec.width = Math.round(node.absoluteBoundingBox.width);
    spec.height = Math.round(node.absoluteBoundingBox.height);
  }

  if (node.cornerRadius) spec.cornerRadius = node.cornerRadius;
  if (node.rectangleCornerRadii) spec.cornerRadii = node.rectangleCornerRadii;
  if (node.opacity !== undefined && node.opacity !== 1) spec.opacity = node.opacity;
  if (node.blendMode && node.blendMode !== 'PASS_THROUGH') spec.blendMode = node.blendMode;

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

  if (node.strokes?.length) {
    spec.strokes = node.strokes.filter(s => s.visible !== false).map(s => ({
      type: s.type,
      hex: s.color ? rgbaToHex(s.color) : undefined,
    }));
    if (node.strokeWeight) spec.strokeWeight = node.strokeWeight;
  }

  if (node.effects?.length) {
    spec.effects = node.effects.filter(e => e.visible !== false).map(e => ({
      type: e.type,
      radius: e.radius,
      offset: e.offset,
      color: e.color ? rgbaToHex(e.color) : undefined,
      opacity: e.color?.a !== undefined ? Math.round(e.color.a * 100) / 100 : 1,
    }));
  }

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

  if (node.styles) spec.styleRefs = node.styles;
  if (node.componentProperties) spec.componentProperties = node.componentProperties;

  if (node.children && depth < maxDepth) {
    spec.children = node.children.map(c => extractComponentSpec(c, depth + 1, maxDepth));
  }

  return spec;
}

/**
 * Walk a Figma page node and collect COMPONENT_SET / standalone COMPONENT entries.
 * Correctly tracks parentType to avoid duplicate variants (REST API has no parent back-pointer).
 *
 * @param {object} page - Figma page node (from REST API /files/:key/nodes)
 * @returns {{ name: string, id: string, variants: object[] }[]}
 */
export function findComponents(page) {
  const components = [];

  function walk(node, parentType = null) {
    if (node.type === 'COMPONENT_SET') {
      const set = { name: node.name, id: node.id, variants: [] };
      if (node.children) {
        set.variants = node.children
          .filter(c => c.type === 'COMPONENT')
          .map(c => extractComponentSpec(c, 0));
      }
      components.push(set);
    } else if (node.type === 'COMPONENT' && parentType !== 'COMPONENT_SET') {
      components.push({
        name: node.name,
        id: node.id,
        variants: [extractComponentSpec(node, 0)],
      });
    }
    if (node.children) node.children.forEach(c => walk(c, node.type));
  }

  walk(page);
  return components;
}

// ── Helpers ───────────────────────────────────────────────────────

/**
 * Slugify a Figma component name.
 * @param {string} name - e.g. "❖ Bottom Sheet"
 * @param {string} [separator='_'] - Use '-' for URL-friendly slugs
 * @returns {string} e.g. "bottom_sheet" or "bottom-sheet"
 */
export function slugify(name, separator = '_') {
  return name.replace(/[❖]/g, '').trim().toLowerCase()
    .replace(/[^a-z0-9]+/g, separator)
    .replace(new RegExp(`^${separator === '-' ? '-' : '_'}|${separator === '-' ? '-' : '_'}$`, 'g'), '');
}

/**
 * Sleep for a given number of milliseconds.
 */
export function sleep(ms) {
  return new Promise(r => setTimeout(r, ms));
}
