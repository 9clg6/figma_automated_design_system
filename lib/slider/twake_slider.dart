import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';

/// Slider type variant matching Figma: Continuous or Discrete
enum TwakeSliderType { continuous, discrete }

/// Style tokens for TwakeSlider
class TwakeSliderStyle {
  static const double trackHeight = 4.0;
  static const double thumbRadius = 10.0;
  static const double thumbPressedRadius = 14.0;
  static const double overlayRadius = 20.0;
  static const double tickMarkRadius = 2.0;
  static const double valueIndicatorTextSize = 11.0;
  static const int discreteDivisions = 4;

  static const Color activeTrackColor = Color(0xFF1565C0);
  static const Color inactiveTrackColor = Color(0xFFBBBBBB);
  static const Color disabledActiveTrackColor = Color(0xFFBBBBBB);
  static const Color disabledInactiveTrackColor = Color(0xFFDDDDDD);
  static const Color disabledThumbColor = Color(0xFF9E9E9E);
  static const Color thumbColor = Color(0xFF1565C0);
  static const Color overlayColor = Color(0x291565C0);
  static const Color valueIndicatorColor = Color(0xFF1565C0);
  static const Color valueIndicatorTextColor = Colors.white;

  const TwakeSliderStyle._();
}

/// A Material 3 styled slider widget matching Linagora / Twake Figma specs.
/// Supports Continuous and Discrete types, all interactive states,
/// and shows a value label bubble when active.
class TwakeSlider extends StatefulWidget {
  /// Current value of the slider (0.0 – 1.0).
  final double value;

  /// Called when the value changes.
  final ValueChanged<double>? onChanged;

  /// Called when the user starts dragging.
  final ValueChanged<double>? onChangeStart;

  /// Called when the user finishes dragging.
  final ValueChanged<double>? onChangeEnd;

  /// Slider type: continuous (smooth) or discrete (stepped).
  final TwakeSliderType type;

  /// Whether the slider is disabled.
  final bool disabled;

  /// Minimum value (used for label display).
  final double min;

  /// Maximum value (used for label display).
  final double max;

  const TwakeSlider({
    Key? key,
    required this.value,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.type = TwakeSliderType.continuous,
    this.disabled = false,
    this.min = 0.0,
    this.max = 100.0,
  }) : super(key: key);

  @override
  State<TwakeSlider> createState() => _TwakeSliderState();
}

class _TwakeSliderState extends State<TwakeSlider> {
  bool _hovered = false;
  bool _pressed = false;

  double get _sliderValue =>
      widget.min + widget.value * (widget.max - widget.min);

  int? get _divisions =>
      widget.type == TwakeSliderType.discrete
          ? TwakeSliderStyle.discreteDivisions
          : null;

  SliderThemeData _buildSliderTheme(BuildContext context) {
    final base = SliderTheme.of(context);

    final bool isDisabled = widget.disabled;
    final bool showLabel = _pressed || _hovered;

    return base.copyWith(
      trackHeight: TwakeSliderStyle.trackHeight,
      activeTrackColor: isDisabled
          ? TwakeSliderStyle.disabledActiveTrackColor
          : TwakeSliderStyle.activeTrackColor,
      inactiveTrackColor: isDisabled
          ? TwakeSliderStyle.disabledInactiveTrackColor
          : TwakeSliderStyle.inactiveTrackColor,
      thumbColor: isDisabled
          ? TwakeSliderStyle.disabledThumbColor
          : TwakeSliderStyle.thumbColor,
      overlayColor: isDisabled
          ? Colors.transparent
          : TwakeSliderStyle.overlayColor,
      thumbShape: _TwakeThumbShape(
        radius: (_pressed && !isDisabled)
            ? TwakeSliderStyle.thumbPressedRadius
            : TwakeSliderStyle.thumbRadius,
        color: isDisabled
            ? TwakeSliderStyle.disabledThumbColor
            : TwakeSliderStyle.thumbColor,
        showHalo: (_hovered || _pressed) && !isDisabled,
        haloColor: TwakeSliderStyle.overlayColor,
        haloRadius: TwakeSliderStyle.overlayRadius,
      ),
      overlayShape: SliderComponentShape.noOverlay,
      trackShape: const RoundedRectSliderTrackShape(),
      tickMarkShape: widget.type == TwakeSliderType.discrete
          ? const RoundSliderTickMarkShape(
              tickMarkRadius: TwakeSliderStyle.tickMarkRadius,
            )
          : SliderTickMarkShape.noTickMark,
      activeTickMarkColor: isDisabled
          ? TwakeSliderStyle.disabledActiveTrackColor
          : TwakeSliderStyle.activeTrackColor,
      inactiveTickMarkColor: isDisabled
          ? TwakeSliderStyle.disabledInactiveTrackColor
          : TwakeSliderStyle.inactiveTrackColor,
      showValueIndicator: showLabel && !isDisabled
          ? ShowValueIndicator.always
          : ShowValueIndicator.never,
      valueIndicatorShape: const DropSliderValueIndicatorShape(),
      valueIndicatorColor: TwakeSliderStyle.valueIndicatorColor,
      valueIndicatorTextStyle: const TextStyle(
        fontSize: TwakeSliderStyle.valueIndicatorTextSize,
        fontWeight: FontWeight.w500,
        color: TwakeSliderStyle.valueIndicatorTextColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        if (!widget.disabled) setState(() => _hovered = true);
      },
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: (_) {
          if (!widget.disabled) setState(() => _pressed = true);
        },
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: SliderTheme(
          data: _buildSliderTheme(context),
          child: Slider(
            value: _sliderValue,
            min: widget.min,
            max: widget.max,
            divisions: _divisions,
            label: _sliderValue.round().toString(),
            onChanged: widget.disabled
                ? null
                : (v) {
                    setState(() => _pressed = true);
                    widget.onChanged
                        ?.call((v - widget.min) / (widget.max - widget.min));
                  },
            onChangeStart: widget.disabled
                ? null
                : (v) {
                    setState(() => _pressed = true);
                    widget.onChangeStart
                        ?.call((v - widget.min) / (widget.max - widget.min));
                  },
            onChangeEnd: widget.disabled
                ? null
                : (v) {
                    setState(() => _pressed = false);
                    widget.onChangeEnd
                        ?.call((v - widget.min) / (widget.max - widget.min));
                  },
          ),
        ),
      ),
    );
  }
}

/// Custom thumb shape with optional halo ring for hovered/pressed states.
class _TwakeThumbShape extends SliderComponentShape {
  final double radius;
  final Color color;
  final bool showHalo;
  final Color haloColor;
  final double haloRadius;

  const _TwakeThumbShape({
    required this.radius,
    required this.color,
    required this.showHalo,
    required this.haloColor,
    required this.haloRadius,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      Size.fromRadius(haloRadius);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    if (showHalo) {
      final haloPaint = Paint()
        ..color = haloColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, haloRadius, haloPaint);
    }

    final thumbPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, thumbPaint);
  }
}
