import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/menu_with_text_field_example_1/twake_menu_with_text_field.dart';

void main() {
  group('TwakeMenuWithTextField golden tests', () {
    testWidgets('light with text field', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            backgroundColor: Color(0xFFF0F0F0),
            body: Center(
              child: TwakeMenuWithTextField(
                label: 'Label',
                showTextField: true,
                textFieldHint: 'Input',
                items: ['List item', 'List item', 'List item', 'List item'],
                isDark: false,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(TwakeMenuWithTextField),
        matchesGoldenFile('goldens/components/twake_menu_light_with_text_field.png'),
      );
    });

    testWidgets('light without text field', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            backgroundColor: Color(0xFFF0F0F0),
            body: Center(
              child: TwakeMenuWithTextField(
                showTextField: false,
                items: [
                  'List item',
                  'List item',
                  'List item',
                  'List item',
                  'List item',
                  'List item',
                  'List item',
                  'List item',
                  'List item',
                  'List item',
                  'List item',
                  'List item',
                ],
                isDark: false,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(TwakeMenuWithTextField),
        matchesGoldenFile('goldens/components/twake_menu_light_no_text_field.png'),
      );
    });

    testWidgets('dark with text field', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            backgroundColor: Color(0xFF1C1B1F),
            body: Center(
              child: TwakeMenuWithTextField(
                label: 'Label',
                showTextField: true,
                textFieldHint: 'Input',
                items: ['List item', 'List item', 'List item', 'List item'],
                isDark: true,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(TwakeMenuWithTextField),
        matchesGoldenFile('goldens/components/twake_menu_dark_with_text_field.png'),
      );
    });

    testWidgets('dark without text field', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            backgroundColor: Color(0xFF1C1B1F),
            body: Center(
              child: TwakeMenuWithTextField(
                showTextField: false,
                items: [
                  'List item',
                  'List item',
                  'List item',
                  'List item',
                  'List item',
                  'List item',
                  'List item',
                  'List item',
                ],
                isDark: true,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(TwakeMenuWithTextField),
        matchesGoldenFile('goldens/components/twake_menu_dark_no_text_field.png'),
      );
    });
  });
}
