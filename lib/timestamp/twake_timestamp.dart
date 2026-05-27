import 'package:flutter/material.dart';

/// Defines the display format for [TwakeTimestamp].
enum TimestampType {
  /// Displays "Today" label.
  today,

  /// Displays a month+day string (e.g. "July 12").
  months,

  /// Displays a full date string (e.g. "October 8, 2022").
  year,
}

/// Style tokens for [TwakeTimestamp].
class TwakeTimestampStyle {
  // Default (non-scrolling) text style
  static const TextStyle defaultTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Color(0xFF8D8D8D),
    height: 1.4,
  );

  // On-scrolling pill container
  static const Color pillBackground = Color(0xFF9E9E9E);
  static const Color pillTextColor = Colors.white;
  static const TextStyle pillTextStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: pillTextColor,
    height: 1.4,
  );
  static const EdgeInsets pillPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 4);
  static const double pillBorderRadius = 20;

  // Overall container
  static const double containerHeight = 48;
  static const EdgeInsets containerPadding =
      EdgeInsets.symmetric(horizontal: 8);

  const TwakeTimestampStyle._();
}

/// A timestamp separator widget used in chat/message lists.
///
/// Renders in two visual modes:
/// - **Default**: plain text label (e.g. "Today", "July 12", "October 8, 2022")
/// - **On-scrolling**: pill-shaped badge with the same label, used as a
///   floating date indicator while the user scrolls.
///
/// The [type] parameter drives the displayed text content.
/// Pass your own [label] to override the default text for [type].
class TwakeTimestamp extends StatelessWidget {
  /// The format type of the timestamp (today / months / year).
  final TimestampType type;

  /// When `true` the timestamp is rendered as a floating pill (on-scrolling mode).
  final bool onScrolling;

  /// Override the display label. When `null`, a default string is used per [type].
  final String? label;

  const TwakeTimestamp({
    Key? key,
    this.type = TimestampType.today,
    this.onScrolling = false,
    this.label,
  }) : super(key: key);

  String _resolveLabel() {
    if (label != null) return label!;
    switch (type) {
      case TimestampType.today:
        return 'Today';
      case TimestampType.months:
        return 'July 12';
      case TimestampType.year:
        return 'October 8, 2022';
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = _resolveLabel();

    return SizedBox(
      height: TwakeTimestampStyle.containerHeight,
      child: Center(
        child: onScrolling ? _PillTimestamp(text: text) : _DefaultTimestamp(text: text),
      ),
    );
  }
}

/// Plain text timestamp (Default variant).
class _DefaultTimestamp extends StatelessWidget {
  final String text;

  const _DefaultTimestamp({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TwakeTimestampStyle.defaultTextStyle,
      textAlign: TextAlign.center,
    );
  }
}

/// Pill-shaped timestamp (On-scrolling variant).
class _PillTimestamp extends StatelessWidget {
  final String text;

  const _PillTimestamp({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: TwakeTimestampStyle.pillPadding,
      decoration: const BoxDecoration(
        color: TwakeTimestampStyle.pillBackground,
        borderRadius: BorderRadius.all(
          Radius.circular(TwakeTimestampStyle.pillBorderRadius),
        ),
      ),
      child: Text(
        text,
        style: TwakeTimestampStyle.pillTextStyle,
        textAlign: TextAlign.center,
      ),
    );
  }
}
