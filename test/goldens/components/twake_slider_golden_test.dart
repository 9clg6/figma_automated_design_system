import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:linagora_design_flutter/slider/twake_slider.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  group('TwakeSlider golden tests', () {
    testGoldens('continuous_enabled_0pct', (tester) async {
      await tester.pumpWidgetBuilder(
        _buildScenario(
          value: 0.0,
          type: TwakeSliderType.continuous,
          disabled: false,
        ),
        wrapper: materialAppWrapper(
          theme: ThemeData(useMaterial3: true),
        ),
        surfaceSize: const Size(280, 80),
      );
      await screenMatchesGolden(tester, 'continuous_enabled_0pct');
    });

    testGoldens('continuous_enabled_25pct', (tester) async {
      await tester.pumpWidgetBuilder(
        _buildScenario(
          value: 0.25,
          type: TwakeSliderType.continuous,
          disabled: false,
        ),
        wrapper: materialAppWrapper(
          theme: ThemeData(useMaterial3: true),
        ),
        surfaceSize: const Size(280, 80),
      );
      await screenMatchesGolden(tester, 'continuous_enabled_25pct');
    });

    testGoldens('continuous_disabled_25pct', (tester) async {
      await tester.pumpWidgetBuilder(
        _buildScenario(
          value: 0.25,
          type: TwakeSliderType.continuous,
          disabled: true,
        ),
        wrapper: materialAppWrapper(
          theme: ThemeData(useMaterial3: true),
        ),
        surfaceSize: const Size(280, 80),
      );
      await screenMatchesGolden(tester, 'continuous_disabled_25pct');
    });

    testGoldens('discrete_enabled_0pct', (tester) async {
      await tester.pumpWidgetBuilder(
        _buildScenario(
          value: 0.0,
          type: TwakeSliderType.discrete,
          disabled: false,
        ),
        wrapper: materialAppWrapper(
          theme: ThemeData(useMaterial3: true),
        ),
        surfaceSize: const Size(280, 80),
      );
      await screenMatchesGolden(tester, 'discrete_enabled_0pct');
    });

    testGoldens('discrete_enabled_25pct', (tester) async {
      await tester.pumpWidgetBuilder(
        _buildScenario(
          value: 0.25,
          type: TwakeSliderType.discrete,
          disabled: false,
        ),
        wrapper: materialAppWrapper(
          theme: ThemeData(useMaterial3: true),
        ),
        surfaceSize: const Size(280, 80),
      );
      await screenMatchesGolden(tester, 'discrete_enabled_25pct');
    });

    testGoldens('discrete_disabled_25pct', (tester) async {
      await tester.pumpWidgetBuilder(
        _buildScenario(
          value: 0.25,
          type: TwakeSliderType.discrete,
          disabled: true,
        ),
        wrapper: materialAppWrapper(
          theme: ThemeData(useMaterial3: true),
        ),
        surfaceSize: const Size(280, 80),
      );
      await screenMatchesGolden(tester, 'discrete_disabled_25pct');
    });

    testGoldens('all_variants_grid', (tester) async {
      await tester.pumpWidgetBuilder(
        _buildAllVariantsGrid(),
        wrapper: materialAppWrapper(
          theme: ThemeData(useMaterial3: true),
        ),
        surfaceSize: const Size(600, 480),
      );
      await screenMatchesGolden(tester, 'all_variants_grid');
    });
  });
}

Widget _buildScenario({
  required double value,
  required TwakeSliderType type,
  required bool disabled,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
    child: TwakeSlider(
      value: value,
      type: type,
      disabled: disabled,
      min: 0,
      max: 100,
      onChanged: (_) {},
    ),
  );
}

Widget _buildAllVariantsGrid() {
  const types = [TwakeSliderType.continuous, TwakeSliderType.discrete];
  const values = [0.0, 0.25, 0.5, 0.75, 1.0];
  const disabled = [false, true];

  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final type in types)
          for (final isDisabled in disabled)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      '${type == TwakeSliderType.continuous ? 'Cont' : 'Disc'} ${isDisabled ? 'off' : 'on'}',
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                  for (final v in values)
                    Expanded(
                      child: TwakeSlider(
                        value: v,
                        type: type,
                        disabled: isDisabled,
                        min: 0,
                        max: 100,
                        onChanged: (_) {},
                      ),
                    ),
                ],
              ),
            ),
      ],
    ),
  );
}
