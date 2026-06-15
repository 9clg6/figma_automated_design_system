import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/badge/twake_badge.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeBadge)
Widget badgesDefaultUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: TwakeBadge(
    // size: TODO,
      ),
    ),
  );
}
