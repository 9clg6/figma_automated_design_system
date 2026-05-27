import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:linagora_design_flutter/lin_message_type_icon_24px/twake_message_type_icon.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  group('TwakeMessageTypeIcon golden tests', () {
    testGoldens('all types light theme', (tester) async {
      final types = MessageIconType.values;

      await tester.pumpWidgetBuilder(
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: types
                .map(
                  (t) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: TwakeMessageTypeIcon(
                      type: t,
                      theme: MessageIconTheme.light,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        surfaceSize: const Size(320, 56),
      );

      await screenMatchesGolden(
        tester,
        'message_type_icon_all_light',
      );
    });

    testGoldens('all types dark theme', (tester) async {
      final types = MessageIconType.values;

      await tester.pumpWidgetBuilder(
        Container(
          color: const Color(0xFF1E1E1E),
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: types
                .map(
                  (t) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: TwakeMessageTypeIcon(
                      type: t,
                      theme: MessageIconTheme.dark,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        surfaceSize: const Size(320, 56),
      );

      await screenMatchesGolden(
        tester,
        'message_type_icon_all_dark',
      );
    });

    testGoldens('single attach light', (tester) async {
      await tester.pumpWidgetBuilder(
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(8),
          child: const TwakeMessageTypeIcon(
            type: MessageIconType.attach,
            theme: MessageIconTheme.light,
          ),
        ),
        surfaceSize: const Size(40, 40),
      );

      await screenMatchesGolden(
        tester,
        'message_type_icon_attach_light',
      );
    });

    testGoldens('single attach dark', (tester) async {
      await tester.pumpWidgetBuilder(
        Container(
          color: const Color(0xFF1E1E1E),
          padding: const EdgeInsets.all(8),
          child: const TwakeMessageTypeIcon(
            type: MessageIconType.attach,
            theme: MessageIconTheme.dark,
          ),
        ),
        surfaceSize: const Size(40, 40),
      );

      await screenMatchesGolden(
        tester,
        'message_type_icon_attach_dark',
      );
    });
  });
}
