import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:linagora_design_flutter/small_fab/twake_small_fab.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  // ── Golden tests ───────────────────────────────────────────────────────────

  testGoldens('TwakeSmallFab — light — all configurations x states', (tester) async {
    const size = Size(400, 280);

    await tester.pumpWidgetBuilder(
      Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: [
          for (final config in SmallFabConfiguration.values)
            for (final state in SmallFabState.values)
              SizedBox(
                width: 60,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TwakeSmallFab(
                      configuration: config,
                      state: state,
                      icon: Icons.edit_outlined,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${config.name[0].toUpperCase()}\n${state.name[0].toUpperCase()}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 8),
                    ),
                  ],
                ),
              ),
        ],
      ),
      wrapper: (child) => MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4285F4),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
      surfaceSize: size,
    );

    await screenMatchesGolden(
      tester,
      'small_fab_light_all_variants',
    );
  });

  testGoldens('TwakeSmallFab — dark — all configurations x states', (tester) async {
    const size = Size(400, 280);

    await tester.pumpWidgetBuilder(
      Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: [
          for (final config in SmallFabConfiguration.values)
            for (final state in SmallFabState.values)
              SizedBox(
                width: 60,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TwakeSmallFab(
                      configuration: config,
                      state: state,
                      icon: Icons.edit_outlined,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${config.name[0].toUpperCase()}\n${state.name[0].toUpperCase()}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 8,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ),
      wrapper: (child) => MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4285F4),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: Scaffold(
          backgroundColor: const Color(0xFF1C1B1F),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
      surfaceSize: size,
    );

    await screenMatchesGolden(
      tester,
      'small_fab_dark_all_variants',
    );
  });

  testGoldens('TwakeSmallFab — surface enabled (single)', (tester) async {
    await tester.pumpWidgetBuilder(
      const TwakeSmallFab(
        configuration: SmallFabConfiguration.surface,
        state: SmallFabState.enabled,
        icon: Icons.edit_outlined,
      ),
      wrapper: (child) => MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4285F4),
          ),
          useMaterial3: true,
        ),
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: child),
        ),
      ),
      surfaceSize: const Size(80, 80),
    );

    await screenMatchesGolden(tester, 'small_fab_surface_enabled');
  });

  testGoldens('TwakeSmallFab — primary pressed (single)', (tester) async {
    await tester.pumpWidgetBuilder(
      const TwakeSmallFab(
        configuration: SmallFabConfiguration.primary,
        state: SmallFabState.pressed,
        icon: Icons.edit_outlined,
      ),
      wrapper: (child) => MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4285F4),
          ),
          useMaterial3: true,
        ),
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: child),
        ),
      ),
      surfaceSize: const Size(80, 80),
    );

    await screenMatchesGolden(tester, 'small_fab_primary_pressed');
  });
}
