import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:linagora_design_flutter/labels/twake_label.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  group('TwakeLabel golden tests', () {
    Widget buildScenario(TwakeLabelVariant variant, TwakeLabelTheme theme) {
      return MaterialApp(
        home: Scaffold(
          backgroundColor:
              theme == TwakeLabelTheme.dark ? const Color(0xFF1C1B1F) : Colors.white,
          body: Center(
            child: TwakeLabel(
              label: 'Label here',
              variant: variant,
              theme: theme,
            ),
          ),
        ),
      );
    }

    testGoldens('TwakeLabel — light default', (tester) async {
      await tester.pumpWidgetBuilder(
        buildScenario(TwakeLabelVariant.defaultVariant, TwakeLabelTheme.light),
        surfaceSize: const Size(300, 80),
      );
      await screenMatchesGolden(tester, 'twake_label_light_default');
    });

    testGoldens('TwakeLabel — light collapsed', (tester) async {
      await tester.pumpWidgetBuilder(
        buildScenario(TwakeLabelVariant.collapsed, TwakeLabelTheme.light),
        surfaceSize: const Size(300, 80),
      );
      await screenMatchesGolden(tester, 'twake_label_light_collapsed');
    });

    testGoldens('TwakeLabel — light expanded', (tester) async {
      await tester.pumpWidgetBuilder(
        buildScenario(TwakeLabelVariant.expanded, TwakeLabelTheme.light),
        surfaceSize: const Size(300, 80),
      );
      await screenMatchesGolden(tester, 'twake_label_light_expanded');
    });

    testGoldens('TwakeLabel — light clear btn', (tester) async {
      await tester.pumpWidgetBuilder(
        buildScenario(TwakeLabelVariant.clearBtn, TwakeLabelTheme.light),
        surfaceSize: const Size(300, 80),
      );
      await screenMatchesGolden(tester, 'twake_label_light_clear_btn');
    });

    testGoldens('TwakeLabel — dark default', (tester) async {
      await tester.pumpWidgetBuilder(
        buildScenario(TwakeLabelVariant.defaultVariant, TwakeLabelTheme.dark),
        surfaceSize: const Size(300, 80),
      );
      await screenMatchesGolden(tester, 'twake_label_dark_default');
    });

    testGoldens('TwakeLabel — dark collapsed', (tester) async {
      await tester.pumpWidgetBuilder(
        buildScenario(TwakeLabelVariant.collapsed, TwakeLabelTheme.dark),
        surfaceSize: const Size(300, 80),
      );
      await screenMatchesGolden(tester, 'twake_label_dark_collapsed');
    });

    testGoldens('TwakeLabel — dark expanded', (tester) async {
      await tester.pumpWidgetBuilder(
        buildScenario(TwakeLabelVariant.expanded, TwakeLabelTheme.dark),
        surfaceSize: const Size(300, 80),
      );
      await screenMatchesGolden(tester, 'twake_label_dark_expanded');
    });

    testGoldens('TwakeLabel — dark clear btn', (tester) async {
      await tester.pumpWidgetBuilder(
        buildScenario(TwakeLabelVariant.clearBtn, TwakeLabelTheme.dark),
        surfaceSize: const Size(300, 80),
      );
      await screenMatchesGolden(tester, 'twake_label_dark_clear_btn');
    });

    testGoldens('TwakeLabel — all variants grid', (tester) async {
      await tester.pumpWidgetBuilder(
        MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Light',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 4),
                  for (final variant in TwakeLabelVariant.values)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: TwakeLabel(
                        label: 'Label here',
                        variant: variant,
                        theme: TwakeLabelTheme.light,
                      ),
                    ),
                  const SizedBox(height: 12),
                  Container(
                    color: const Color(0xFF1C1B1F),
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Dark',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.white)),
                        const SizedBox(height: 4),
                        for (final variant in TwakeLabelVariant.values)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: TwakeLabel(
                              label: 'Label here',
                              variant: variant,
                              theme: TwakeLabelTheme.dark,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        surfaceSize: const Size(300, 500),
      );
      await screenMatchesGolden(tester, 'twake_label_all_variants');
    });
  });
}
