import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/checkboxes/twake_checkbox.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeCheckbox)
Widget checkboxesDefaultUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: TwakeCheckbox(
    // type: TODO,
      ),
    ),
  );
}
