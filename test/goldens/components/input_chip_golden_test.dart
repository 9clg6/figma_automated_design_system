import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:linagora_design_flutter/input_chip/twake_input_chip.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  group('TwakeInputChip golden tests', () {
    Widget _wrap(Widget child) => MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
            useMaterial3: true,
          ),
          home: Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: child),
          ),
        );

    testGoldens('label_only_unselected_enabled', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(
          const TwakeInputChip(
            label: 'Enabled',
            style: InputChipStyle.unselected,
            configuration: InputChipConfiguration.labelOnly,
            state: InputChipState.enabled,
          ),
        ),
        surfaceSize: const Size(200, 80),
      );
      await screenMatchesGolden(tester, 'input_chip_label_only_unselected_enabled');
    });

    testGoldens('label_trailing_icon_unselected_enabled', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(
          const TwakeInputChip(
            label: 'Enabled',
            style: InputChipStyle.unselected,
            configuration: InputChipConfiguration.labelAndTrailingIcon,
            state: InputChipState.enabled,
          ),
        ),
        surfaceSize: const Size(200, 80),
      );
      await screenMatchesGolden(tester, 'input_chip_label_trailing_icon_unselected_enabled');
    });

    testGoldens('leading_icon_label_unselected_focused', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(
          const TwakeInputChip(
            label: 'Focused',
            style: InputChipStyle.unselected,
            configuration: InputChipConfiguration.leadingIconAndLabel,
            state: InputChipState.focused,
          ),
        ),
        surfaceSize: const Size(200, 80),
      );
      await screenMatchesGolden(tester, 'input_chip_leading_icon_label_unselected_focused');
    });

    testGoldens('selected_label_only_hovered', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(
          const TwakeInputChip(
            label: 'Hovered',
            style: InputChipStyle.selected,
            configuration: InputChipConfiguration.labelOnly,
            state: InputChipState.hovered,
          ),
        ),
        surfaceSize: const Size(200, 80),
      );
      await screenMatchesGolden(tester, 'input_chip_selected_label_only_hovered');
    });

    testGoldens('selected_label_avatar_trailing_dragged', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(
          TwakeInputChip(
            label: 'Bob Jones',
            style: InputChipStyle.selected,
            configuration: InputChipConfiguration.labelAvatarAndTrailingIcon,
            state: InputChipState.dragged,
            avatar: const CircleAvatar(
              backgroundColor: Color(0xFF6750A4),
              child: Text('B', style: TextStyle(color: Colors.white, fontSize: 10)),
            ),
          ),
        ),
        surfaceSize: const Size(240, 80),
      );
      await screenMatchesGolden(tester, 'input_chip_selected_label_avatar_trailing_dragged');
    });

    testGoldens('all_configurations_grid', (tester) async {
      final configs = [
        InputChipConfiguration.labelOnly,
        InputChipConfiguration.labelAndTrailingIcon,
        InputChipConfiguration.leadingIconAndLabel,
        InputChipConfiguration.leadingIconLabelTrailingIcon,
        InputChipConfiguration.labelAndAvatar,
        InputChipConfiguration.labelAvatarAndTrailingIcon,
      ];
      await tester.pumpWidgetBuilder(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
            useMaterial3: true,
          ),
          home: Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final config in configs)
                    for (final style in InputChipStyle.values)
                      TwakeInputChip(
                        label: 'Label',
                        style: style,
                        configuration: config,
                        state: InputChipState.enabled,
                      ),
                ],
              ),
            ),
          ),
        ),
        surfaceSize: const Size(600, 300),
      );
      await screenMatchesGolden(tester, 'input_chip_all_configurations_grid');
    });
  });
}
