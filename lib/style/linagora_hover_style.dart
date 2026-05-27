import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';

class LinagoraHoverStyle {
  final Color hoverColor;
  final Color selectedColor;
  final Color containerColor;
  final BorderRadiusGeometry borderRadius;
  final BorderRadius hoverBorderRadius;
  final BorderRadius actionBubbleBorderRadius;
  final double actionBubbleWidth;
  final double actionBubbleHeight;
  final double containerHeight;

  static final LinagoraHoverStyle _materialLinagoraHoverStyle =
      LinagoraHoverStyle._material();

  factory LinagoraHoverStyle.material() {
    return _materialLinagoraHoverStyle;
  }

  LinagoraHoverStyle._material()
      : selectedColor = LinagoraSysColors.material().secondaryContainer,
        hoverColor = LinagoraSysColors.material().surface,
        containerColor = const Color(0xFF313033),
        borderRadius = const BorderRadius.all(
          Radius.circular(4),
        ),
        hoverBorderRadius = BorderRadius.circular(4),
        actionBubbleBorderRadius = BorderRadius.circular(24),
        actionBubbleWidth = 144,
        actionBubbleHeight = 48,
        containerHeight = 24;
}
