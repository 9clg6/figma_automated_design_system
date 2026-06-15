import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/bottom_navigation//twake_bottom_navigation.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeBottomNavigation)
Widget navigationrailDefaultUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: TwakeBottomNavigation(
    // selectedTab: TODO,
      ),
    ),
  );
}
