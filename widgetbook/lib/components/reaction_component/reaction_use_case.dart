import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/reaction/reaction_picker.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: ReactionsPicker)
Widget reactionPickerDefaultUseCase(BuildContext context) {
  return Center(
    child: ReactionsPicker(
      onClickEmojiReactionAction: (_) {},
      onPickEmojiReactionAction: () {},
    ),
  );
}

@widgetbook.UseCase(name: 'Custom size', type: ReactionsPicker)
Widget reactionPickerCustomUseCase(BuildContext context) {
  return Center(
    child: ReactionsPicker(
      height: context.knobs.double.slider(
        label: 'Height',
        initialValue: 56,
        min: 40,
        max: 80,
      ),
      emojiSize: context.knobs.double.slider(
        label: 'Emoji size',
        initialValue: 28,
        min: 16,
        max: 48,
      ),
      borderRadius: context.knobs.double.slider(
        label: 'Border radius',
        initialValue: 32,
        min: 0,
        max: 40,
      ),
      onClickEmojiReactionAction: (_) {},
      onPickEmojiReactionAction: () {},
    ),
  );
}

@widgetbook.UseCase(name: 'With my reaction', type: ReactionsPicker)
Widget reactionPickerMyReactionUseCase(BuildContext context) {
  return Center(
    child: ReactionsPicker(
      myEmojiReacted: context.knobs.string(
        label: 'My reacted emoji',
        initialValue: '👍',
      ),
      onClickEmojiReactionAction: (_) {},
      onPickEmojiReactionAction: () {},
    ),
  );
}
