import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/slider/twake_slider.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Continuous', type: TwakeSlider)
Widget sliderContinuousUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: TwakeSlider(
        value: 0.5,
        type: TwakeSliderType.continuous,
        onChanged: (_) {},
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Discrete', type: TwakeSlider)
Widget sliderDiscreteUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: TwakeSlider(
        value: 0.5,
        type: TwakeSliderType.discrete,
        onChanged: (_) {},
      ),
    ),
  );
}
