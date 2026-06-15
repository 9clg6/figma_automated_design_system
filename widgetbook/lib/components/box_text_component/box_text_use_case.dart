import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/dialog_2/twake_dialog_2.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeDialog2)
Widget boxtextDefaultUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: TwakeDialog2(
      ),
    ),
  );
}
