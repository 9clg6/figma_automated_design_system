import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/component_1/twake_message_context_menu.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeMessageContextMenu)
Widget menuNewDefaultUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: const TwakeMessageContextMenu(
        items: const [],
      ),
    ),
  );
}
