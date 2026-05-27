import 'package:flutter/material.dart';

/// Button type variants matching Figma spec.
enum TwakeButtonType { filled, tonal, outlined, text, elevated }

/// Icon placement variants matching Figma spec.
enum TwakeButtonIconConfig { none, leftIcon, rightIcon }

/// Device context affects button height: desktop=40, mobile=48.
enum TwakeButtonDevice { onDesktop, onMobile }

/// Production-ready Twake/Linagora button widget.
/// Supports all Figma variants: type, icon config, state, device, theme.
class TwakeButton extends StatefulWidget {
  /// Button label text.
  final String label;

  /// Visual style of the button.
  final TwakeButtonType type;

  /// Icon placement.
  final TwakeButtonIconConfig iconConfig;

  /// Device context — affects height (desktop: 40px, mobile: 48px).
  final TwakeButtonDevice device;

  /// Whether the button is disabled.
  final bool disabled;

  /// Optional icon widget displayed according to [iconConfig].
  final Widget? icon;

  /// Tap callback — null disables the button.
  final VoidCallback? onTap;

  const TwakeButton({
    Key? key,
    required this.label,
    this.type = TwakeButtonType.filled,
    this.iconConfig = TwakeButtonIconConfig.none,
    this.device = TwakeButtonDevice.onDesktop,
    this.disabled = false,
    this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  State<TwakeButton> createState() => _TwakeButtonState();
}

class _TwakeButtonState extends State<TwakeButton> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  bool get _isDisabled => widget.disabled || widget.onTap == null;

  double get _height =>
      widget.device == TwakeButtonDevice.onMobile ? 48.0 : 40.0;

  // ── Color helpers ──────────────────────────────────────────────────────────

  Color _containerColor(ColorScheme cs) {
    if (_isDisabled) return cs.onSurface.withOpacity(0.12);
    switch (widget.type) {
      case TwakeButtonType.filled:
        if (_pressed) return cs.primary.withOpacity(0.88);
        if (_hovered) return cs.primary.withOpacity(0.92);
        if (_focused) return cs.primary.withOpacity(0.88);
        return cs.primary;
      case TwakeButtonType.tonal:
        if (_pressed) return cs.secondaryContainer.withOpacity(0.88);
        if (_hovered) return cs.secondaryContainer.withOpacity(0.92);
        if (_focused) return cs.secondaryContainer.withOpacity(0.88);
        return cs.secondaryContainer;
      case TwakeButtonType.elevated:
        if (_pressed) return cs.surfaceContainerLow.withOpacity(0.88);
        if (_hovered) return cs.surfaceContainerLow.withOpacity(0.95);
        if (_focused) return cs.surfaceContainerLow.withOpacity(0.88);
        return cs.surfaceContainerLow;
      case TwakeButtonType.outlined:
      case TwakeButtonType.text:
        return Colors.transparent;
    }
  }

  Color _foregroundColor(ColorScheme cs) {
    if (_isDisabled) return cs.onSurface.withOpacity(0.38);
    switch (widget.type) {
      case TwakeButtonType.filled:
        return cs.onPrimary;
      case TwakeButtonType.tonal:
        return cs.onSecondaryContainer;
      case TwakeButtonType.elevated:
      case TwakeButtonType.outlined:
      case TwakeButtonType.text:
        return cs.primary;
    }
  }

  Color? _overlayColor(ColorScheme cs) {
    if (_isDisabled) return null;
    final fg = _foregroundColor(cs);
    if (_pressed) return fg.withOpacity(0.12);
    if (_hovered) return fg.withOpacity(0.08);
    if (_focused) return fg.withOpacity(0.12);
    return null;
  }

  Border? _border(ColorScheme cs) {
    if (widget.type != TwakeButtonType.outlined) return null;
    final color = _isDisabled
        ? cs.onSurface.withOpacity(0.12)
        : (_focused || _pressed)
            ? cs.primary
            : cs.outline;
    return Border.all(color: color, width: 1);
  }

  List<BoxShadow>? _shadows(ColorScheme cs) {
    if (widget.type != TwakeButtonType.elevated || _isDisabled) return null;
    return [
      BoxShadow(
        color: cs.shadow.withOpacity(_hovered ? 0.3 : 0.15),
        blurRadius: _hovered ? 6 : 3,
        offset: const Offset(0, 2),
      ),
    ];
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  Widget _buildContent(Color fgColor) {
    final label = Text(
      widget.label,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: fgColor,
        height: 1.43,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    final iconWidget = widget.icon != null
        ? IconTheme(data: IconThemeData(color: fgColor, size: 18), child: widget.icon!)
        : const SizedBox(width: 18, height: 18);

    switch (widget.iconConfig) {
      case TwakeButtonIconConfig.none:
        return label;
      case TwakeButtonIconConfig.leftIcon:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconWidget,
            const SizedBox(width: 8),
            label,
          ],
        );
      case TwakeButtonIconConfig.rightIcon:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            label,
            const SizedBox(width: 8),
            iconWidget,
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final containerColor = _containerColor(cs);
    final fgColor = _foregroundColor(cs);
    final overlay = _overlayColor(cs);
    final border = _border(cs);
    final shadows = _shadows(cs);

    final EdgeInsets padding = widget.iconConfig == TwakeButtonIconConfig.none
        ? const EdgeInsets.symmetric(horizontal: 24)
        : const EdgeInsets.symmetric(horizontal: 16);

    return Semantics(
      button: true,
      enabled: !_isDisabled,
      label: widget.label,
      child: MouseRegion(
        cursor: _isDisabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
        onEnter: _isDisabled ? null : (_) => setState(() => _hovered = true),
        onExit: _isDisabled ? null : (_) => setState(() => _hovered = false),
        child: FocusableActionDetector(
          onShowFocusHighlight: (v) => setState(() => _focused = v),
          actions: const {},
          child: GestureDetector(
            onTapDown: _isDisabled ? null : (_) => setState(() => _pressed = true),
            onTapUp: _isDisabled
                ? null
                : (_) {
                    setState(() => _pressed = false);
                    widget.onTap?.call();
                  },
            onTapCancel: _isDisabled ? null : () => setState(() => _pressed = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              height: _height,
              padding: padding,
              decoration: BoxDecoration(
                color: overlay != null
                    ? Color.alphaBlend(overlay, containerColor)
                    : containerColor,
                borderRadius: BorderRadius.circular(100),
                border: border,
                boxShadow: shadows,
              ),
              child: Center(
                widthFactor: 1,
                child: _buildContent(fgColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
