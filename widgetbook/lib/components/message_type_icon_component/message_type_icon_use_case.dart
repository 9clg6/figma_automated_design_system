import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/lin_message_type_icon_24px/twake_message_type_icon.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'All types', type: TwakeMessageTypeIcon)
Widget messageTypeIconAllUseCase(BuildContext context) {
  return Center(
    child: Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: MessageIconType.values
          .map(
            (t) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TwakeMessageTypeIcon(type: t),
                const SizedBox(height: 4),
                Text(t.name, style: const TextStyle(fontSize: 10)),
              ],
            ),
          )
          .toList(),
    ),
  );
}
