import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/modal_date_picker/twake_modal_date_picker.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Single date', type: TwakeModalDatePicker)
Widget datePickerSingleUseCase(BuildContext context) {
  return Center(
    child: TwakeModalDatePicker(
      mode: TwakeDatePickerMode.single,
      onDaySelected: (_) {},
      onCancel: () {},
      onConfirm: () {},
    ),
  );
}

@widgetbook.UseCase(name: 'Date range', type: TwakeModalDatePicker)
Widget datePickerRangeUseCase(BuildContext context) {
  return Center(
    child: TwakeModalDatePicker(
      mode: TwakeDatePickerMode.range,
      onDaySelected: (_) {},
      onCancel: () {},
      onConfirm: () {},
    ),
  );
}
