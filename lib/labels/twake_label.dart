import 'package:flutter/material.dart';

/// Variant options for [TwakeLabel].
enum TwakeLabelVariant {
  /// Simple label with no trailing widget.
  defaultVariant,

  /// Label with a chevron-down icon (collapsed state).
  collapsed,

  /// Label with a chevron-up icon (expanded state).
  expanded,

  /// Label with a "Clear" text button.
  clearBtn,
}

/// Theme options for [TwakeLabel].
enum TwakeLabelTheme {
  light,
  dark,
}

/// Style tokens for [TwakeLabel].
class TwakeLabelStyle {
  // Dimensions
  static const double height = 36.0;
  static const double width = 234.0;
  static const EdgeInsets padding =
      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);

  // Light theme colors
  static const Color lightBackground = Colors.transparent;
  static const Color lightLabelColor = Color(0xFF1C1B1F);
  static const Color lightSecondaryColor = Color(0xFF49454F);
  static const Color lightClearColor = Color(0xFF1C1B1F);
  static const Color lightIconColor = Color(0xFF49454F);

  // Dark theme colors
  static const Color darkBackground = Colors.transparent;
  static const Color darkLabelColor = Color(0xFF9E9E9E);
  static const Color darkSecondaryColor = Color(0xFF9E9E9E);
  static const Color darkClearColor = Color(0xFF9E9E9E);
  static const Color darkIconColor = Color(0xFF9E9E9E);

  // Typography
  static const TextStyle labelTextStyleLight = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: lightLabelColor,
    letterSpacing: 0.25,
  );

  static const TextStyle labelTextStyleDark = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: darkLabelColor,
    letterSpacing: 0.25,
  );

  static const TextStyle clearTextStyleLight = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: lightClearColor,
    letterSpacing: 0.1,
  );

  static const TextStyle clearTextStyleDark = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: darkClearColor,
    letterSpacing: 0.1,
  );

  const TwakeLabelStyle._();
}

/// A label component matching the Figma "Labels" component set.
///
/// Supports [TwakeLabelVariant] (Default, Collapsed, Expanded, Clear btn)
/// and [TwakeLabelTheme] (Light, Dark).
class TwakeLabel extends StatelessWidget {
  /// The text to display.
  final String label;

  /// The visual variant.
  final TwakeLabelVariant variant;

  /// The color theme.
  final TwakeLabelTheme theme;

  /// Called when the chevron icon is tapped (Collapsed / Expanded variants).
  final VoidCallback? onChevronTap;

  /// Called when the "Clear" button is tapped (Clear btn variant).
  final VoidCallback? onClearTap;

  const TwakeLabel({
    Key? key,
    required this.label,
    this.variant = TwakeLabelVariant.defaultVariant,
    this.theme = TwakeLabelTheme.light,
    this.onChevronTap,
    this.onClearTap,
  }) : super(key: key);

  bool get _isDark => theme == TwakeLabelTheme.dark;

  Color get _labelColor =>
      _isDark ? TwakeLabelStyle.darkLabelColor : TwakeLabelStyle.lightLabelColor;

  Color get _iconColor =>
      _isDark ? TwakeLabelStyle.darkIconColor : TwakeLabelStyle.lightIconColor;

  TextStyle get _labelTextStyle => _isDark
      ? TwakeLabelStyle.labelTextStyleDark
      : TwakeLabelStyle.labelTextStyleLight;

  TextStyle get _clearTextStyle => _isDark
      ? TwakeLabelStyle.clearTextStyleDark
      : TwakeLabelStyle.clearTextStyleLight;

  Widget _buildTrailing() {
    switch (variant) {
      case TwakeLabelVariant.collapsed:
        return GestureDetector(
          onTap: onChevronTap,
          behavior: HitTestBehavior.opaque,
          child: Icon(
            Icons.keyboard_arrow_down,
            size: 20.0,
            color: _iconColor,
          ),
        );
      case TwakeLabelVariant.expanded:
        return GestureDetector(
          onTap: onChevronTap,
          behavior: HitTestBehavior.opaque,
          child: Icon(
            Icons.keyboard_arrow_up,
            size: 20.0,
            color: _iconColor,
          ),
        );
      case TwakeLabelVariant.clearBtn:
        return GestureDetector(
          onTap: onClearTap,
          behavior: HitTestBehavior.opaque,
          child: Text(
            'Clear',
            style: _clearTextStyle,
          ),
        );
      case TwakeLabelVariant.defaultVariant:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasTrailing = variant != TwakeLabelVariant.defaultVariant;

    return SizedBox(
      width: TwakeLabelStyle.width,
      height: TwakeLabelStyle.height,
      child: Padding(
        padding: TwakeLabelStyle.padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                label,
                style: _labelTextStyle,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            if (hasTrailing) ...
              [
                const SizedBox(width: 8.0),
                _buildTrailing(),
              ],
          ],
        ),
      ),
    );
  }
}
