@TestOn('vm')
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/dialog/confirmation_dialog_builder.dart';
import 'package:linagora_design_flutter/dialog/options_dialog.dart';

import '../../helpers/golden_test_helper.dart';

void main() {
  group('ConfirmationDialogBuilder golden tests', () {
    testWidgets('basic dialog — title + text + actions', (tester) async {
      await pumpGolden(
        tester,
        const _BasicDialogShowcase(),
        size: const Size(550, 550),
      );

      await expectLater(
        find.byType(_BasicDialogShowcase),
        matchesGoldenFile('dialog_basic.png'),
      );
    });

    testWidgets('dialog with icon=false (no close button)', (tester) async {
      await pumpGolden(
        tester,
        const _DialogNoIcon(),
        size: const Size(550, 500),
      );

      await expectLater(
        find.byType(_DialogNoIcon),
        matchesGoldenFile('dialog_no_icon.png'),
      );
    });

    testWidgets('dialog with vertical action buttons', (tester) async {
      await pumpGolden(
        tester,
        const _DialogVerticalActions(),
        size: const Size(550, 550),
      );

      await expectLater(
        find.byType(_DialogVerticalActions),
        matchesGoldenFile('dialog_vertical_actions.png'),
      );
    });

    testWidgets('dialog with additional widget content', (tester) async {
      await pumpGolden(
        tester,
        const _DialogWithAdditionalContent(),
        size: const Size(550, 650),
      );

      await expectLater(
        find.byType(_DialogWithAdditionalContent),
        matchesGoldenFile('dialog_additional_content.png'),
      );
    });

    testWidgets('dialog with rich text spans', (tester) async {
      await pumpGolden(
        tester,
        const _DialogRichText(),
        size: const Size(550, 550),
      );

      await expectLater(
        find.byType(_DialogRichText),
        matchesGoldenFile('dialog_rich_text.png'),
      );
    });

    testWidgets('dialog custom button colors', (tester) async {
      await pumpGolden(
        tester,
        const _DialogCustomColors(),
        size: const Size(550, 500),
      );

      await expectLater(
        find.byType(_DialogCustomColors),
        matchesGoldenFile('dialog_custom_colors.png'),
      );
    });
  });

  group('OptionsDialog golden tests', () {
    testWidgets('options dialog — standard', (tester) async {
      await pumpGolden(
        tester,
        const _OptionsDialogShowcase(),
        size: const Size(550, 550),
      );

      await expectLater(
        find.byType(_OptionsDialogShowcase),
        matchesGoldenFile('dialog_options.png'),
      );
    });

    testWidgets('options dialog — with description', (tester) async {
      await pumpGolden(
        tester,
        const _OptionsDialogWithDescription(),
        size: const Size(550, 600),
      );

      await expectLater(
        find.byType(_OptionsDialogWithDescription),
        matchesGoldenFile('dialog_options_description.png'),
      );
    });

    testWidgets('options dialog — with trailing icons', (tester) async {
      await pumpGolden(
        tester,
        const _OptionsDialogWithIcons(),
        size: const Size(550, 550),
      );

      await expectLater(
        find.byType(_OptionsDialogWithIcons),
        matchesGoldenFile('dialog_options_icons.png'),
      );
    });
  });
}

// ── Basic dialog: title + content + confirm/cancel ──
class _BasicDialogShowcase extends StatelessWidget {
  const _BasicDialogShowcase();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Figma: Basic dialog — Icon=false',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ConfirmationDialogBuilder(
            title: 'Delete conversation?',
            textContent: 'This action cannot be undone. All messages in this conversation will be permanently deleted.',
            confirmText: 'Delete',
            cancelText: 'Cancel',
            onConfirmButtonAction: () {},
            onCancelButtonAction: () {},
          ),
        ],
      ),
    );
  }
}

// ── Dialog without close button (Icon=false variant) ──
class _DialogNoIcon extends StatelessWidget {
  const _DialogNoIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Dialog — no close button',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ConfirmationDialogBuilder(
            title: 'Confirm action',
            textContent: 'Are you sure you want to proceed?',
            confirmText: 'Yes',
            cancelText: 'No',
            onConfirmButtonAction: () {},
            onCancelButtonAction: () {},
          ),
        ],
      ),
    );
  }
}

// ── Vertical action buttons layout ──
class _DialogVerticalActions extends StatelessWidget {
  const _DialogVerticalActions();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Dialog — vertical action buttons',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ConfirmationDialogBuilder(
            title: 'Leave room',
            textContent: 'You will no longer be able to see messages in this room.',
            confirmText: 'Leave room',
            cancelText: 'Stay',
            isArrangeActionButtonsVertical: true,
            onConfirmButtonAction: () {},
            onCancelButtonAction: () {},
          ),
        ],
      ),
    );
  }
}

// ── Dialog with additional widget content ──
class _DialogWithAdditionalContent extends StatelessWidget {
  const _DialogWithAdditionalContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Dialog — additional widget',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ConfirmationDialogBuilder(
            title: 'Set notification',
            textContent: 'Choose how long to mute:',
            confirmText: 'Mute',
            cancelText: 'Cancel',
            additionalWidgetContent: Column(
              children: [
                _radioTile('15 minutes'),
                _radioTile('1 hour'),
                _radioTile('8 hours'),
                _radioTile('Forever'),
              ],
            ),
            onConfirmButtonAction: () {},
            onCancelButtonAction: () {},
          ),
        ],
      ),
    );
  }

  static Widget _radioTile(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.radio_button_off, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

// ── Dialog with rich text (TextSpan) ──
class _DialogRichText extends StatelessWidget {
  const _DialogRichText();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Dialog — rich text content',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ConfirmationDialogBuilder(
            title: 'Remove member',
            listTextSpan: const [
              TextSpan(text: 'Are you sure you want to remove '),
              TextSpan(
                text: 'John Doe',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: ' from this room?'),
            ],
            confirmText: 'Remove',
            cancelText: 'Cancel',
            onConfirmButtonAction: () {},
            onCancelButtonAction: () {},
          ),
        ],
      ),
    );
  }
}

// ── Dialog with custom button colors ──
class _DialogCustomColors extends StatelessWidget {
  const _DialogCustomColors();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Dialog — custom button colors',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ConfirmationDialogBuilder(
            title: 'Danger zone',
            textContent: 'This will permanently delete your account.',
            confirmText: 'Delete account',
            cancelText: 'Keep account',
            confirmBackgroundButtonColor: const Color(0xFFFF3347),
            confirmLabelButtonColor: Colors.white,
            cancelBackgroundButtonColor: Colors.transparent,
            cancelLabelButtonColor: const Color(0xFF0A84FF),
            onConfirmButtonAction: () {},
            onCancelButtonAction: () {},
          ),
        ],
      ),
    );
  }
}

// ── OptionsDialog standard ──
class _OptionsDialogShowcase extends StatelessWidget {
  const _OptionsDialogShowcase();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Figma: List dialog — options',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SizedBox(
            width: 400,
            child: OptionsDialog<String>(
              title: 'Choose language',
              availableOptions: const [
                LinagoraDialogOption(name: 'English', value: 'en'),
                LinagoraDialogOption(name: 'Français', value: 'fr'),
                LinagoraDialogOption(name: 'Deutsch', value: 'de'),
                LinagoraDialogOption(name: 'Español', value: 'es'),
              ],
              onSelected: (_) {},
            ),
          ),
        ],
      ),
    );
  }
}

// ── OptionsDialog with description ──
class _OptionsDialogWithDescription extends StatelessWidget {
  const _OptionsDialogWithDescription();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Options dialog — with description',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SizedBox(
            width: 400,
            child: OptionsDialog<String>(
              title: 'Export chat',
              description: 'Select the format for your exported conversation:',
              availableOptions: const [
                LinagoraDialogOption(name: 'Plain text (.txt)', value: 'txt'),
                LinagoraDialogOption(name: 'JSON (.json)', value: 'json'),
                LinagoraDialogOption(name: 'HTML (.html)', value: 'html'),
              ],
              onSelected: (_) {},
            ),
          ),
        ],
      ),
    );
  }
}

// ── OptionsDialog with trailing icons ──
class _OptionsDialogWithIcons extends StatelessWidget {
  const _OptionsDialogWithIcons();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Options dialog — trailing icons',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SizedBox(
            width: 400,
            child: OptionsDialog<String>(
              title: 'Sort messages',
              availableOptions: const [
                LinagoraDialogOption(
                  name: 'Newest first',
                  value: 'newest',
                  trailingIcon: Icon(Icons.arrow_downward, size: 18),
                ),
                LinagoraDialogOption(
                  name: 'Oldest first',
                  value: 'oldest',
                  trailingIcon: Icon(Icons.arrow_upward, size: 18),
                ),
                LinagoraDialogOption(
                  name: 'By sender',
                  value: 'sender',
                  trailingIcon: Icon(Icons.person, size: 18),
                ),
              ],
              onSelected: (_) {},
            ),
          ),
        ],
      ),
    );
  }
}
