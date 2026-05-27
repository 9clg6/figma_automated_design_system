import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/member_list_1/twake_member_list_item.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeMemberListItem)
Widget memberListItemDefaultUseCase(BuildContext context) {
  return Center(
    child: TwakeMemberListItem(
      name: 'John Doe',
      role: MemberRole.member,
      onTap: () {},
    ),
  );
}

@widgetbook.UseCase(name: 'Admin with details', type: TwakeMemberListItem)
Widget memberListItemAdminUseCase(BuildContext context) {
  return Center(
    child: TwakeMemberListItem(
      name: 'Jane Smith',
      role: MemberRole.admin,
      showMatrixId: true,
      matrixId: '@jane:matrix.org',
      showEmail: true,
      email: 'jane@example.com',
      onTap: () {},
    ),
  );
}
