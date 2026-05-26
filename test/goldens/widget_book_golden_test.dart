@TestOn('vm')
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/avatar/round_avatar.dart';
import 'package:linagora_design_flutter/avatar/round_avatar_style.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';
import 'package:linagora_design_flutter/colors/linagora_ref_colors.dart';
import 'package:linagora_design_flutter/dialog/confirmation_dialog_builder.dart';
import 'package:linagora_design_flutter/dialog/options_dialog.dart';
import 'package:linagora_design_flutter/list_item/twake_list_item.dart';
import 'package:linagora_design_flutter/list_item/twake_inkwell.dart';
import 'package:linagora_design_flutter/reaction/reaction_picker.dart';
import 'package:linagora_design_flutter/style/linagora_divider_style.dart';
import 'package:linagora_design_flutter/style/linagora_hover_style.dart';

import '../helpers/golden_test_helper.dart';

void main() {
  group('Widget Book — full component catalog', () {
    testWidgets('page 1: avatars', (tester) async {
      await pumpGolden(tester, const _AvatarPage(), size: const Size(800, 900));
      await expectLater(
        find.byType(_AvatarPage),
        matchesGoldenFile('widget_book_avatars.png'),
      );
    });

    testWidgets('page 2: dialogs', (tester) async {
      await pumpGolden(tester, const _DialogPage(), size: const Size(800, 1800));
      await expectLater(
        find.byType(_DialogPage),
        matchesGoldenFile('widget_book_dialogs.png'),
      );
    });

    testWidgets('page 3: lists & interactions', (tester) async {
      await pumpGolden(tester, const _ListPage(), size: const Size(800, 1100));
      await expectLater(
        find.byType(_ListPage),
        matchesGoldenFile('widget_book_lists.png'),
      );
    });

    testWidgets('page 4: styles (divider, hover, reaction)', (tester) async {
      await pumpGolden(tester, const _StylesPage(), size: const Size(800, 1200));
      await expectLater(
        find.byType(_StylesPage),
        matchesGoldenFile('widget_book_styles.png'),
      );
    });
  });
}

// ═══════════════════════════════════════════════════════════════════
// PAGE 1: AVATARS
// ═══════════════════════════════════════════════════════════════════
class _AvatarPage extends StatelessWidget {
  const _AvatarPage();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _sectionTitle('❖ Avatar', 'Figma: 166 component sets'),

          // Size variants
          _subsection('Size variants (Figma: 40, 56, 60, 96, 160)'),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [40.0, 56.0, 60.0, 96.0, 160.0].map((s) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RoundAvatar(text: 'CL', size: s),
                  const SizedBox(height: 4),
                  Text('${s.toInt()}', style: const TextStyle(fontSize: 9, color: Colors.black54)),
                ],
              ),
            )).toList(),
          ),

          const SizedBox(height: 24),
          _subsection('Monogram style — 10 gradient palettes'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(10, (i) => RoundAvatar(
              text: '#${i + 1}',
              size: 48,
              linearGradientColors: RoundAvatarStyle.defaultGradientColors[i],
              stops: RoundAvatarStyle.defaultGradientStops,
            )),
          ),

          const SizedBox(height: 24),
          _subsection('Text diversity'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['AB', 'CD', 'EF', 'GH', 'IJ', 'KL', 'MN', 'OP', 'QR', 'ST']
                .map((t) => RoundAvatar(text: t, size: 40))
                .toList(),
          ),

          const SizedBox(height: 24),
          _subsection('Box shadow variant'),
          Row(
            children: [
              const RoundAvatar(text: 'NS', size: 56),
              const SizedBox(width: 24),
              RoundAvatar(
                text: 'WS', size: 56,
                boxShadows: const [
                  BoxShadow(color: Color(0x40000000), blurRadius: 8, offset: Offset(0, 4)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// PAGE 2: DIALOGS
// ═══════════════════════════════════════════════════════════════════
class _DialogPage extends StatelessWidget {
  const _DialogPage();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _sectionTitle('❖ Dialog modal', 'Figma: 29 component sets'),

          _subsection('Basic dialog (Icon=false)'),
          ConfirmationDialogBuilder(
            title: 'Delete conversation?',
            textContent: 'This action cannot be undone.',
            confirmText: 'Delete',
            cancelText: 'Cancel',
            onConfirmButtonAction: () {},
            onCancelButtonAction: () {},
          ),

          const SizedBox(height: 24),
          _subsection('Vertical action buttons'),
          ConfirmationDialogBuilder(
            title: 'Leave room',
            textContent: 'You will no longer see messages.',
            confirmText: 'Leave room',
            cancelText: 'Stay',
            isArrangeActionButtonsVertical: true,
            onConfirmButtonAction: () {},
            onCancelButtonAction: () {},
          ),

          const SizedBox(height: 24),
          _subsection('Rich text content'),
          ConfirmationDialogBuilder(
            title: 'Remove member',
            listTextSpan: const [
              TextSpan(text: 'Remove '),
              TextSpan(text: 'John Doe', style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: ' from this room?'),
            ],
            confirmText: 'Remove',
            cancelText: 'Cancel',
            onConfirmButtonAction: () {},
            onCancelButtonAction: () {},
          ),

          const SizedBox(height: 24),
          _subsection('Options dialog (list)'),
          SizedBox(
            width: 400,
            child: OptionsDialog<String>(
              title: 'Choose language',
              availableOptions: const [
                LinagoraDialogOption(name: 'English', value: 'en'),
                LinagoraDialogOption(name: 'Français', value: 'fr'),
                LinagoraDialogOption(name: 'Deutsch', value: 'de'),
              ],
              onSelected: (_) {},
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// PAGE 3: LISTS & INTERACTIONS
// ═══════════════════════════════════════════════════════════════════
class _ListPage extends StatelessWidget {
  const _ListPage();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _sectionTitle('❖ Lists', 'Figma: 1325 component sets'),

          _subsection('Line variants (1-line 56px / 2-line 72px / 3-line 88px)'),

          // 1-line
          TwakeListItem(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: const [
                Icon(Icons.inbox, size: 24, color: Colors.black54),
                SizedBox(width: 16),
                Expanded(child: Text('1-line: Single headline')),
              ],
            ),
          ),

          // 2-line
          TwakeListItem(
            height: 72,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const RoundAvatar(text: 'JD', size: 40),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('2-line: Headline', style: TextStyle(fontWeight: FontWeight.w500)),
                      SizedBox(height: 2),
                      Text('Supporting text', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                const Text('12:34', style: TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),

          // 3-line
          TwakeListItem(
            height: 88,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: RoundAvatar(text: 'AS', size: 40),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('3-line: Headline', style: TextStyle(fontWeight: FontWeight.w500)),
                      SizedBox(height: 2),
                      Text('Supporting line 1', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text('Supporting line 2', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          _subsection('Leading variants'),
          // icon
          TwakeListItem(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: const [
                Icon(Icons.folder_outlined, size: 24, color: Colors.black54),
                SizedBox(width: 16),
                Expanded(child: Text('Leading icon')),
              ],
            ),
          ),
          // checkbox
          TwakeListItem(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Checkbox(value: true, onChanged: (_) {}),
                const SizedBox(width: 8),
                const Expanded(child: Text('Leading checkbox')),
              ],
            ),
          ),

          const SizedBox(height: 24),
          _subsection('Trailing variants'),
          TwakeListItem(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: const [
                Expanded(child: Text('Trailing icon')),
                Icon(Icons.chevron_right, size: 24, color: Colors.black54),
              ],
            ),
          ),
          TwakeListItem(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: const [
                Expanded(child: Text('Trailing switch')),
                Switch(value: true, onChanged: null),
              ],
            ),
          ),

          const SizedBox(height: 24),
          _sectionTitle('❖ TwakeInkWell', 'Hover/selected states'),
          _subsection('Selection states'),
          TwakeInkWell(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: const Text('Default (not selected)'),
            ),
          ),
          TwakeInkWell(
            isSelected: true,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: const Text('Selected', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
          TwakeInkWell(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: const Text('Default again'),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// PAGE 4: STYLES (divider, hover, reaction)
// ═══════════════════════════════════════════════════════════════════
class _StylesPage extends StatelessWidget {
  const _StylesPage();

  @override
  Widget build(BuildContext context) {
    final divStyle = LinagoraDividerStyle.material();
    final hovStyle = LinagoraHoverStyle.material();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Dividers ──
          _sectionTitle('❖ Dividers', 'Figma: 14 component sets'),

          _subsection('horizontal/full-width'),
          Divider(color: divStyle.color, thickness: divStyle.thickness, height: 1),
          const SizedBox(height: 16),

          _subsection('horizontal/inset (left: 16)'),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Divider(color: divStyle.color, thickness: divStyle.thickness, height: 1),
          ),
          const SizedBox(height: 16),

          _subsection('horizontal/middle-inset'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(color: divStyle.color, thickness: divStyle.thickness, height: 1),
          ),
          const SizedBox(height: 16),

          _subsection('horizontal/with subhead'),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16, right: 8),
                child: Text('Section', style: TextStyle(fontSize: 12, color: Colors.black54)),
              ),
              Expanded(child: Divider(color: divStyle.color, thickness: divStyle.thickness, height: 1)),
            ],
          ),

          const SizedBox(height: 32),
          // ── Hover Style ──
          _sectionTitle('❖ On action hovered bar', 'Figma: 18 component sets'),

          _subsection('Color swatches'),
          Row(
            children: [
              _swatch('hoverColor', hovStyle.hoverColor),
              const SizedBox(width: 16),
              _swatch('selectedColor', hovStyle.selectedColor),
            ],
          ),
          const SizedBox(height: 16),

          _subsection('Hover vs selected state'),
          Container(
            decoration: BoxDecoration(
              color: hovStyle.hoverColor,
              borderRadius: hovStyle.hoverBorderRadius,
            ),
            padding: const EdgeInsets.all(12),
            child: const Text('Hovered'),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: hovStyle.selectedColor,
              borderRadius: hovStyle.borderRadius,
            ),
            padding: const EdgeInsets.all(12),
            child: const Text('Selected', style: TextStyle(fontWeight: FontWeight.w600)),
          ),

          const SizedBox(height: 32),
          // ── Reactions ──
          _sectionTitle('❖ Reaction chat', 'Figma: reaction picker'),

          _subsection('Default picker'),
          const ReactionsPicker(enableMoreEmojiWidget: false),

          const SizedBox(height: 16),
          _subsection('With "more" button'),
          const ReactionsPicker(enableMoreEmojiWidget: true),

          const SizedBox(height: 16),
          _subsection('Own reaction highlighted (👍)'),
          const ReactionsPicker(myEmojiReacted: '👍', enableMoreEmojiWidget: false),

          const SizedBox(height: 16),
          _subsection('Custom emojis'),
          const ReactionsPicker(
            emojis: ['🎉', '🔥', '💯', '✅', '❌'],
            emojiSize: 36,
            borderRadius: 16,
            height: 64,
            enableMoreEmojiWidget: false,
          ),
        ],
      ),
    );
  }

  static Widget _swatch(String label, Color color) {
    final hex = '#${color.value.toRadixString(16).toUpperCase().padLeft(8, '0')}';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24, height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.black12),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 10)),
            Text(hex, style: const TextStyle(fontSize: 8, fontFamily: 'monospace', color: Colors.black54)),
          ],
        ),
      ],
    );
  }
}

// ── Shared helpers ──
Widget _sectionTitle(String title, String subtitle) => Padding(
  padding: const EdgeInsets.only(bottom: 16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
    ],
  ),
);

Widget _subsection(String text) => Padding(
  padding: const EdgeInsets.only(bottom: 8, top: 4),
  child: Text(text, style: const TextStyle(fontSize: 11, color: Colors.black54, fontWeight: FontWeight.w500)),
);
