import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:linagora_design_flutter/bar_logo_web/twake_bar_logo_web.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  group('TwakeBarLogoWeb golden tests', () {
    testGoldens('default — help icon visible, grid hidden', (tester) async {
      await tester.pumpWidgetBuilder(
        const TwakeBarLogoWeb(
          showIconHelp: true,
          showApplicationGrid: false,
        ),
        surfaceSize: const Size(565, 60),
      );
      await screenMatchesGolden(
        tester,
        'twake_bar_logo_web_default',
      );
    });

    testGoldens('both icons visible', (tester) async {
      await tester.pumpWidgetBuilder(
        const TwakeBarLogoWeb(
          showIconHelp: true,
          showApplicationGrid: true,
        ),
        surfaceSize: const Size(565, 60),
      );
      await screenMatchesGolden(
        tester,
        'twake_bar_logo_web_both_icons',
      );
    });

    testGoldens('no icons', (tester) async {
      await tester.pumpWidgetBuilder(
        const TwakeBarLogoWeb(
          showIconHelp: false,
          showApplicationGrid: false,
        ),
        surfaceSize: const Size(565, 60),
      );
      await screenMatchesGolden(
        tester,
        'twake_bar_logo_web_no_icons',
      );
    });

    testGoldens('only grid icon', (tester) async {
      await tester.pumpWidgetBuilder(
        const TwakeBarLogoWeb(
          showIconHelp: false,
          showApplicationGrid: true,
        ),
        surfaceSize: const Size(565, 60),
      );
      await screenMatchesGolden(
        tester,
        'twake_bar_logo_web_grid_only',
      );
    });
  });
}
