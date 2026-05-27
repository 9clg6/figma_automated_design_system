import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:linagora_design_flutter/member_list_1/twake_member_list_item.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  group('TwakeMemberListItem golden tests', () {
    Widget buildTestWidget(Widget child) {
      return MaterialApp(
        theme: ThemeData.light(),
        home: Scaffold(
          backgroundColor: Colors.white,
          body: SizedBox(
            width: 344,
            child: child,
          ),
        ),
      );
    }

    testGoldens('default_owner_online', (tester) async {
      await tester.pumpWidgetBuilder(
        buildTestWidget(
          const TwakeMemberListItem(
            name: 'Ha-eun',
            statusText: 'Online',
            role: MemberRole.owner,
            type: MemberListItemType.defaultType,
          ),
        ),
        surfaceSize: const Size(344, 72),
      );
      await screenMatchesGolden(tester, 'member_list_item_default_owner_online');
    });

    testGoldens('default_admin_last_seen', (tester) async {
      await tester.pumpWidgetBuilder(
        buildTestWidget(
          const TwakeMemberListItem(
            name: 'Ha-eun',
            role: MemberRole.admin,
            type: MemberListItemType.defaultType,
            showLastSeen: true,
            lastSeenTime: '16:30',
          ),
        ),
        surfaceSize: const Size(344, 72),
      );
      await screenMatchesGolden(tester, 'member_list_item_default_admin_last_seen');
    });

    testGoldens('default_owner_matrix_email', (tester) async {
      await tester.pumpWidgetBuilder(
        buildTestWidget(
          const TwakeMemberListItem(
            name: 'Ha-eun',
            role: MemberRole.owner,
            type: MemberListItemType.defaultType,
            showMatrixId: true,
            matrixId: 'ha-eun-techagile.mattrix.com',
            showEmail: true,
            email: 'ha-en@techagile.com',
          ),
        ),
        surfaceSize: const Size(344, 80),
      );
      await screenMatchesGolden(tester, 'member_list_item_default_owner_matrix_email');
    });

    testGoldens('unselect_owner_online', (tester) async {
      await tester.pumpWidgetBuilder(
        buildTestWidget(
          TwakeMemberListItem(
            name: 'Ha-eun',
            statusText: 'Online',
            role: MemberRole.owner,
            type: MemberListItemType.unselect,
            onCheckboxChanged: (_) {},
          ),
        ),
        surfaceSize: const Size(344, 72),
      );
      await screenMatchesGolden(tester, 'member_list_item_unselect_owner_online');
    });

    testGoldens('selected_owner_online', (tester) async {
      await tester.pumpWidgetBuilder(
        buildTestWidget(
          TwakeMemberListItem(
            name: 'Ha-eun',
            statusText: 'Online',
            role: MemberRole.owner,
            type: MemberListItemType.selected,
            onCheckboxChanged: (_) {},
          ),
        ),
        surfaceSize: const Size(344, 72),
      );
      await screenMatchesGolden(tester, 'member_list_item_selected_owner_online');
    });

    testGoldens('selected_admin_last_seen', (tester) async {
      await tester.pumpWidgetBuilder(
        buildTestWidget(
          TwakeMemberListItem(
            name: 'Ha-eun',
            role: MemberRole.admin,
            type: MemberListItemType.selected,
            showLastSeen: true,
            lastSeenTime: '16:30',
            onCheckboxChanged: (_) {},
          ),
        ),
        surfaceSize: const Size(344, 72),
      );
      await screenMatchesGolden(tester, 'member_list_item_selected_admin_last_seen');
    });

    testGoldens('add_contact_member_matrix_email', (tester) async {
      await tester.pumpWidgetBuilder(
        buildTestWidget(
          const TwakeMemberListItem(
            name: 'Ha-eun',
            role: MemberRole.member,
            type: MemberListItemType.addContact,
            showMatrixId: true,
            matrixId: 'ha-eun-techagile.mattrix.com',
            showEmail: true,
            email: 'ha-en@techagile.com',
          ),
        ),
        surfaceSize: const Size(344, 80),
      );
      await screenMatchesGolden(tester, 'member_list_item_add_contact_member_matrix_email');
    });

    testGoldens('disabled_contact_member_matrix_email', (tester) async {
      await tester.pumpWidgetBuilder(
        buildTestWidget(
          const TwakeMemberListItem(
            name: 'Ha-eun',
            role: MemberRole.member,
            type: MemberListItemType.disabledContact,
            showMatrixId: true,
            matrixId: 'ha-eun-techagile.mattrix.com',
            showEmail: true,
            email: 'ha-en@techagile.com',
          ),
        ),
        surfaceSize: const Size(344, 80),
      );
      await screenMatchesGolden(tester, 'member_list_item_disabled_contact_member_matrix_email');
    });

    testGoldens('dark_theme_selected', (tester) async {
      await tester.pumpWidgetBuilder(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            body: SizedBox(
              width: 344,
              child: TwakeMemberListItem(
                name: 'Bob Jones',
                statusText: 'Online',
                role: MemberRole.admin,
                type: MemberListItemType.selected,
                showLastSeen: true,
                lastSeenTime: '16:30',
                onCheckboxChanged: (_) {},
              ),
            ),
          ),
        ),
        surfaceSize: const Size(344, 72),
      );
      await screenMatchesGolden(tester, 'member_list_item_dark_theme_selected');
    });

    testGoldens('full_list_showcase', (tester) async {
      await tester.pumpWidgetBuilder(
        MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            backgroundColor: Colors.white,
            body: SizedBox(
              width: 344,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const TwakeMemberListItem(
                    name: 'Ha-eun',
                    statusText: 'Online',
                    role: MemberRole.owner,
                    type: MemberListItemType.defaultType,
                  ),
                  const Divider(height: 1),
                  const TwakeMemberListItem(
                    name: 'Ha-eun',
                    role: MemberRole.owner,
                    type: MemberListItemType.defaultType,
                    showLastSeen: true,
                    lastSeenTime: '16:30',
                  ),
                  const Divider(height: 1),
                  const TwakeMemberListItem(
                    name: 'Ha-eun',
                    role: MemberRole.owner,
                    type: MemberListItemType.defaultType,
                    showMatrixId: true,
                    matrixId: 'ha-eun-techagile.mattrix.com',
                    showEmail: true,
                    email: 'ha-en@techagile.com',
                  ),
                  const Divider(height: 1),
                  TwakeMemberListItem(
                    name: 'Ha-eun',
                    statusText: 'Online',
                    role: MemberRole.owner,
                    type: MemberListItemType.unselect,
                    onCheckboxChanged: (_) {},
                  ),
                  const Divider(height: 1),
                  TwakeMemberListItem(
                    name: 'Ha-eun',
                    statusText: 'Online',
                    role: MemberRole.owner,
                    type: MemberListItemType.selected,
                    onCheckboxChanged: (_) {},
                  ),
                  const Divider(height: 1),
                  const TwakeMemberListItem(
                    name: 'Ha-eun',
                    role: MemberRole.member,
                    type: MemberListItemType.addContact,
                    showMatrixId: true,
                    matrixId: 'ha-eun-techagile.mattrix.com',
                    showEmail: true,
                    email: 'ha-en@techagile.com',
                  ),
                ],
              ),
            ),
          ),
        ),
        surfaceSize: const Size(344, 510),
      );
      await screenMatchesGolden(tester, 'member_list_item_full_list_showcase');
    });
  });
}
