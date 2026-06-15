import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/input_chip//twake_input_chip.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeInputChip)
Widget chipsDefaultUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: TwakeInputChip(
    label: 'TwakeInputChip example',
      ),
    ),
  );
}
