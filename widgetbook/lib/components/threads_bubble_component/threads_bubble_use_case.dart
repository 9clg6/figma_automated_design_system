import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/threads_bubble/twake_threads_bubble.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeThreadsBubble)
Widget threadsBubbleDefaultUseCase(BuildContext context) {
  return const Center(
    child: TwakeThreadsBubble(),
  );
}
