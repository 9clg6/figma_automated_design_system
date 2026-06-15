import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/snackbar//twake_snackbar.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeSnackbar)
Widget snackbarsDefaultUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: TwakeSnackbar(
    message: 'TwakeSnackbar example',
      ),
    ),
  );
}
