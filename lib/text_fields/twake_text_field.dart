import 'package:flutter/material.dart';

/// Theme variant for [TwakeTextField].
enum TwakeTextFieldTheme { light, dark }

/// Visual configuration variant for [TwakeTextField].
enum TwakeTextFieldConfiguration { filled, outline }

/// State variant for [TwakeTextField].
enum TwakeTextFieldState { enable, hovered, focused, error, disabled }

/// Style tokens for [TwakeTextField].
class TwakeTextFieldStyle {
  // Dimensions
  static const double borderRadius = 4.0;
  static const double fieldHeight = 56.0;
  static const double borderWidth = 1.0;
  static const double focusedBorderWidth = 2.0;
  static const double labelFontSize = 12.0;
  static const double inputFontSize = 16.0;
  static const double supportingFontSize = 12.0;
  static const EdgeInsets contentPadding =
      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);

  // Light theme colors
  static const Color lightBackground = Color(0xFFECECEC);
  static const Color lightHoveredBackground = Color(0xFFE2E2E2);
  static const Color lightDisabledBackground = Color(0xFFF5F5F5);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightOnSurface = Color(0xFF1C1B1F);
  static const Color lightOnSurfaceVariant = Color(0xFF49454F);
  static const Color lightOutline = Color(0xFF79747E);
  static const Color lightOutlineVariant = Color(0xFFCAC4D0);
  static const Color lightPrimary = Color(0xFF1565C0);
  static const Color lightError = Color(0xFFB3261E);
  static const Color lightDisabledContent = Color(0x611C1B1F);
  static const Color lightDisabledBorder = Color(0x1F1C1B1F);

  // Dark theme colors
  static const Color darkBackground = Color(0xFF313033);
  static const Color darkHoveredBackground = Color(0xFF3A3A3D);
  static const Color darkDisabledBackground = Color(0xFF2B2B2E);
  static const Color darkSurface = Color(0xFF1C1B1F);
  static const Color darkOnSurface = Color(0xFFE6E1E5);
  static const Color darkOnSurfaceVariant = Color(0xFFCAC4D0);
  static const Color darkOutline = Color(0xFF938F99);
  static const Color darkOutlineVariant = Color(0xFF49454F);
  static const Color darkPrimary = Color(0xFFD0BCFF);
  static const Color darkError = Color(0xFFF2B8B5);
  static const Color darkDisabledContent = Color(0x61E6E1E5);
  static const Color darkDisabledBorder = Color(0x1FE6E1E5);

  const TwakeTextFieldStyle._();
}

/// A Twake/Linagora-branded text field component matching the Figma "Text Fields"
/// component set.
///
/// Supports [TwakeTextFieldTheme] (light/dark),
/// [TwakeTextFieldConfiguration] (filled/outline),
/// and [TwakeTextFieldState] (enable/hovered/focused/error/disabled).
class TwakeTextField extends StatefulWidget {
  /// Label displayed above the input area.
  final String label;

  /// Hint / placeholder text inside the input.
  final String? hintText;

  /// Controller for the underlying [TextField].
  final TextEditingController? controller;

  /// Supporting / helper text shown below the field.
  final String supportingText;

  /// Whether to show the supporting text row.
  final bool showSupportingText;

  /// Whether to show the trailing clear icon.
  final bool showTrailingIcon;

  /// Light or dark theme.
  final TwakeTextFieldTheme theme;

  /// Filled or outline configuration.
  final TwakeTextFieldConfiguration configuration;

  /// Explicit state override. When null, state is managed internally
  /// (hover / focus tracked via listeners).
  final TwakeTextFieldState? state;

  /// Called when the clear icon is tapped.
  final VoidCallback? onClear;

  /// Called on text change.
  final ValueChanged<String>? onChanged;

  /// Called when the field is submitted.
  final ValueChanged<String>? onSubmitted;

  /// Focus node — optional external control.
  final FocusNode? focusNode;

  /// Whether the field is obscured (password).
  final bool obscureText;

  /// Keyboard type.
  final TextInputType? keyboardType;

  const TwakeTextField({
    Key? key,
    this.label = 'Label',
    this.hintText,
    this.controller,
    this.supportingText = 'Supporting text',
    this.showSupportingText = true,
    this.showTrailingIcon = true,
    this.theme = TwakeTextFieldTheme.light,
    this.configuration = TwakeTextFieldConfiguration.outline,
    this.state,
    this.onClear,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.obscureText = false,
    this.keyboardType,
  }) : super(key: key);

  @override
  State<TwakeTextField> createState() => _TwakeTextFieldState();
}

class _TwakeTextFieldState extends State<TwakeTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _isHovered = false;

  TwakeTextFieldState get _effectiveState {
    if (widget.state != null) return widget.state!;
    if (_isFocused) return TwakeTextFieldState.focused;
    if (_isHovered) return TwakeTextFieldState.hovered;
    return TwakeTextFieldState.enable;
  }

  bool get _isDark => widget.theme == TwakeTextFieldTheme.dark;
  bool get _isFilled =>
      widget.configuration == TwakeTextFieldConfiguration.filled;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.removeListener(_onFocusChange);
      _focusNode.dispose();
    }
    super.dispose();
  }

  // ── Color helpers ────────────────────────────────────────────────────────

  Color get _labelColor {
    final state = _effectiveState;
    if (state == TwakeTextFieldState.disabled) {
      return _isDark
          ? TwakeTextFieldStyle.darkDisabledContent
          : TwakeTextFieldStyle.lightDisabledContent;
    }
    if (state == TwakeTextFieldState.error) {
      return _isDark
          ? TwakeTextFieldStyle.darkError
          : TwakeTextFieldStyle.lightError;
    }
    if (state == TwakeTextFieldState.focused) {
      return _isDark
          ? TwakeTextFieldStyle.darkPrimary
          : TwakeTextFieldStyle.lightPrimary;
    }
    return _isDark
        ? TwakeTextFieldStyle.darkOnSurfaceVariant
        : TwakeTextFieldStyle.lightOnSurfaceVariant;
  }

  Color get _inputColor {
    final state = _effectiveState;
    if (state == TwakeTextFieldState.disabled) {
      return _isDark
          ? TwakeTextFieldStyle.darkDisabledContent
          : TwakeTextFieldStyle.lightDisabledContent;
    }
    return _isDark
        ? TwakeTextFieldStyle.darkOnSurface
        : TwakeTextFieldStyle.lightOnSurface;
  }

  Color get _supportingColor {
    final state = _effectiveState;
    if (state == TwakeTextFieldState.error) {
      return _isDark
          ? TwakeTextFieldStyle.darkError
          : TwakeTextFieldStyle.lightError;
    }
    if (state == TwakeTextFieldState.disabled) {
      return _isDark
          ? TwakeTextFieldStyle.darkDisabledContent
          : TwakeTextFieldStyle.lightDisabledContent;
    }
    return _isDark
        ? TwakeTextFieldStyle.darkOnSurfaceVariant
        : TwakeTextFieldStyle.lightOnSurfaceVariant;
  }

  Color get _fillColor {
    if (!_isFilled) return Colors.transparent;
    final state = _effectiveState;
    if (_isDark) {
      if (state == TwakeTextFieldState.disabled) {
        return TwakeTextFieldStyle.darkDisabledBackground;
      }
      if (state == TwakeTextFieldState.hovered) {
        return TwakeTextFieldStyle.darkHoveredBackground;
      }
      return TwakeTextFieldStyle.darkBackground;
    } else {
      if (state == TwakeTextFieldState.disabled) {
        return TwakeTextFieldStyle.lightDisabledBackground;
      }
      if (state == TwakeTextFieldState.hovered) {
        return TwakeTextFieldStyle.lightHoveredBackground;
      }
      return TwakeTextFieldStyle.lightBackground;
    }
  }

  Color get _borderColor {
    final state = _effectiveState;
    if (state == TwakeTextFieldState.disabled) {
      return _isDark
          ? TwakeTextFieldStyle.darkDisabledBorder
          : TwakeTextFieldStyle.lightDisabledBorder;
    }
    if (state == TwakeTextFieldState.error) {
      return _isDark
          ? TwakeTextFieldStyle.darkError
          : TwakeTextFieldStyle.lightError;
    }
    if (state == TwakeTextFieldState.focused) {
      return _isDark
          ? TwakeTextFieldStyle.darkPrimary
          : TwakeTextFieldStyle.lightPrimary;
    }
    if (state == TwakeTextFieldState.hovered) {
      return _isDark
          ? TwakeTextFieldStyle.darkOnSurface
          : TwakeTextFieldStyle.lightOnSurface;
    }
    return _isDark
        ? TwakeTextFieldStyle.darkOutline
        : TwakeTextFieldStyle.lightOutline;
  }

  double get _borderWidth {
    return _effectiveState == TwakeTextFieldState.focused
        ? TwakeTextFieldStyle.focusedBorderWidth
        : TwakeTextFieldStyle.borderWidth;
  }

  Color get _iconColor {
    final state = _effectiveState;
    if (state == TwakeTextFieldState.disabled) {
      return _isDark
          ? TwakeTextFieldStyle.darkDisabledContent
          : TwakeTextFieldStyle.lightDisabledContent;
    }
    if (state == TwakeTextFieldState.error) {
      return _isDark
          ? TwakeTextFieldStyle.darkError
          : TwakeTextFieldStyle.lightError;
    }
    return _isDark
        ? TwakeTextFieldStyle.darkOnSurfaceVariant
        : TwakeTextFieldStyle.lightOnSurfaceVariant;
  }

  // ── InputDecoration ──────────────────────────────────────────────────────

  InputDecoration _buildDecoration() {
    final state = _effectiveState;
    final isDisabled = state == TwakeTextFieldState.disabled;
    final isError = state == TwakeTextFieldState.error;

    final OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(TwakeTextFieldStyle.borderRadius),
      borderSide: BorderSide(
        color: _borderColor,
        width: _borderWidth,
      ),
    );

    return InputDecoration(
      labelText: widget.label,
      labelStyle: TextStyle(
        color: _labelColor,
        fontSize: TwakeTextFieldStyle.labelFontSize,
      ),
      hintText: widget.hintText,
      hintStyle: TextStyle(
        color: _isDark
            ? TwakeTextFieldStyle.darkOnSurfaceVariant
            : TwakeTextFieldStyle.lightOnSurfaceVariant,
        fontSize: TwakeTextFieldStyle.inputFontSize,
      ),
      filled: true,
      fillColor: _fillColor,
      suffixIcon: widget.showTrailingIcon
          ? IconButton(
              icon: Icon(
                isError ? Icons.error : Icons.cancel,
                color: _iconColor,
                size: 20,
              ),
              onPressed: isDisabled ? null : widget.onClear,
              splashRadius: 18,
            )
          : null,
      helperText: widget.showSupportingText ? widget.supportingText : null,
      helperStyle: TextStyle(
        color: _supportingColor,
        fontSize: TwakeTextFieldStyle.supportingFontSize,
      ),
      errorText:
          (isError && widget.showSupportingText) ? widget.supportingText : null,
      errorStyle: TextStyle(
        color: _isDark
            ? TwakeTextFieldStyle.darkError
            : TwakeTextFieldStyle.lightError,
        fontSize: TwakeTextFieldStyle.supportingFontSize,
      ),
      contentPadding: TwakeTextFieldStyle.contentPadding,
      border: border,
      enabledBorder: border,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(TwakeTextFieldStyle.borderRadius),
        borderSide: BorderSide(
          color: _borderColor,
          width: _borderWidth,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(TwakeTextFieldStyle.borderRadius),
        borderSide: BorderSide(
          color: isError
              ? (_isDark
                  ? TwakeTextFieldStyle.darkError
                  : TwakeTextFieldStyle.lightError)
              : _borderColor,
          width: TwakeTextFieldStyle.borderWidth,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(TwakeTextFieldStyle.borderRadius),
        borderSide: BorderSide(
          color: _isDark
              ? TwakeTextFieldStyle.darkError
              : TwakeTextFieldStyle.lightError,
          width: TwakeTextFieldStyle.focusedBorderWidth,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(TwakeTextFieldStyle.borderRadius),
        borderSide: BorderSide(
          color: _isDark
              ? TwakeTextFieldStyle.darkDisabledBorder
              : TwakeTextFieldStyle.lightDisabledBorder,
          width: TwakeTextFieldStyle.borderWidth,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = _effectiveState;
    final isDisabled = state == TwakeTextFieldState.disabled;
    final isError = state == TwakeTextFieldState.error;

    final bgColor = _isDark
        ? TwakeTextFieldStyle.darkSurface
        : TwakeTextFieldStyle.lightSurface;

    return MouseRegion(
      onEnter: (_) {
        if (widget.state == null) setState(() => _isHovered = true);
      },
      onExit: (_) {
        if (widget.state == null) setState(() => _isHovered = false);
      },
      child: Container(
        color: bgColor,
        child: TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          enabled: !isDisabled,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          style: TextStyle(
            color: _inputColor,
            fontSize: TwakeTextFieldStyle.inputFontSize,
          ),
          decoration: _buildDecoration().copyWith(
            // When state is error, pass errorText to activate error styling.
            errorText: isError && widget.showSupportingText
                ? widget.supportingText
                : null,
            helperText: (!isError && widget.showSupportingText)
                ? widget.supportingText
                : null,
          ),
        ),
      ),
    );
  }
}
