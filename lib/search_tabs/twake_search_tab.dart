import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/search_tabs/twake_search_tab_style.dart';

/// A single tab item used in search/navigation tab bars.
///
/// Supports active/inactive state, optional leading icon,
/// optional badge (single or multi-digit), and an optional divider.
class TwakeSearchTab extends StatelessWidget {
  /// The label text displayed in the tab.
  final String label;

  /// Whether this tab is currently active/selected.
  final bool active;

  /// Whether to show a leading icon (dot indicator).
  final bool leadingIcon;

  /// Whether to show a single-digit badge.
  final bool singleBadge;

  /// Whether to show a multi-digit badge.
  final bool badgesMultipleDigit;

  /// Whether to show the bottom divider/indicator line.
  final bool divider;

  /// Badge count to display when [singleBadge] or [badgesMultipleDigit] is true.
  final int badgeCount;

  /// Callback when the tab is tapped.
  final VoidCallback? onTap;

  const TwakeSearchTab({
    Key? key,
    this.label = 'Tab',
    this.active = false,
    this.leadingIcon = false,
    this.singleBadge = false,
    this.badgesMultipleDigit = false,
    this.divider = true,
    this.badgeCount = 1,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final labelColor = active
        ? TwakeSearchTabStyle.activeColor(colorScheme)
        : TwakeSearchTabStyle.inactiveColor(colorScheme);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: TwakeSearchTabStyle.tabHeight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: TwakeSearchTabStyle.contentPadding,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (leadingIcon) ...
                    [
                      _LeadingDot(active: active, colorScheme: colorScheme),
                      const SizedBox(width: TwakeSearchTabStyle.iconLabelSpacing),
                    ],
                  Text(
                    label,
                    style: TwakeSearchTabStyle.labelStyle(context, active),
                  ),
                  if (singleBadge || badgesMultipleDigit) ...
                    [
                      const SizedBox(width: TwakeSearchTabStyle.badgeLabelSpacing),
                      _Badge(
                        count: badgesMultipleDigit ? badgeCount : 1,
                        multiDigit: badgesMultipleDigit,
                        active: active,
                        colorScheme: colorScheme,
                      ),
                    ],
                ],
              ),
            ),
            const SizedBox(height: TwakeSearchTabStyle.indicatorTopSpacing),
            if (divider)
              _BottomIndicator(active: active, colorScheme: colorScheme)
            else
              const SizedBox(height: TwakeSearchTabStyle.indicatorHeight),
          ],
        ),
      ),
    );
  }
}

class _LeadingDot extends StatelessWidget {
  final bool active;
  final ColorScheme colorScheme;

  const _LeadingDot({required this.active, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: TwakeSearchTabStyle.dotSize,
      height: TwakeSearchTabStyle.dotSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active
            ? TwakeSearchTabStyle.activeColor(colorScheme)
            : TwakeSearchTabStyle.inactiveColor(colorScheme),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final int count;
  final bool multiDigit;
  final bool active;
  final ColorScheme colorScheme;

  const _Badge({
    required this.count,
    required this.multiDigit,
    required this.active,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final color = active
        ? TwakeSearchTabStyle.activeColor(colorScheme)
        : TwakeSearchTabStyle.inactiveColor(colorScheme);
    if (!multiDigit) {
      // Single badge: small filled dot
      return Container(
        width: TwakeSearchTabStyle.singleBadgeSize,
        height: TwakeSearchTabStyle.singleBadgeSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      );
    }
    // Multi-digit badge: pill shape with number
    return Container(
      padding: TwakeSearchTabStyle.badgePadding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(TwakeSearchTabStyle.badgeBorderRadius),
      ),
      child: Text(
        count.toString(),
        style: TwakeSearchTabStyle.badgeTextStyle,
      ),
    );
  }
}

class _BottomIndicator extends StatelessWidget {
  final bool active;
  final ColorScheme colorScheme;

  const _BottomIndicator({required this.active, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: TwakeSearchTabStyle.indicatorHeight,
      decoration: BoxDecoration(
        color: active
            ? TwakeSearchTabStyle.activeColor(colorScheme)
            : TwakeSearchTabStyle.dividerColor(colorScheme),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TwakeSearchTabStyle.indicatorBorderRadius),
        ),
      ),
    );
  }
}
