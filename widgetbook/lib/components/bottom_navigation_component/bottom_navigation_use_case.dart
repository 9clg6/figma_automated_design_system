import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/bottom_navigation/twake_bottom_navigation.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeBottomNavigation)
Widget bottomNavigationDefaultUseCase(BuildContext context) {
  return Center(
    child: TwakeBottomNavigation(
      selectedTab: TwakeBottomNavigationTab.chat,
      showChatBadge: true,
      chatBadgeCount: '3',
      onContactTap: () {},
      onChatTap: () {},
      onSettingsTap: () {},
    ),
  );
}
