import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:linagora_design_flutter/message_counter/twake_message_counter.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  group('TwakeMessageCounter golden tests', () {
    testGoldens('mention_only', (tester) async {
      await tester.pumpWidgetBuilder(
        const Center(
          child: TwakeMessageCounter(
            showMention: true,
          ),
        ),
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
        ),
        surfaceSize: const Size(80, 48),
      );
      await screenMatchesGolden(tester, 'message_counter_mention_only');
    });

    testGoldens('single_digit', (tester) async {
      await tester.pumpWidgetBuilder(
        const Center(
          child: TwakeMessageCounter(
            singleDigitCount: 9,
          ),
        ),
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
        ),
        surfaceSize: const Size(80, 48),
      );
      await screenMatchesGolden(tester, 'message_counter_single_digit');
    });

    testGoldens('multiple_digits', (tester) async {
      await tester.pumpWidgetBuilder(
        const Center(
          child: TwakeMessageCounter(
            multipleDigitsCount: 99,
          ),
        ),
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
        ),
        surfaceSize: const Size(80, 48),
      );
      await screenMatchesGolden(tester, 'message_counter_multiple_digits');
    });

    testGoldens('mention_single_multiple', (tester) async {
      await tester.pumpWidgetBuilder(
        const Center(
          child: TwakeMessageCounter(
            showMention: true,
            singleDigitCount: 9,
            multipleDigitsCount: 9,
          ),
        ),
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
        ),
        surfaceSize: const Size(120, 48),
      );
      await screenMatchesGolden(tester, 'message_counter_mention_single_multiple');
    });

    testGoldens('over_99_count', (tester) async {
      await tester.pumpWidgetBuilder(
        const Center(
          child: TwakeMessageCounter(
            multipleDigitsCount: 120,
          ),
        ),
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
        ),
        surfaceSize: const Size(100, 48),
      );
      await screenMatchesGolden(tester, 'message_counter_over_99');
    });
  });
}
