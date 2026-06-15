import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/text_fields//twake_text_field.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeTextField)
Widget inputfieldDefaultUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: TwakeTextField(
      ),
    ),
  );
}
