import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/side_sheet/twake_side_sheet.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Standard', type: TwakeSideSheet)
Widget sideSheetStandardUseCase(BuildContext context) {
  return Center(
    child: SizedBox(
      width: 360,
      height: 500,
      child: TwakeSideSheet(
        title: 'Side Sheet',
        body: const Center(child: Text('Sheet content')),
        onClose: () {},
        onSave: () {},
        onCancel: () {},
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Modal', type: TwakeSideSheet)
Widget sideSheetModalUseCase(BuildContext context) {
  return Center(
    child: SizedBox(
      width: 360,
      height: 500,
      child: TwakeSideSheet(
        type: TwakeSideSheetType.modal,
        title: 'Modal Sheet',
        showBack: true,
        body: const Center(child: Text('Modal content')),
        onClose: () {},
        onBack: () {},
        onSave: () {},
        onCancel: () {},
      ),
    ),
  );
}
