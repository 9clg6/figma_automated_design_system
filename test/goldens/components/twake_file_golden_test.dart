import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:linagora_design_flutter/file/twake_file.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  // ── Helpers ──────────────────────────────────────────────────────────────

  /// A simple coloured box used as a stand-in thumbnail.
  Widget colorThumbnail(Color color) => Container(color: color);

  /// PDF-style icon thumbnail (matches the Figma file tiles).
  Widget pdfThumbnail() => Container(
        color: const Color(0xFFFFF3F3),
        child: const Center(
          child: Text(
            'PDF',
            style: TextStyle(
              color: Color(0xFFE53935),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

  Widget wrap(Widget child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: child),
        ),
      );

  // ── Golden tests ─────────────────────────────────────────────────────────

  group('TwakeFile golden tests', () {
    testGoldens('type=preview', (tester) async {
      await tester.pumpWidgetBuilder(
        wrap(
          TwakeFile(
            type: TwakeFileType.preview,
            thumbnail: pdfThumbnail(),
          ),
        ),
        surfaceSize: const Size(120, 120),
      );
      await screenMatchesGolden(tester, 'twake_file_preview');
    });

    testGoldens('type=media_show_time_show_play', (tester) async {
      await tester.pumpWidgetBuilder(
        wrap(
          TwakeFile(
            type: TwakeFileType.media,
            thumbnail: colorThumbnail(const Color(0xFF4CAF50)),
            showTime: true,
            howLong: '1:20',
            showPlay: true,
          ),
        ),
        surfaceSize: const Size(120, 120),
      );
      await screenMatchesGolden(
          tester, 'twake_file_media_show_time_show_play');
    });

    testGoldens('type=media_no_time_show_play', (tester) async {
      await tester.pumpWidgetBuilder(
        wrap(
          TwakeFile(
            type: TwakeFileType.media,
            thumbnail: colorThumbnail(const Color(0xFF2196F3)),
            showTime: false,
            howLong: '1:20',
            showPlay: true,
          ),
        ),
        surfaceSize: const Size(120, 120),
      );
      await screenMatchesGolden(
          tester, 'twake_file_media_no_time_show_play');
    });

    testGoldens('type=media_show_time_no_play', (tester) async {
      await tester.pumpWidgetBuilder(
        wrap(
          TwakeFile(
            type: TwakeFileType.media,
            thumbnail: colorThumbnail(const Color(0xFFFF9800)),
            showTime: true,
            howLong: '0:45',
            showPlay: false,
          ),
        ),
        surfaceSize: const Size(120, 120),
      );
      await screenMatchesGolden(
          tester, 'twake_file_media_show_time_no_play');
    });

    testGoldens('type=media_no_overlays', (tester) async {
      await tester.pumpWidgetBuilder(
        wrap(
          TwakeFile(
            type: TwakeFileType.media,
            thumbnail: colorThumbnail(const Color(0xFF9C27B0)),
            showTime: false,
            howLong: '2:00',
            showPlay: false,
          ),
        ),
        surfaceSize: const Size(120, 120),
      );
      await screenMatchesGolden(
          tester, 'twake_file_media_no_overlays');
    });

    testGoldens('file_row_preview_and_media', (tester) async {
      await tester.pumpWidgetBuilder(
        wrap(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TwakeFile(
                type: TwakeFileType.preview,
                thumbnail: pdfThumbnail(),
              ),
              const SizedBox(width: 8),
              TwakeFile(
                type: TwakeFileType.media,
                thumbnail: colorThumbnail(const Color(0xFF43A047)),
                showTime: true,
                howLong: '1:20',
                showPlay: true,
              ),
            ],
          ),
        ),
        surfaceSize: const Size(200, 120),
      );
      await screenMatchesGolden(tester, 'twake_file_row_preview_and_media');
    });
  });
}
