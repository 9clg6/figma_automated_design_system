import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linear_progress_indicator/twake_linear_progress_indicator.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Determinate', type: TwakeLinearProgressIndicator)
Widget linearProgressDeterminateUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: TwakeLinearProgressIndicator(
        value: context.knobs.double.slider(
          label: 'Progress',
          initialValue: 0.6,
          min: 0,
          max: 1,
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Indeterminate', type: TwakeLinearProgressIndicator)
Widget linearProgressIndeterminateUseCase(BuildContext context) {
  return const Center(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: TwakeLinearProgressIndicator(),
    ),
  );
}
