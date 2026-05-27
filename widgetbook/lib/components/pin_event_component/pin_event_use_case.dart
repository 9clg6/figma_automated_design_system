import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/pin_events/twake_pin_event.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakePinEvent)
Widget pinEventDefaultUseCase(BuildContext context) {
  return const Center(
    child: TwakePinEvent(
      name: 'Alice',
      type: PinEventType.text,
    ),
  );
}
