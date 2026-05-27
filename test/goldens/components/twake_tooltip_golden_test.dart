import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:linagora_design_flutter/container/twake_tooltip.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  group('TwakeTooltip golden tests', () {
    testGoldens('plain_tooltip', (tester) async {
      await tester.pumpWidgetBuilder(
        const Scaffold(
          backgroundColor: Color(0xFFFFFFFF),
          body: Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: TwakeTooltip(
                type: TwakeTooltipType.plain,
                supportingText:
                    "Rich tooltip bring attention to a particular element of feature that warrants the user's focus",
              ),
            ),
          ),
        ),
        surfaceSize: const Size(400, 120),
      );
      await screenMatchesGolden(tester, 'plain_tooltip');
    });

    testGoldens('rich_tooltip_with_buttons', (tester) async {
      await tester.pumpWidgetBuilder(
        Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: TwakeTooltip(
                type: TwakeTooltipType.rich,
                subhead: 'Rich tooltip',
                supportingText:
                    "Rich tooltip bring attention to a particular element of feature that warrants the user's focus",
                button1Label: 'Enabled',
                button2Label: 'Enabled',
              ),
            ),
          ),
        ),
        surfaceSize: const Size(420, 220),
      );
      await screenMatchesGolden(tester, 'rich_tooltip_with_buttons');
    });

    testGoldens('rich_tooltip_no_buttons', (tester) async {
      await tester.pumpWidgetBuilder(
        const Scaffold(
          backgroundColor: Color(0xFFF5F5F5),
          body: Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: TwakeTooltip(
                type: TwakeTooltipType.rich,
                subhead: 'Rich tooltip',
                supportingText:
                    "Rich tooltip bring attention to a particular element of feature that warrants the user's focus",
                button1Label: null,
                button2Label: null,
              ),
            ),
          ),
        ),
        surfaceSize: const Size(420, 180),
      );
      await screenMatchesGolden(tester, 'rich_tooltip_no_buttons');
    });

    testGoldens('rich_tooltip_with_icons', (tester) async {
      await tester.pumpWidgetBuilder(
        Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: TwakeTooltip(
                type: TwakeTooltipType.rich,
                subhead: 'Rich tooltip',
                supportingText:
                    "Rich tooltip bring attention to a particular element of feature that warrants the user's focus",
                button1Label: 'Enabled',
                button2Label: 'Enabled',
                showIconLeft: true,
                showIconRight: true,
              ),
            ),
          ),
        ),
        surfaceSize: const Size(420, 220),
      );
      await screenMatchesGolden(tester, 'rich_tooltip_with_icons');
    });
  });
}
