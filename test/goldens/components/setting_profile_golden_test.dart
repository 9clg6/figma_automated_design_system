import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:linagora_design_flutter/setting_profile/twake_setting_profile.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  Widget buildSubject({
    required SettingProfileState state,
  }) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SizedBox(
            width: 376,
            child: TwakeSettingProfile(
              avatar: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.grey.shade300,
                child: const Text('A'),
              ),
              profileName: 'Profile Name',
              subtitle: 'mira@domain.tld',
              state: state,
              onTap: () {},
            ),
          ),
        ),
      ),
    );
  }

  group('TwakeSettingProfile golden tests', () {
    testGoldens('State=Default', (tester) async {
      await tester.pumpWidgetBuilder(
        buildSubject(state: SettingProfileState.defaultState),
        surfaceSize: const Size(376, 88),
      );
      await screenMatchesGolden(
        tester,
        'setting_profile_default',
      );
    });

    testGoldens('State=Hover', (tester) async {
      await tester.pumpWidgetBuilder(
        buildSubject(state: SettingProfileState.hover),
        surfaceSize: const Size(376, 88),
      );
      await screenMatchesGolden(
        tester,
        'setting_profile_hover',
      );
    });

    testGoldens('State=Active', (tester) async {
      await tester.pumpWidgetBuilder(
        buildSubject(state: SettingProfileState.active),
        surfaceSize: const Size(376, 88),
      );
      await screenMatchesGolden(
        tester,
        'setting_profile_active',
      );
    });
  });
}
