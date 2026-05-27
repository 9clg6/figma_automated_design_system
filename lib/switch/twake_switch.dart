import 'package:flutter/material.dart';

/// Interaction state for [TwakeSwitch].
enum TwakeSwitchState {
  enabled,
  hovered,
  focused,
  pressed,
  disabled,
}

/// Style tokens for [TwakeSwitch].
class TwakeSwitchStyle {
  // Track dimensions
  static const double trackWidth = 52.0;
  static const double trackHeight = 32.0;
  static const double trackRadius = 16.0;

  // Thumb dimensions
  static const double thumbSizeEnabled = 24.0;
  static const double thumbSizeSmall = 16.0;
  static const double thumbSizePressed = 28.0;

  // Padding/margin
  static const double thumbPadding = 4.0;

  // Colors — selected (on)
  static const Color trackOnColor = Color(0xFF2196F3);
  static const Color trackOnDisabledColor = Color(0xFFB3D7F8);
  static const Color thumbOnColor = Colors.white;

  // Colors — unselected (off)
  static const Color trackOffColor = Color(0xFFE0E0E0);
  static const Color trackOffDisabledColor = Color(0xFFF5F5F5);
  static const Color thumbOffColor = Color(0xFF9E9E9E);
  static const Color thumbOffDisabledColor = Color(0xFFBDBDBD);
  static const Color thumbOffHoveredColor = Color(0xFF757575);
  static const Color thumbOffPressedColor = Color(0xFF616161);

  // Overlay (hovered / focused / pressed) on track
  static const Color trackHoverOverlay = Color(0x0A2196F3);
  static const Color trackPressOverlay = Color(0x1A2196F3);
  static const Color trackFocusOverlay = Color(0x1A2196F3);

  // Icon colors
  static const Color iconOnColor = Color(0xFF2196F3);
  static const Color iconOffColor = Color(0xFF9E9E9E);
  static const Color iconDisabledColor = Color(0xFFBDBDBD);

  const TwakeSwitchStyle._();
}

/// A Material 3-style switch widget matching the Linagora/Twake Figma spec.
///
/// Supports [selected], [state], [showIcon], and [onChanged] callback.
/// When [state] is [TwakeSwitchState.disabled], the switch is non-interactive
/// regardless of the [onChanged] callback.
class TwakeSwitch extends StatefulWidget {
  /// Whether the switch is in the "on" (selected) position.
  final bool selected;

  /// The interaction state of the switch.
  /// Defaults to [TwakeSwitchState.enabled].
  final TwakeSwitchState state;

  /// Whether to show a check / close icon inside the thumb.
  final bool showIcon;

  /// Called when the user taps the switch. Ignored when [state] is disabled.
  final ValueChanged<bool>? onChanged;

  const TwakeSwitch({
    Key? key,
    required this.selected,
    this.state = TwakeSwitchState.enabled,
    this.showIcon = false,
    this.onChanged,
  }) : super(key: key);

  @override
  State<TwakeSwitch> createState() => _TwakeSwitchState();
}

class _TwakeSwitchState extends State<TwakeSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _thumbAnimation;

  bool _hovered = false;
  bool _pressed = false;

  bool get _isDisabled => widget.state == TwakeSwitchState.disabled;

  // Effective state merges widget.state with local gesture state
  TwakeSwitchState get _effectiveState {
    if (_isDisabled) return TwakeSwitchState.disabled;
    if (_pressed) return TwakeSwitchState.pressed;
    if (_hovered) return TwakeSwitchState.hovered;
    return widget.state;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: widget.selected ? 1.0 : 0.0,
    );
    _thumbAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(TwakeSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) {
      if (widget.selected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_isDisabled) return;
    widget.onChanged?.call(!widget.selected);
  }

  double get _thumbSize {
    switch (_effectiveState) {
      case TwakeSwitchState.pressed:
        return TwakeSwitchStyle.thumbSizePressed;
      case TwakeSwitchState.enabled:
        if (!widget.selected) return TwakeSwitchStyle.thumbSizeSmall;
        return TwakeSwitchStyle.thumbSizeEnabled;
      default:
        if (!widget.selected) return TwakeSwitchStyle.thumbSizeSmall;
        return TwakeSwitchStyle.thumbSizeEnabled;
    }
  }

  Color get _trackColor {
    if (_isDisabled) {
      return widget.selected
          ? TwakeSwitchStyle.trackOnDisabledColor
          : TwakeSwitchStyle.trackOffDisabledColor;
    }
    if (widget.selected) {
      return TwakeSwitchStyle.trackOnColor;
    }
    return TwakeSwitchStyle.trackOffColor;
  }

  Color get _thumbColor {
    if (_isDisabled) {
      return widget.selected
          ? TwakeSwitchStyle.thumbOnColor
          : TwakeSwitchStyle.thumbOffDisabledColor;
    }
    if (widget.selected) return TwakeSwitchStyle.thumbOnColor;
    switch (_effectiveState) {
      case TwakeSwitchState.pressed:
        return TwakeSwitchStyle.thumbOffPressedColor;
      case TwakeSwitchState.hovered:
        return TwakeSwitchStyle.thumbOffHoveredColor;
      default:
        return TwakeSwitchStyle.thumbOffColor;
    }
  }

  Color? get _overlayColor {
    if (_isDisabled || widget.selected) return null;
    switch (_effectiveState) {
      case TwakeSwitchState.hovered:
        return TwakeSwitchStyle.trackHoverOverlay;
      case TwakeSwitchState.focused:
        return TwakeSwitchStyle.trackFocusOverlay;
      case TwakeSwitchState.pressed:
        return TwakeSwitchStyle.trackPressOverlay;
      default:
        return null;
    }
  }

  Widget? _buildThumbIcon() {
    if (!widget.showIcon) return null;
    if (_isDisabled) {
      return Icon(
        widget.selected ? Icons.check : Icons.close,
        size: 16,
        color: widget.selected
            ? TwakeSwitchStyle.trackOnDisabledColor
            : TwakeSwitchStyle.iconDisabledColor,
      );
    }
    if (widget.selected) {
      return const Icon(
        Icons.check,
        size: 16,
        color: TwakeSwitchStyle.iconOnColor,
      );
    }
    return Icon(
      Icons.close,
      size: 14,
      color: _thumbColor == TwakeSwitchStyle.thumbOnColor
          ? TwakeSwitchStyle.iconOnColor
          : TwakeSwitchStyle.iconOffColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor:
          _isDisabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      onEnter: (_) {
        if (!_isDisabled) setState(() => _hovered = true);
      },
      onExit: (_) {
        setState(() => _hovered = false);
      },
      child: GestureDetector(
        onTapDown: (_) {
          if (!_isDisabled) setState(() => _pressed = true);
        },
        onTapUp: (_) {
          setState(() => _pressed = false);
          _handleTap();
        },
        onTapCancel: () {
          setState(() => _pressed = false);
        },
        child: SizedBox(
          width: TwakeSwitchStyle.trackWidth,
          height: TwakeSwitchStyle.trackHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Track
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: TwakeSwitchStyle.trackWidth,
                height: TwakeSwitchStyle.trackHeight,
                decoration: BoxDecoration(
                  color: _trackColor,
                  borderRadius: BorderRadius.circular(
                    TwakeSwitchStyle.trackRadius,
                  ),
                ),
              ),
              // Overlay for non-selected hover/focus/press
              if (_overlayColor != null)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: TwakeSwitchStyle.trackWidth,
                  height: TwakeSwitchStyle.trackHeight,
                  decoration: BoxDecoration(
                    color: _overlayColor,
                    borderRadius: BorderRadius.circular(
                      TwakeSwitchStyle.trackRadius,
                    ),
                  ),
                ),
              // Thumb
              AnimatedBuilder(
                animation: _thumbAnimation,
                builder: (context, child) {
                  final thumbSize = _thumbSize;
                  final maxTravel = TwakeSwitchStyle.trackWidth -
                      thumbSize -
                      TwakeSwitchStyle.thumbPadding * 2;
                  final offset = TwakeSwitchStyle.thumbPadding +
                      _thumbAnimation.value * maxTravel -
                      (TwakeSwitchStyle.trackWidth / 2 - thumbSize / 2);

                  return Transform.translate(
                    offset: Offset(
                      _thumbAnimation.value *
                          (TwakeSwitchStyle.trackWidth -
                              thumbSize -
                              TwakeSwitchStyle.thumbPadding * 2) -
                          (TwakeSwitchStyle.trackWidth / 2 -
                              thumbSize / 2 -
                              TwakeSwitchStyle.thumbPadding),
                      0,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: thumbSize,
                      height: thumbSize,
                      decoration: BoxDecoration(
                        color: _thumbColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: widget.showIcon
                          ? Center(child: _buildThumbIcon())
                          : null,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
