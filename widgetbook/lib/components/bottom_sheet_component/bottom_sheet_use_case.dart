import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/bottom_sheet/twake_bottom_sheet.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeBottomSheet)
Widget bottomSheetDefaultUseCase(BuildContext context) {
  return const Center(
    child: TwakeBottomSheet(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text('Bottom sheet content'),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Modal', type: TwakeBottomSheet)
Widget bottomSheetModalUseCase(BuildContext context) {
  return const Center(
    child: TwakeBottomSheet(
      modal: true,
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text('Modal bottom sheet content'),
      ),
    ),
  );
}
