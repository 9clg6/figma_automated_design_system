import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:linagora_design_flutter/typing_bar/twake_typing_bar.dart';

void main() {
  group('TwakeTypingBar golden tests', () {
    setUpAll(() async {
      await loadAppFonts();
    });

    Widget _wrap(Widget child) {
      return MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A73E8)),
          useMaterial3: true,
        ),
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(width: 360, child: child),
          ),
        ),
      );
    }

    testGoldens('default_no_send_button', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(
          const TwakeTypingBar(
            type: TypingBarType.defaultType,
            showSendButton: false,
            hintText: 'New message',
          ),
        ),
        surfaceSize: const Size(360, 80),
      );
      await screenMatchesGolden(tester, 'typing_bar_default_no_send');
    });

    testGoldens('default_with_send_button', (tester) async {
      final controller = TextEditingController(text: 'Hello world');
      await tester.pumpWidgetBuilder(
        _wrap(
          TwakeTypingBar(
            type: TypingBarType.defaultType,
            showSendButton: true,
            hintText: 'New message',
            controller: controller,
          ),
        ),
        surfaceSize: const Size(360, 80),
      );
      await screenMatchesGolden(tester, 'typing_bar_default_with_send');
    });

    testGoldens('typing_state', (tester) async {
      final controller = TextEditingController(text: 'New message');
      await tester.pumpWidgetBuilder(
        _wrap(
          TwakeTypingBar(
            type: TypingBarType.typing,
            showSendButton: true,
            hintText: 'New message',
            controller: controller,
          ),
        ),
        surfaceSize: const Size(360, 80),
      );
      await screenMatchesGolden(tester, 'typing_bar_typing_state');
    });

    testGoldens('reply_preview', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(
          const TwakeTypingBar(
            type: TypingBarType.reply,
            showSendButton: true,
            hintText: 'New message',
            replyData: TypingBarReplyData(
              authorName: 'Reply to Jaylen Catom',
              previewText: 'Lorem ipsum dolor sit amet consectetur...',
            ),
          ),
        ),
        surfaceSize: const Size(360, 150),
      );
      await screenMatchesGolden(tester, 'typing_bar_reply_preview');
    });

    testGoldens('link_preview_no_thumbnail', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(
          const TwakeTypingBar(
            type: TypingBarType.link,
            showSendButton: false,
            hintText: 'New message',
            linkData: TypingBarLinkData(
              title: "There is a 'gravity hole' in the Ind...",
              description:
                  'CNN — There is a "gravity hole" in the Indian Ocean - a spot where Earth...',
              url: 'www.cnn.com',
            ),
          ),
        ),
        surfaceSize: const Size(360, 230),
      );
      await screenMatchesGolden(tester, 'typing_bar_link_preview_no_thumbnail');
    });

    testGoldens('link_preview_with_send', (tester) async {
      final controller = TextEditingController(
        text: 'https://edition.cnn.com/travel/article/beond-airline-maldives/index.html',
      );
      await tester.pumpWidgetBuilder(
        _wrap(
          TwakeTypingBar(
            type: TypingBarType.link,
            showSendButton: true,
            hintText: 'New message',
            controller: controller,
            linkData: const TypingBarLinkData(
              title: "There is a 'gravity hole' in the Ind...",
              description:
                  'CNN — There is a "gravity hole" in the Indian Ocean - a spot where Earth...',
              url: 'www.cnn.com',
            ),
          ),
        ),
        surfaceSize: const Size(360, 250),
      );
      await screenMatchesGolden(tester, 'typing_bar_link_preview_with_send');
    });
  });
}
