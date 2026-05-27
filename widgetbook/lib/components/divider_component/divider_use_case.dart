import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/style/linagora_divider_style.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Horizontal divider', type: Divider)
Widget dividerHorizontalUseCase(BuildContext context) {
  final style = LinagoraDividerStyle.material();
  return Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Content above divider'),
        const SizedBox(height: 16),
        Divider(
          color: style.color,
          thickness: style.thickness,
        ),
        const SizedBox(height: 16),
        const Text('Content below divider'),
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'In a list', type: Divider)
Widget dividerInListUseCase(BuildContext context) {
  final style = LinagoraDividerStyle.material();
  return ListView.separated(
    shrinkWrap: true,
    itemCount: 5,
    separatorBuilder: (_, __) => Divider(
      color: style.color,
      thickness: style.thickness,
      indent: 72,
    ),
    itemBuilder: (_, i) => ListTile(
      leading: CircleAvatar(child: Text('${i + 1}')),
      title: Text('List item ${i + 1}'),
      subtitle: const Text('Subtitle text'),
    ),
  );
}
