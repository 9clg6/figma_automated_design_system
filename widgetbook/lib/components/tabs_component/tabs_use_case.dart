import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/search_tabs//twake_search_tab.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeSearchTab)
Widget tabsDefaultUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: TwakeSearchTab(
      ),
    ),
  );
}
