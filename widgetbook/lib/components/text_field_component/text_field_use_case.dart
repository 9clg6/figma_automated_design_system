import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/text_fields/twake_text_field.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Filled', type: TwakeTextField)
Widget textFieldFilledUseCase(BuildContext context) {
  return const Center(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: TwakeTextField(
        label: 'Label',
        hintText: 'Enter text',
        configuration: TwakeTextFieldConfiguration.filled,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Outline', type: TwakeTextField)
Widget textFieldOutlineUseCase(BuildContext context) {
  return const Center(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: TwakeTextField(
        label: 'Label',
        hintText: 'Enter text',
        configuration: TwakeTextFieldConfiguration.outline,
      ),
    ),
  );
}
