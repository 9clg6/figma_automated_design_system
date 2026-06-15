import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/modal_date_picker//twake_modal_date_picker.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeModalDatePicker)
Widget datepickersDefaultUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: TwakeModalDatePicker(
      ),
    ),
  );
}
