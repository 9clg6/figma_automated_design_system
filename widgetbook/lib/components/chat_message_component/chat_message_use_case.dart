import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/message_list//twake_message_list_item.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeMessageListItem)
Widget chatmessageDefaultUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: TwakeMessageListItem(
      ),
    ),
  );
}
