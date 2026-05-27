import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/small_fab/twake_small_fab.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeSmallFab)
Widget smallFabDefaultUseCase(BuildContext context) {
  return Center(
    child: TwakeSmallFab(
      onTap: () {},
    ),
  );
}

@widgetbook.UseCase(name: 'All configurations', type: TwakeSmallFab)
Widget smallFabAllConfigsUseCase(BuildContext context) {
  return Center(
    child: Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: SmallFabConfiguration.values
          .map(
            (c) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TwakeSmallFab(configuration: c, onTap: () {}),
                const SizedBox(height: 4),
                Text(c.name, style: const TextStyle(fontSize: 10)),
              ],
            ),
          )
          .toList(),
    ),
  );
}
