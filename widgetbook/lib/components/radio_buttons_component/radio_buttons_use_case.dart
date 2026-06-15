import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linear_progress_indicator/twake_linear_progress_indicator.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeLinearProgressIndicator)
Widget radiobuttonsDefaultUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: TwakeLinearProgressIndicator(
      ),
    ),
  );
}
