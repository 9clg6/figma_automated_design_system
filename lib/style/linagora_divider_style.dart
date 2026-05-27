import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_state_layer.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';

class LinagoraDividerStyle {
  final Color color;
  final double thickness;
  final BoxBorder borderDecoration;

  // Height constants
  static const double verticalHeight = 120.0;
  static const double horizontalHeight = 1.0;

  // Padding constants for vertical variants
  static const EdgeInsets verticalMiddleInsetPadding =
      EdgeInsets.symmetric(vertical: 16.0);
  static const EdgeInsets verticalInsetPadding =
      EdgeInsets.only(top: 16.0);
  static const EdgeInsets verticalFullWidthPadding = EdgeInsets.zero;

  // Padding constants for horizontal variants
  static const EdgeInsets horizontalInsetPadding =
      EdgeInsets.symmetric(horizontal: 16.0);
  static const EdgeInsets horizontalMiddleInsetPadding =
      EdgeInsets.symmetric(horizontal: 16.0);
  static const EdgeInsets horizontalWithSubheadPadding =
      EdgeInsets.symmetric(horizontal: 16.0);

  // Spacing constant for horizontal/with-subhead variant
  static const double horizontalWithSubheadSpacing = 4.0;

  static final LinagoraDividerStyle _materialLinagoraHoverStyle =
      LinagoraDividerStyle._material();

  factory LinagoraDividerStyle.material() {
    return _materialLinagoraHoverStyle;
  }

  LinagoraDividerStyle._material()
      : color = LinagoraStateLayer(LinagoraSysColors.material().surfaceTint)
            .opacityLayer3,
        thickness = 1.0,
        borderDecoration = Border(
          bottom: BorderSide(
            width: 1.0,
            color: LinagoraStateLayer(
              LinagoraSysColors.material().surfaceTint,
            ).opacityLayer3,
          ),
        );
}
