import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:linagora_design_flutter/component_1/twake_message_context_menu.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  group('TwakeMessageContextMenu golden tests', () {
    // Helper to wrap widget in a testable container
    Widget _wrap(Widget child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          body: Center(child: Padding(padding: const EdgeInsets.all(16), child: child)),
        ),
      );
    }

    // Build a menu with n items (5..9)
    List<TwakeContextMenuItem> _items(int count) {
      final base = twakeDefaultMenuItems();
      final extras = List.generate(
        count - 5,
        (i) => TwakeContextMenuItem(
          label: 'Reply',
          icon: Icons.reply_rounded,
        ),
      );
      // Insert extras before Delete
      return [
        ...base.take(4),
        ...extras,
        base.last,
      ];
    }

    testGoldens('emoji_bar_false_items_5', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(
          TwakeMessageContextMenu(
            showEmojiBar: false,
            items: _items(5),
          ),
        ),
        surfaceSize: const Size(280, 300),
      );
      await screenMatchesGolden(tester, 'twake_message_context_menu_no_emoji_5');
    });

    testGoldens('emoji_bar_true_items_5', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(
          TwakeMessageContextMenu(
            showEmojiBar: true,
            items: _items(5),
          ),
        ),
        surfaceSize: const Size(320, 360),
      );
      await screenMatchesGolden(tester, 'twake_message_context_menu_emoji_5');
    });

    testGoldens('emoji_bar_false_items_7', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(
          TwakeMessageContextMenu(
            showEmojiBar: false,
            items: _items(7),
          ),
        ),
        surfaceSize: const Size(280, 380),
      );
      await screenMatchesGolden(tester, 'twake_message_context_menu_no_emoji_7');
    });

    testGoldens('emoji_bar_true_items_9', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(
          TwakeMessageContextMenu(
            showEmojiBar: true,
            items: _items(9),
          ),
        ),
        surfaceSize: const Size(320, 560),
      );
      await screenMatchesGolden(tester, 'twake_message_context_menu_emoji_9');
    });

    testGoldens('emoji_bar_true_items_9_custom_emojis', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(
          TwakeMessageContextMenu(
            showEmojiBar: true,
            items: _items(9),
            emojis: const ['👍', '😍', '😎', '🤔', '😀'],
          ),
        ),
        surfaceSize: const Size(320, 560),
      );
      await screenMatchesGolden(tester, 'twake_message_context_menu_emoji_9_custom');
    });
  });
}
