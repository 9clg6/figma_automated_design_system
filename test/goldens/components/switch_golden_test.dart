import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:linagora_design_flutter/switch/twake_switch.dart';

void main() {
  group('TwakeSwitch golden tests', () {
    testGoldens('switch_all_variants_light', (tester) async {
      await loadAppFonts();

      final states = [
        TwakeSwitchState.enabled,
        TwakeSwitchState.hovered,
        TwakeSwitchState.focused,
        TwakeSwitchState.pressed,
        TwakeSwitchState.disabled,
      ];

      await tester.pumpWidgetBuilder(
        MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            backgroundColor: const Color(0xFFF5F5F5),
            body: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Selected=true, Icon=false
                  Row(
                    children: states
                        .map(
                          (s) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TwakeSwitch(
                              selected: true,
                              state: s,
                              showIcon: false,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  // Selected=true, Icon=true
                  Row(
                    children: states
                        .map(
                          (s) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TwakeSwitch(
                              selected: true,
                              state: s,
                              showIcon: true,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  // Selected=false, Icon=false
                  Row(
                    children: states
                        .map(
                          (s) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TwakeSwitch(
                              selected: false,
                              state: s,
                              showIcon: false,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  // Selected=false, Icon=true
                  Row(
                    children: states
                        .map(
                          (s) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TwakeSwitch(
                              selected: false,
                              state: s,
                              showIcon: true,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
        surfaceSize: const Size(520, 320),
      );

      await screenMatchesGolden(tester, 'switch_all_variants_light');
    });

    testGoldens('switch_all_variants_dark', (tester) async {
      await loadAppFonts();

      final states = [
        TwakeSwitchState.enabled,
        TwakeSwitchState.hovered,
        TwakeSwitchState.focused,
        TwakeSwitchState.pressed,
        TwakeSwitchState.disabled,
      ];

      await tester.pumpWidgetBuilder(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            backgroundColor: const Color(0xFF1E1E1E),
            body: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: states
                        .map(
                          (s) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TwakeSwitch(
                              selected: true,
                              state: s,
                              showIcon: false,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: states
                        .map(
                          (s) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TwakeSwitch(
                              selected: true,
                              state: s,
                              showIcon: true,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: states
                        .map(
                          (s) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TwakeSwitch(
                              selected: false,
                              state: s,
                              showIcon: false,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: states
                        .map(
                          (s) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TwakeSwitch(
                              selected: false,
                              state: s,
                              showIcon: true,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
        surfaceSize: const Size(520, 320),
      );

      await screenMatchesGolden(tester, 'switch_all_variants_dark');
    });

    testGoldens('switch_selected_enabled', (tester) async {
      await loadAppFonts();
      await tester.pumpWidgetBuilder(
        const MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: TwakeSwitch(
                selected: true,
                state: TwakeSwitchState.enabled,
                showIcon: false,
              ),
            ),
          ),
        ),
        surfaceSize: const Size(120, 80),
      );
      await screenMatchesGolden(tester, 'switch_selected_enabled');
    });

    testGoldens('switch_unselected_enabled', (tester) async {
      await loadAppFonts();
      await tester.pumpWidgetBuilder(
        const MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: TwakeSwitch(
                selected: false,
                state: TwakeSwitchState.enabled,
                showIcon: false,
              ),
            ),
          ),
        ),
        surfaceSize: const Size(120, 80),
      );
      await screenMatchesGolden(tester, 'switch_unselected_enabled');
    });

    testGoldens('switch_selected_with_icon', (tester) async {
      await loadAppFonts();
      await tester.pumpWidgetBuilder(
        const MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: TwakeSwitch(
                selected: true,
                state: TwakeSwitchState.enabled,
                showIcon: true,
              ),
            ),
          ),
        ),
        surfaceSize: const Size(120, 80),
      );
      await screenMatchesGolden(tester, 'switch_selected_with_icon');
    });

    testGoldens('switch_disabled_selected', (tester) async {
      await loadAppFonts();
      await tester.pumpWidgetBuilder(
        const MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: TwakeSwitch(
                selected: true,
                state: TwakeSwitchState.disabled,
                showIcon: false,
              ),
            ),
          ),
        ),
        surfaceSize: const Size(120, 80),
      );
      await screenMatchesGolden(tester, 'switch_disabled_selected');
    });

    testGoldens('switch_disabled_unselected', (tester) async {
      await loadAppFonts();
      await tester.pumpWidgetBuilder(
        const MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: TwakeSwitch(
                selected: false,
                state: TwakeSwitchState.disabled,
                showIcon: false,
              ),
            ),
          ),
        ),
        surfaceSize: const Size(120, 80),
      );
      await screenMatchesGolden(tester, 'switch_disabled_unselected');
    });
  });
}
