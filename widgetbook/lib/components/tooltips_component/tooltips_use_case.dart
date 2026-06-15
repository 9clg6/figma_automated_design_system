import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/container/twake_tooltip.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeTooltip)
Widget tooltipsDefaultUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: TwakeTooltip(
      ),
    ),
  );
}
