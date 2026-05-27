import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/message_counter/twake_message_counter.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Single digit', type: TwakeMessageCounter)
Widget messageCounterSingleUseCase(BuildContext context) {
  return const Center(
    child: TwakeMessageCounter(
      singleDigitCount: 5,
    ),
  );
}

@widgetbook.UseCase(name: 'Multiple digits with mention', type: TwakeMessageCounter)
Widget messageCounterMultipleUseCase(BuildContext context) {
  return const Center(
    child: TwakeMessageCounter(
      showMention: true,
      multipleDigitsCount: 42,
    ),
  );
}
