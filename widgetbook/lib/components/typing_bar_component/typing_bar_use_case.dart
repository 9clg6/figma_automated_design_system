import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/typing_bar/twake_typing_bar.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeTypingBar)
Widget typingBarDefaultUseCase(BuildContext context) {
  return Center(
    child: TwakeTypingBar(
      onSend: () {},
      onChanged: (_) {},
    ),
  );
}

@widgetbook.UseCase(name: 'Reply mode', type: TwakeTypingBar)
Widget typingBarReplyUseCase(BuildContext context) {
  return Center(
    child: TwakeTypingBar(
      type: TypingBarType.reply,
      showSendButton: true,
      replyData: const TypingBarReplyData(
        authorName: 'Alice',
        previewText: 'Original message preview',
      ),
      onSend: () {},
      onChanged: (_) {},
      onDismissPreview: () {},
    ),
  );
}
