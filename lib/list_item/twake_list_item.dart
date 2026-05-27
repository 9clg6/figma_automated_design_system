import 'package:flutter/material.dart';

/// Height constants matching Figma spec variants:
/// 1-line: 56px, 2-line: 72px, 3-line+: 124px
class TwakeListItemHeight {
  static const double oneLine = 56.0;
  static const double twoLine = 72.0;
  static const double threeLine = 124.0;

  const TwakeListItemHeight._();
}

class TwakeListItem extends StatelessWidget {
  final Widget child;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const TwakeListItem({
    Key? key,
    required this.child,
    this.height,
    this.padding,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding ?? EdgeInsets.zero,
      height: height,
      decoration: const BoxDecoration(
        color: Color(0xFFF4F4F4),
      ),
      child: child,
    );
  }
}
