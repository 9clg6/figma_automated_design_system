import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/snackbar/twake_snackbar.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'One line', type: TwakeSnackbar)
Widget snackbarOneLineUseCase(BuildContext context) {
  return const Center(
    child: TwakeSnackbar(
      message: 'Single-line snackbar message',
    ),
  );
}

@widgetbook.UseCase(name: 'With action and close', type: TwakeSnackbar)
Widget snackbarWithActionUseCase(BuildContext context) {
  return Center(
    child: TwakeSnackbar(
      message: 'Message with action',
      lines: SnackbarLines.twoLines,
      showAction: true,
      showCloseAffordance: true,
      actionLabel: 'Undo',
      onActionTap: () {},
      onCloseTap: () {},
    ),
  );
}
