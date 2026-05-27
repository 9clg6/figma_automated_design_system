import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/dialog_2/twake_dialog_2.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeDialog2)
Widget dialog2DefaultUseCase(BuildContext context) {
  return Center(
    child: TwakeDialog2(
      title: 'Confirm action',
      subText: 'Are you sure you want to proceed?',
      onClose: () {},
      onRightAction: () {},
    ),
  );
}
