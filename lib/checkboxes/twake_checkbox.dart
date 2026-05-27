import 'package:flutter/material.dart';

/// Checkbox type variants matching Figma spec
enum TwakeCheckboxType {
  selected,
  unselected,
  indeterminate,
  errorSelected,
  errorUnselected,
  errorIndeterminate,
}

/// Checkbox state variants matching Figma spec
enum TwakeCheckboxState {
  enabled,
  hovered,
  focused,
  pressed,
  disabled,
}

/// Style tokens for [TwakeCheckbox]
class TwakeCheckboxStyle {
  static const double boxSize = 18.0;
  static const double touchTargetSize = 48.0;
  static const double borderWidth = 2.0;
  static const double borderRadius = 2.0;
  static const double rippleRadius = 20.0;

  // Normal colors
  static const Color primaryColor = Color(0xFF1565C0);
  static const Color uncheckedBorderColor = Color(0xFF49454F);
  static const Color disabledColor = Color(0x611C1B1F);
  static const Color disabledBorderColor = Color(0x611C1B1F);

  // Error colors
  static const Color errorColor = Color(0xFFB3261E);

  // Ripple / overlay colors
  static const Color primaryRipple = Color(0x1A1565C0);
  static const Color errorRipple = Color(0x1AB3261E);
  static const Color neutralRipple = Color(0x1A49454F);

  const TwakeCheckboxStyle._();
}

/// A Twake-branded checkbox widget matching Figma Checkboxes component.
///
/// Supports all [TwakeCheckboxType] and [TwakeCheckboxState] variants.
/// Use [onChanged] to react to user interaction.
class TwakeCheckbox extends StatefulWidget {
  /// The visual type/value of the checkbox.
  final TwakeCheckboxType type;

  /// The interactive state of the checkbox.
  /// When null, state is managed internally (hover/press).
  final TwakeCheckboxState? state;

  /// Called when the checkbox is tapped (if not disabled).
  final ValueChanged<TwakeCheckboxType>? onChanged;

  const TwakeCheckbox({
    Key? key,
    required this.type,
    this.state,
    this.onChanged,
  }) : super(key: key);

  @override
  State<TwakeCheckbox> createState() => _TwakeCheckboxState();
}

class _TwakeCheckboxState extends State<TwakeCheckbox> {
  bool _hovered = false;
  bool _pressed = false;

  TwakeCheckboxState get _effectiveState {
    if (widget.state != null) return widget.state!;
    if (_isDisabled) return TwakeCheckboxState.disabled;
    if (_pressed) return TwakeCheckboxState.pressed;
    if (_hovered) return TwakeCheckboxState.hovered;
    return TwakeCheckboxState.enabled;
  }

  bool get _isDisabled => widget.state == TwakeCheckboxState.disabled;

  bool get _isError =>
      widget.type == TwakeCheckboxType.errorSelected ||
      widget.type == TwakeCheckboxType.errorUnselected ||
      widget.type == TwakeCheckboxType.errorIndeterminate;

  bool get _isSelected =>
      widget.type == TwakeCheckboxType.selected ||
      widget.type == TwakeCheckboxType.errorSelected;

  bool get _isIndeterminate =>
      widget.type == TwakeCheckboxType.indeterminate ||
      widget.type == TwakeCheckboxType.errorIndeterminate;

  Color get _activeColor {
    if (_isDisabled) return TwakeCheckboxStyle.disabledColor;
    if (_isError) return TwakeCheckboxStyle.errorColor;
    return TwakeCheckboxStyle.primaryColor;
  }

  Color get _borderColor {
    if (_isDisabled) return TwakeCheckboxStyle.disabledBorderColor;
    if (_isError) return TwakeCheckboxStyle.errorColor;
    if (_isSelected || _isIndeterminate) return TwakeCheckboxStyle.primaryColor;
    return TwakeCheckboxStyle.uncheckedBorderColor;
  }

  Color get _rippleColor {
    if (_isError) return TwakeCheckboxStyle.errorRipple;
    if (_isSelected || _isIndeterminate) return TwakeCheckboxStyle.primaryRipple;
    return TwakeCheckboxStyle.neutralRipple;
  }

  bool get _showRipple =>
      !_isDisabled &&
      (_effectiveState == TwakeCheckboxState.hovered ||
          _effectiveState == TwakeCheckboxState.focused ||
          _effectiveState == TwakeCheckboxState.pressed);

  void _handleTap() {
    if (_isDisabled) return;
    widget.onChanged?.call(widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: TwakeCheckboxStyle.touchTargetSize,
      height: TwakeCheckboxStyle.touchTargetSize,
      child: MouseRegion(
        cursor: _isDisabled
            ? SystemMouseCursors.forbidden
            : SystemMouseCursors.click,
        onEnter: (_) {
          if (!_isDisabled && widget.state == null) {
            setState(() => _hovered = true);
          }
        },
        onExit: (_) {
          if (widget.state == null) {
            setState(() {
              _hovered = false;
              _pressed = false;
            });
          }
        },
        child: GestureDetector(
          onTapDown: (_) {
            if (!_isDisabled && widget.state == null) {
              setState(() => _pressed = true);
            }
          },
          onTapUp: (_) {
            if (widget.state == null) {
              setState(() => _pressed = false);
            }
            _handleTap();
          },
          onTapCancel: () {
            if (widget.state == null) {
              setState(() => _pressed = false);
            }
          },
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Ripple / overlay circle
                if (_showRipple)
                  Container(
                    width: TwakeCheckboxStyle.rippleRadius * 2,
                    height: TwakeCheckboxStyle.rippleRadius * 2,
                    decoration: BoxDecoration(
                      color: _rippleColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                // Checkbox box
                _CheckboxBox(
                  isSelected: _isSelected,
                  isIndeterminate: _isIndeterminate,
                  isDisabled: _isDisabled,
                  activeColor: _activeColor,
                  borderColor: _borderColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CheckboxBox extends StatelessWidget {
  final bool isSelected;
  final bool isIndeterminate;
  final bool isDisabled;
  final Color activeColor;
  final Color borderColor;

  const _CheckboxBox({
    required this.isSelected,
    required this.isIndeterminate,
    required this.isDisabled,
    required this.activeColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final filled = isSelected || isIndeterminate;

    return Container(
      width: TwakeCheckboxStyle.boxSize,
      height: TwakeCheckboxStyle.boxSize,
      decoration: BoxDecoration(
        color: filled ? activeColor : Colors.transparent,
        borderRadius:
            BorderRadius.circular(TwakeCheckboxStyle.borderRadius),
        border: filled
            ? null
            : Border.all(
                color: borderColor,
                width: TwakeCheckboxStyle.borderWidth,
              ),
      ),
      child: filled
          ? Center(
              child: isIndeterminate
                  ? _IndeterminateIcon(isDisabled: isDisabled)
                  : _CheckIcon(isDisabled: isDisabled),
            )
          : null,
    );
  }
}

class _CheckIcon extends StatelessWidget {
  final bool isDisabled;

  const _CheckIcon({required this.isDisabled});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.check,
      size: 14.0,
      color: isDisabled ? Colors.white54 : Colors.white,
    );
  }
}

class _IndeterminateIcon extends StatelessWidget {
  final bool isDisabled;

  const _IndeterminateIcon({required this.isDisabled});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10.0,
      height: 2.0,
      decoration: BoxDecoration(
        color: isDisabled ? Colors.white54 : Colors.white,
        borderRadius: BorderRadius.circular(1.0),
      ),
    );
  }
}
