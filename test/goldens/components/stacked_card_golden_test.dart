import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:linagora_design_flutter/stacked_card/twake_stacked_card.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  group('TwakeStackedCard golden tests', () {
    Widget _buildCard(TwakeStackedCardStyle style, Brightness brightness) {
      return MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2196F3),
            brightness: brightness,
          ),
          useMaterial3: true,
        ),
        home: Scaffold(
          backgroundColor: brightness == Brightness.dark
              ? const Color(0xFF1C1B1F)
              : const Color(0xFFF4F4F4),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: TwakeStackedCard(
                style: style,
                headerTitle: 'Header',
                headerSubhead: 'Subhead',
                title: 'Title',
                subhead: 'Subhead',
                supportingText:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor',
                primaryActionLabel: 'Enabled',
                secondaryActionLabel: 'Enabled',
              ),
            ),
          ),
        ),
      );
    }

    testGoldens('outlined_light', (tester) async {
      await tester.pumpWidgetBuilder(
        _buildCard(TwakeStackedCardStyle.outlined, Brightness.light),
        surfaceSize: const Size(420, 540),
      );
      await screenMatchesGolden(tester, 'stacked_card_outlined_light');
    });

    testGoldens('elevated_light', (tester) async {
      await tester.pumpWidgetBuilder(
        _buildCard(TwakeStackedCardStyle.elevated, Brightness.light),
        surfaceSize: const Size(420, 540),
      );
      await screenMatchesGolden(tester, 'stacked_card_elevated_light');
    });

    testGoldens('filled_light', (tester) async {
      await tester.pumpWidgetBuilder(
        _buildCard(TwakeStackedCardStyle.filled, Brightness.light),
        surfaceSize: const Size(420, 540),
      );
      await screenMatchesGolden(tester, 'stacked_card_filled_light');
    });

    testGoldens('outlined_dark', (tester) async {
      await tester.pumpWidgetBuilder(
        _buildCard(TwakeStackedCardStyle.outlined, Brightness.dark),
        surfaceSize: const Size(420, 540),
      );
      await screenMatchesGolden(tester, 'stacked_card_outlined_dark');
    });

    testGoldens('elevated_dark', (tester) async {
      await tester.pumpWidgetBuilder(
        _buildCard(TwakeStackedCardStyle.elevated, Brightness.dark),
        surfaceSize: const Size(420, 540),
      );
      await screenMatchesGolden(tester, 'stacked_card_elevated_dark');
    });

    testGoldens('filled_dark', (tester) async {
      await tester.pumpWidgetBuilder(
        _buildCard(TwakeStackedCardStyle.filled, Brightness.dark),
        surfaceSize: const Size(420, 540),
      );
      await screenMatchesGolden(tester, 'stacked_card_filled_dark');
    });
  });
}
