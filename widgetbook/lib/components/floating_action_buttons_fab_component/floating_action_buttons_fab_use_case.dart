import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/small_fab//twake_small_fab.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeSmallFab)
Widget floatingactionbuttonsfabDefaultUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: TwakeSmallFab(
      ),
    ),
  );
}
