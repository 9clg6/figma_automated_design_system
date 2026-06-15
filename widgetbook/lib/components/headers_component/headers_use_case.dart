import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/bar_logo_web//twake_bar_logo_web.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeBarLogoWeb)
Widget headersDefaultUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: TwakeBarLogoWeb(
      ),
    ),
  );
}
