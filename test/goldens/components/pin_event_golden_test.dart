import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:linagora_design_flutter/pin_events/twake_pin_event.dart';

void main() {
  group('TwakePinEvent golden tests', () {
    testGoldens('light_file_with_caption', (tester) async {
      await tester.pumpWidgetBuilder(
        const SizedBox(
          width: 768,
          child: TwakePinEvent(
            name: 'Kaylynn Botosh',
            type: PinEventType.file,
            theme: PinEventTheme.light,
            noCaption: false,
            isMobile: false,
          ),
        ),
        surfaceSize: const Size(768, 48),
      );
      await screenMatchesGolden(tester, 'light_file_with_caption');
    });

    testGoldens('light_file_no_caption', (tester) async {
      await tester.pumpWidgetBuilder(
        const SizedBox(
          width: 768,
          child: TwakePinEvent(
            name: 'Kaylynn Botosh',
            type: PinEventType.file,
            theme: PinEventTheme.light,
            noCaption: true,
            isMobile: false,
          ),
        ),
        surfaceSize: const Size(768, 48),
      );
      await screenMatchesGolden(tester, 'light_file_no_caption');
    });

    testGoldens('light_photo_with_caption', (tester) async {
      await tester.pumpWidgetBuilder(
        const SizedBox(
          width: 768,
          child: TwakePinEvent(
            name: 'Kaylynn Botosh',
            type: PinEventType.photo,
            theme: PinEventTheme.light,
            noCaption: false,
            isMobile: false,
          ),
        ),
        surfaceSize: const Size(768, 48),
      );
      await screenMatchesGolden(tester, 'light_photo_with_caption');
    });

    testGoldens('light_link_with_caption', (tester) async {
      await tester.pumpWidgetBuilder(
        const SizedBox(
          width: 768,
          child: TwakePinEvent(
            name: 'Kaylynn Botosh',
            type: PinEventType.link,
            theme: PinEventTheme.light,
            noCaption: false,
            isMobile: false,
          ),
        ),
        surfaceSize: const Size(768, 48),
      );
      await screenMatchesGolden(tester, 'light_link_with_caption');
    });

    testGoldens('light_contact_with_caption', (tester) async {
      await tester.pumpWidgetBuilder(
        const SizedBox(
          width: 768,
          child: TwakePinEvent(
            name: 'Kaylynn Botosh',
            contactName: 'Davis Calzoni',
            type: PinEventType.contact,
            theme: PinEventTheme.light,
            noCaption: false,
            isMobile: false,
          ),
        ),
        surfaceSize: const Size(768, 48),
      );
      await screenMatchesGolden(tester, 'light_contact_with_caption');
    });

    testGoldens('light_poll_with_caption', (tester) async {
      await tester.pumpWidgetBuilder(
        const SizedBox(
          width: 768,
          child: TwakePinEvent(
            name: 'Kaylynn Botosh',
            type: PinEventType.poll,
            theme: PinEventTheme.light,
            noCaption: false,
            isMobile: false,
          ),
        ),
        surfaceSize: const Size(768, 48),
      );
      await screenMatchesGolden(tester, 'light_poll_with_caption');
    });

    testGoldens('light_video_with_caption', (tester) async {
      await tester.pumpWidgetBuilder(
        const SizedBox(
          width: 768,
          child: TwakePinEvent(
            name: 'Kaylynn Botosh',
            type: PinEventType.video,
            theme: PinEventTheme.light,
            noCaption: false,
            isMobile: false,
          ),
        ),
        surfaceSize: const Size(768, 48),
      );
      await screenMatchesGolden(tester, 'light_video_with_caption');
    });

    testGoldens('light_audio_with_caption', (tester) async {
      await tester.pumpWidgetBuilder(
        const SizedBox(
          width: 768,
          child: TwakePinEvent(
            name: 'Kaylynn Botosh',
            type: PinEventType.audio,
            theme: PinEventTheme.light,
            noCaption: false,
            isMobile: false,
          ),
        ),
        surfaceSize: const Size(768, 48),
      );
      await screenMatchesGolden(tester, 'light_audio_with_caption');
    });

    testGoldens('light_text_with_caption', (tester) async {
      await tester.pumpWidgetBuilder(
        const SizedBox(
          width: 768,
          child: TwakePinEvent(
            name: 'Kaylynn Botosh',
            type: PinEventType.text,
            theme: PinEventTheme.light,
            noCaption: false,
            isMobile: false,
          ),
        ),
        surfaceSize: const Size(768, 48),
      );
      await screenMatchesGolden(tester, 'light_text_with_caption');
    });

    testGoldens('dark_file_with_caption', (tester) async {
      await tester.pumpWidgetBuilder(
        const SizedBox(
          width: 768,
          child: TwakePinEvent(
            name: 'Kaylynn Botosh',
            type: PinEventType.file,
            theme: PinEventTheme.dark,
            noCaption: false,
            isMobile: false,
          ),
        ),
        surfaceSize: const Size(768, 48),
      );
      await screenMatchesGolden(tester, 'dark_file_with_caption');
    });

    testGoldens('dark_photo_no_caption', (tester) async {
      await tester.pumpWidgetBuilder(
        const SizedBox(
          width: 768,
          child: TwakePinEvent(
            name: 'Kaylynn Botosh',
            type: PinEventType.photo,
            theme: PinEventTheme.dark,
            noCaption: true,
            isMobile: false,
          ),
        ),
        surfaceSize: const Size(768, 48),
      );
      await screenMatchesGolden(tester, 'dark_photo_no_caption');
    });

    testGoldens('dark_contact_with_caption', (tester) async {
      await tester.pumpWidgetBuilder(
        const SizedBox(
          width: 768,
          child: TwakePinEvent(
            name: 'Kaylynn Botosh',
            contactName: 'Davis Calzoni',
            type: PinEventType.contact,
            theme: PinEventTheme.dark,
            noCaption: false,
            isMobile: false,
          ),
        ),
        surfaceSize: const Size(768, 48),
      );
      await screenMatchesGolden(tester, 'dark_contact_with_caption');
    });

    testGoldens('mobile_light_file_with_caption', (tester) async {
      await tester.pumpWidgetBuilder(
        const SizedBox(
          width: 375,
          child: TwakePinEvent(
            name: 'Kaylynn Botosh',
            type: PinEventType.file,
            theme: PinEventTheme.light,
            noCaption: false,
            isMobile: true,
          ),
        ),
        surfaceSize: const Size(375, 48),
      );
      await screenMatchesGolden(tester, 'mobile_light_file_with_caption');
    });

    testGoldens('mobile_dark_text_no_caption', (tester) async {
      await tester.pumpWidgetBuilder(
        const SizedBox(
          width: 375,
          child: TwakePinEvent(
            name: 'Kaylynn Botosh',
            type: PinEventType.text,
            theme: PinEventTheme.dark,
            noCaption: true,
            isMobile: true,
          ),
        ),
        surfaceSize: const Size(375, 48),
      );
      await screenMatchesGolden(tester, 'mobile_dark_text_no_caption');
    });

    testGoldens('all_types_light_grid', (tester) async {
      final types = PinEventType.values;
      await tester.pumpWidgetBuilder(
        SizedBox(
          width: 768,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: types
                .map(
                  (t) => TwakePinEvent(
                    name: 'Kaylynn Botosh',
                    type: t,
                    theme: PinEventTheme.light,
                    noCaption: false,
                    isMobile: false,
                  ),
                )
                .toList(),
          ),
        ),
        surfaceSize: Size(768, 48.0 * types.length),
      );
      await screenMatchesGolden(tester, 'all_types_light_grid');
    });

    testGoldens('all_types_dark_grid', (tester) async {
      final types = PinEventType.values;
      await tester.pumpWidgetBuilder(
        SizedBox(
          width: 768,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: types
                .map(
                  (t) => TwakePinEvent(
                    name: 'Kaylynn Botosh',
                    type: t,
                    theme: PinEventTheme.dark,
                    noCaption: false,
                    isMobile: false,
                  ),
                )
                .toList(),
          ),
        ),
        surfaceSize: Size(768, 48.0 * types.length),
      );
      await screenMatchesGolden(tester, 'all_types_dark_grid');
    });
  });
}
