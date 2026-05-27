import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';

/// Enum representing which tab is currently active.
enum TwakeBottomNavigationTab {
  contact,
  chat,
  settings,
}

/// Enum for the visual state of the bottom navigation bar.
enum TwakeBottomNavigationState {
  defaultState,
  hovered,
  activeChat,
  activeProfil,
  activeContact,
}

/// Style tokens for [TwakeBottomNavigation].
class TwakeBottomNavigationStyle {
  static const double barHeight = 52.0;
  static const double itemWidth = 120.0;
  static const double iconSize = 24.0;
  static const double badgeSize = 16.0;
  static const double badgeFontSize = 10.0;
  static const double labelFontSize = 10.0;
  static const double labelTopSpacing = 2.0;
  static const EdgeInsets barPadding =
      EdgeInsets.symmetric(horizontal: 0, vertical: 4);
  static const Color activeColor = Color(0xFF1A73E8);
  static const Color inactiveColor = Color(0xFF5F6368);
  static const Color hoveredColor = Color(0xFF444746);
  static const Color badgeColor = Color(0xFFE53935);
  static const Color badgeTextColor = Color(0xFFFFFFFF);
  static const Color barBackground = Color(0xFFF4F4F4);
  static const Color dividerColor = Color(0xFFE0E0E0);
  static const Color activeIndicatorColor = Color(0xFFD3E3FD);
  static const double indicatorHeight = 32.0;
  static const double indicatorWidth = 64.0;
  static const double indicatorRadius = 16.0;

  const TwakeBottomNavigationStyle._();
}

/// A Twake-branded bottom navigation bar with 3 tabs:
/// Contact, Chat (with optional badge), and Settings.
///
/// Supports [TwakeBottomNavigationState] for visual variants
/// matching the Figma spec.
class TwakeBottomNavigation extends StatelessWidget {
  /// Which tab is currently selected.
  final TwakeBottomNavigationTab selectedTab;

  /// Visual state of the bar (default, hovered, active*).
  final TwakeBottomNavigationState state;

  /// Whether to show a badge on the Chat tab.
  final bool showChatBadge;

  /// Badge count text (e.g. "3"). Shown only when [showChatBadge] is true.
  final String? chatBadgeCount;

  /// Called when the Contact tab is tapped.
  final VoidCallback? onContactTap;

  /// Called when the Chat tab is tapped.
  final VoidCallback? onChatTap;

  /// Called when the Settings tab is tapped.
  final VoidCallback? onSettingsTap;

  const TwakeBottomNavigation({
    Key? key,
    required this.selectedTab,
    this.state = TwakeBottomNavigationState.defaultState,
    this.showChatBadge = false,
    this.chatBadgeCount,
    this.onContactTap,
    this.onChatTap,
    this.onSettingsTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: TwakeBottomNavigationStyle.barHeight,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: TwakeBottomNavigationStyle.barBackground,
        border: Border(
          top: BorderSide(
            color: TwakeBottomNavigationStyle.dividerColor,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          _TwakeNavItem(
            icon: Icons.people_outline,
            activeIcon: Icons.people,
            label: 'Contact',
            isActive: selectedTab == TwakeBottomNavigationTab.contact,
            isHovered: state == TwakeBottomNavigationState.hovered &&
                selectedTab == TwakeBottomNavigationTab.contact,
            onTap: onContactTap,
          ),
          _TwakeNavItem(
            icon: Icons.chat_bubble_outline,
            activeIcon: Icons.chat_bubble,
            label: 'Chats',
            isActive: selectedTab == TwakeBottomNavigationTab.chat,
            isHovered: state == TwakeBottomNavigationState.hovered &&
                selectedTab == TwakeBottomNavigationTab.chat,
            showBadge: showChatBadge,
            badgeCount: chatBadgeCount,
            onTap: onChatTap,
          ),
          _TwakeNavItem(
            icon: Icons.settings_outlined,
            activeIcon: Icons.settings,
            label: 'Settings',
            isActive: selectedTab == TwakeBottomNavigationTab.settings,
            isHovered: state == TwakeBottomNavigationState.hovered &&
                selectedTab == TwakeBottomNavigationTab.settings,
            onTap: onSettingsTap,
          ),
        ],
      ),
    );
  }
}

/// Private widget representing a single navigation tab item.
class _TwakeNavItem extends StatefulWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final bool isHovered;
  final bool showBadge;
  final String? badgeCount;
  final VoidCallback? onTap;

  const _TwakeNavItem({
    Key? key,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    this.isHovered = false,
    this.showBadge = false,
    this.badgeCount,
    this.onTap,
  }) : super(key: key);

  @override
  State<_TwakeNavItem> createState() => _TwakeNavItemState();
}

class _TwakeNavItemState extends State<_TwakeNavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bool active = widget.isActive;
    final bool hovered = _hovered || widget.isHovered;

    final Color iconColor = active
        ? TwakeBottomNavigationStyle.activeColor
        : hovered
            ? TwakeBottomNavigationStyle.hoveredColor
            : TwakeBottomNavigationStyle.inactiveColor;

    final Color labelColor = active
        ? TwakeBottomNavigationStyle.activeColor
        : hovered
            ? TwakeBottomNavigationStyle.hoveredColor
            : TwakeBottomNavigationStyle.inactiveColor;

    return Expanded(
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            height: TwakeBottomNavigationStyle.barHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // Active indicator pill
                    if (active)
                      Container(
                        width: TwakeBottomNavigationStyle.indicatorWidth,
                        height: TwakeBottomNavigationStyle.indicatorHeight,
                        decoration: BoxDecoration(
                          color: TwakeBottomNavigationStyle.activeIndicatorColor,
                          borderRadius: BorderRadius.circular(
                            TwakeBottomNavigationStyle.indicatorRadius,
                          ),
                        ),
                      ),
                    // Icon
                    Icon(
                      active ? widget.activeIcon : widget.icon,
                      size: TwakeBottomNavigationStyle.iconSize,
                      color: iconColor,
                    ),
                    // Badge
                    if (widget.showBadge)
                      Positioned(
                        top: -4,
                        right: active ? -8 : -12,
                        child: _TwakeBadge(
                          count: widget.badgeCount,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: TwakeBottomNavigationStyle.labelTopSpacing),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: TwakeBottomNavigationStyle.labelFontSize,
                    fontWeight:
                        active ? FontWeight.w600 : FontWeight.w400,
                    color: labelColor,
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Small red badge used to indicate unread chat count.
class _TwakeBadge extends StatelessWidget {
  final String? count;

  const _TwakeBadge({Key? key, this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool hasCount = count != null && count!.isNotEmpty;
    return Container(
      constraints: const BoxConstraints(
        minWidth: TwakeBottomNavigationStyle.badgeSize,
        minHeight: TwakeBottomNavigationStyle.badgeSize,
      ),
      padding: hasCount
          ? const EdgeInsets.symmetric(horizontal: 4, vertical: 1)
          : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: TwakeBottomNavigationStyle.badgeColor,
        borderRadius: BorderRadius.circular(
          TwakeBottomNavigationStyle.badgeSize / 2,
        ),
      ),
      child: hasCount
          ? Text(
              count!,
              style: const TextStyle(
                fontSize: TwakeBottomNavigationStyle.badgeFontSize,
                color: TwakeBottomNavigationStyle.badgeTextColor,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            )
          : const SizedBox(
              width: TwakeBottomNavigationStyle.badgeSize,
              height: TwakeBottomNavigationStyle.badgeSize,
            ),
    );
  }
}
