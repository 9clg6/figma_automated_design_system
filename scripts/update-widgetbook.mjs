#!/usr/bin/env node

/**
 * update-widgetbook.mjs
 *
 * Scans component-map.json for all components with dart_files,
 * reads each widget file to extract the main class name,
 * generates widgetbook use cases and updates widgetbook.dart.
 *
 * Usage:
 *   node scripts/update-widgetbook.mjs
 *   node scripts/update-widgetbook.mjs --dry-run
 */

import { readFileSync, writeFileSync, mkdirSync, existsSync } from 'node:fs';
import { join, resolve, basename, dirname } from 'node:path';

const ROOT = resolve(import.meta.dirname, '..');
const MAP_PATH = join(ROOT, 'config', 'component-map.json');
const WIDGETBOOK_DIR = join(ROOT, 'widgetbook');
const COMPONENTS_DIR = join(WIDGETBOOK_DIR, 'lib', 'components');
const WIDGETBOOK_DART = join(WIDGETBOOK_DIR, 'lib', 'widgetbook.dart');

const dryRun = process.argv.includes('--dry-run');

// --only flag: restrict use case generation to specific slugs
const onlyArg = process.argv.find(a => a.startsWith('--only'));
const onlyFilter = onlyArg
  ? (onlyArg.includes('=')
      ? onlyArg.split('=')[1]
      : process.argv[process.argv.indexOf('--only') + 1]
    )?.split(',')
  : null;

const componentMap = JSON.parse(readFileSync(MAP_PATH, 'utf8'));

// ── Helpers ───────────────────────────────────────────────────
function slugify(name) {
  return name.replace(/[❖]/g, '').trim().toLowerCase()
    .replace(/[^a-z0-9]+/g, '_').replace(/^_|_$/g, '');
}

function pascalCase(str) {
  return str.split(/[\s_-]+/)
    .map(w => w.charAt(0).toUpperCase() + w.slice(1).toLowerCase())
    .join('');
}

function extractMainClass(dartCode) {
  // Find the first public StatelessWidget or StatefulWidget class
  const match = dartCode.match(/class\s+(Twake\w+|Linagora\w+)\s+extends\s+Stateless/);
  if (match) return match[1];
  const match2 = dartCode.match(/class\s+(Twake\w+|Linagora\w+)\s+extends\s+Stateful/);
  if (match2) return match2[1];
  // Fallback: first public class
  const match3 = dartCode.match(/class\s+([A-Z]\w+)\s+extends/);
  return match3 ? match3[1] : null;
}

function extractConstructorParams(dartCode, className) {
  // Extract required params from constructor.
  // Returns [{ name, type }]. The type is resolved from the matching
  // field declaration in the class body (constructor uses `this.x`).
  const ctorRegex = new RegExp(`const\\s+${className}\\(\\{[^}]*\\}\\)`, 's');
  const match = dartCode.match(ctorRegex);
  if (!match) return [];

  const params = [];
  const requiredMatches = match[0].matchAll(/required\s+this\.(\w+)/g);
  for (const m of requiredMatches) {
    const name = m[1];
    // Find the field declaration: `final <Type> <name>;`
    const fieldRegex = new RegExp(`final\\s+([\\w<>,\\s]+?\\??)\\s+${name}\\s*;`);
    const fieldMatch = dartCode.match(fieldRegex);
    const type = fieldMatch ? fieldMatch[1].trim() : 'dynamic';
    params.push({ name, type });
  }
  return params;
}

// Map a Dart param (name + type) to a widgetbook knob expression, or a
// static fallback when no sensible knob exists (callbacks, unknown types).
function knobForParam({ name, type }) {
  const nullable = type.endsWith('?');
  const base = nullable ? type.slice(0, -1) : type;

  // Callbacks — no knob, just a no-op
  if (base.startsWith('void Function') || base.startsWith('Function') ||
      name === 'onTap' || name === 'onPressed' || name.startsWith('on')) {
    return `${name}: (${base.includes('()') || base === 'VoidCallback' ? '' : '_'}) {},`;
  }

  switch (base) {
    case 'String':
      return `${name}: context.knobs.string(label: '${name}', initialValue: '${name}'),`;
    case 'bool':
      return `${name}: context.knobs.boolean(label: '${name}', initialValue: false),`;
    case 'int':
      return `${name}: context.knobs.int.slider(label: '${name}', initialValue: 1, min: 0, max: 100),`;
    case 'double':
      return `${name}: context.knobs.double.slider(label: '${name}', initialValue: 1, min: 0, max: 100),`;
    case 'Color':
      return `${name}: context.knobs.color(label: '${name}', initialValue: Colors.blue),`;
    case 'Widget':
      return `${name}: const Text('Example'),`;
    case 'IconData':
      return `${name}: Icons.star,`;
    default:
      // Unknown type (enum, custom class) — leave a TODO the dev can fill
      return `// ${name}: TODO (${type}),`;
  }
}

// ── Scan components ───────────────────────────────────────────
const components = [];

for (const [slug, cfg] of Object.entries(componentMap.components)) {
  if (cfg.dart_files.length === 0) continue;

  const dartPath = join(ROOT, cfg.dart_files[0]);
  if (!existsSync(dartPath)) {
    console.warn(`  ⚠️  ${slug}: ${cfg.dart_files[0]} not found, skipping`);
    continue;
  }

  const dartCode = readFileSync(dartPath, 'utf8');
  const mainClass = extractMainClass(dartCode);
  if (!mainClass) {
    console.warn(`  ⚠️  ${slug}: no widget class found, skipping`);
    continue;
  }

  const requiredParams = extractConstructorParams(dartCode, mainClass);
  const importPath = cfg.dart_files[0].replace(/^lib\//, '');

  components.push({
    slug,
    figmaName: cfg.figma_name,
    mainClass,
    importPath,
    requiredParams,
    dartCode,
  });
}

console.log(`Found ${components.length} components with widgets\n`);

// ── Generate use case files ───────────────────────────────────
let created = 0;
let skipped = 0;

const targetComponents = onlyFilter
  ? components.filter(c => onlyFilter.includes(c.slug))
  : components;

if (onlyFilter) {
  console.log(`Scoped to: ${onlyFilter.join(', ')}\n`);
}

for (const comp of targetComponents) {
  const dirName = `${slugify(comp.figmaName)}_component`;
  const dir = join(COMPONENTS_DIR, dirName);
  const fileName = `${slugify(comp.figmaName)}_use_case.dart`;
  const filePath = join(dir, fileName);

  if (existsSync(filePath)) {
    skipped++;
    continue;
  }

  // Build minimal use case
  const useCaseFn = `${slugify(comp.figmaName).replace(/_/g, '')}DefaultUseCase`;

  // Determine constructor args — interactive knobs where the type allows it
  const constructorArgs = comp.requiredParams
    .map(p => `        ${knobForParam(p)}`)
    .join('\n');

  // `const` only holds if there are no knob expressions (knobs are runtime)
  const hasKnobs = comp.requiredParams.some(p => knobForParam(p).includes('context.knobs'));
  const childConst = hasKnobs ? '' : 'const ';

  const code = `import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/${comp.importPath}';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: ${comp.mainClass})
Widget ${useCaseFn}(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: ${childConst}${comp.mainClass}(
${constructorArgs}
      ),
    ),
  );
}
`;

  if (dryRun) {
    console.log(`  Would create: ${dirName}/${fileName}`);
    created++;
    continue;
  }

  mkdirSync(dir, { recursive: true });
  writeFileSync(filePath, code, 'utf8');
  console.log(`  ✅ ${dirName}/${fileName}`);
  created++;
}

console.log(`\nUse cases: ${created} created, ${skipped} already existed`);

// ── Update widgetbook.dart ────────────────────────────────────
if (dryRun) {
  console.log('\n--dry-run: widgetbook.dart not updated.');
  process.exit(0);
}

// Only rewrite widgetbook.dart when new use cases were created
// (drift-only runs don't need to touch the index)
if (created === 0) {
  console.log('\nNo new use cases — widgetbook.dart unchanged.');
  process.exit(0);
}

// Read existing widgetbook.dart to preserve addons/theme config
const existingWidgetbook = readFileSync(WIDGETBOOK_DART, 'utf8');

// Extract the addons section (between 'addons: [' and the matching ']')
const addonsMatch = existingWidgetbook.match(/addons:\s*\[[\s\S]*?\n\s{6}\],/);
const addonsSection = addonsMatch ? addonsMatch[0] : `addons: [],`;

// Build imports
const imports = [];
const widgetbookEntries = [];

// Sort components alphabetically by slug
const sorted = [...components].sort((a, b) => a.slug.localeCompare(b.slug));

for (const comp of sorted) {
  const dirName = `${slugify(comp.figmaName)}_component`;
  const fileName = `${slugify(comp.figmaName)}_use_case.dart`;
  const importLine = `import 'package:widgetbook_workspace/components/${dirName}/${fileName}';`;
  imports.push(importLine);

  const useCaseFn = `${slugify(comp.figmaName).replace(/_/g, '')}DefaultUseCase`;
  const displayName = comp.figmaName.replace(/[❖]/g, '').trim();

  widgetbookEntries.push(`            WidgetbookComponent(
              name: '${displayName}',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => ${useCaseFn}(context),
                ),
              ],
            ),`);
}

const newWidgetbook = `import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart' hide AlignmentAddon;
${imports.join('\n')}
import 'package:widgetbook_workspace/custom/github_addon.dart';
import 'package:widgetbook_workspace/theme/theme_data.dart';
import 'custom/alignment_addon.dart';

void main() {
  runApp(const WidgetbookApp());
}

class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      themeMode: ThemeMode.light,
      darkTheme: ThemeData.light(),
      ${addonsSection}
      directories: [
        WidgetbookFolder(
          name: 'Components',
          children: [
${widgetbookEntries.join('\n')}
          ],
        ),
      ],
    );
  }
}
`;

writeFileSync(WIDGETBOOK_DART, newWidgetbook, 'utf8');
console.log(`\nUpdated widgetbook.dart (${sorted.length} components)`);
