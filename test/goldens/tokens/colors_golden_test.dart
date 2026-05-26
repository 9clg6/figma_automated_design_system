@TestOn('vm')
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';
import 'package:linagora_design_flutter/colors/linagora_ref_colors.dart';
import 'package:linagora_design_flutter/colors/linagora_key_colors.dart';

import '../../helpers/golden_test_helper.dart';

void main() {
  group('LinagoraSysColors golden tests', () {
    testWidgets('light system colors palette', (tester) async {
      final colors = LinagoraSysColors.material();

      final swatches = <MapEntry<String, Color>>[
        MapEntry('primary', colors.primary),
        MapEntry('onPrimary', colors.onPrimary),
        MapEntry('primaryContainer', colors.primaryContainer),
        MapEntry('onPrimaryContainer', colors.onPrimaryContainer),
        MapEntry('secondary', colors.secondary),
        MapEntry('onSecondary', colors.onSecondary),
        MapEntry('secondaryContainer', colors.secondaryContainer),
        MapEntry('onSecondaryContainer', colors.onSecondaryContainer),
        MapEntry('tertiary', colors.tertiary),
        MapEntry('onTertiary', colors.onTertiary),
        MapEntry('tertiaryContainer', colors.tertiaryContainer),
        MapEntry('onTertiaryContainer', colors.onTertiaryContainer),
        MapEntry('error', colors.error),
        MapEntry('onError', colors.onError),
        MapEntry('errorContainer', colors.errorContainer),
        MapEntry('onErrorContainer', colors.onErrorContainer),
        MapEntry('background', colors.background),
        MapEntry('onBackground', colors.onBackground),
        MapEntry('surface', colors.surface),
        MapEntry('onSurface', colors.onSurface),
        MapEntry('surfaceVariant', colors.surfaceVariant),
        MapEntry('onSurfaceVariant', colors.onSurfaceVariant),
        MapEntry('outline', colors.outline),
        MapEntry('outlineVariant', colors.outlineVariant),
        MapEntry('inverseSurface', colors.inverseSurface),
        MapEntry('onInverseSurface', colors.onInverseSurface),
        MapEntry('inversePrimary', colors.inversePrimary),
        MapEntry('shadow', colors.shadow),
        MapEntry('surfaceTint', colors.surfaceTint),
      ];

      await pumpGolden(
        tester,
        _ColorPaletteWidget(
          title: 'LinagoraSysColors (Light)',
          swatches: swatches,
        ),
        size: const Size(500, 900),
      );

      await expectLater(
        find.byType(_ColorPaletteWidget),
        matchesGoldenFile('sys_colors_light.png'),
      );
    });

    testWidgets('dark system colors palette', (tester) async {
      final colors = LinagoraSysColors.material();

      final swatches = <MapEntry<String, Color>>[
        MapEntry('primaryDark', colors.primaryDark),
        MapEntry('onPrimaryDark', colors.onPrimaryDark),
        MapEntry('primaryContainerDark', colors.primaryContainerDark),
        MapEntry('onPrimaryContainerDark', colors.onPrimaryContainerDark),
        MapEntry('secondaryDark', colors.secondaryDark),
        MapEntry('onSecondaryDark', colors.onSecondaryDark),
        MapEntry('secondaryContainerDark', colors.secondaryContainerDark),
        MapEntry('onSecondaryContainerDark', colors.onSecondaryContainerDark),
        MapEntry('tertiaryDark', colors.tertiaryDark),
        MapEntry('onTertiaryDark', colors.onTertiaryDark),
        MapEntry('errorDark', colors.errorDark),
        MapEntry('onErrorDark', colors.onErrorDark),
        MapEntry('backgroundDark', colors.backgroundDark),
        MapEntry('onBackgroundDark', colors.onBackgroundDark),
        MapEntry('surfaceDark', colors.surfaceDark),
        MapEntry('onSurfaceDark', colors.onSurfaceDark),
        MapEntry('surfaceVariantDark', colors.surfaceVariantDark),
        MapEntry('outlineDark', colors.outlineDark),
        MapEntry('outlineVariantDark', colors.outlineVariantDark),
        MapEntry('inverseSurfaceDark', colors.inverseSurfaceDark),
        MapEntry('shadowDark', colors.shadowDark),
        MapEntry('surfaceTintDark', colors.surfaceTintDark),
      ];

      await pumpGolden(
        tester,
        _ColorPaletteWidget(
          title: 'LinagoraSysColors (Dark)',
          swatches: swatches,
        ),
        size: const Size(500, 750),
      );

      await expectLater(
        find.byType(_ColorPaletteWidget),
        matchesGoldenFile('sys_colors_dark.png'),
      );
    });
  });

  group('LinagoraRefColors golden tests', () {
    testWidgets('reference color palettes', (tester) async {
      final ref = LinagoraRefColors.material();
      final palettes = <String, MaterialColor>{
        'primary': ref.primary,
        'secondary': ref.secondary,
        'tertiary': ref.tertiary,
        'neutral': ref.neutral,
        'neutralVariant': ref.neutralVariant,
        'error': ref.error,
      };

      await pumpGolden(
        tester,
        _RefColorPaletteWidget(palettes: palettes),
        size: const Size(600, 550),
      );

      await expectLater(
        find.byType(_RefColorPaletteWidget),
        matchesGoldenFile('ref_colors.png'),
      );
    });
  });

  group('LinagoraKeyColors golden tests', () {
    testWidgets('key colors', (tester) async {
      final key = LinagoraKeyColors.material();
      final swatches = <MapEntry<String, Color>>[
        MapEntry('primary', key.primary),
        MapEntry('secondary', key.secondary),
        MapEntry('tertiary', key.tertiary),
        MapEntry('neutral', key.neutral),
        MapEntry('neutralVariant', key.neutralVariant),
        MapEntry('error', key.error),
      ];

      await pumpGolden(
        tester,
        _ColorPaletteWidget(
          title: 'LinagoraKeyColors',
          swatches: swatches,
        ),
        size: const Size(500, 300),
      );

      await expectLater(
        find.byType(_ColorPaletteWidget),
        matchesGoldenFile('key_colors.png'),
      );
    });
  });
}

// ── Test widgets ──────────────────────────────────────────────

class _ColorPaletteWidget extends StatelessWidget {
  final String title;
  final List<MapEntry<String, Color>> swatches;

  const _ColorPaletteWidget({
    required this.title,
    required this.swatches,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(
            child: Wrap(
              spacing: 4,
              runSpacing: 4,
              children: swatches.map((e) => _ColorSwatch(name: e.key, color: e.value)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  final String name;
  final Color color;

  const _ColorSwatch({required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    final luminance = color.computeLuminance();
    return Container(
      width: 90,
      height: 44,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.black12),
      ),
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 7,
              fontWeight: FontWeight.w600,
              color: luminance > 0.5 ? Colors.black : Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
            style: TextStyle(
              fontSize: 6,
              color: luminance > 0.5 ? Colors.black54 : Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

class _RefColorPaletteWidget extends StatelessWidget {
  final Map<String, MaterialColor> palettes;

  const _RefColorPaletteWidget({required this.palettes});

  static const shades = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 95, 99, 100];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('LinagoraRefColors', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          // Header row
          Row(
            children: [
              const SizedBox(width: 80),
              ...shades.map((s) => SizedBox(
                width: 36,
                child: Text('$s', style: const TextStyle(fontSize: 7), textAlign: TextAlign.center),
              )),
            ],
          ),
          const SizedBox(height: 4),
          ...palettes.entries.map((entry) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text(entry.key, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w600)),
                ),
                ...shades.map((shade) {
                  final color = entry.value[shade] ?? Colors.transparent;
                  return Container(
                    width: 36,
                    height: 32,
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(color: Colors.black12, width: 0.5),
                    ),
                  );
                }),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
