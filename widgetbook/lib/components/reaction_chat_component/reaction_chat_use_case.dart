import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/reaction/reaction_picker.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: ReactionsPicker)
Widget reactionchatDefaultUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: ReactionsPicker(
      ),
    ),
  );
}
