import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/file//twake_file.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeFile)
Widget bubblemediaDefaultUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: TwakeFile(
    // type: TODO,
    // thumbnail: TODO,
      ),
    ),
  );
}
