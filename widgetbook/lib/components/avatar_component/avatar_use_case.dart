import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/avatar/round_avatar.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Monogram', type: RoundAvatar)
Widget avatarMonogramUseCase(BuildContext context) {
  return Center(
    child: RoundAvatar(
      text: context.knobs.string(
        label: 'Text',
        initialValue: 'John Doe',
      ),
      size: context.knobs.double.slider(
        label: 'Size',
        initialValue: 56,
        min: 24,
        max: 120,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'All sizes', type: RoundAvatar)
Widget avatarSizesUseCase(BuildContext context) {
  const sizes = [24.0, 32.0, 40.0, 48.0, 56.0, 72.0, 96.0];
  return Center(
    child: Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: sizes
          .map((s) => RoundAvatar(text: 'AB', size: s))
          .toList(),
    ),
  );
}

@widgetbook.UseCase(name: 'With gradient colors', type: RoundAvatar)
Widget avatarGradientsUseCase(BuildContext context) {
  final names = ['Alice', 'Bob', 'Charlie', 'Diana', 'Eve', 'Frank'];
  return Center(
    child: Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: names
          .map((n) => RoundAvatar(text: n, size: 56))
          .toList(),
    ),
  );
}
