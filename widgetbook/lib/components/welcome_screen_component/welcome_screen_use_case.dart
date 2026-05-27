import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/twake_screen/twake_welcome_screen.dart';
import 'package:linagora_design_flutter/twake_screen/homeserver_button_widget.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeWelcomeScreen)
Widget welcomeScreenUseCase(BuildContext context) {
  return TwakeWelcomeScreen(
    useCompanyServerTitle: context.knobs.string(
      label: 'Company server title',
      initialValue: 'Use your company server',
    ),
    description: context.knobs.string(
      label: 'Description',
      initialValue: 'Connect with your team securely using the Twake platform.',
    ),
    signInTitle: 'Sign in',
    createTwakeIdTitle: 'Create a Twake ID',
    privacyPolicy: 'Privacy Policy',
    descriptionPrivacyPolicy:
        'By continuing, you agree to our terms and privacy policy.',
    logo: const FlutterLogo(size: 64),
    onSignInOnTap: () {},
    onCreateTwakeIdOnTap: () {},
    onUseCompanyServerOnTap: () {},
    onPrivacyPolicyOnTap: () {},
  );
}

@widgetbook.UseCase(name: 'Default', type: HomeserverButtonWidget)
Widget homeserverButtonUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: HomeserverButtonWidget(
        title: context.knobs.string(
          label: 'Title',
          initialValue: 'matrix.linagora.com',
        ),
        onTap: () {},
      ),
    ),
  );
}
