import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/labels/twake_label.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeLabel)
Widget labelDefaultUseCase(BuildContext context) {
  return const Center(
    child: TwakeLabel(label: 'Label text'),
  );
}

@widgetbook.UseCase(name: 'All variants', type: TwakeLabel)
Widget labelAllVariantsUseCase(BuildContext context) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: TwakeLabelVariant.values
          .map(
            (v) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: TwakeLabel(
                label: v.name,
                variant: v,
                onChevronTap: () {},
                onClearTap: () {},
              ),
            ),
          )
          .toList(),
    ),
  );
}
