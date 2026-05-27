import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:linagora_design_flutter/button/twake_button.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  group('TwakeButton golden tests', () {
    // ── Light theme ──────────────────────────────────────────────────────────

    testGoldens('button_filled_types_light', (tester) async {
      await tester.pumpWidgetBuilder(
        _buildAllTypes(Brightness.light),
        surfaceSize: const Size(600, 120),
      );
      await screenMatchesGolden(tester, 'button_filled_types_light');
    });

    testGoldens('button_filled_states_light', (tester) async {
      await tester.pumpWidgetBuilder(
        _buildFilledStates(Brightness.light),
        surfaceSize: const Size(600, 80),
      );
      await screenMatchesGolden(tester, 'button_filled_states_light');
    });

    testGoldens('button_icon_configs_light', (tester) async {
      await tester.pumpWidgetBuilder(
        _buildIconConfigs(Brightness.light),
        surfaceSize: const Size(500, 80),
      );
      await screenMatchesGolden(tester, 'button_icon_configs_light');
    });

    testGoldens('button_devices_light', (tester) async {
      await tester.pumpWidgetBuilder(
        _buildDevices(Brightness.light),
        surfaceSize: const Size(400, 140),
      );
      await screenMatchesGolden(tester, 'button_devices_light');
    });

    // ── Dark theme ───────────────────────────────────────────────────────────

    testGoldens('button_filled_types_dark', (tester) async {
      await tester.pumpWidgetBuilder(
        _buildAllTypes(Brightness.dark),
        surfaceSize: const Size(600, 120),
      );
      await screenMatchesGolden(tester, 'button_filled_types_dark');
    });

    testGoldens('button_filled_states_dark', (tester) async {
      await tester.pumpWidgetBuilder(
        _buildFilledStates(Brightness.dark),
        surfaceSize: const Size(600, 80),
      );
      await screenMatchesGolden(tester, 'button_filled_states_dark');
    });

    testGoldens('button_disabled_all_types', (tester) async {
      await tester.pumpWidgetBuilder(
        _buildDisabledAllTypes(Brightness.light),
        surfaceSize: const Size(700, 80),
      );
      await screenMatchesGolden(tester, 'button_disabled_all_types');
    });
  });
}

Widget _wrap(Widget child, Brightness brightness) => MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
          brightness: brightness,
        ),
        useMaterial3: true,
      ),
      home: Scaffold(
        backgroundColor:
            brightness == Brightness.light ? Colors.white : const Color(0xFF1C1B1F),
        body: Center(child: child),
      ),
    );

Widget _buildAllTypes(Brightness brightness) => _wrap(
      Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            TwakeButton(
              label: 'Filled',
              type: TwakeButtonType.filled,
              onTap: () {},
            ),
            TwakeButton(
              label: 'Tonal',
              type: TwakeButtonType.tonal,
              onTap: () {},
            ),
            TwakeButton(
              label: 'Outlined',
              type: TwakeButtonType.outlined,
              onTap: () {},
            ),
            TwakeButton(
              label: 'Text',
              type: TwakeButtonType.text,
              onTap: () {},
            ),
            TwakeButton(
              label: 'Elevated',
              type: TwakeButtonType.elevated,
              onTap: () {},
            ),
          ],
        ),
      ),
      brightness,
    );

Widget _buildFilledStates(Brightness brightness) => _wrap(
      Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 12,
          children: [
            TwakeButton(label: 'Enabled', type: TwakeButtonType.filled, onTap: () {}),
            TwakeButton(label: 'Disabled', type: TwakeButtonType.filled, disabled: true, onTap: () {}),
            TwakeButton(label: 'No tap', type: TwakeButtonType.filled),
          ],
        ),
      ),
      brightness,
    );

Widget _buildIconConfigs(Brightness brightness) => _wrap(
      Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 12,
          children: [
            TwakeButton(
              label: 'No Icon',
              type: TwakeButtonType.filled,
              iconConfig: TwakeButtonIconConfig.none,
              onTap: () {},
            ),
            TwakeButton(
              label: 'Left Icon',
              type: TwakeButtonType.filled,
              iconConfig: TwakeButtonIconConfig.leftIcon,
              icon: const Icon(Icons.add),
              onTap: () {},
            ),
            TwakeButton(
              label: 'Right Icon',
              type: TwakeButtonType.filled,
              iconConfig: TwakeButtonIconConfig.rightIcon,
              icon: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ],
        ),
      ),
      brightness,
    );

Widget _buildDevices(Brightness brightness) => _wrap(
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TwakeButton(
              label: 'Desktop (40px)',
              type: TwakeButtonType.filled,
              device: TwakeButtonDevice.onDesktop,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            TwakeButton(
              label: 'Mobile (48px)',
              type: TwakeButtonType.filled,
              device: TwakeButtonDevice.onMobile,
              onTap: () {},
            ),
          ],
        ),
      ),
      brightness,
    );

Widget _buildDisabledAllTypes(Brightness brightness) => _wrap(
      Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 12,
          children: [
            TwakeButton(label: 'Filled', type: TwakeButtonType.filled, disabled: true, onTap: () {}),
            TwakeButton(label: 'Tonal', type: TwakeButtonType.tonal, disabled: true, onTap: () {}),
            TwakeButton(label: 'Outlined', type: TwakeButtonType.outlined, disabled: true, onTap: () {}),
            TwakeButton(label: 'Text', type: TwakeButtonType.text, disabled: true, onTap: () {}),
            TwakeButton(label: 'Elevated', type: TwakeButtonType.elevated, disabled: true, onTap: () {}),
          ],
        ),
      ),
      brightness,
    );
