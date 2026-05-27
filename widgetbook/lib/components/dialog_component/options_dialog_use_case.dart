import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/dialog/options_dialog.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Basic', type: OptionsDialog)
Widget optionsDialogBasicUseCase(BuildContext context) {
  return Center(
    child: OptionsDialog<String>(
      title: context.knobs.string(
        label: 'Title',
        initialValue: 'Sort messages',
      ),
      availableOptions: const [
        LinagoraDialogOption(name: 'Newest first', value: 'newest'),
        LinagoraDialogOption(name: 'Oldest first', value: 'oldest'),
        LinagoraDialogOption(name: 'Most relevant', value: 'relevant'),
      ],
      onSelected: (_) {},
    ),
  );
}

@widgetbook.UseCase(name: 'With description', type: OptionsDialog)
Widget optionsDialogDescriptionUseCase(BuildContext context) {
  return Center(
    child: OptionsDialog<String>(
      title: 'Choose notification level',
      description: 'This setting applies to the current room only.',
      availableOptions: const [
        LinagoraDialogOption(name: 'All messages', value: 'all'),
        LinagoraDialogOption(name: 'Mentions only', value: 'mentions'),
        LinagoraDialogOption(name: 'Muted', value: 'muted'),
      ],
      onSelected: (_) {},
    ),
  );
}

@widgetbook.UseCase(name: 'With icons', type: OptionsDialog)
Widget optionsDialogIconsUseCase(BuildContext context) {
  return Center(
    child: OptionsDialog<String>(
      title: 'Share via',
      availableOptions: [
        LinagoraDialogOption(
          name: 'Copy link',
          value: 'copy',
          trailingIcon: const Icon(Icons.link, size: 20),
        ),
        LinagoraDialogOption(
          name: 'Email',
          value: 'email',
          trailingIcon: const Icon(Icons.email_outlined, size: 20),
        ),
        LinagoraDialogOption(
          name: 'QR Code',
          value: 'qr',
          trailingIcon: const Icon(Icons.qr_code, size: 20),
        ),
      ],
      onSelected: (_) {},
    ),
  );
}
