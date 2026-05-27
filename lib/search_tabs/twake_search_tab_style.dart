import 'package:flutter/material.dart';

/// Design tokens for [TwakeSearchTab].
class TwakeSearchTabStyle {
  TwakeSearchTabStyle._();

  // ── Tab sizing ────────────────────────────────────────────────
  static const double tabHeight = 48.0;
  static const EdgeInsets contentPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 0);

  // ── Colours ───────────────────────────────────────────────────
  static Color activeColor(ColorScheme cs) => cs.primary;
  static Color inactiveColor(ColorScheme cs) => cs.onSurfaceVariant;
  static Color dividerColor(ColorScheme cs) => cs.outlineVariant;

  // ── Typography ────────────────────────────────────────────────
  static TextStyle labelStyle(BuildContext context, bool active) {
    return TextStyle(
      fontSize: 14,
      fontWeight: active ? FontWeight.w600 : FontWeight.w500,
      letterSpacing: 0.1,
      color: active
          ? activeColor(Theme.of(context).colorScheme)
          : inactiveColor(Theme.of(context).colorScheme),
    );
  }

  // ── Spacing ───────────────────────────────────────────────────
  static const double iconLabelSpacing = 8.0;
  static const double badgeLabelSpacing = 8.0;
  static const double indicatorTopSpacing = 4.0;

  // ── Indicator ─────────────────────────────────────────────────
  static const double indicatorHeight = 3.0;
  static const double indicatorBorderRadius = 3.0;

  // ── Leading dot ───────────────────────────────────────────────
  static const double dotSize = 6.0;

  // ── Badge ─────────────────────────────────────────────────────
  static const double singleBadgeSize = 6.0;
  static const double badgeBorderRadius = 10.0;
  static const EdgeInsets badgePadding =
      EdgeInsets.symmetric(horizontal: 6, vertical: 1);
  static const TextStyle badgeTextStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}
