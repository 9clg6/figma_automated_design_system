import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/bar_logo_web/twake_bar_logo_web.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeBarLogoWeb)
Widget barLogoWebDefaultUseCase(BuildContext context) {
  return Center(
    child: TwakeBarLogoWeb(
      showIconHelp: true,
      showApplicationGrid: true,
      onHelpTap: () {},
      onApplicationGridTap: () {},
      onLogoTap: () {},
    ),
  );
}
