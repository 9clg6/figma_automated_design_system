#!/usr/bin/env node

/**
 * generate-kb-diff.mjs
 *
 * Generates a semantic diff between extracted Figma tokens (kb/registries/)
 * and current Dart code, writing the result to /tmp/kb.diff
 * for consumption by figma-to-dart.mjs
 */

import { readFileSync, writeFileSync } from 'node:fs';
import { join, resolve } from 'node:path';

const ROOT = resolve(import.meta.dirname, '..');
const colors = JSON.parse(readFileSync(join(ROOT, 'kb/registries/colors.json'), 'utf8'));
const typo = JSON.parse(readFileSync(join(ROOT, 'kb/registries/typography.json'), 'utf8'));
const effects = JSON.parse(readFileSync(join(ROOT, 'kb/registries/effects.json'), 'utf8'));

let diff = '--- Figma Design System Token Sync ---\n';
diff += '--- All Figma token values (authoritative source) ---\n\n';

// ── SYS COLORS (Light) ──────────────────────────────────────
diff += '=== SYS COLORS (Light) ===\n';
const sysLightMap = {
  'primary': 'M3/sys light/Primary/primary',
  'onPrimary': 'M3/sys light/Primary/on-primary',
  'primaryContainer': 'M3/sys light/Primary/primary-container',
  'onPrimaryContainer': 'M3/sys light/Primary/on-primary-container',
  'onSecondary': 'M3/sys light/Secondary/on-secondary',
  'secondaryContainer': 'M3/sys light/Secondary/secondary-container',
  'onSecondaryContainer': 'M3/sys light/Secondary/on-secondary-container',
  'tertiary': 'M3/sys light/Tetirary/tertiary',
  'onTertiary': 'M3/sys light/Tetirary/on-tertiary',
  'tertiaryContainer': 'M3/sys light/Tetirary/tertiary-container',
  'onTertiaryContainer': 'M3/sys light/Tetirary/on-tertiary-container',
  'error': 'M3/sys light/Error/error',
  'onError': 'M3/sys light/Error/on-error',
  'errorContainer': 'M3/sys light/Error/error-container',
  'onErrorContainer': 'M3/sys light/Error/on-error-container',
  'background': 'M3/sys light/BG + Surface/background - n99',
  'onBackground': 'M3/sys light/BG + Surface/on-background - n10',
  'surface': 'M3/sys light/BG + Surface/surface',
  'onSurface': 'M3/sys light/BG + Surface/on-surface',
  'surfaceVariant': 'M3/sys light/BG + Surface/surface-variant',
  'onSurfaceVariant': 'M3/sys light/BG + Surface/on-surface-variant',
  'outline': 'M3/sys light/Outline + Shadow/outline',
  'outlineVariant': 'M3/sys light/Outline + Shadow/outline-variant',
};

for (const [dart, figmaKey] of Object.entries(sysLightMap)) {
  const val = colors[figmaKey];
  if (val) diff += `${dart}: ${val.hex}\n`;
}

// Secondary has a long name in Figma — find it
for (const [k, v] of Object.entries(colors)) {
  if (k.startsWith('M3/sys light/Secondary/secondary') && !k.includes('container') && !k.includes('on-')) {
    diff += `secondary: ${v.hex}\n`;
    break;
  }
}

// Derived tokens (not explicit in Figma, use M3 spec):
// inversePrimary = primary80, surfaceTint = primary, inverseSurface = neutral20
diff += `# Derived tokens (M3 spec):\n`;
diff += `inversePrimary: ${colors['M3/ref/primary/primary80']?.hex || '#BFDFFF'} (= primary80)\n`;
diff += `surfaceTint: ${colors['M3/sys light/Primary/primary']?.hex || '#0A84FF'} (= primary)\n`;
diff += `inverseSurface: ${colors['M3/ref/neutral/neutral20']?.hex || '#313033'} (= neutral20)\n`;
diff += `onInverseSurface: ${colors['M3/ref/neutral/neutral95']?.hex || '#F4EFF4'} (= neutral95)\n`;
diff += `shadow: #000000 (= neutral0)\n`;

// ── SYS COLORS (Dark) ───────────────────────────────────────
diff += '\n=== SYS COLORS (Dark) ===\n';
const sysDarkMap = {
  'primaryDark': 'M3/sys dark/Primary/primary',
  'onPrimaryDark': 'M3/sys dark/Primary/on-primary',
  'primaryContainerDark': 'M3/sys dark/Primary/primary-container',
  'onPrimaryContainerDark': 'M3/sys dark/Primary/on-primary-container',
  'secondaryDark': 'M3/sys dark/Secondary/secondary',
  'onSecondaryDark': 'M3/sys dark/Secondary/on-secondary',
  'secondaryContainerDark': 'M3/sys dark/Secondary/secondary-container',
  'onSecondaryContainerDark': 'M3/sys dark/Secondary/on-secondary-container',
  'tertiaryDark': 'M3/sys dark/Tetiary/tertiary',
  'onTertiaryDark': 'M3/sys dark/Tetiary/on-tertiary',
  'tertiaryContainerDark': 'M3/sys dark/Tetiary/tertiary-container',
  'onTertiaryContainerDark': 'M3/sys dark/Tetiary/on-tertiary-container',
  'errorDark': 'M3/sys dark/Error/error',
  'onErrorDark': 'M3/sys dark/Error/on-error',
  'errorContainerDark': 'M3/sys dark/Error/error-container',
  'onErrorContainerDark': 'M3/sys dark/Error/on-error-container',
  'backgroundDark': 'M3/sys dark/BG + Surface/background',
  'onBackgroundDark': 'M3/sys dark/BG + Surface/on-background',
  'surfaceDark': 'M3/sys dark/BG + Surface/surface',
  'onSurfaceDark': 'M3/sys dark/BG + Surface/on-surface',
  'surfaceVariantDark': 'M3/sys dark/BG + Surface/surface-variant',
  'onSurfaceVariantDark': 'M3/sys dark/BG + Surface/on-surface-variant',
  'outlineDark': 'M3/sys dark/Outline + Shadow/outline',
  'outlineVariantDark': 'M3/sys dark/Outline + Shadow/outline-variant',
};

for (const [dart, figmaKey] of Object.entries(sysDarkMap)) {
  const val = colors[figmaKey];
  if (val) diff += `${dart}: ${val.hex}\n`;
}

// Derived dark tokens
diff += `# Derived dark tokens (M3 spec):\n`;
diff += `inversePrimaryDark: ${colors['M3/sys dark/Primary/primary']?.hex || '#0A84FF'} (= primaryDark)\n`;
diff += `surfaceTintDark: ${colors['M3/sys dark/Primary/primary']?.hex || '#0A84FF'} (= primaryDark)\n`;
diff += `inverseSurfaceDark: #FFFFFF\n`;
diff += `onInverseSurfaceDark: ${colors['M3/ref/neutral/neutral20']?.hex || '#313033'}\n`;
diff += `shadowDark: #000000\n`;

// ── KEY COLORS ───────────────────────────────────────────────
diff += '\n=== KEY COLORS ===\n';
const keyMap = {
  'primary': 'M3/ref/primary/primary40',
  'secondary': 'M3/ref/secondary/secondary40',
  'tertiary': 'M3/ref/tertiary/tertiary40',
  'neutral': 'M3/ref/neutral/neutral40',
  'neutralVariant': 'M3/ref/neutral-variant/neutral-variant40',
  'error': 'M3/ref/error/error40',
};
for (const [dart, figmaKey] of Object.entries(keyMap)) {
  const val = colors[figmaKey];
  if (val) diff += `${dart}: ${val.hex}\n`;
}

// ── REF COLORS ───────────────────────────────────────────────
diff += '\n=== REF COLORS ===\n';
const palettes = ['primary', 'secondary', 'tertiary', 'neutral', 'neutral-variant', 'error'];
const shades = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 95, 99, 100];

for (const p of palettes) {
  const dartName = p.replace(/-(\w)/g, (_, c) => c.toUpperCase()); // neutral-variant → neutralVariant
  diff += `${dartName}:\n`;
  for (const s of shades) {
    const key = `M3/ref/${p}/${p}${s}`;
    const val = colors[key];
    if (val) diff += `  ${s}: ${val.hex}\n`;
  }
}

// ── TYPOGRAPHY ───────────────────────────────────────────────
diff += '\n=== TYPOGRAPHY ===\n';
diff += '# Figma has 21 text styles. Dart currently only exposes 6 body variants.\n';
diff += '# Add missing styles to LinagoraTextStyle class.\n';
for (const [name, val] of Object.entries(typo)) {
  const shortName = name.replace('M3/', '');
  diff += `${shortName}: fontSize=${val.fontSize} fontWeight=${val.fontWeight} letterSpacing=${val.letterSpacing} fontFamily=${val.fontFamily}\n`;
}

// ── EFFECTS ──────────────────────────────────────────────────
diff += '\n=== EFFECTS (Elevation shadows) ===\n';
for (const [name, val] of Object.entries(effects)) {
  const shortName = name.replace('M3/', '');
  if (val.effects) {
    diff += `${shortName}:\n`;
    for (const eff of val.effects) {
      if (eff.type === 'DROP_SHADOW') {
        const c = eff.color;
        diff += `  shadow: offset=(${eff.offset?.x},${eff.offset?.y}) radius=${eff.radius} color=rgba(${Math.round(c.r*255)},${Math.round(c.g*255)},${Math.round(c.b*255)},${c.a.toFixed(2)})\n`;
      }
    }
  }
}

writeFileSync('/tmp/kb.diff', diff);
console.log(`✅ Wrote /tmp/kb.diff (${diff.length} bytes)`);
console.log(diff);
