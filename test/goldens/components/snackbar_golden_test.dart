import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:linagora_design_flutter/snackbar/twake_snackbar.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  group('TwakeSnackbar golden tests', () {
    Widget _wrap(Widget child) => MaterialApp(
          home: Scaffold(
            backgroundColor: const Color(0xFFF5F5F5),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: child,
            ),
          ),
        );

    testGoldens('single_line_no_action_no_close', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(
          const TwakeSnackbar(
            message: 'Single-line snackbar',
            lines: SnackbarLines.oneLine,
          ),
        ),
        surfaceSize: const Size(376, 80),
      );
      await screenMatchesGolden(
          tester, 'snackbar_single_line_no_action_no_close');
    });

    testGoldens('single_line_with_close', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(
          const TwakeSnackbar(
            message: 'Single-line snackbar with close affordance',
            lines: SnackbarLines.oneLine,
            showCloseAffordance: true,
          ),
        ),
        surfaceSize: const Size(376, 80),
      );
      await screenMatchesGolden(tester, 'snackbar_single_line_with_close');
    });

    testGoldens('single_line_with_action', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(
          const TwakeSnackbar(
            message: 'Single-line snackbar with action',
            lines: SnackbarLines.oneLine,
            showAction: true,
          ),
        ),
        surfaceSize: const Size(376, 80),
      );
      await screenMatchesGolden(tester, 'snackbar_single_line_with_action');
    });

    testGoldens('single_line_with_action_and_close', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(
          const TwakeSnackbar(
            message: 'Single-line snackbar with action',
            lines: SnackbarLines.oneLine,
            showAction: true,
            showCloseAffordance: true,
          ),
        ),
        surfaceSize: const Size(376, 80),
      );
      await screenMatchesGolden(
          tester, 'snackbar_single_line_with_action_and_close');
    });

    testGoldens('two_line_no_action_no_close', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(
          const TwakeSnackbar(
            message: 'Two-line snackbar\nwithout action',
            lines: SnackbarLines.twoLines,
          ),
        ),
        surfaceSize: const Size(376, 100),
      );
      await screenMatchesGolden(
          tester, 'snackbar_two_line_no_action_no_close');
    });

    testGoldens('two_line_with_close', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(
          const TwakeSnackbar(
            message: 'Two-line snackbar with\nclose affordance',
            lines: SnackbarLines.twoLines,
            showCloseAffordance: true,
          ),
        ),
        surfaceSize: const Size(376, 100),
      );
      await screenMatchesGolden(tester, 'snackbar_two_line_with_close');
    });

    testGoldens('two_line_with_action', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(
          const TwakeSnackbar(
            message: 'Two-line snackbar\nwith action',
            lines: SnackbarLines.twoLines,
            showAction: true,
          ),
        ),
        surfaceSize: const Size(376, 100),
      );
      await screenMatchesGolden(tester, 'snackbar_two_line_with_action');
    });

    testGoldens('two_line_with_action_and_close', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(
          const TwakeSnackbar(
            message: 'Two-line snackbar with\naction and close affordance',
            lines: SnackbarLines.twoLines,
            showAction: true,
            showCloseAffordance: true,
          ),
        ),
        surfaceSize: const Size(376, 100),
      );
      await screenMatchesGolden(
          tester, 'snackbar_two_line_with_action_and_close');
    });

    testGoldens('two_line_longer_action', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(
          const TwakeSnackbar(
            message: 'Two-line snackbar with\nlonger action',
            lines: SnackbarLines.twoLines,
            showAction: true,
            longerAction: true,
            actionLabel: 'Longer Action',
          ),
        ),
        surfaceSize: const Size(376, 144),
      );
      await screenMatchesGolden(tester, 'snackbar_two_line_longer_action');
    });

    testGoldens('two_line_longer_action_and_close', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(
          const TwakeSnackbar(
            message: 'Two-line snackbar with longer\naction and close affordance',
            lines: SnackbarLines.twoLines,
            showAction: true,
            longerAction: true,
            showCloseAffordance: true,
            actionLabel: 'Longer Action',
          ),
        ),
        surfaceSize: const Size(376, 144),
      );
      await screenMatchesGolden(
          tester, 'snackbar_two_line_longer_action_and_close');
    });
  });
}
