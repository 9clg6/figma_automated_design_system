import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:linagora_design_flutter/threads_bubble/twake_threads_bubble.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  group('TwakeThreadsBubble Golden Tests', () {
    testGoldens('light_desktop_dm_react', (tester) async {
      await tester.pumpWidgetBuilder(
        const Center(
          child: TwakeThreadsBubble(
            bubbleTheme: ThreadsBubbleTheme.light,
            isMobile: false,
            state: ThreadsBubbleState.dmWithReact,
            showInputCommentSection: true,
            showInteractionWithThread: true,
          ),
        ),
        surfaceSize: const Size(360, 420),
      );
      await screenMatchesGolden(tester, 'light_desktop_dm_react');
    });

    testGoldens('light_desktop_dm_no_react', (tester) async {
      await tester.pumpWidgetBuilder(
        const Center(
          child: TwakeThreadsBubble(
            bubbleTheme: ThreadsBubbleTheme.light,
            isMobile: false,
            state: ThreadsBubbleState.dmNoReact,
            showInputCommentSection: true,
            showInteractionWithThread: true,
          ),
        ),
        surfaceSize: const Size(360, 240),
      );
      await screenMatchesGolden(tester, 'light_desktop_dm_no_react');
    });

    testGoldens('light_desktop_sender_react', (tester) async {
      await tester.pumpWidgetBuilder(
        const Center(
          child: TwakeThreadsBubble(
            bubbleTheme: ThreadsBubbleTheme.light,
            isMobile: false,
            state: ThreadsBubbleState.senderWithReact,
            showInputCommentSection: true,
            showInteractionWithThread: true,
          ),
        ),
        surfaceSize: const Size(360, 420),
      );
      await screenMatchesGolden(tester, 'light_desktop_sender_react');
    });

    testGoldens('light_desktop_sender_no_react', (tester) async {
      await tester.pumpWidgetBuilder(
        const Center(
          child: TwakeThreadsBubble(
            bubbleTheme: ThreadsBubbleTheme.light,
            isMobile: false,
            state: ThreadsBubbleState.senderNoReact,
            showInputCommentSection: true,
            showInteractionWithThread: true,
          ),
        ),
        surfaceSize: const Size(360, 240),
      );
      await screenMatchesGolden(tester, 'light_desktop_sender_no_react');
    });

    testGoldens('dark_desktop_dm_react', (tester) async {
      await tester.pumpWidgetBuilder(
        const Center(
          child: TwakeThreadsBubble(
            bubbleTheme: ThreadsBubbleTheme.dark,
            isMobile: false,
            state: ThreadsBubbleState.dmWithReact,
            showInputCommentSection: true,
            showInteractionWithThread: true,
          ),
        ),
        surfaceSize: const Size(360, 420),
        wrapper: materialAppWrapper(
          theme: ThemeData.dark(),
        ),
      );
      await screenMatchesGolden(tester, 'dark_desktop_dm_react');
    });

    testGoldens('light_mobile_dm_react', (tester) async {
      await tester.pumpWidgetBuilder(
        const Center(
          child: TwakeThreadsBubble(
            bubbleTheme: ThreadsBubbleTheme.light,
            isMobile: true,
            state: ThreadsBubbleState.dmWithReact,
            showInputCommentSection: true,
            showInteractionWithThread: true,
          ),
        ),
        surfaceSize: const Size(360, 380),
      );
      await screenMatchesGolden(tester, 'light_mobile_dm_react');
    });

    testGoldens('light_mobile_dm_no_react', (tester) async {
      await tester.pumpWidgetBuilder(
        const Center(
          child: TwakeThreadsBubble(
            bubbleTheme: ThreadsBubbleTheme.light,
            isMobile: true,
            state: ThreadsBubbleState.dmNoReact,
            showInputCommentSection: true,
            showInteractionWithThread: true,
          ),
        ),
        surfaceSize: const Size(360, 240),
      );
      await screenMatchesGolden(tester, 'light_mobile_dm_no_react');
    });

    testGoldens('dark_mobile_dm_react', (tester) async {
      await tester.pumpWidgetBuilder(
        const Center(
          child: TwakeThreadsBubble(
            bubbleTheme: ThreadsBubbleTheme.dark,
            isMobile: true,
            state: ThreadsBubbleState.dmWithReact,
            showInputCommentSection: true,
            showInteractionWithThread: true,
          ),
        ),
        surfaceSize: const Size(360, 400),
        wrapper: materialAppWrapper(
          theme: ThemeData.dark(),
        ),
      );
      await screenMatchesGolden(tester, 'dark_mobile_dm_react');
    });

    testGoldens('dark_mobile_dm_no_react', (tester) async {
      await tester.pumpWidgetBuilder(
        const Center(
          child: TwakeThreadsBubble(
            bubbleTheme: ThreadsBubbleTheme.dark,
            isMobile: true,
            state: ThreadsBubbleState.dmNoReact,
            showInputCommentSection: true,
            showInteractionWithThread: true,
          ),
        ),
        surfaceSize: const Size(360, 240),
        wrapper: materialAppWrapper(
          theme: ThemeData.dark(),
        ),
      );
      await screenMatchesGolden(tester, 'dark_mobile_dm_no_react');
    });
  });
}
