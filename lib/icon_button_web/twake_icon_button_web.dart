import 'package:flutter/material.dart';

/// Enum representing the visual configuration of [TwakeIconButtonWeb].
enum TwakeIconButtonConfiguration {
  standard,
  filled,
  outlined,
  tonal,
}

/// Enum representing the theme of [TwakeIconButtonWeb].
enum TwakeIconButtonTheme {
  light,
  dark,
}

/// Style tokens for [TwakeIconButtonWeb].
class TwakeIconButtonWebStyle {
  static const double buttonSize = 36.0;
  static const double iconSize = 20.0;
  static const double borderRadius = 18.0;
  static const double borderWidth = 1.0;

  // Light theme colors
  static const Color lightIconColor = Color(0xFF49454F);
  static const Color lightFilledBackground = Color(0xFF6750A4);
  static const Color lightFilledIcon = Color(0xFFFFFFFF);
  static const Color lightTonalBackground = Color(0xFFE8DEF8);
  static const Color lightTonalIcon = Color(0xFF21005D);
  static const Color lightOutlinedBorder = Color(0xFF79747E);
  static const Color lightHoverOverlay = Color(0x1A6750A4);
  static const Color lightDisabledIcon = Color(0x611C1B1F);
  static const Color lightDisabledBackground = Color(0x1F1C1B1F);
  static const Color lightDisabledBorder = Color(0x1F1C1B1F);

  // Dark theme colors
  static const Color darkIconColor = Color(0xFFCCC2DC);
  static const Color darkFilledBackground = Color(0xFFD0BCFF);
  static const Color darkFilledIcon = Color(0xFF381E72);
  static const Color darkTonalBackground = Color(0xFF4A4458);
  static const Color darkTonalIcon = Color(0xFFE8DEF8);
  static const Color darkOutlinedBorder = Color(0xFF938F99);
  static const Color darkHoverOverlay = Color(0x1ACCC2DC);
  static const Color darkDisabledIcon = Color(0x61E6E1E5);
  static const Color darkDisabledBackground = Color(0x1FE6E1E5);
  static const Color darkDisabledBorder = Color(0x1FE6E1E5);

  const TwakeIconButtonWebStyle._();
}

/// A production-ready icon button widget matching the Figma "Icon button (web)" component.
///
/// Supports [TwakeIconButtonConfiguration] (standard, filled, outlined, tonal)
/// and [TwakeIconButtonTheme] (light, dark), as well as enabled/disabled state
/// and hover/focus/press interactions.
class TwakeIconButtonWeb extends StatefulWidget {
  /// The icon to display inside the button.
  final IconData icon;

  /// Visual configuration of the button.
  final TwakeIconButtonConfiguration configuration;

  /// Theme of the button.
  final TwakeIconButtonTheme buttonTheme;

  /// Whether the button is enabled.
  final bool enabled;

  /// Callback when the button is tapped.
  final VoidCallback? onTap;

  /// Optional tooltip string.
  final String? tooltip;

  const TwakeIconButtonWeb({
    Key? key,
    required this.icon,
    this.configuration = TwakeIconButtonConfiguration.standard,
    this.buttonTheme = TwakeIconButtonTheme.light,
    this.enabled = true,
    this.onTap,
    this.tooltip,
  }) : super(key: key);

  @override
  State<TwakeIconButtonWeb> createState() => _TwakeIconButtonWebState();
}

class _TwakeIconButtonWebState extends State<TwakeIconButtonWeb> {
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;

  bool get _isDark => widget.buttonTheme == TwakeIconButtonTheme.dark;

  Color get _iconColor {
    if (!widget.enabled) {
      return _isDark
          ? TwakeIconButtonWebStyle.darkDisabledIcon
          : TwakeIconButtonWebStyle.lightDisabledIcon;
    }
    switch (widget.configuration) {
      case TwakeIconButtonConfiguration.filled:
        return _isDark
            ? TwakeIconButtonWebStyle.darkFilledIcon
            : TwakeIconButtonWebStyle.lightFilledIcon;
      case TwakeIconButtonConfiguration.tonal:
        return _isDark
            ? TwakeIconButtonWebStyle.darkTonalIcon
            : TwakeIconButtonWebStyle.lightTonalIcon;
      case TwakeIconButtonConfiguration.standard:
      case TwakeIconButtonConfiguration.outlined:
        return _isDark
            ? TwakeIconButtonWebStyle.darkIconColor
            : TwakeIconButtonWebStyle.lightIconColor;
    }
  }

  Color get _backgroundColor {
    if (!widget.enabled) {
      switch (widget.configuration) {
        case TwakeIconButtonConfiguration.filled:
        case TwakeIconButtonConfiguration.tonal:
          return _isDark
              ? TwakeIconButtonWebStyle.darkDisabledBackground
              : TwakeIconButtonWebStyle.lightDisabledBackground;
        case TwakeIconButtonConfiguration.standard:
        case TwakeIconButtonConfiguration.outlined:
          return Colors.transparent;
      }
    }

    Color base;
    switch (widget.configuration) {
      case TwakeIconButtonConfiguration.filled:
        base = _isDark
            ? TwakeIconButtonWebStyle.darkFilledBackground
            : TwakeIconButtonWebStyle.lightFilledBackground;
        break;
      case TwakeIconButtonConfiguration.tonal:
        base = _isDark
            ? TwakeIconButtonWebStyle.darkTonalBackground
            : TwakeIconButtonWebStyle.lightTonalBackground;
        break;
      case TwakeIconButtonConfiguration.standard:
      case TwakeIconButtonConfiguration.outlined:
        base = Colors.transparent;
        break;
    }

    if (_isPressed || _isFocused || _isHovered) {
      final overlay = _isDark
          ? TwakeIconButtonWebStyle.darkHoverOverlay
          : TwakeIconButtonWebStyle.lightHoverOverlay;
      if (base == Colors.transparent) {
        return overlay;
      }
      return Color.alphaBlend(overlay, base);
    }

    return base;
  }

  Border? get _border {
    if (widget.configuration != TwakeIconButtonConfiguration.outlined) {
      return null;
    }
    if (!widget.enabled) {
      return Border.all(
        color: _isDark
            ? TwakeIconButtonWebStyle.darkDisabledBorder
            : TwakeIconButtonWebStyle.lightDisabledBorder,
        width: TwakeIconButtonWebStyle.borderWidth,
      );
    }
    return Border.all(
      color: _isDark
          ? TwakeIconButtonWebStyle.darkOutlinedBorder
          : TwakeIconButtonWebStyle.lightOutlinedBorder,
      width: TwakeIconButtonWebStyle.borderWidth,
    );
  }

  @override
  Widget build(BuildContext context) {
    final button = MouseRegion(
      cursor: widget.enabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.forbidden,
      onEnter: widget.enabled
          ? (_) => setState(() => _isHovered = true)
          : null,
      onExit: widget.enabled
          ? (_) => setState(() => _isHovered = false)
          : null,
      child: GestureDetector(
        onTap: widget.enabled ? widget.onTap : null,
        onTapDown: widget.enabled
            ? (_) => setState(() => _isPressed = true)
            : null,
        onTapUp: widget.enabled
            ? (_) => setState(() => _isPressed = false)
            : null,
        onTapCancel: widget.enabled
            ? () => setState(() => _isPressed = false)
            : null,
        child: Focus(
          onFocusChange: (focused) => setState(() => _isFocused = focused),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: TwakeIconButtonWebStyle.buttonSize,
            height: TwakeIconButtonWebStyle.buttonSize,
            decoration: BoxDecoration(
              color: _backgroundColor,
              borderRadius: BorderRadius.circular(
                TwakeIconButtonWebStyle.borderRadius,
              ),
              border: _border,
            ),
            child: Center(
              child: Icon(
                widget.icon,
                size: TwakeIconButtonWebStyle.iconSize,
                color: _iconColor,
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }
    return button;
  }
}
