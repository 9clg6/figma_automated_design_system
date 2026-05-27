import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/list_item/twake_list_item.dart';
import 'package:linagora_design_flutter/list_item/twake_inkwell.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Line variants', type: TwakeListItem)
Widget listItemVariantsUseCase(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TwakeListItem(
          height: TwakeListItemHeight.oneLine,
          child: const ListTile(
            title: Text('One-line item (56px)'),
            trailing: Icon(Icons.chevron_right),
          ),
        ),
        const SizedBox(height: 8),
        TwakeListItem(
          height: TwakeListItemHeight.twoLine,
          child: const ListTile(
            title: Text('Two-line item (72px)'),
            subtitle: Text('Secondary text'),
            trailing: Icon(Icons.chevron_right),
          ),
        ),
        const SizedBox(height: 8),
        TwakeListItem(
          height: TwakeListItemHeight.threeLine,
          child: const ListTile(
            isThreeLine: true,
            title: Text('Three-line item (124px)'),
            subtitle: Text('Secondary text\nTertiary text'),
            trailing: Icon(Icons.chevron_right),
          ),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'With leading & trailing', type: TwakeListItem)
Widget listItemLeadingTrailingUseCase(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TwakeListItem(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: const Text('John Doe'),
            subtitle: const Text('Online'),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ),
        ),
        const SizedBox(height: 8),
        TwakeListItem(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.group)),
            title: const Text('Design Team'),
            subtitle: const Text('5 members'),
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward_ios, size: 16),
              onPressed: () {},
            ),
          ),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'InkWell states', type: TwakeInkWell)
Widget inkwellStatesUseCase(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TwakeInkWell(
          onTap: () {},
          child: const ListTile(
            title: Text('Default state'),
            subtitle: Text('Tap or hover me'),
          ),
        ),
        const SizedBox(height: 8),
        TwakeInkWell(
          isSelected: true,
          onTap: () {},
          child: const ListTile(
            title: Text('Selected state'),
            subtitle: Text('isSelected: true'),
          ),
        ),
        const SizedBox(height: 8),
        TwakeInkWell(
          onTap: () {},
          onLongPress: () {},
          child: const ListTile(
            title: Text('With long press'),
            subtitle: Text('Long press enabled'),
          ),
        ),
      ],
    ),
  );
}
