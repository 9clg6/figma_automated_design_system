import 'package:flutter/material.dart';

/// Design tokens for [TwakeLinearProgressIndicator].
class TwakeLinearProgressIndicatorStyle {
  final double height;
  final Color activeColor;
  final Color trackColor;
  final BorderRadius borderRadius;

  const TwakeLinearProgressIndicatorStyle._({
    required this.height,
    required this.activeColor,
    required this.trackColor,
    required this.borderRadius,
  });

  static final _instance = TwakeLinearProgressIndicatorStyle._(
    height: 4.0,
    activeColor: const Color(0xFF006D3A),
    trackColor: const Color(0xFFE0E0E0),
    borderRadius: BorderRadius.circular(2),
  );

  factory TwakeLinearProgressIndicatorStyle.material() => _instance;
}
