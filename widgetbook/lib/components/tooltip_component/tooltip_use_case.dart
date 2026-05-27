import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/container/twake_tooltip.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Plain', type: TwakeTooltip)
Widget tooltipPlainUseCase(BuildContext context) {
  return const Center(
    child: TwakeTooltip(
      type: TwakeTooltipType.plain,
      supportingText: 'This is a plain tooltip',
    ),
  );
}

@widgetbook.UseCase(name: 'Rich', type: TwakeTooltip)
Widget tooltipRichUseCase(BuildContext context) {
  return Center(
    child: TwakeTooltip(
      type: TwakeTooltipType.rich,
      subhead: 'Rich Tooltip',
      supportingText: 'This tooltip has more detail and action buttons.',
      button1Label: 'Action 1',
      button2Label: 'Action 2',
      onButton1Pressed: () {},
      onButton2Pressed: () {},
    ),
  );
}
