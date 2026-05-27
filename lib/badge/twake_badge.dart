import 'package:flutter/material.dart';

/// Size variants for [TwakeBadge], matching Figma spec:
/// - [small]: 6×6 dot, no label
/// - [largeSingleDigit]: 16×16 circle with single digit label
/// - [multipleDigits]: 16px tall pill with multi-digit label
enum BadgeSize {
  small,
  largeSingleDigit,
  multipleDigits,
}

/// Badge style tokens matching Figma design.
class TwakeBadgeStyle {
  static const Color badgeColor = Color(0xFFE53935);
  static const Color labelColor = Colors.white;
  static const double smallSize = 6.0;
  static const double largeSize = 16.0;
  static const double multipleDigitsWidth = 23.0;
  static const double multipleDigitsHeight = 16.0;
  static const double largeBorderRadius = 8.0;
  static const double multipleBorderRadius = 8.0;
  static const TextStyle labelStyle = TextStyle(
    color: labelColor,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    height: 1.0,
    leadingDistribution: TextLeadingDistribution.even,
  );

  const TwakeBadgeStyle._();
}

/// A badge widget with three size variants matching the Figma Badges component.
///
/// - [BadgeSize.small]: A small 6×6 red dot with no label.
/// - [BadgeSize.largeSingleDigit]: A 16×16 red circle showing a single-digit [label].
/// - [BadgeSize.multipleDigits]: A 23×16 red pill showing a multi-digit [label].
class TwakeBadge extends StatelessWidget {
  /// The size variant of the badge.
  final BadgeSize size;

  /// The label text to display inside the badge.
  /// Only used for [BadgeSize.largeSingleDigit] and [BadgeSize.multipleDigits].
  final String label;

  const TwakeBadge({
    Key? key,
    required this.size,
    this.label = '',
  }) : super(key: key);

  /// Convenience constructor for a small dot badge.
  const TwakeBadge.small({Key? key})
      : size = BadgeSize.small,
        label = '',
        super(key: key);

  /// Convenience constructor for a single-digit badge.
  const TwakeBadge.singleDigit({Key? key, required String digit})
      : size = BadgeSize.largeSingleDigit,
        label = digit,
        super(key: key);

  /// Convenience constructor for a multi-digit badge.
  const TwakeBadge.multipleDigits({Key? key, required String count})
      : size = BadgeSize.multipleDigits,
        label = count,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (size) {
      case BadgeSize.small:
        return _SmallBadge();
      case BadgeSize.largeSingleDigit:
        return _LargeSingleDigitBadge(label: label);
      case BadgeSize.multipleDigits:
        return _MultipleDigitsBadge(label: label);
    }
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: TwakeBadgeStyle.smallSize,
      height: TwakeBadgeStyle.smallSize,
      decoration: const BoxDecoration(
        color: TwakeBadgeStyle.badgeColor,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _LargeSingleDigitBadge extends StatelessWidget {
  final String label;

  const _LargeSingleDigitBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: TwakeBadgeStyle.largeSize,
      height: TwakeBadgeStyle.largeSize,
      decoration: const BoxDecoration(
        color: TwakeBadgeStyle.badgeColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TwakeBadgeStyle.labelStyle,
        textAlign: TextAlign.center,
        maxLines: 1,
      ),
    );
  }
}

class _MultipleDigitsBadge extends StatelessWidget {
  final String label;

  const _MultipleDigitsBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: TwakeBadgeStyle.multipleDigitsHeight,
      constraints: const BoxConstraints(
        minWidth: TwakeBadgeStyle.multipleDigitsWidth,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        color: TwakeBadgeStyle.badgeColor,
        borderRadius: BorderRadius.circular(TwakeBadgeStyle.multipleBorderRadius),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TwakeBadgeStyle.labelStyle,
        textAlign: TextAlign.center,
        maxLines: 1,
      ),
    );
  }
}
