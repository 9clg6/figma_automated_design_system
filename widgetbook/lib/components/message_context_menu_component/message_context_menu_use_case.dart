import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/component_1/twake_message_context_menu.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeMessageContextMenu)
Widget messageContextMenuDefaultUseCase(BuildContext context) {
  return Center(
    child: TwakeMessageContextMenu(
      items: [
        TwakeContextMenuItem(label: 'Reply', icon: Icons.reply, onTap: () {}),
        TwakeContextMenuItem(label: 'Forward', icon: Icons.forward, onTap: () {}),
        TwakeContextMenuItem(label: 'Copy', icon: Icons.copy, onTap: () {}),
        TwakeContextMenuItem(label: 'Pin', icon: Icons.push_pin, onTap: () {}),
        TwakeContextMenuItem(
          label: 'Delete',
          icon: Icons.delete,
          isDestructive: true,
          onTap: () {},
        ),
      ],
    ),
  );
}
