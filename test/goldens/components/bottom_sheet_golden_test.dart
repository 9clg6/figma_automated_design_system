import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:linagora_design_flutter/bottom_sheet/twake_bottom_sheet.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  group('TwakeBottomSheet golden tests', () {
    testGoldens('bottom_sheet_light_non_modal_with_drag_handle', (tester) async {
      await tester.pumpWidgetBuilder(
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 400,
            height: 480,
            child: TwakeBottomSheet(
              showDragHandle: true,
              modal: false,
              child: const SizedBox.expand(),
            ),
          ),
        ),
        surfaceSize: const Size(400, 480),
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
        ),
      );
      await screenMatchesGolden(
          tester, 'bottom_sheet_light_non_modal_with_drag_handle');
    });

    testGoldens('bottom_sheet_dark_non_modal_with_drag_handle', (tester) async {
      await tester.pumpWidgetBuilder(
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 400,
            height: 480,
            child: TwakeBottomSheet(
              showDragHandle: true,
              modal: false,
              child: const SizedBox.expand(),
            ),
          ),
        ),
        surfaceSize: const Size(400, 480),
        wrapper: materialAppWrapper(
          theme: ThemeData.dark(),
        ),
      );
      await screenMatchesGolden(
          tester, 'bottom_sheet_dark_non_modal_with_drag_handle');
    });

    testGoldens('bottom_sheet_light_modal_with_drag_handle', (tester) async {
      await tester.pumpWidgetBuilder(
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 400,
            height: 480,
            child: TwakeBottomSheet(
              showDragHandle: true,
              modal: true,
              child: const SizedBox.expand(),
            ),
          ),
        ),
        surfaceSize: const Size(400, 480),
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
        ),
      );
      await screenMatchesGolden(
          tester, 'bottom_sheet_light_modal_with_drag_handle');
    });

    testGoldens('bottom_sheet_dark_modal_with_drag_handle', (tester) async {
      await tester.pumpWidgetBuilder(
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 400,
            height: 480,
            child: TwakeBottomSheet(
              showDragHandle: true,
              modal: true,
              child: const SizedBox.expand(),
            ),
          ),
        ),
        surfaceSize: const Size(400, 480),
        wrapper: materialAppWrapper(
          theme: ThemeData.dark(),
        ),
      );
      await screenMatchesGolden(
          tester, 'bottom_sheet_dark_modal_with_drag_handle');
    });

    testGoldens('bottom_sheet_light_no_drag_handle', (tester) async {
      await tester.pumpWidgetBuilder(
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 400,
            height: 480,
            child: TwakeBottomSheet(
              showDragHandle: false,
              modal: false,
              child: const SizedBox.expand(),
            ),
          ),
        ),
        surfaceSize: const Size(400, 480),
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
        ),
      );
      await screenMatchesGolden(tester, 'bottom_sheet_light_no_drag_handle');
    });

    testGoldens('bottom_sheet_dark_no_drag_handle', (tester) async {
      await tester.pumpWidgetBuilder(
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 400,
            height: 480,
            child: TwakeBottomSheet(
              showDragHandle: false,
              modal: false,
              child: const SizedBox.expand(),
            ),
          ),
        ),
        surfaceSize: const Size(400, 480),
        wrapper: materialAppWrapper(
          theme: ThemeData.dark(),
        ),
      );
      await screenMatchesGolden(tester, 'bottom_sheet_dark_no_drag_handle');
    });
  });
}
