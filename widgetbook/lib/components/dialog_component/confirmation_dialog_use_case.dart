import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/dialog/confirmation_dialog_builder.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Basic', type: ConfirmationDialogBuilder)
Widget dialogBasicUseCase(BuildContext context) {
  return Center(
    child: ConfirmationDialogBuilder(
      title: context.knobs.string(
        label: 'Title',
        initialValue: 'Delete conversation?',
      ),
      textContent: context.knobs.string(
        label: 'Content',
        initialValue:
            'This action cannot be undone. All messages will be permanently removed.',
      ),
      confirmText: context.knobs.string(
        label: 'Confirm text',
        initialValue: 'Delete',
      ),
      cancelText: context.knobs.string(
        label: 'Cancel text',
        initialValue: 'Cancel',
      ),
      maxWidth: 312,
      onConfirmButtonAction: () {},
      onCancelButtonAction: () {},
    ),
  );
}

@widgetbook.UseCase(name: 'Vertical actions', type: ConfirmationDialogBuilder)
Widget dialogVerticalUseCase(BuildContext context) {
  return Center(
    child: ConfirmationDialogBuilder(
      title: 'Sign out',
      textContent: 'Are you sure you want to sign out of your account?',
      confirmText: 'Sign out',
      cancelText: 'Stay signed in',
      isArrangeActionButtonsVertical: true,
      maxWidth: 312,
      onConfirmButtonAction: () {},
      onCancelButtonAction: () {},
    ),
  );
}

@widgetbook.UseCase(name: 'With close button', type: ConfirmationDialogBuilder)
Widget dialogCloseButtonUseCase(BuildContext context) {
  return Center(
    child: ConfirmationDialogBuilder(
      title: 'Notification settings',
      textContent: 'Choose how you want to receive notifications for this room.',
      confirmText: 'Save',
      cancelText: 'Reset',
      maxWidth: 312,
      onCloseButtonAction: () {},
      onConfirmButtonAction: () {},
      onCancelButtonAction: () {},
    ),
  );
}
