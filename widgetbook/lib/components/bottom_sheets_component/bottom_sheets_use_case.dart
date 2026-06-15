import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/bottom_sheet/twake_bottom_sheet.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeBottomSheet)
Widget bottomsheetsDefaultUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: TwakeBottomSheet(
      ),
    ),
  );
}
