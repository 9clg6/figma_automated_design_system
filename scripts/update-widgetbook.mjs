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

import { readFileSync, writeFileSync, mkdirSync, existsSync, readdirSync, rmSync, statSync } from 'node:fs';
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

// Canonical naming derived from the component-map KEY (slug). Single source
// of truth so generation and the index never diverge.
function canonicalNames(comp) {
  const snake = comp.slug.replace(/-/g, '_');
  const dirName = `${snake}_component`;
  const fileName = `${snake}_use_case.dart`;
  const pas = pascalCase(comp.slug);
  const fnBase = pas.charAt(0).toLowerCase() + pas.slice(1);
  const useCaseName = comp.primaryAxis ? 'Variants' : 'Default';
  const useCaseFn = comp.primaryAxis
    ? `${fnBase}VariantsUseCase`
    : `${fnBase}DefaultUseCase`;
  return { dirName, fileName, useCaseName, useCaseFn };
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

function fieldType(dartCode, name) {
  // Resolve the declared type of `final <Type> <name>;`
  const fieldRegex = new RegExp(`final\\s+([\\w<>,\\s]+?\\??)\\s+${name}\\s*;`);
  const fieldMatch = dartCode.match(fieldRegex);
  return fieldMatch ? fieldMatch[1].trim() : 'dynamic';
}

function extractConstructorParams(dartCode, className) {
  // Extract ALL named params (required + optional) from the primary
  // (non-named) constructor. Returns [{ name, type, required }].
  // The type is resolved from the matching field declaration in the
  // class body (constructor uses `this.x`).
  const ctorRegex = new RegExp(`const\\s+${className}\\(\\{[^}]*\\}\\)`, 's');
  const match = dartCode.match(ctorRegex);
  if (!match) return [];

  const body = match[0];
  const params = [];
  const seen = new Set();

  // Required params: `required this.<name>`
  for (const m of body.matchAll(/required\s+this\.(\w+)/g)) {
    const name = m[1];
    if (seen.has(name)) continue;
    seen.add(name);
    params.push({ name, type: fieldType(dartCode, name), required: true });
  }

  // Optional params: `this.<name>` (with or without `= default`),
  // excluding the required ones already captured.
  for (const m of body.matchAll(/(?<!required\s)this\.(\w+)/g)) {
    const name = m[1];
    if (seen.has(name)) continue;
    seen.add(name);
    params.push({ name, type: fieldType(dartCode, name), required: false });
  }

  return params;
}

// Parse top-level enum declarations: `enum Name { a, b, c }`
// Returns Map<enumName, [values]>.
function extractEnums(dartCode) {
  const enums = new Map();
  for (const m of dartCode.matchAll(/enum\s+(\w+)\s*\{([^}]*)\}/g)) {
    const name = m[1];
    let body = m[2]
      // strip line + block comments
      .replace(/\/\/[^\n]*/g, '')
      .replace(/\/\*[\s\S]*?\*\//g, '');
    // enhanced enums: members section starts at the first ';'
    const semi = body.indexOf(';');
    if (semi !== -1) body = body.slice(0, semi);
    const values = body
      .split(',')
      .map(v => v.trim()
        .replace(/\(.*$/s, '')   // strip constructor args
        .replace(/<.*$/s, '')    // strip generics
        .trim())
      // keep only valid lowerCamel identifiers
      .filter(v => /^[a-z_]\w*$/.test(v));
    if (values.length) enums.set(name, values);
  }
  return enums;
}

// Produce a fixed literal Dart expression for a given param type, used to
// fill every non-axis param when building a showcase instance.
// `enums` is the widget's enum map. Returns a Dart expression string.
function literalForType(type, enums) {
  const nullable = type.endsWith('?');
  const base = nullable ? type.slice(0, -1) : type;

  if (enums.has(base)) return `${base}.${enums.get(base)[0]}`;

  // Callbacks
  if (base === 'VoidCallback') return '() {}';
  if (base.startsWith('void Function') || base.startsWith('Function')) {
    return '(_) {}';
  }
  if (base.startsWith('ValueChanged')) return '(_) {}';

  // List<X> → build 1 element for primitive/enum/Widget X, else empty list
  // (we can't safely construct arbitrary custom classes).
  const listMatch = base.match(/^List<(.+)>$/);
  if (listMatch) {
    const inner = listMatch[1].trim();
    const innerBase = inner.endsWith('?') ? inner.slice(0, -1) : inner;
    const simple = enums.has(innerBase) ||
      ['String', 'bool', 'int', 'double', 'num', 'Color', 'Widget', 'IconData']
        .includes(innerBase);
    return simple ? `[${literalForType(inner, enums)}]` : 'const []';
  }

  switch (base) {
    case 'String': return `'Example'`;
    case 'bool': return 'false';
    case 'int': return '1';
    case 'double': return '1.0';
    case 'num': return '1';
    case 'Color': return 'Colors.blue';
    case 'Widget': return `const Text('Example')`;
    case 'IconData': return 'Icons.star';
    case 'EdgeInsets':
    case 'EdgeInsetsGeometry': return 'const EdgeInsets.all(8)';
    case 'DateTime': return 'DateTime(2020, 1, 1)';
    case 'DateTimeRange':
      return 'DateTimeRange(start: DateTime(2020, 1, 1), end: DateTime(2030, 12, 31))';
    default:
      if (nullable) return 'null';
      // Unknown non-nullable type — best effort const constructor
      return `const ${base}()`;
  }
}

// Is a literal expression non-const (contains a closure or runtime value)?
function isNonConst(expr) {
  return /\{\}|\(_\)|Colors\.|=>|DateTime\(|DateTimeRange\(/.test(expr) && !expr.startsWith('const ');
}

// Map a Dart param (name + type) to a widgetbook knob expression, or a
// static fallback when no sensible knob exists (callbacks, unknown types).
function knobForParam({ name, type }, enums) {
  const nullable = type.endsWith('?');
  const base = nullable ? type.slice(0, -1) : type;

  // Enum-typed param — use the first enum value (no knob).
  if (enums && enums.has(base)) {
    return `${name}: ${base}.${enums.get(base)[0]},`;
  }

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
      // Unknown type (custom class etc.) — best-effort literal so the
      // generated instance still compiles.
      return `${name}: ${literalForType(type, enums || new Map())},`;
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

  const allParams = extractConstructorParams(dartCode, mainClass);
  const requiredParams = allParams.filter(p => p.required);
  const enums = extractEnums(dartCode);
  const importPath = cfg.dart_files[0].replace(/^lib\//, '');

  // Axes = params whose (non-nullable) type is one of the widget's enums.
  const axisParams = allParams.filter(p => {
    const base = p.type.endsWith('?') ? p.type.slice(0, -1) : p.type;
    return enums.has(base);
  });

  // Primary axis: prefer type/variant/style, else first enum param.
  let primaryAxis = axisParams.find(p =>
    ['type', 'variant', 'style'].includes(p.name)) || axisParams[0] || null;

  components.push({
    slug,
    figmaName: cfg.figma_name,
    mainClass,
    importPath,
    allParams,
    requiredParams,
    enums,
    primaryAxis,
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

// Build a `<Widget>(args)` instance expression filling every param with a
// fixed literal, except `overrideName` which is set to `overrideExpr`.
// `indent` is the leading whitespace for each arg line.
function buildInstance(comp, overrideName, overrideExpr, indent) {
  const lines = [];
  for (const p of comp.allParams) {
    if (p.name === overrideName) {
      lines.push(`${indent}${p.name}: ${overrideExpr},`);
      continue;
    }
    // Only fill REQUIRED params with literals. Optional params keep their
    // constructor defaults — this avoids inventing values for private /
    // dynamic / complex types we can't safely construct.
    if (!p.required) continue;
    lines.push(`${indent}${p.name}: ${literalForType(p.type, comp.enums)},`);
  }
  return `${comp.mainClass}(\n${lines.join('\n')}\n${indent.slice(2)})`;
}

for (const comp of targetComponents) {
  // Canonical dir/file/fn derive from the component-map KEY (slug), never
  // from slugify(figmaName) — guarantees one dir per component.
  const { dirName, fileName, useCaseFn } = canonicalNames(comp);
  const dir = join(COMPONENTS_DIR, dirName);
  const filePath = join(dir, fileName);

  // Skip only when the existing canonical file already defines the function
  // the index will reference — otherwise we MUST regenerate so the index and
  // file stay consistent (legacy hand-written files often use other fn names).
  if (existsSync(filePath) &&
      readFileSync(filePath, 'utf8').includes(`Widget ${useCaseFn}(`)) {
    skipped++;
    continue;
  }

  let code;

  if (comp.primaryAxis) {
    // ── Variant showcase ──────────────────────────────────────
    const axis = comp.primaryAxis;
    const axisBase = axis.type.endsWith('?') ? axis.type.slice(0, -1) : axis.type;
    const values = comp.enums.get(axisBase);

    const rows = values.map(v => {
      const instance = buildInstance(comp, axis.name, `${axisBase}.${v}`, '            ');
      return `          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${v}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 4),
                ${instance},
              ],
            ),
          ),`;
    }).join('\n');

    code = `import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/${comp.importPath}';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Variants', type: ${comp.mainClass})
Widget ${useCaseFn}(BuildContext context) {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
${rows}
        ],
      ),
    ),
  );
}
`;
  } else {
    // ── Default single instance (fallback) ────────────────────
    const constructorArgs = comp.requiredParams
      .map(p => `        ${knobForParam(p, comp.enums)}`)
      .join('\n');
    // Drop `const` if any arg is a knob or a non-const literal (DateTime, etc.)
    const constSafe = comp.requiredParams.every(p => {
      const expr = knobForParam(p, comp.enums);
      return !expr.includes('context.knobs') && !isNonConst(expr);
    });
    const childConst = constSafe ? 'const ' : '';

    code = `import 'package:flutter/material.dart';
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
  }

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

// The index is ALWAYS rebuilt from the component map (never from the
// filesystem) so it can never contain duplicates, regardless of `created`.

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
  const { dirName, fileName, useCaseName, useCaseFn } = canonicalNames(comp);
  const importLine = `import 'package:widgetbook_workspace/components/${dirName}/${fileName}';`;
  imports.push(importLine);

  const displayName = comp.figmaName.replace(/[❖]/g, '').trim();

  widgetbookEntries.push(`            WidgetbookComponent(
              name: '${displayName}',
              useCases: [
                WidgetbookUseCase(
                  name: '${useCaseName}',
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

// ── Delete legacy duplicate dirs (orphans) ────────────────────
// Keep only `${slug}_component` dirs for slugs present in the current map.
const canonicalDirs = new Set(sorted.map(c => canonicalNames(c).dirName));
if (existsSync(COMPONENTS_DIR)) {
  let deleted = 0;
  for (const entry of readdirSync(COMPONENTS_DIR)) {
    const full = join(COMPONENTS_DIR, entry);
    if (!statSync(full).isDirectory()) continue;
    if (!entry.endsWith('_component')) continue; // only touch *_component dirs
    if (canonicalDirs.has(entry)) continue;
    rmSync(full, { recursive: true, force: true });
    console.log(`  🗑️  deleted orphan dir: ${entry}`);
    deleted++;
  }
  console.log(`\nOrphan dirs deleted: ${deleted}`);
}
