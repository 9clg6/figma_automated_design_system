import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/icon_button_web/twake_icon_button_web.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeIconButtonWeb)
Widget iconButtonWebDefaultUseCase(BuildContext context) {
  return Center(
    child: TwakeIconButtonWeb(
      icon: Icons.favorite,
      onTap: () {},
    ),
  );
}

@widgetbook.UseCase(name: 'All configurations', type: TwakeIconButtonWeb)
Widget iconButtonWebAllConfigsUseCase(BuildContext context) {
  return Center(
    child: Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: TwakeIconButtonConfiguration.values
          .map(
            (c) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TwakeIconButtonWeb(
                  icon: Icons.favorite,
                  configuration: c,
                  onTap: () {},
                ),
                const SizedBox(height: 4),
                Text(c.name, style: const TextStyle(fontSize: 10)),
              ],
            ),
          )
          .toList(),
    ),
  );
}
