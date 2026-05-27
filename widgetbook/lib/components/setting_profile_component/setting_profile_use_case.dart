import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/setting_profile/twake_setting_profile.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeSettingProfile)
Widget settingProfileDefaultUseCase(BuildContext context) {
  return Center(
    child: TwakeSettingProfile(
      avatar: const CircleAvatar(child: Text('JD')),
      profileName: 'John Doe',
      subtitle: 'john.doe@example.com',
      onTap: () {},
    ),
  );
}
