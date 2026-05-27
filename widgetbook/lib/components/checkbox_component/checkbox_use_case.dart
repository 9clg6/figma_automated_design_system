import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/checkboxes/twake_checkbox.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeCheckbox)
Widget checkboxDefaultUseCase(BuildContext context) {
  return Center(
    child: TwakeCheckbox(
      type: TwakeCheckboxType.unselected,
      onChanged: (_) {},
    ),
  );
}

@widgetbook.UseCase(name: 'All types', type: TwakeCheckbox)
Widget checkboxAllTypesUseCase(BuildContext context) {
  return Center(
    child: Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: TwakeCheckboxType.values
          .map(
            (t) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TwakeCheckbox(type: t, onChanged: (_) {}),
                const SizedBox(height: 4),
                Text(t.name, style: const TextStyle(fontSize: 10)),
              ],
            ),
          )
          .toList(),
    ),
  );
}
