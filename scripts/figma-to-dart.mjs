#!/usr/bin/env node

/**
 * figma-to-dart.mjs
 *
 * Claude Agent that reads KB drift (bridge-ds knowledge-base diff)
 * and generates/updates Dart theme files accordingly.
 *
 * Architecture (inspired by VGV):
 *   Phase 1 — Read KB diff + figma-map.json (deterministic)
 *   Phase 2 — Map design tokens to project theme system (AI judgment)
 *   Phase 3 — Edit Dart files (AI judgment, constrained by allowlist)
 *   Phase 4 — Self-validate (deterministic — flutter analyze)
 *
 * Inputs:
 *   - /tmp/kb.diff              — KB drift diff (from workflow)
 *   - config/figma-map.json     — node_id → Dart file mapping
 *   - config/system-prompt.md   — system prompt with project conventions
 *
 * Env:
 *   - ANTHROPIC_API_KEY
 */

import { readFileSync, existsSync } from 'node:fs';
import { join, resolve } from 'node:path';
import Anthropic from '@anthropic-ai/sdk';

// ── Config ─────────────────────────────────────────────────────
const ROOT = resolve(import.meta.dirname, '..');
const DIFF_PATH = '/tmp/kb.diff';
const MAP_PATH = join(ROOT, 'config', 'figma-map.json');
const PROMPT_PATH = join(ROOT, 'config', 'system-prompt.md');
const KB_PATH = join(ROOT, 'kb', 'registries');

const MODEL = 'claude-sonnet-4-20250514';
const MAX_TOKENS = 8192;
const TIMEOUT_MS = 8 * 60 * 1000; // 8 min hard cap

// ── Allowlist — only these paths can be edited ─────────────────
const ALLOWED_PATHS = [
  'lib/widgets/theme/',
  'lib/config/theme/',
  'lib/theme/',
];

// ── Load inputs ────────────────────────────────────────────────
function loadInput(path, label) {
  if (!existsSync(path)) {
    console.error(`❌ Missing ${label}: ${path}`);
    process.exit(1);
  }
  return readFileSync(path, 'utf8');
}

const diff = loadInput(DIFF_PATH, 'KB diff');
const figmaMap = loadInput(MAP_PATH, 'figma-map.json');
const systemPrompt = existsSync(PROMPT_PATH)
  ? readFileSync(PROMPT_PATH, 'utf8')
  : getDefaultSystemPrompt();

// ── Load current Dart files referenced in figma-map ────────────
function loadDartFiles() {
  const map = JSON.parse(figmaMap);
  const files = {};

  for (const [_nodeId, dartPath] of Object.entries(map)) {
    const fullPath = join(ROOT, dartPath);
    if (existsSync(fullPath)) {
      files[dartPath] = readFileSync(fullPath, 'utf8');
    } else {
      files[dartPath] = '// File does not exist yet — create it.';
    }
  }

  return files;
}

// ── Default system prompt ──────────────────────────────────────
function getDefaultSystemPrompt() {
  return `You are a Flutter theme engineer. You receive:
1. A diff of design system changes from Figma (knowledge-base registry format)
2. A mapping of Figma node IDs to Dart file paths
3. The current content of those Dart files

Your job:
- Update ONLY the Dart files listed in the mapping
- Map every design token to the project's theme system (ColorScheme, TextTheme, AppSpacing)
- NEVER hardcode color values, font sizes, or spacing — always use theme references
- NEVER touch files outside the allowed paths
- Output a JSON array of file edits

Allowed paths: ${ALLOWED_PATHS.join(', ')}

Output format (strict JSON, no markdown):
[
  {
    "path": "lib/theme/colors.dart",
    "action": "edit",
    "content": "// full file content after edit"
  }
]

Rules:
- Preserve existing code structure and comments
- Add new tokens, update changed values, do NOT remove tokens unless explicitly deleted in the diff
- Use const where possible
- Follow Dart conventions (lowerCamelCase for variables, UpperCamelCase for classes)
`;
}

// ── Validate edits against allowlist ───────────────────────────
function validateEdits(edits) {
  for (const edit of edits) {
    const allowed = ALLOWED_PATHS.some((prefix) =>
      edit.path.startsWith(prefix),
    );
    if (!allowed) {
      throw new Error(
        `🚫 Edit blocked — path outside allowlist: ${edit.path}`,
      );
    }
  }
}

// ── Main ───────────────────────────────────────────────────────
async function main() {
  console.log('🔄 Figma-to-Dart agent starting...');
  console.log(`   Diff size: ${diff.length} bytes`);
  console.log(`   Map: ${MAP_PATH}`);

  const dartFiles = loadDartFiles();
  console.log(
    `   Dart files loaded: ${Object.keys(dartFiles).length}`,
  );

  // ── Build prompt ─────────────────────────────────────────
  const userPrompt = `## KB Diff (design system changes)
\`\`\`diff
${diff}
\`\`\`

## Figma Map (node_id → Dart file)
\`\`\`json
${figmaMap}
\`\`\`

## Current Dart files
${Object.entries(dartFiles)
  .map(
    ([path, content]) => `### ${path}\n\`\`\`dart\n${content}\n\`\`\``,
  )
  .join('\n\n')}

Analyze the diff, identify which tokens changed, and produce the updated Dart files.
Output ONLY the JSON array of edits. No explanation, no markdown fences.`;

  // ── Call Claude ───────────────────────────────────────────
  const client = new Anthropic();

  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), TIMEOUT_MS);

  try {
    console.log('🤖 Calling Claude...');

    const response = await client.messages.create(
      {
        model: MODEL,
        max_tokens: MAX_TOKENS,
        system: [
          {
            type: 'text',
            text: systemPrompt,
            cache_control: { type: 'ephemeral' },
          },
        ],
        messages: [{ role: 'user', content: userPrompt }],
      },
      { signal: controller.signal },
    );

    clearTimeout(timeout);

    // ── Parse response ───────────────────────────────────────
    const raw = response.content[0]?.text;
    if (!raw) {
      throw new Error('Empty response from Claude');
    }

    // Strip markdown fences if Claude added them despite instructions
    const cleaned = raw
      .replace(/^```json\n?/m, '')
      .replace(/\n?```$/m, '')
      .trim();

    let edits;
    try {
      edits = JSON.parse(cleaned);
    } catch {
      console.error('❌ Failed to parse Claude response as JSON:');
      console.error(cleaned.slice(0, 500));
      process.exit(1);
    }

    if (!Array.isArray(edits)) {
      throw new Error('Expected JSON array of edits');
    }

    // ── Validate & apply ─────────────────────────────────────
    validateEdits(edits);

    const { writeFileSync, mkdirSync } = await import('node:fs');
    const { dirname } = await import('node:path');

    for (const edit of edits) {
      const fullPath = join(ROOT, edit.path);
      mkdirSync(dirname(fullPath), { recursive: true });
      writeFileSync(fullPath, edit.content, 'utf8');
      console.log(`  ✅ ${edit.action}: ${edit.path}`);
    }

    console.log(`\n✨ Applied ${edits.length} edit(s).`);

    // ── Token usage ──────────────────────────────────────────
    const usage = response.usage;
    console.log(
      `📊 Tokens — input: ${usage.input_tokens}, output: ${usage.output_tokens}`,
    );
    if (usage.cache_read_input_tokens) {
      console.log(
        `   Cache hit: ${usage.cache_read_input_tokens} tokens`,
      );
    }
  } catch (err) {
    clearTimeout(timeout);
    if (err.name === 'AbortError') {
      console.error('⏰ Claude call timed out (8 min limit)');
      process.exit(1);
    }
    throw err;
  }
}

main().catch((err) => {
  console.error('💥 Fatal:', err.message);
  process.exit(1);
});
