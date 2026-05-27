import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/icon_button_web/twake_icon_button_web.dart';

void main() {
  group('TwakeIconButtonWeb Golden Tests', () {
    Widget buildTestWidget(Widget child) {
      return MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: child),
        ),
      );
    }

    testWidgets('light_standard_enabled', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const TwakeIconButtonWeb(
            icon: Icons.settings,
            configuration: TwakeIconButtonConfiguration.standard,
            buttonTheme: TwakeIconButtonTheme.light,
            enabled: true,
          ),
        ),
      );
      await expectLater(
        find.byType(TwakeIconButtonWeb),
        matchesGoldenFile('goldens/components/icon_button_web_light_standard_enabled.png'),
      );
    });

    testWidgets('light_filled_enabled', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const TwakeIconButtonWeb(
            icon: Icons.settings,
            configuration: TwakeIconButtonConfiguration.filled,
            buttonTheme: TwakeIconButtonTheme.light,
            enabled: true,
          ),
        ),
      );
      await expectLater(
        find.byType(TwakeIconButtonWeb),
        matchesGoldenFile('goldens/components/icon_button_web_light_filled_enabled.png'),
      );
    });

    testWidgets('light_outlined_enabled', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const TwakeIconButtonWeb(
            icon: Icons.settings,
            configuration: TwakeIconButtonConfiguration.outlined,
            buttonTheme: TwakeIconButtonTheme.light,
            enabled: true,
          ),
        ),
      );
      await expectLater(
        find.byType(TwakeIconButtonWeb),
        matchesGoldenFile('goldens/components/icon_button_web_light_outlined_enabled.png'),
      );
    });

    testWidgets('light_tonal_enabled', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const TwakeIconButtonWeb(
            icon: Icons.settings,
            configuration: TwakeIconButtonConfiguration.tonal,
            buttonTheme: TwakeIconButtonTheme.light,
            enabled: true,
          ),
        ),
      );
      await expectLater(
        find.byType(TwakeIconButtonWeb),
        matchesGoldenFile('goldens/components/icon_button_web_light_tonal_enabled.png'),
      );
    });

    testWidgets('dark_standard_enabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            backgroundColor: const Color(0xFF1C1B1F),
            body: Center(
              child: const TwakeIconButtonWeb(
                icon: Icons.settings,
                configuration: TwakeIconButtonConfiguration.standard,
                buttonTheme: TwakeIconButtonTheme.dark,
                enabled: true,
              ),
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(TwakeIconButtonWeb),
        matchesGoldenFile('goldens/components/icon_button_web_dark_standard_enabled.png'),
      );
    });

    testWidgets('dark_filled_enabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            backgroundColor: const Color(0xFF1C1B1F),
            body: Center(
              child: const TwakeIconButtonWeb(
                icon: Icons.settings,
                configuration: TwakeIconButtonConfiguration.filled,
                buttonTheme: TwakeIconButtonTheme.dark,
                enabled: true,
              ),
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(TwakeIconButtonWeb),
        matchesGoldenFile('goldens/components/icon_button_web_dark_filled_enabled.png'),
      );
    });

    testWidgets('light_standard_disabled', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const TwakeIconButtonWeb(
            icon: Icons.settings,
            configuration: TwakeIconButtonConfiguration.standard,
            buttonTheme: TwakeIconButtonTheme.light,
            enabled: false,
          ),
        ),
      );
      await expectLater(
        find.byType(TwakeIconButtonWeb),
        matchesGoldenFile('goldens/components/icon_button_web_light_standard_disabled.png'),
      );
    });

    testWidgets('light_filled_disabled', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const TwakeIconButtonWeb(
            icon: Icons.settings,
            configuration: TwakeIconButtonConfiguration.filled,
            buttonTheme: TwakeIconButtonTheme.light,
            enabled: false,
          ),
        ),
      );
      await expectLater(
        find.byType(TwakeIconButtonWeb),
        matchesGoldenFile('goldens/components/icon_button_web_light_filled_disabled.png'),
      );
    });

    testWidgets('all_variants_grid', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TwakeIconButtonWeb(
                        icon: Icons.settings,
                        configuration: TwakeIconButtonConfiguration.standard,
                        buttonTheme: TwakeIconButtonTheme.light,
                        enabled: true,
                      ),
                      const SizedBox(width: 8),
                      TwakeIconButtonWeb(
                        icon: Icons.settings,
                        configuration: TwakeIconButtonConfiguration.filled,
                        buttonTheme: TwakeIconButtonTheme.light,
                        enabled: true,
                      ),
                      const SizedBox(width: 8),
                      TwakeIconButtonWeb(
                        icon: Icons.settings,
                        configuration: TwakeIconButtonConfiguration.outlined,
                        buttonTheme: TwakeIconButtonTheme.light,
                        enabled: true,
                      ),
                      const SizedBox(width: 8),
                      TwakeIconButtonWeb(
                        icon: Icons.settings,
                        configuration: TwakeIconButtonConfiguration.tonal,
                        buttonTheme: TwakeIconButtonTheme.light,
                        enabled: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TwakeIconButtonWeb(
                        icon: Icons.settings,
                        configuration: TwakeIconButtonConfiguration.standard,
                        buttonTheme: TwakeIconButtonTheme.light,
                        enabled: false,
                      ),
                      const SizedBox(width: 8),
                      TwakeIconButtonWeb(
                        icon: Icons.settings,
                        configuration: TwakeIconButtonConfiguration.filled,
                        buttonTheme: TwakeIconButtonTheme.light,
                        enabled: false,
                      ),
                      const SizedBox(width: 8),
                      TwakeIconButtonWeb(
                        icon: Icons.settings,
                        configuration: TwakeIconButtonConfiguration.outlined,
                        buttonTheme: TwakeIconButtonTheme.light,
                        enabled: false,
                      ),
                      const SizedBox(width: 8),
                      TwakeIconButtonWeb(
                        icon: Icons.settings,
                        configuration: TwakeIconButtonConfiguration.tonal,
                        buttonTheme: TwakeIconButtonTheme.light,
                        enabled: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/components/icon_button_web_all_variants_grid.png'),
      );
    });
  });
}
