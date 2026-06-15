import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/dialog/confirmation_dialog_builder.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: ConfirmationDialogBuilder)
Widget dialogmodalDefaultUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: ConfirmationDialogBuilder(
      ),
    ),
  );
}
