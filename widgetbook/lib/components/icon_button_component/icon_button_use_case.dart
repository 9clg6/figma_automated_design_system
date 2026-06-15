import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/icon_button_web/twake_icon_button_web.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeIconButtonWeb)
Widget iconbuttonDefaultUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: TwakeIconButtonWeb(
    icon: Icons.star,
      ),
    ),
  );
}
