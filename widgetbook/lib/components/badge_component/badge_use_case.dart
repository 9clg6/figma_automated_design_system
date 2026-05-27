import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/badge/twake_badge.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Small dot', type: TwakeBadge)
Widget badgeSmallUseCase(BuildContext context) {
  return const Center(
    child: TwakeBadge.small(),
  );
}

@widgetbook.UseCase(name: 'Single digit', type: TwakeBadge)
Widget badgeSingleDigitUseCase(BuildContext context) {
  return const Center(
    child: TwakeBadge(
      size: BadgeSize.largeSingleDigit,
      label: '3',
    ),
  );
}

@widgetbook.UseCase(name: 'Multiple digits', type: TwakeBadge)
Widget badgeMultipleDigitsUseCase(BuildContext context) {
  return const Center(
    child: TwakeBadge(
      size: BadgeSize.multipleDigits,
      label: '99+',
    ),
  );
}
