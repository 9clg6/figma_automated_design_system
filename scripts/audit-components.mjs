#!/usr/bin/env node

/**
 * audit-components.mjs
 *
 * Sends each Figma component spec + Flutter source to Claude API
 * for comparison. Generates an audit report per component and a
 * summary report.
 *
 * Usage:
 *   ANTHROPIC_API_KEY=... node scripts/audit-components.mjs [--only avatar,lists]
 *
 * Inputs:
 *   kb/components/{name}.json     — extracted Figma specs
 *   config/component-map.json     — component → dart_files mapping
 *
 * Outputs:
 *   kb/audit/{name}.md            — per-component audit report
 *   kb/audit/SUMMARY.md           — aggregated summary
 */

import { readFileSync, writeFileSync, mkdirSync, existsSync, readdirSync } from 'node:fs';
import { join, resolve } from 'node:path';
import Anthropic from '@anthropic-ai/sdk';

const ROOT = resolve(import.meta.dirname, '..');
const MAP_PATH = join(ROOT, 'config', 'component-map.json');
const COMPONENTS_DIR = join(ROOT, 'kb', 'components');
const AUDIT_DIR = join(ROOT, 'kb', 'audit');

const MODEL = 'claude-sonnet-4-6';
const MAX_TOKENS = 4096;

// Parse --only filter
const onlyArg = process.argv.find(a => a.startsWith('--only'));
const onlyFilter = onlyArg
  ? (onlyArg.includes('=') ? onlyArg.split('=')[1] : process.argv[process.argv.indexOf('--only') + 1])?.split(',')
  : null;

const componentMap = JSON.parse(readFileSync(MAP_PATH, 'utf8'));

// ── System prompt for component audit ────────────────────────
const SYSTEM_PROMPT = `You are a Design System auditor for Linagora Design Flutter.

You receive:
1. A Figma component specification (JSON structure with variants, colors, spacing, typography)
2. The current Flutter implementation files (Dart source code)

Your job is to produce a concise audit report comparing the Figma design spec to the Flutter code.

## Report format (use exactly this markdown structure):

### Status: MATCH | DRIFT | NOT_IMPLEMENTED | PARTIAL

### Component: {name}

### Variants Coverage
- List each Figma variant and whether Flutter implements it

### Property Comparison
| Property | Figma | Flutter | Match |
|----------|-------|---------|-------|
| (list colors, spacing, radii, typography, etc.) |

### Issues Found
- Bullet list of specific mismatches, missing features, wrong values

### Recommendations
- What to fix to achieve full Figma parity

## Rules:
- Be specific: include exact hex values, pixel sizes, font weights
- If Flutter has NO implementation (dart_files is empty), report status NOT_IMPLEMENTED with a brief summary of what the Figma component defines
- Focus on visual/design properties, not code architecture
- Keep reports concise — max 60 lines
`;

// ── Load component spec ──────────────────────────────────────
function loadComponentSpec(name) {
  const path = join(COMPONENTS_DIR, `${name}.json`);
  if (!existsSync(path)) return null;
  return JSON.parse(readFileSync(path, 'utf8'));
}

// ── Load dart files ──────────────────────────────────────────
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

// ── Truncate deep JSON to avoid token explosion ──────────────
function truncateSpec(spec, maxDepth = 4) {
  function truncate(obj, depth) {
    if (depth > maxDepth) return '[truncated]';
    if (Array.isArray(obj)) {
      if (obj.length > 10) {
        return [...obj.slice(0, 5).map(i => truncate(i, depth + 1)), `... ${obj.length - 5} more`];
      }
      return obj.map(i => truncate(i, depth + 1));
    }
    if (obj && typeof obj === 'object') {
      const result = {};
      for (const [k, v] of Object.entries(obj)) {
        result[k] = truncate(v, depth + 1);
      }
      return result;
    }
    return obj;
  }
  return truncate(spec, 0);
}

// ── Main ─────────────────────────────────────────────────────
async function main() {
  mkdirSync(AUDIT_DIR, { recursive: true });

  const client = new Anthropic();

  const components = Object.entries(componentMap.components);
  const filtered = onlyFilter
    ? components.filter(([name]) => onlyFilter.includes(name))
    : components;

  // Only audit components that have extracted specs
  const available = filtered.filter(([name]) => existsSync(join(COMPONENTS_DIR, `${name}.json`)));

  console.log(`🔍 Auditing ${available.length} components...`);

  const results = [];

  for (const [name, cfg] of available) {
    console.log(`\n📋 ${name} (${cfg.figma_name})...`);

    const spec = loadComponentSpec(name);
    if (!spec || spec.status === 'fetch_error') {
      console.log(`  ⚠️  No spec data, skipping`);
      results.push({ name, status: 'NO_DATA' });
      continue;
    }

    const dartFiles = loadDartFiles(cfg.dart_files);
    const hasImpl = Object.keys(dartFiles).length > 0;

    // Build user prompt
    let userPrompt = `## Figma Component: ${cfg.figma_name}\n\n`;
    userPrompt += `### Component Spec (from Figma API)\n\`\`\`json\n`;
    userPrompt += JSON.stringify(truncateSpec(spec), null, 2);
    userPrompt += `\n\`\`\`\n\n`;

    if (hasImpl) {
      userPrompt += `### Flutter Implementation\n`;
      for (const [path, content] of Object.entries(dartFiles)) {
        userPrompt += `#### ${path}\n\`\`\`dart\n${content}\n\`\`\`\n\n`;
      }
      userPrompt += `Compare the Figma spec with the Flutter implementation. Report all visual mismatches.`;
    } else {
      userPrompt += `### Flutter Implementation\nNo Flutter implementation exists for this component.\n\n`;
      userPrompt += `Report status as NOT_IMPLEMENTED. Summarize what the Figma component defines (variants, key properties) so we have a baseline.`;
    }

    try {
      const response = await client.messages.create({
        model: MODEL,
        max_tokens: MAX_TOKENS,
        system: [{ type: 'text', text: SYSTEM_PROMPT, cache_control: { type: 'ephemeral' } }],
        messages: [{ role: 'user', content: userPrompt }],
      });

      const report = response.content[0]?.text || 'Empty response';

      // Extract status from report
      const statusMatch = report.match(/Status:\s*(MATCH|DRIFT|NOT_IMPLEMENTED|PARTIAL)/i);
      const status = statusMatch ? statusMatch[1].toUpperCase() : 'UNKNOWN';

      // Save report
      writeFileSync(join(AUDIT_DIR, `${name}.md`), report, 'utf8');
      console.log(`  ✅ ${status} (${response.usage.input_tokens}+${response.usage.output_tokens} tokens)`);

      results.push({
        name,
        figmaName: cfg.figma_name,
        status,
        hasImpl,
        dartFiles: cfg.dart_files,
        inputTokens: response.usage.input_tokens,
        outputTokens: response.usage.output_tokens,
      });
    } catch (err) {
      console.error(`  ❌ Claude error: ${err.message}`);
      results.push({ name, status: 'ERROR', error: err.message });
    }
  }

  // ── Generate summary ────────────────────────────────────────
  let summary = `# Component Audit Summary\n\n`;
  summary += `Generated: ${new Date().toISOString()}\n\n`;

  const byStatus = {};
  for (const r of results) {
    byStatus[r.status] = byStatus[r.status] || [];
    byStatus[r.status].push(r);
  }

  summary += `## Overview\n\n`;
  summary += `| Status | Count | Components |\n`;
  summary += `|--------|-------|------------|\n`;
  for (const [status, items] of Object.entries(byStatus).sort()) {
    summary += `| ${status} | ${items.length} | ${items.map(i => i.name).join(', ')} |\n`;
  }

  summary += `\n## Detailed Results\n\n`;
  for (const r of results) {
    const icon = r.status === 'MATCH' ? '✅' : r.status === 'NOT_IMPLEMENTED' ? '⬜' : r.status === 'DRIFT' ? '🔴' : r.status === 'PARTIAL' ? '🟡' : '❓';
    summary += `- ${icon} **${r.name}** (${r.figmaName || '?'}): ${r.status}`;
    if (r.dartFiles?.length) summary += ` — ${r.dartFiles.join(', ')}`;
    summary += `\n`;
  }

  const totalInput = results.reduce((s, r) => s + (r.inputTokens || 0), 0);
  const totalOutput = results.reduce((s, r) => s + (r.outputTokens || 0), 0);
  summary += `\n## Token Usage\n\n`;
  summary += `- Input: ${totalInput.toLocaleString()} tokens\n`;
  summary += `- Output: ${totalOutput.toLocaleString()} tokens\n`;
  summary += `- Total: ${(totalInput + totalOutput).toLocaleString()} tokens\n`;

  writeFileSync(join(AUDIT_DIR, 'SUMMARY.md'), summary, 'utf8');
  console.log(`\n✨ Audit complete. Summary: ${join(AUDIT_DIR, 'SUMMARY.md')}`);
  console.log(`   ${results.filter(r => r.status === 'MATCH').length} MATCH, ${results.filter(r => r.status === 'DRIFT').length} DRIFT, ${results.filter(r => r.status === 'PARTIAL').length} PARTIAL, ${results.filter(r => r.status === 'NOT_IMPLEMENTED').length} NOT_IMPLEMENTED`);
}

main().catch(err => {
  console.error('💥 Fatal:', err.message);
  process.exit(1);
});
