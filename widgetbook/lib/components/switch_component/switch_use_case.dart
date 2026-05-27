import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/switch/twake_switch.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeSwitch)
Widget switchDefaultUseCase(BuildContext context) {
  return Center(
    child: TwakeSwitch(
      selected: false,
      onChanged: (_) {},
    ),
  );
}

@widgetbook.UseCase(name: 'Selected with icon', type: TwakeSwitch)
Widget switchSelectedUseCase(BuildContext context) {
  return Center(
    child: TwakeSwitch(
      selected: true,
      showIcon: true,
      onChanged: (_) {},
    ),
  );
}
