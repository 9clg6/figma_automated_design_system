import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linear_progress_indicator/twake_linear_progress_indicator_style.dart';

/// A linear progress indicator following the Linagora / Twake design system.
///
/// Wraps [LinearProgressIndicator] with design-token colours and a fixed
/// height of 4 dp.  Pass [value] in [0, 1] for a determinate bar, or leave
/// it null for an indeterminate (animated) bar.
///
/// ```dart
/// TwakeLinearProgressIndicator(value: 0.75)
/// TwakeLinearProgressIndicator()  // indeterminate
/// ```
class TwakeLinearProgressIndicator extends StatelessWidget {
  /// Progress value in the range [0.0, 1.0].
  /// Null → indeterminate (animated) indicator.
  final double? value;

  /// Override the filled / active colour.
  /// Defaults to [TwakeLinearProgressIndicatorStyle.activeColor].
  final Color? activeColor;

  /// Override the track / background colour.
  /// Defaults to [TwakeLinearProgressIndicatorStyle.trackColor].
  final Color? trackColor;

  /// Minimum width of the bar. Defaults to [double.infinity].
  final double? minWidth;

  const TwakeLinearProgressIndicator({
    Key? key,
    this.value,
    this.activeColor,
    this.trackColor,
    this.minWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = TwakeLinearProgressIndicatorStyle.material();

    return SizedBox(
      height: style.height,
      width: minWidth ?? double.infinity,
      child: ClipRRect(
        borderRadius: style.borderRadius,
        child: LinearProgressIndicator(
          value: value,
          backgroundColor: trackColor ?? style.trackColor,
          valueColor: AlwaysStoppedAnimation<Color>(
            activeColor ?? style.activeColor,
          ),
          minHeight: style.height,
        ),
      ),
    );
  }
}
