import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/member_list_1/twake_member_list_item.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeMemberListItem)
Widget memberslistDefaultUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: TwakeMemberListItem(
    // name: TODO,
      ),
    ),
  );
}
