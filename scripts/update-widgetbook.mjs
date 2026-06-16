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
  // Extract required params from constructor
  const ctorRegex = new RegExp(`const\\s+${className}\\(\\{[^}]*\\}\\)`, 's');
  const match = dartCode.match(ctorRegex);
  if (!match) return [];

  const params = [];
  const requiredMatches = match[0].matchAll(/required\s+this\.(\w+)/g);
  for (const m of requiredMatches) params.push(m[1]);
  return params;
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

  // Determine constructor args
  let constructorArgs = '';
  for (const p of comp.requiredParams) {
    if (p === 'child') constructorArgs += "    child: Text('Example'),\n";
    else if (p === 'onTap' || p === 'onPressed') constructorArgs += `    ${p}: () {},\n`;
    else if (p === 'label' || p === 'title' || p === 'text' || p === 'message')
      constructorArgs += `    ${p}: '${comp.mainClass} example',\n`;
    else if (p === 'icon') constructorArgs += `    ${p}: Icons.star,\n`;
    else if (p.startsWith('on')) constructorArgs += `    ${p}: (_) {},\n`;
    else constructorArgs += `    // ${p}: TODO,\n`;
  }

  const code = `import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/${comp.importPath}';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: ${comp.mainClass})
Widget ${useCaseFn}(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: ${comp.mainClass}(
${constructorArgs}      ),
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
