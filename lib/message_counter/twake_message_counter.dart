import 'package:flutter/material.dart';

/// Style tokens for [TwakeMessageCounter].
class TwakeMessageCounterStyle {
  static const double badgeSize = 20.0;
  static const double badgeRadius = 10.0;
  static const Color badgeColor = Color(0xFF2196F3);
  static const Color badgeTextColor = Colors.white;
  static const TextStyle badgeTextStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: badgeTextColor,
    height: 1.0,
  );
  static const double spacing = 4.0;

  const TwakeMessageCounterStyle._();
}

/// A compact message counter widget showing:
/// - an @ mention badge (when [showMention] is true)
/// - a single-digit unread count badge (when [singleDigitCount] is not null)
/// - a multi-digit unread count badge (when [multipleDigitsCount] is not null)
///
/// Matches the Figma "Message Counter" component set.
class TwakeMessageCounter extends StatelessWidget {
  /// Whether to show the @ mention indicator.
  final bool showMention;

  /// A single-digit count to display (1–9). Shown when non-null.
  final int? singleDigitCount;

  /// A multi-digit count to display (10+). Shown when non-null.
  final int? multipleDigitsCount;

  const TwakeMessageCounter({
    Key? key,
    this.showMention = false,
    this.singleDigitCount,
    this.multipleDigitsCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> badges = [];

    if (showMention) {
      badges.add(_MentionBadge());
    }

    if (singleDigitCount != null) {
      if (badges.isNotEmpty) {
        badges.add(const SizedBox(width: TwakeMessageCounterStyle.spacing));
      }
      badges.add(_CountBadge(count: singleDigitCount!));
    }

    if (multipleDigitsCount != null) {
      if (badges.isNotEmpty) {
        badges.add(const SizedBox(width: TwakeMessageCounterStyle.spacing));
      }
      badges.add(_CountBadge(count: multipleDigitsCount!));
    }

    if (badges.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: badges,
    );
  }
}

/// The blue @ mention badge.
class _MentionBadge extends StatelessWidget {
  const _MentionBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: TwakeMessageCounterStyle.badgeSize,
      height: TwakeMessageCounterStyle.badgeSize,
      decoration: const BoxDecoration(
        color: TwakeMessageCounterStyle.badgeColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: const Text(
        '@',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: TwakeMessageCounterStyle.badgeTextColor,
          height: 1.0,
        ),
      ),
    );
  }
}

/// A blue circular badge displaying a numeric count.
class _CountBadge extends StatelessWidget {
  final int count;

  const _CountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    final String label = count > 99 ? '99+' : count.toString();
    final bool isMultiDigit = label.length > 1;

    return Container(
      constraints: BoxConstraints(
        minWidth: TwakeMessageCounterStyle.badgeSize,
        minHeight: TwakeMessageCounterStyle.badgeSize,
      ),
      padding: isMultiDigit
          ? const EdgeInsets.symmetric(horizontal: 5.0)
          : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: TwakeMessageCounterStyle.badgeColor,
        borderRadius: BorderRadius.circular(TwakeMessageCounterStyle.badgeRadius),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TwakeMessageCounterStyle.badgeTextStyle,
      ),
    );
  }
}
