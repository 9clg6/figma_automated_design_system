import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/timestamp/twake_timestamp.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeTimestamp)
Widget timestampDefaultUseCase(BuildContext context) {
  return const Center(
    child: TwakeTimestamp(type: TimestampType.today),
  );
}

@widgetbook.UseCase(name: 'On scrolling pill', type: TwakeTimestamp)
Widget timestampScrollingUseCase(BuildContext context) {
  return const Center(
    child: TwakeTimestamp(
      type: TimestampType.months,
      onScrolling: true,
    ),
  );
}
