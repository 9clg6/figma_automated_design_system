import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:linagora_design_flutter/bottom_navigation/twake_bottom_navigation.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  group('TwakeBottomNavigation golden tests', () {
    Widget buildTestWidget(TwakeBottomNavigation nav) {
      return MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Align(
            alignment: Alignment.bottomCenter,
            child: nav,
          ),
        ),
      );
    }

    testGoldens('State=Default, Digit Chat?=false', (tester) async {
      await tester.pumpWidgetBuilder(
        buildTestWidget(
          const TwakeBottomNavigation(
            selectedTab: TwakeBottomNavigationTab.contact,
            state: TwakeBottomNavigationState.defaultState,
            showChatBadge: false,
          ),
        ),
        surfaceSize: const Size(360, 52),
      );
      await screenMatchesGolden(
          tester, 'bottom_navigation_default_no_badge');
    });

    testGoldens('State=Default, Digit Chat?=true', (tester) async {
      await tester.pumpWidgetBuilder(
        buildTestWidget(
          const TwakeBottomNavigation(
            selectedTab: TwakeBottomNavigationTab.contact,
            state: TwakeBottomNavigationState.defaultState,
            showChatBadge: true,
            chatBadgeCount: '3',
          ),
        ),
        surfaceSize: const Size(360, 52),
      );
      await screenMatchesGolden(
          tester, 'bottom_navigation_default_with_badge');
    });

    testGoldens('State=Active Chat, Digit Chat?=false', (tester) async {
      await tester.pumpWidgetBuilder(
        buildTestWidget(
          const TwakeBottomNavigation(
            selectedTab: TwakeBottomNavigationTab.chat,
            state: TwakeBottomNavigationState.activeChat,
            showChatBadge: false,
          ),
        ),
        surfaceSize: const Size(360, 52),
      );
      await screenMatchesGolden(
          tester, 'bottom_navigation_active_chat_no_badge');
    });

    testGoldens('State=Active Chat, Digit Chat?=true', (tester) async {
      await tester.pumpWidgetBuilder(
        buildTestWidget(
          const TwakeBottomNavigation(
            selectedTab: TwakeBottomNavigationTab.chat,
            state: TwakeBottomNavigationState.activeChat,
            showChatBadge: true,
            chatBadgeCount: '5',
          ),
        ),
        surfaceSize: const Size(360, 52),
      );
      await screenMatchesGolden(
          tester, 'bottom_navigation_active_chat_with_badge');
    });

    testGoldens('State=Active Contact, Digit Chat?=true', (tester) async {
      await tester.pumpWidgetBuilder(
        buildTestWidget(
          const TwakeBottomNavigation(
            selectedTab: TwakeBottomNavigationTab.contact,
            state: TwakeBottomNavigationState.activeContact,
            showChatBadge: true,
            chatBadgeCount: '2',
          ),
        ),
        surfaceSize: const Size(360, 52),
      );
      await screenMatchesGolden(
          tester, 'bottom_navigation_active_contact_with_badge');
    });

    testGoldens('State=Active Profil, Digit Chat?=true', (tester) async {
      await tester.pumpWidgetBuilder(
        buildTestWidget(
          const TwakeBottomNavigation(
            selectedTab: TwakeBottomNavigationTab.settings,
            state: TwakeBottomNavigationState.activeProfil,
            showChatBadge: true,
            chatBadgeCount: '1',
          ),
        ),
        surfaceSize: const Size(360, 52),
      );
      await screenMatchesGolden(
          tester, 'bottom_navigation_active_profil_with_badge');
    });

    testGoldens('State=Hovered, Digit Chat?=false', (tester) async {
      await tester.pumpWidgetBuilder(
        buildTestWidget(
          const TwakeBottomNavigation(
            selectedTab: TwakeBottomNavigationTab.chat,
            state: TwakeBottomNavigationState.hovered,
            showChatBadge: false,
          ),
        ),
        surfaceSize: const Size(360, 52),
      );
      await screenMatchesGolden(
          tester, 'bottom_navigation_hovered_no_badge');
    });

    testGoldens('State=Hovered, Digit Chat?=true', (tester) async {
      await tester.pumpWidgetBuilder(
        buildTestWidget(
          const TwakeBottomNavigation(
            selectedTab: TwakeBottomNavigationTab.chat,
            state: TwakeBottomNavigationState.hovered,
            showChatBadge: true,
            chatBadgeCount: '9',
          ),
        ),
        surfaceSize: const Size(360, 52),
      );
      await screenMatchesGolden(
          tester, 'bottom_navigation_hovered_with_badge');
    });
  });
}
