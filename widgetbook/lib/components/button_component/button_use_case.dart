import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/button/twake_button.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Filled', type: TwakeButton)
Widget buttonFilledUseCase(BuildContext context) {
  return Center(
    child: TwakeButton(
      label: 'Button',
      type: TwakeButtonType.filled,
      onTap: () {},
    ),
  );
}

@widgetbook.UseCase(name: 'All types', type: TwakeButton)
Widget buttonAllTypesUseCase(BuildContext context) {
  return Center(
    child: Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: TwakeButtonType.values
          .map(
            (t) => TwakeButton(
              label: t.name,
              type: t,
              onTap: () {},
            ),
          )
          .toList(),
    ),
  );
}
