import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:linagora_design_flutter/modal_date_picker/twake_modal_date_picker.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  group('TwakeModalDatePicker golden tests', () {
    testGoldens('single_mode_light', (tester) async {
      await tester.pumpWidgetBuilder(
        Center(
          child: TwakeModalDatePicker(
            mode: TwakeDatePickerMode.single,
            supportingText: 'Select date',
            headline: 'Mon, Aug 17',
            initialMonth: DateTime(2023, 8, 1),
            selectedDate: DateTime(2023, 8, 17),
            onCancel: () {},
            onConfirm: () {},
          ),
        ),
        surfaceSize: const Size(400, 560),
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
        ),
      );
      await screenMatchesGolden(tester, 'modal_date_picker_single_light');
    });

    testGoldens('single_mode_dark', (tester) async {
      await tester.pumpWidgetBuilder(
        Center(
          child: TwakeModalDatePicker(
            mode: TwakeDatePickerMode.single,
            supportingText: 'Select date',
            headline: 'Mon, Aug 17',
            initialMonth: DateTime(2023, 8, 1),
            selectedDate: DateTime(2023, 8, 17),
            onCancel: () {},
            onConfirm: () {},
          ),
        ),
        surfaceSize: const Size(400, 560),
        wrapper: materialAppWrapper(
          theme: ThemeData.dark(),
        ),
      );
      await screenMatchesGolden(tester, 'modal_date_picker_single_dark');
    });

    testGoldens('range_mode_light', (tester) async {
      await tester.pumpWidgetBuilder(
        Center(
          child: TwakeModalDatePicker(
            mode: TwakeDatePickerMode.range,
            supportingText: 'Select date',
            supportingTextRange: 'Depart - Return dates',
            headline: 'Mon, Aug 17',
            headlineRange: 'Aug 17 \u2013 Aug 23',
            initialMonth: DateTime(2023, 8, 1),
            rangeStart: DateTime(2023, 8, 17),
            rangeEnd: DateTime(2023, 8, 23),
            onCancel: () {},
            onConfirm: () {},
          ),
        ),
        surfaceSize: const Size(400, 560),
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
        ),
      );
      await screenMatchesGolden(tester, 'modal_date_picker_range_light');
    });

    testGoldens('range_mode_dark', (tester) async {
      await tester.pumpWidgetBuilder(
        Center(
          child: TwakeModalDatePicker(
            mode: TwakeDatePickerMode.range,
            supportingText: 'Select date',
            supportingTextRange: 'Depart - Return dates',
            headline: 'Mon, Aug 17',
            headlineRange: 'Aug 17 \u2013 Aug 23',
            initialMonth: DateTime(2023, 8, 1),
            rangeStart: DateTime(2023, 8, 17),
            rangeEnd: DateTime(2023, 8, 23),
            onCancel: () {},
            onConfirm: () {},
          ),
        ),
        surfaceSize: const Size(400, 560),
        wrapper: materialAppWrapper(
          theme: ThemeData.dark(),
        ),
      );
      await screenMatchesGolden(tester, 'modal_date_picker_range_dark');
    });

    testGoldens('no_selection_light', (tester) async {
      await tester.pumpWidgetBuilder(
        Center(
          child: TwakeModalDatePicker(
            mode: TwakeDatePickerMode.single,
            supportingText: 'Select date',
            headline: 'Mon, Aug 17',
            initialMonth: DateTime(2023, 8, 1),
          ),
        ),
        surfaceSize: const Size(400, 560),
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
        ),
      );
      await screenMatchesGolden(tester, 'modal_date_picker_no_selection_light');
    });
  });
}
