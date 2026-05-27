import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/stacked_card/twake_stacked_card.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeStackedCard)
Widget stackedCardDefaultUseCase(BuildContext context) {
  return Center(
    child: TwakeStackedCard(
      onPrimaryAction: () {},
      onSecondaryAction: () {},
    ),
  );
}
