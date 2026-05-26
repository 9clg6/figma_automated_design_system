@TestOn('vm')
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/list_item/twake_list_item.dart';
import 'package:linagora_design_flutter/list_item/twake_inkwell.dart';
import 'package:linagora_design_flutter/avatar/round_avatar.dart';

import '../../helpers/golden_test_helper.dart';

void main() {
  group('TwakeListItem golden tests', () {
    testWidgets('1-line, 2-line, 3-line content variants', (tester) async {
      await pumpGolden(
        tester,
        const _ListItemLineVariants(),
        size: const Size(450, 500),
      );

      await expectLater(
        find.byType(_ListItemLineVariants),
        matchesGoldenFile('list_item_line_variants.png'),
      );
    });

    testWidgets('with leading elements — icon, avatar, checkbox', (tester) async {
      await pumpGolden(
        tester,
        const _ListItemLeadingVariants(),
        size: const Size(450, 450),
      );

      await expectLater(
        find.byType(_ListItemLeadingVariants),
        matchesGoldenFile('list_item_leading.png'),
      );
    });

    testWidgets('with trailing elements — icon, text, switch', (tester) async {
      await pumpGolden(
        tester,
        const _ListItemTrailingVariants(),
        size: const Size(450, 400),
      );

      await expectLater(
        find.byType(_ListItemTrailingVariants),
        matchesGoldenFile('list_item_trailing.png'),
      );
    });

    testWidgets('custom height and padding', (tester) async {
      await pumpGolden(
        tester,
        const _ListItemCustomSizing(),
        size: const Size(450, 550),
      );

      await expectLater(
        find.byType(_ListItemCustomSizing),
        matchesGoldenFile('list_item_custom_sizing.png'),
      );
    });
  });

  group('TwakeInkWell golden tests', () {
    testWidgets('default + selected states', (tester) async {
      await pumpGolden(
        tester,
        const _InkWellStates(),
        size: const Size(450, 600),
      );

      await expectLater(
        find.byType(_InkWellStates),
        matchesGoldenFile('inkwell_states.png'),
      );
    });
  });
}

// ── Figma: 1-line (56px), 2-line (72px), 3-line (88px) ──
class _ListItemLineVariants extends StatelessWidget {
  const _ListItemLineVariants();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Figma: List Density=0 line variants',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('1-line (56px) / 2-line (72px) / 3-line (88px)',
              style: TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 16),

          // 1-line
          _label('1-line (56px)'),
          TwakeListItem(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text('Single line item', style: TextStyle(fontSize: 14)),
            ),
          ),
          const SizedBox(height: 8),

          // 2-line
          _label('2-line (72px)'),
          TwakeListItem(
            height: 72,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Headline text', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                SizedBox(height: 2),
                Text('Supporting text line', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // 3-line
          _label('3-line (88px)'),
          TwakeListItem(
            height: 88,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Headline text', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                SizedBox(height: 2),
                Text('Supporting text line 1', style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text('Supporting text line 2', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text(text, style: const TextStyle(fontSize: 10, color: Colors.black54)),
  );
}

// ── Figma leading elements: icon, avatar, checkbox ──
class _ListItemLeadingVariants extends StatelessWidget {
  const _ListItemLeadingVariants();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Figma: Leading Element Variants',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          // Leading icon
          TwakeListItem(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: const [
                Icon(Icons.folder_outlined, size: 24, color: Colors.black54),
                SizedBox(width: 16),
                Expanded(child: Text('Leading icon (24px)', style: TextStyle(fontSize: 14))),
              ],
            ),
          ),
          const SizedBox(height: 4),

          // Leading avatar
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
                      Text('Leading avatar (40px)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      SizedBox(height: 2),
                      Text('Supporting text', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),

          // Leading checkbox
          TwakeListItem(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Checkbox(value: true, onChanged: (_) {}),
                const SizedBox(width: 8),
                const Expanded(child: Text('Leading checkbox', style: TextStyle(fontSize: 14))),
              ],
            ),
          ),
          const SizedBox(height: 4),

          // Leading image
          TwakeListItem(
            height: 72,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F1FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.image, color: Color(0xFF0A84FF)),
                ),
                const SizedBox(width: 16),
                const Expanded(child: Text('Leading image (56px)', style: TextStyle(fontSize: 14))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Figma trailing elements: icon, text, switch ──
class _ListItemTrailingVariants extends StatelessWidget {
  const _ListItemTrailingVariants();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Figma: Trailing Element Variants',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          // Trailing icon
          TwakeListItem(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: const [
                Expanded(child: Text('Trailing icon', style: TextStyle(fontSize: 14))),
                Icon(Icons.chevron_right, size: 24, color: Colors.black54),
              ],
            ),
          ),
          const SizedBox(height: 4),

          // Trailing text
          TwakeListItem(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: const [
                Expanded(child: Text('Trailing text', style: TextStyle(fontSize: 14))),
                Text('100+', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 4),

          // Trailing switch
          TwakeListItem(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: const [
                Expanded(child: Text('Trailing switch', style: TextStyle(fontSize: 14))),
                Switch(value: true, onChanged: null),
              ],
            ),
          ),
          const SizedBox(height: 4),

          // Trailing checkbox
          TwakeListItem(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: const [
                Expanded(child: Text('Trailing checkbox', style: TextStyle(fontSize: 14))),
                Checkbox(value: false, onChanged: null),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Custom height and padding ──
class _ListItemCustomSizing extends StatelessWidget {
  const _ListItemCustomSizing();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Custom Height & Padding',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          _label('height: 48 (compact)'),
          TwakeListItem(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text('Compact item', style: TextStyle(fontSize: 13)),
            ),
          ),
          const SizedBox(height: 4),

          _label('height: 64 (default)'),
          TwakeListItem(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text('Default item', style: TextStyle(fontSize: 14)),
            ),
          ),
          const SizedBox(height: 4),

          _label('height: 80 (spacious)'),
          TwakeListItem(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text('Spacious item', style: TextStyle(fontSize: 15)),
            ),
          ),
          const SizedBox(height: 4),

          _label('margin: EdgeInsets.all(8)'),
          TwakeListItem(
            height: 56,
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text('Item with margin', style: TextStyle(fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text(text, style: const TextStyle(fontSize: 10, color: Colors.black54)),
  );
}

// ── TwakeInkWell: default + selected states ──
class _InkWellStates extends StatelessWidget {
  const _InkWellStates();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('TwakeInkWell — Interaction States',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Figma: Selected / Hovered / Default',
              style: TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 16),

          // Default state
          const Text('isSelected: false (default)',
              style: TextStyle(fontSize: 10, color: Colors.black54)),
          const SizedBox(height: 4),
          TwakeInkWell(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: const [
                  Icon(Icons.chat_bubble_outline, size: 20),
                  SizedBox(width: 12),
                  Text('Default state', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Selected state
          const Text('isSelected: true',
              style: TextStyle(fontSize: 10, color: Colors.black54)),
          const SizedBox(height: 4),
          TwakeInkWell(
            isSelected: true,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: const [
                  Icon(Icons.chat_bubble, size: 20),
                  SizedBox(width: 12),
                  Text('Selected state', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Multiple items showing contrast
          const Text('List with mixed selection',
              style: TextStyle(fontSize: 10, color: Colors.black54)),
          const SizedBox(height: 4),
          ...[
            ('General', true),
            ('Random', false),
            ('Design', false),
            ('Engineering', true),
          ].map((item) => TwakeInkWell(
            isSelected: item.$2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                '# ${item.$1}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: item.$2 ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }
}
