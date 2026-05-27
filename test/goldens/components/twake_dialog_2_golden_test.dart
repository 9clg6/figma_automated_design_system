import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/dialog_2/twake_dialog_2.dart';

void main() {
  group('TwakeDialog2 Golden Tests', () {
    testWidgets('both buttons visible', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: TwakeDialog2(
                title: 'Title',
                subText: 'Sub text',
                showButtonClose: true,
                showButtonRight: true,
                closeLabel: 'Close',
                rightLabel: 'Label',
              ),
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(TwakeDialog2),
        matchesGoldenFile('goldens/components/twake_dialog2_both_buttons.png'),
      );
    });

    testWidgets('only close button visible', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: TwakeDialog2(
                title: 'Title',
                subText: 'Sub text',
                showButtonClose: true,
                showButtonRight: false,
                closeLabel: 'Close',
              ),
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(TwakeDialog2),
        matchesGoldenFile('goldens/components/twake_dialog2_only_close.png'),
      );
    });

    testWidgets('only right button visible', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: TwakeDialog2(
                title: 'Title',
                subText: 'Sub text',
                showButtonClose: false,
                showButtonRight: true,
                rightLabel: 'Label',
              ),
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(TwakeDialog2),
        matchesGoldenFile('goldens/components/twake_dialog2_only_right.png'),
      );
    });

    testWidgets('no buttons visible', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: TwakeDialog2(
                title: 'Title',
                subText: 'Sub text',
                showButtonClose: false,
                showButtonRight: false,
              ),
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(TwakeDialog2),
        matchesGoldenFile('goldens/components/twake_dialog2_no_buttons.png'),
      );
    });

    testWidgets('long content', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: TwakeDialog2(
                title: 'Connect Telegram to continue chatting',
                subText:
                    'This is Telegram user. To chat with them, connect your Telegram account to Twake Chat.',
                showButtonClose: false,
                showButtonRight: true,
                rightLabel: 'Connect',
              ),
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(TwakeDialog2),
        matchesGoldenFile('goldens/components/twake_dialog2_long_content.png'),
      );
    });
  });
}
