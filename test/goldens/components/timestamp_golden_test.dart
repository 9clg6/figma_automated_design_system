import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:linagora_design_flutter/timestamp/twake_timestamp.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  group('TwakeTimestamp golden tests', () {
    testGoldens('today_default', (tester) async {
      await tester.pumpWidgetBuilder(
        const Center(
          child: TwakeTimestamp(
            type: TimestampType.today,
            onScrolling: false,
          ),
        ),
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
        ),
        surfaceSize: const Size(200, 80),
      );
      await screenMatchesGolden(tester, 'today_default');
    });

    testGoldens('today_on_scrolling', (tester) async {
      await tester.pumpWidgetBuilder(
        const Center(
          child: TwakeTimestamp(
            type: TimestampType.today,
            onScrolling: true,
          ),
        ),
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
        ),
        surfaceSize: const Size(200, 80),
      );
      await screenMatchesGolden(tester, 'today_on_scrolling');
    });

    testGoldens('months_default', (tester) async {
      await tester.pumpWidgetBuilder(
        const Center(
          child: TwakeTimestamp(
            type: TimestampType.months,
            onScrolling: false,
          ),
        ),
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
        ),
        surfaceSize: const Size(200, 80),
      );
      await screenMatchesGolden(tester, 'months_default');
    });

    testGoldens('months_on_scrolling', (tester) async {
      await tester.pumpWidgetBuilder(
        const Center(
          child: TwakeTimestamp(
            type: TimestampType.months,
            onScrolling: true,
          ),
        ),
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
        ),
        surfaceSize: const Size(200, 80),
      );
      await screenMatchesGolden(tester, 'months_on_scrolling');
    });

    testGoldens('year_default', (tester) async {
      await tester.pumpWidgetBuilder(
        const Center(
          child: TwakeTimestamp(
            type: TimestampType.year,
            onScrolling: false,
          ),
        ),
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
        ),
        surfaceSize: const Size(300, 80),
      );
      await screenMatchesGolden(tester, 'year_default');
    });

    testGoldens('year_on_scrolling', (tester) async {
      await tester.pumpWidgetBuilder(
        const Center(
          child: TwakeTimestamp(
            type: TimestampType.year,
            onScrolling: true,
          ),
        ),
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
        ),
        surfaceSize: const Size(300, 80),
      );
      await screenMatchesGolden(tester, 'year_on_scrolling');
    });

    testGoldens('custom_label_default', (tester) async {
      await tester.pumpWidgetBuilder(
        const Center(
          child: TwakeTimestamp(
            type: TimestampType.today,
            onScrolling: false,
            label: 'Yesterday',
          ),
        ),
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
        ),
        surfaceSize: const Size(200, 80),
      );
      await screenMatchesGolden(tester, 'custom_label_default');
    });
  });
}
