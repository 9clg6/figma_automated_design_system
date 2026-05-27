import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:linagora_design_flutter/linear_progress_indicator/twake_linear_progress_indicator.dart';

void main() {
  group('TwakeLinearProgressIndicator golden tests', () {
    testGoldens('light – all fixed variants', (tester) async {
      await loadAppFonts();

      final builder = GoldenBuilder.column(
        bgColor: const Color(0xFFF1F1F1),
      )
        ..addScenario(
          '25 %',
          const SizedBox(
            width: 280,
            child: TwakeLinearProgressIndicator(value: 0.25),
          ),
        )
        ..addScenario(
          '50 %',
          const SizedBox(
            width: 280,
            child: TwakeLinearProgressIndicator(value: 0.50),
          ),
        )
        ..addScenario(
          '75 %',
          const SizedBox(
            width: 280,
            child: TwakeLinearProgressIndicator(value: 0.75),
          ),
        )
        ..addScenario(
          '100 %',
          const SizedBox(
            width: 280,
            child: TwakeLinearProgressIndicator(value: 1.0),
          ),
        )
        ..addScenario(
          'indeterminate',
          const SizedBox(
            width: 280,
            // value: null → indeterminate; animation is frozen in golden
            child: TwakeLinearProgressIndicator(),
          ),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        surfaceSize: const Size(400, 500),
      );

      await screenMatchesGolden(
        tester,
        'twake_linear_progress_indicator_light',
        customPump: (tester) => tester.pump(),
      );
    });

    testGoldens('dark – all fixed variants', (tester) async {
      await loadAppFonts();

      final builder = GoldenBuilder.column(
        bgColor: const Color(0xFF1E1E1E),
      )
        ..addScenario(
          '25 %',
          const SizedBox(
            width: 280,
            child: TwakeLinearProgressIndicator(value: 0.25),
          ),
        )
        ..addScenario(
          '50 %',
          const SizedBox(
            width: 280,
            child: TwakeLinearProgressIndicator(value: 0.50),
          ),
        )
        ..addScenario(
          '75 %',
          const SizedBox(
            width: 280,
            child: TwakeLinearProgressIndicator(value: 0.75),
          ),
        )
        ..addScenario(
          '100 %',
          const SizedBox(
            width: 280,
            child: TwakeLinearProgressIndicator(value: 1.0),
          ),
        )
        ..addScenario(
          'indeterminate',
          const SizedBox(
            width: 280,
            child: TwakeLinearProgressIndicator(),
          ),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: materialAppWrapper(
          theme: ThemeData.dark(),
        ),
        surfaceSize: const Size(400, 500),
      );

      await screenMatchesGolden(
        tester,
        'twake_linear_progress_indicator_dark',
        customPump: (tester) => tester.pump(),
      );
    });
  });
}
