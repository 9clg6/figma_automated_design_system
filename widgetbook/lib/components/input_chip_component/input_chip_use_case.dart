import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/input_chip/twake_input_chip.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeInputChip)
Widget inputChipDefaultUseCase(BuildContext context) {
  return Center(
    child: TwakeInputChip(
      label: 'Chip label',
      onTap: () {},
    ),
  );
}

@widgetbook.UseCase(name: 'Selected with trailing icon', type: TwakeInputChip)
Widget inputChipSelectedUseCase(BuildContext context) {
  return Center(
    child: TwakeInputChip(
      label: 'Selected chip',
      style: InputChipStyle.selected,
      configuration: InputChipConfiguration.labelAndTrailingIcon,
      onTap: () {},
      onDeleted: () {},
    ),
  );
}
