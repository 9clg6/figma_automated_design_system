import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/search_tabs/twake_search_tab.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeSearchTab)
Widget searchTabDefaultUseCase(BuildContext context) {
  return Center(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TwakeSearchTab(
          label: 'All',
          active: true,
          onTap: () {},
        ),
        TwakeSearchTab(
          label: 'Messages',
          active: false,
          singleBadge: true,
          badgeCount: 3,
          onTap: () {},
        ),
        TwakeSearchTab(
          label: 'Files',
          active: false,
          onTap: () {},
        ),
      ],
    ),
  );
}
