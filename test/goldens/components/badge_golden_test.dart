import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:linagora_design_flutter/badge/twake_badge.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  group('TwakeBadge golden tests', () {
    testGoldens('badge_small_light', (tester) async {
      await tester.pumpWidgetBuilder(
        const Center(
          child: TwakeBadge.small(),
        ),
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
        ),
        surfaceSize: const Size(60, 60),
      );
      await screenMatchesGolden(tester, 'badge_small_light');
    });

    testGoldens('badge_single_digit_light', (tester) async {
      await tester.pumpWidgetBuilder(
        const Center(
          child: TwakeBadge.singleDigit(digit: '3'),
        ),
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
        ),
        surfaceSize: const Size(60, 60),
      );
      await screenMatchesGolden(tester, 'badge_single_digit_light');
    });

    testGoldens('badge_multiple_digits_light', (tester) async {
      await tester.pumpWidgetBuilder(
        const Center(
          child: TwakeBadge.multipleDigits(count: '32'),
        ),
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
        ),
        surfaceSize: const Size(80, 60),
      );
      await screenMatchesGolden(tester, 'badge_multiple_digits_light');
    });

    testGoldens('badge_all_variants_light', (tester) async {
      await tester.pumpWidgetBuilder(
        Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            color: const Color(0xFFF5F5F5),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TwakeBadge.small(),
                SizedBox(height: 20),
                TwakeBadge.singleDigit(digit: '3'),
                SizedBox(height: 20),
                TwakeBadge.multipleDigits(count: '32'),
              ],
            ),
          ),
        ),
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
        ),
        surfaceSize: const Size(120, 180),
      );
      await screenMatchesGolden(tester, 'badge_all_variants_light');
    });

    testGoldens('badge_all_variants_dark', (tester) async {
      await tester.pumpWidgetBuilder(
        Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            color: const Color(0xFF1C1B1F),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TwakeBadge.small(),
                SizedBox(height: 20),
                TwakeBadge.singleDigit(digit: '3'),
                SizedBox(height: 20),
                TwakeBadge.multipleDigits(count: '32'),
              ],
            ),
          ),
        ),
        wrapper: materialAppWrapper(
          theme: ThemeData.dark(),
        ),
        surfaceSize: const Size(120, 180),
      );
      await screenMatchesGolden(tester, 'badge_all_variants_dark');
    });
  });
}
