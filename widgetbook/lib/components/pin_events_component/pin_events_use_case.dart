import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/pin_events//twake_pin_event.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakePinEvent)
Widget pineventsDefaultUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: TwakePinEvent(
    // name: TODO,
      ),
    ),
  );
}
