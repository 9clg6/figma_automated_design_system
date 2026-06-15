import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/setting_profile//twake_setting_profile.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeSettingProfile)
Widget settingsDefaultUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: TwakeSettingProfile(
    // avatar: TODO,
    // profileName: TODO,
    // subtitle: TODO,
      ),
    ),
  );
}
