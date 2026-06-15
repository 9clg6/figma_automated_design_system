import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/list_item/twake_list_item.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeListItem)
Widget listsDefaultUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: TwakeListItem(
    child: Text('Example'),
      ),
    ),
  );
}
