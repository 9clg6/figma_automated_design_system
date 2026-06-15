import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/menu_with_text_field_example_1/twake_menu_with_text_field.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeMenuWithTextField)
Widget menusDefaultUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: TwakeMenuWithTextField(
      ),
    ),
  );
}
