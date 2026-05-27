import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/file/twake_file.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Preview', type: TwakeFile)
Widget filePreviewUseCase(BuildContext context) {
  return Center(
    child: TwakeFile(
      type: TwakeFileType.preview,
      thumbnail: Container(
        color: Colors.grey[300],
        child: const Icon(Icons.insert_drive_file, size: 32),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Media', type: TwakeFile)
Widget fileMediaUseCase(BuildContext context) {
  return Center(
    child: TwakeFile(
      type: TwakeFileType.media,
      thumbnail: Container(
        color: Colors.blueGrey[200],
        child: const Icon(Icons.play_circle_fill, size: 32),
      ),
      showTime: true,
      howLong: '2:45',
      showPlay: true,
      onTap: () {},
    ),
  );
}
