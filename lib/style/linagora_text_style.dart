
import 'package:flutter/painting.dart';

class LinagoraTextStyle {
  final TextStyle displayMedium;

  final TextStyle displaySmall;

  final TextStyle headlineLarge;

  final TextStyle headlineMedium;

  final TextStyle headlineSmall;

  final TextStyle titleLarge;

  final TextStyle titleMedium;

  final TextStyle titleSemibold;

  final TextStyle titleSmall;

  final TextStyle labelLarge;

  final TextStyle labelMedium;

  final TextStyle labelSmall;

  final TextStyle bodyLarge;

  final TextStyle bodyLargeBold;

  final TextStyle bodyLarge1;

  final TextStyle bodyLarge2;

  final TextStyle bodyMedium;

  final TextStyle bodyMedium1;

  final TextStyle bodyMedium2;

  final TextStyle bodyMedium3;

  final TextStyle bodySmall;

  static final LinagoraTextStyle _materialLinagoraTextStyle =
      LinagoraTextStyle._material();

  factory LinagoraTextStyle.material() {
    return _materialLinagoraTextStyle;
  }

  LinagoraTextStyle._material()
      : displayMedium = const TextStyle(
          fontSize: 45,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
        displaySmall = const TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
        headlineLarge = const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
        headlineMedium = const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
        headlineSmall = const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
        titleLarge = const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
        titleMedium = const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15000000596046448,
        ),
        titleSemibold = const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15000000596046448,
        ),
        titleSmall = const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.10000000149011612,
        ),
        labelLarge = const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.10000000149011612,
        ),
        labelMedium = const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        labelSmall = const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        bodyLarge = const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.15000000596046448,
        ),
        bodyLargeBold = const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.15000000596046448,
        ),
        bodyLarge1 = const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.15,
        ),
        bodyLarge2 = const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.15,
        ),
        bodyMedium = const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.25,
        ),
        bodyMedium1 = const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.15,
        ),
        bodyMedium2 = const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.25,
        ),
        bodyMedium3 = const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
        ),
        bodySmall = const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.4000000059604645,
        );
}
