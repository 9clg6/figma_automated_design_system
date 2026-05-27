import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/bubble_message/twake_bubble_message.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeBubbleMessage)
Widget bubbleMessageDefaultUseCase(BuildContext context) {
  return Center(
    child: TwakeBubbleMessage(
      message: 'Hello, how are you?',
      time: '10:30',
      senderName: 'Alice',
      onTap: () {},
    ),
  );
}

@widgetbook.UseCase(name: 'Sender', type: TwakeBubbleMessage)
Widget bubbleMessageSenderUseCase(BuildContext context) {
  return Center(
    child: TwakeBubbleMessage(
      message: 'I am doing great, thanks!',
      time: '10:31',
      chat: BubbleChat.sender,
      onTap: () {},
    ),
  );
}
