import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/menu_with_text_field_example_1/twake_menu_with_text_field.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeMenuWithTextField)
Widget menuWithTextFieldDefaultUseCase(BuildContext context) {
  return Center(
    child: TwakeMenuWithTextField(
      showTextField: true,
      items: const ['Item 1', 'Item 2', 'Item 3', 'Item 4'],
      onItemTap: (_) {},
      onSearchChanged: (_) {},
    ),
  );
}
