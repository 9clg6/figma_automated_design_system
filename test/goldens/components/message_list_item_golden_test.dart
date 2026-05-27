import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:linagora_design_flutter/message_list/twake_message_list_item.dart';

void main() {
  group('TwakeMessageListItem golden tests', () {
    setUpAll(() async {
      await loadAppFonts();
    });

    Widget _wrap(Widget child) {
      return MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.white,
          body: SizedBox(
            width: 344,
            child: child,
          ),
        ),
      );
    }

    testGoldens('default_unread', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(
          const TwakeMessageListItem(
            name: 'Sophie Marceau',
            textContent:
                'Acting is wonderful therapy for people. Instead of suffering for yourself.',
            time: '10:00',
            unreadCount: 3,
          ),
        ),
        surfaceSize: const Size(344, 72),
      );
      await screenMatchesGolden(tester, 'message_list_item_default_unread');
    });

    testGoldens('default_read', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(
          const TwakeMessageListItem(
            name: 'Sophie Marceau',
            textContent:
                'Acting is wonderful therapy for people. Instead of suffering for yourself.',
            time: '10:00',
            isRead: true,
          ),
        ),
        surfaceSize: const Size(344, 72),
      );
      await screenMatchesGolden(tester, 'message_list_item_default_read');
    });

    testGoldens('hovered', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(
          const TwakeMessageListItem(
            name: 'Sophie Marceau',
            textContent:
                'Acting is wonderful therapy for people.',
            time: '10:00',
            isHovered: true,
            unreadCount: 2,
          ),
        ),
        surfaceSize: const Size(344, 72),
      );
      await screenMatchesGolden(tester, 'message_list_item_hovered');
    });

    testGoldens('selected', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(
          const TwakeMessageListItem(
            name: 'Sophie Marceau',
            textContent: 'Acting is wonderful therapy.',
            time: '10:00',
            state: MessageListItemState.selected,
          ),
        ),
        surfaceSize: const Size(344, 72),
      );
      await screenMatchesGolden(tester, 'message_list_item_selected');
    });

    testGoldens('unselect', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(
          const TwakeMessageListItem(
            name: 'Sophie Marceau',
            textContent: 'Acting is wonderful therapy.',
            time: '10:00',
            state: MessageListItemState.unselect,
          ),
        ),
        surfaceSize: const Size(344, 72),
      );
      await screenMatchesGolden(tester, 'message_list_item_unselect');
    });

    testGoldens('typing', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(
          const TwakeMessageListItem(
            name: 'Sophie Marceau',
            textContent: '',
            time: '10:00',
            state: MessageListItemState.typing,
          ),
        ),
        surfaceSize: const Size(344, 64),
      );
      await screenMatchesGolden(tester, 'message_list_item_typing');
    });

    testGoldens('reaction', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(
          const TwakeMessageListItem(
            name: 'Sophie Marceau',
            textContent: 'Acting is wonderful therapy.',
            time: '10:00',
            state: MessageListItemState.reaction,
          ),
        ),
        surfaceSize: const Size(344, 64),
      );
      await screenMatchesGolden(tester, 'message_list_item_reaction');
    });

    testGoldens('media_photo', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(
          const TwakeMessageListItem(
            name: 'Sophie Marceau',
            textContent: 'Check this photo',
            time: '10:00',
            state: MessageListItemState.mediaPhoto,
          ),
        ),
        surfaceSize: const Size(344, 64),
      );
      await screenMatchesGolden(tester, 'message_list_item_media_photo');
    });

    testGoldens('media_video', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(
          const TwakeMessageListItem(
            name: 'Sophie Marceau',
            textContent: 'Check this video',
            time: '10:00',
            state: MessageListItemState.mediaVideo,
          ),
        ),
        surfaceSize: const Size(344, 64),
      );
      await screenMatchesGolden(tester, 'message_list_item_media_video');
    });

    testGoldens('chat_default', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(
          const TwakeMessageListItem(
            name: 'Sophie Marceau',
            textContent: 'Last one commented',
            time: '10:00',
            isChat: true,
            unreadCount: 5,
          ),
        ),
        surfaceSize: const Size(344, 72),
      );
      await screenMatchesGolden(tester, 'message_list_item_chat_default');
    });

    testGoldens('chat_media_hovered', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(
          const TwakeMessageListItem(
            name: 'Sophie Marceau',
            textContent: 'Last one commented',
            time: '10:00',
            isChat: true,
            hasChatMedia: true,
            isHovered: true,
          ),
        ),
        surfaceSize: const Size(344, 72),
      );
      await screenMatchesGolden(tester, 'message_list_item_chat_media_hovered');
    });

    testGoldens('muted_unread', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(
          const TwakeMessageListItem(
            name: 'Sophie Marceau',
            textContent: 'Acting is wonderful therapy.',
            time: '10:00',
            isMuted: true,
            unreadCount: 7,
          ),
        ),
        surfaceSize: const Size(344, 72),
      );
      await screenMatchesGolden(tester, 'message_list_item_muted_unread');
    });
  });
}
