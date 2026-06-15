import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/button/twake_button.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeButton)
Widget buttonsDefaultUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: TwakeButton(
    label: 'TwakeButton example',
      ),
    ),
  );
}
