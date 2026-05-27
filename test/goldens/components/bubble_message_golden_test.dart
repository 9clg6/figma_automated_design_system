import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/bubble_message/twake_bubble_message.dart';

void main() {
  const String shortMessage = 'Hello there!';
  const String longMessage =
      "I'm curious about the progress of quantum computing. "
      'I heard that Google and IBM have achieved quantum supremacy and are '
      'developing quantum algorithms for various applications.';
  const String time = '9:40';
  const String senderName = 'Patrick Bruel';

  Widget buildTestApp(Widget child) {
    return MaterialApp(
      theme: ThemeData.light(useMaterial3: true),
      home: Scaffold(
        backgroundColor: const Color(0xFFF4F4F4),
        body: Center(child: child),
      ),
    );
  }

  group('TwakeBubbleMessage golden tests', () {
    testWidgets('mobile_dm_short_message', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const TwakeBubbleMessage(
            message: shortMessage,
            time: time,
            device: BubbleDevice.mobile,
            chat: BubbleChat.dm,
            type: BubbleType.shortMessage,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/mobile_dm_short_message.png'),
      );
    });

    testWidgets('mobile_sender_short_message', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const TwakeBubbleMessage(
            message: shortMessage,
            time: time,
            device: BubbleDevice.mobile,
            chat: BubbleChat.sender,
            type: BubbleType.shortMessage,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/mobile_sender_short_message.png'),
      );
    });

    testWidgets('mobile_chat_multiple_lines', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const TwakeBubbleMessage(
            message: longMessage,
            time: time,
            senderName: senderName,
            device: BubbleDevice.mobile,
            chat: BubbleChat.chat,
            type: BubbleType.multipleLines,
            showPin: true,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/mobile_chat_multiple_lines.png'),
      );
    });

    testWidgets('mobile_chat_sender_multiple_lines', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const TwakeBubbleMessage(
            message: longMessage,
            time: time,
            senderName: senderName,
            device: BubbleDevice.mobile,
            chat: BubbleChat.chatSender,
            type: BubbleType.multipleLines,
            showPin: true,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/mobile_chat_sender_multiple_lines.png'),
      );
    });

    testWidgets('mobile_dm_incoming_call', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const TwakeBubbleMessage(
            message: '',
            time: time,
            device: BubbleDevice.mobile,
            chat: BubbleChat.dm,
            type: BubbleType.incomingCall,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/mobile_dm_incoming_call.png'),
      );
    });

    testWidgets('mobile_sender_incoming_video_call', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const TwakeBubbleMessage(
            message: '',
            time: time,
            device: BubbleDevice.mobile,
            chat: BubbleChat.sender,
            type: BubbleType.incomingVideoCall,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/mobile_sender_incoming_video_call.png'),
      );
    });

    testWidgets('mobile_chat_short_message_with_reaction', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          TwakeBubbleMessage(
            message: shortMessage,
            time: time,
            senderName: senderName,
            device: BubbleDevice.mobile,
            chat: BubbleChat.chat,
            type: BubbleType.shortMessage,
            showReaction: true,
            reactionWidget: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: const Text('👍 2', style: TextStyle(fontSize: 12)),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile(
            'goldens/mobile_chat_short_message_with_reaction.png'),
      );
    });

    testWidgets('mobile_sender_selection_mode', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const TwakeBubbleMessage(
            message: shortMessage,
            time: time,
            device: BubbleDevice.mobile,
            chat: BubbleChat.sender,
            type: BubbleType.shortMessage,
            selectionMode: true,
            isSelected: true,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/mobile_sender_selection_mode.png'),
      );
    });

    testWidgets('desktop_dm_short_message', (tester) async {
      tester.view.physicalSize = const Size(1128, 200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        buildTestApp(
          const TwakeBubbleMessage(
            message: shortMessage,
            time: time,
            device: BubbleDevice.desktop,
            chat: BubbleChat.dm,
            type: BubbleType.shortMessage,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/desktop_dm_short_message.png'),
      );
    });

    testWidgets('desktop_sender_short_message', (tester) async {
      tester.view.physicalSize = const Size(1128, 200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        buildTestApp(
          const TwakeBubbleMessage(
            message: shortMessage,
            time: time,
            device: BubbleDevice.desktop,
            chat: BubbleChat.sender,
            type: BubbleType.shortMessage,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/desktop_sender_short_message.png'),
      );
    });
  });
}
