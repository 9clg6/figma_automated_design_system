import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/text_fields/twake_text_field.dart';

void main() {
  group('TwakeTextField golden tests', () {
    // Helper to pump a widget in a constrained environment
    Future<void> pumpTextField(
      WidgetTester tester,
      Widget child,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: const Color(0xFFF0F4FF),
            body: Center(
              child: SizedBox(
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('light_outline_enable', (tester) async {
      await pumpTextField(
        tester,
        const TwakeTextField(
          label: 'Label',
          supportingText: 'Supporting text',
          theme: TwakeTextFieldTheme.light,
          configuration: TwakeTextFieldConfiguration.outline,
          state: TwakeTextFieldState.enable,
        ),
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/components/twake_text_field_light_outline_enable.png'),
      );
    });

    testWidgets('light_outline_focused', (tester) async {
      await pumpTextField(
        tester,
        const TwakeTextField(
          label: 'Label',
          supportingText: 'Supporting text',
          theme: TwakeTextFieldTheme.light,
          configuration: TwakeTextFieldConfiguration.outline,
          state: TwakeTextFieldState.focused,
        ),
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/components/twake_text_field_light_outline_focused.png'),
      );
    });

    testWidgets('light_outline_error', (tester) async {
      await pumpTextField(
        tester,
        const TwakeTextField(
          label: 'Label',
          supportingText: 'Supporting text',
          theme: TwakeTextFieldTheme.light,
          configuration: TwakeTextFieldConfiguration.outline,
          state: TwakeTextFieldState.error,
        ),
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/components/twake_text_field_light_outline_error.png'),
      );
    });

    testWidgets('light_outline_disabled', (tester) async {
      await pumpTextField(
        tester,
        const TwakeTextField(
          label: 'Label',
          supportingText: 'Supporting text',
          theme: TwakeTextFieldTheme.light,
          configuration: TwakeTextFieldConfiguration.outline,
          state: TwakeTextFieldState.disabled,
        ),
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/components/twake_text_field_light_outline_disabled.png'),
      );
    });

    testWidgets('dark_outline_enable', (tester) async {
      await pumpTextField(
        tester,
        const TwakeTextField(
          label: 'Label',
          supportingText: 'Supporting text',
          theme: TwakeTextFieldTheme.dark,
          configuration: TwakeTextFieldConfiguration.outline,
          state: TwakeTextFieldState.enable,
        ),
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/components/twake_text_field_dark_outline_enable.png'),
      );
    });

    testWidgets('dark_outline_error', (tester) async {
      await pumpTextField(
        tester,
        const TwakeTextField(
          label: 'Label',
          supportingText: 'Supporting text',
          theme: TwakeTextFieldTheme.dark,
          configuration: TwakeTextFieldConfiguration.outline,
          state: TwakeTextFieldState.error,
        ),
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/components/twake_text_field_dark_outline_error.png'),
      );
    });

    testWidgets('light_filled_enable', (tester) async {
      await pumpTextField(
        tester,
        const TwakeTextField(
          label: 'Label',
          supportingText: 'Supporting text',
          theme: TwakeTextFieldTheme.light,
          configuration: TwakeTextFieldConfiguration.filled,
          state: TwakeTextFieldState.enable,
        ),
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/components/twake_text_field_light_filled_enable.png'),
      );
    });

    testWidgets('dark_filled_enable', (tester) async {
      await pumpTextField(
        tester,
        const TwakeTextField(
          label: 'Label',
          supportingText: 'Supporting text',
          theme: TwakeTextFieldTheme.dark,
          configuration: TwakeTextFieldConfiguration.filled,
          state: TwakeTextFieldState.enable,
        ),
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/components/twake_text_field_dark_filled_enable.png'),
      );
    });

    testWidgets('light_filled_focused', (tester) async {
      await pumpTextField(
        tester,
        const TwakeTextField(
          label: 'Label',
          supportingText: 'Supporting text',
          theme: TwakeTextFieldTheme.light,
          configuration: TwakeTextFieldConfiguration.filled,
          state: TwakeTextFieldState.focused,
        ),
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/components/twake_text_field_light_filled_focused.png'),
      );
    });

    testWidgets('dark_filled_disabled', (tester) async {
      await pumpTextField(
        tester,
        const TwakeTextField(
          label: 'Label',
          supportingText: 'Supporting text',
          theme: TwakeTextFieldTheme.dark,
          configuration: TwakeTextFieldConfiguration.filled,
          state: TwakeTextFieldState.disabled,
        ),
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/components/twake_text_field_dark_filled_disabled.png'),
      );
    });

    testWidgets('no_supporting_no_trailing', (tester) async {
      await pumpTextField(
        tester,
        const TwakeTextField(
          label: 'Label',
          supportingText: 'Supporting text',
          showSupportingText: false,
          showTrailingIcon: false,
          theme: TwakeTextFieldTheme.light,
          configuration: TwakeTextFieldConfiguration.outline,
          state: TwakeTextFieldState.enable,
        ),
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/components/twake_text_field_no_supporting_no_trailing.png'),
      );
    });
  });
}
