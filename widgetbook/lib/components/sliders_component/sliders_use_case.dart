import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/slider/twake_slider.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeSlider)
Widget slidersDefaultUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: TwakeSlider(
    // value: TODO,
      ),
    ),
  );
}
