import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:linagora_design_flutter/search_tabs/twake_search_tab.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  group('TwakeSearchTab golden tests', () {
    Widget buildScenario(Widget child) {
      return MaterialApp(
        theme: ThemeData.light(useMaterial3: true),
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: child),
        ),
      );
    }

    Widget buildDarkScenario(Widget child) {
      return MaterialApp(
        theme: ThemeData.dark(useMaterial3: true),
        home: Scaffold(
          backgroundColor: const Color(0xFF1C1B1F),
          body: Center(child: child),
        ),
      );
    }

    testGoldens('twake_search_tab_inactive_default', (tester) async {
      await tester.pumpWidgetBuilder(
        buildScenario(
          const TwakeSearchTab(
            label: 'Tab',
            active: false,
          ),
        ),
        surfaceSize: const Size(120, 60),
      );
      await screenMatchesGolden(tester, 'twake_search_tab_inactive_default');
    });

    testGoldens('twake_search_tab_active_default', (tester) async {
      await tester.pumpWidgetBuilder(
        buildScenario(
          const TwakeSearchTab(
            label: 'Tab',
            active: true,
          ),
        ),
        surfaceSize: const Size(120, 60),
      );
      await screenMatchesGolden(tester, 'twake_search_tab_active_default');
    });

    testGoldens('twake_search_tab_active_leading_icon', (tester) async {
      await tester.pumpWidgetBuilder(
        buildScenario(
          const TwakeSearchTab(
            label: 'Tab',
            active: true,
            leadingIcon: true,
          ),
        ),
        surfaceSize: const Size(140, 60),
      );
      await screenMatchesGolden(tester, 'twake_search_tab_active_leading_icon');
    });

    testGoldens('twake_search_tab_inactive_leading_icon', (tester) async {
      await tester.pumpWidgetBuilder(
        buildScenario(
          const TwakeSearchTab(
            label: 'Tab',
            active: false,
            leadingIcon: true,
          ),
        ),
        surfaceSize: const Size(140, 60),
      );
      await screenMatchesGolden(tester, 'twake_search_tab_inactive_leading_icon');
    });

    testGoldens('twake_search_tab_active_single_badge', (tester) async {
      await tester.pumpWidgetBuilder(
        buildScenario(
          const TwakeSearchTab(
            label: 'Tab',
            active: true,
            singleBadge: true,
          ),
        ),
        surfaceSize: const Size(140, 60),
      );
      await screenMatchesGolden(tester, 'twake_search_tab_active_single_badge');
    });

    testGoldens('twake_search_tab_active_multi_badge', (tester) async {
      await tester.pumpWidgetBuilder(
        buildScenario(
          const TwakeSearchTab(
            label: 'Tab',
            active: true,
            badgesMultipleDigit: true,
            badgeCount: 12,
          ),
        ),
        surfaceSize: const Size(160, 60),
      );
      await screenMatchesGolden(tester, 'twake_search_tab_active_multi_badge');
    });

    testGoldens('twake_search_tab_no_divider', (tester) async {
      await tester.pumpWidgetBuilder(
        buildScenario(
          const TwakeSearchTab(
            label: 'Tab',
            active: false,
            divider: false,
          ),
        ),
        surfaceSize: const Size(120, 60),
      );
      await screenMatchesGolden(tester, 'twake_search_tab_no_divider');
    });

    testGoldens('twake_search_tab_all_variants_row', (tester) async {
      await tester.pumpWidgetBuilder(
        buildScenario(
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TwakeSearchTab(label: 'Tab', active: false),
              TwakeSearchTab(label: 'Tab', active: true),
              TwakeSearchTab(label: 'Tab', active: false, leadingIcon: true),
              TwakeSearchTab(label: 'Tab', active: true, leadingIcon: true),
              TwakeSearchTab(label: 'Tab', active: true, singleBadge: true),
              TwakeSearchTab(
                label: 'Tab',
                active: true,
                badgesMultipleDigit: true,
                badgeCount: 9,
              ),
            ],
          ),
        ),
        surfaceSize: const Size(700, 70),
      );
      await screenMatchesGolden(tester, 'twake_search_tab_all_variants_row');
    });

    testGoldens('twake_search_tab_dark_active', (tester) async {
      await tester.pumpWidgetBuilder(
        buildDarkScenario(
          const TwakeSearchTab(
            label: 'Tab',
            active: true,
            leadingIcon: true,
          ),
        ),
        surfaceSize: const Size(140, 60),
      );
      await screenMatchesGolden(tester, 'twake_search_tab_dark_active');
    });

    testGoldens('twake_search_tab_dark_inactive', (tester) async {
      await tester.pumpWidgetBuilder(
        buildDarkScenario(
          const TwakeSearchTab(
            label: 'Tab',
            active: false,
            leadingIcon: true,
          ),
        ),
        surfaceSize: const Size(140, 60),
      );
      await screenMatchesGolden(tester, 'twake_search_tab_dark_inactive');
    });
  });
}
