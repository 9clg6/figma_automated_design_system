import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/side_sheet/twake_side_sheet.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeSideSheet)
Widget sidesheetsDefaultUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: TwakeSideSheet(
      ),
    ),
  );
}
