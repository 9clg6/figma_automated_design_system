import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:linagora_design_flutter/checkboxes/twake_checkbox.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  group('TwakeCheckbox Golden Tests', () {
    testGoldens('checkbox_all_types_enabled', (tester) async {
      await tester.pumpWidgetBuilder(
        _buildGrid(TwakeCheckboxState.enabled),
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
        ),
        surfaceSize: const Size(380, 60),
      );
      await screenMatchesGolden(tester, 'checkbox_all_types_enabled');
    });

    testGoldens('checkbox_all_types_hovered', (tester) async {
      await tester.pumpWidgetBuilder(
        _buildGrid(TwakeCheckboxState.hovered),
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
        ),
        surfaceSize: const Size(380, 60),
      );
      await screenMatchesGolden(tester, 'checkbox_all_types_hovered');
    });

    testGoldens('checkbox_all_types_focused', (tester) async {
      await tester.pumpWidgetBuilder(
        _buildGrid(TwakeCheckboxState.focused),
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
        ),
        surfaceSize: const Size(380, 60),
      );
      await screenMatchesGolden(tester, 'checkbox_all_types_focused');
    });

    testGoldens('checkbox_all_types_pressed', (tester) async {
      await tester.pumpWidgetBuilder(
        _buildGrid(TwakeCheckboxState.pressed),
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
        ),
        surfaceSize: const Size(380, 60),
      );
      await screenMatchesGolden(tester, 'checkbox_all_types_pressed');
    });

    testGoldens('checkbox_all_types_disabled', (tester) async {
      await tester.pumpWidgetBuilder(
        _buildGrid(TwakeCheckboxState.disabled),
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
        ),
        surfaceSize: const Size(380, 60),
      );
      await screenMatchesGolden(tester, 'checkbox_all_types_disabled');
    });

    testGoldens('checkbox_full_matrix_light', (tester) async {
      await tester.pumpWidgetBuilder(
        _buildFullMatrix(),
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
        ),
        surfaceSize: const Size(380, 360),
      );
      await screenMatchesGolden(tester, 'checkbox_full_matrix_light');
    });

    testGoldens('checkbox_full_matrix_dark', (tester) async {
      await tester.pumpWidgetBuilder(
        _buildFullMatrix(),
        wrapper: materialAppWrapper(
          theme: ThemeData.dark(),
        ),
        surfaceSize: const Size(380, 360),
      );
      await screenMatchesGolden(tester, 'checkbox_full_matrix_dark');
    });
  });
}

Widget _buildGrid(TwakeCheckboxState state) {
  const types = TwakeCheckboxType.values;
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: types
        .map((type) => TwakeCheckbox(type: type, state: state))
        .toList(),
  );
}

Widget _buildFullMatrix() {
  const types = TwakeCheckboxType.values;
  const states = TwakeCheckboxState.values;
  return Container(
    color: Colors.white,
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: states.map((state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: types
                .map((type) => TwakeCheckbox(type: type, state: state))
                .toList(),
          ),
        );
      }).toList(),
    ),
  );
}
