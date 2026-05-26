@TestOn('vm')
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/style/linagora_hover_style.dart';

import '../../helpers/golden_test_helper.dart';

void main() {
  group('LinagoraHoverStyle golden tests', () {
    testWidgets('hover and selected color swatches', (tester) async {
      await pumpGolden(
        tester,
        const _HoverStyleProperties(),
        size: const Size(500, 350),
      );

      await expectLater(
        find.byType(_HoverStyleProperties),
        matchesGoldenFile('hover_style_properties.png'),
      );
    });

    testWidgets('hover bar in context — Figma: On action hovered bar', (tester) async {
      await pumpGolden(
        tester,
        const _HoverBarShowcase(),
        size: const Size(500, 500),
      );

      await expectLater(
        find.byType(_HoverBarShowcase),
        matchesGoldenFile('hover_bar_showcase.png'),
      );
    });
  });
}

// ── Property swatches ──
class _HoverStyleProperties extends StatelessWidget {
  const _HoverStyleProperties();

  @override
  Widget build(BuildContext context) {
    final style = LinagoraHoverStyle.material();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('LinagoraHoverStyle Properties',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Figma: ❖ On action hovered bar',
              style: TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 20),

          _colorRow('hoverColor', style.hoverColor),
          const SizedBox(height: 12),
          _colorRow('selectedColor', style.selectedColor),
          const SizedBox(height: 20),

          const Text('borderRadius', style: TextStyle(fontSize: 11, color: Colors.black54)),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 120, height: 48,
                decoration: BoxDecoration(
                  color: style.selectedColor,
                  borderRadius: style.borderRadius,
                  border: Border.all(color: Colors.black12),
                ),
                alignment: Alignment.center,
                child: const Text('borderRadius', style: TextStyle(fontSize: 10)),
              ),
              const SizedBox(width: 16),
              Container(
                width: 120, height: 48,
                decoration: BoxDecoration(
                  color: style.hoverColor,
                  borderRadius: style.hoverBorderRadius,
                  border: Border.all(color: Colors.black12),
                ),
                alignment: Alignment.center,
                child: const Text('hoverBorderRadius', style: TextStyle(fontSize: 10)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _colorRow(String label, Color color) {
    final hex = '#${color.value.toRadixString(16).toUpperCase().padLeft(8, '0')}';
    return Row(
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.black12),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            Text(hex, style: const TextStyle(fontSize: 10, fontFamily: 'monospace', color: Colors.black54)),
          ],
        ),
      ],
    );
  }
}

// ── Figma: On action hovered bar — action icons on hover ──
class _HoverBarShowcase extends StatelessWidget {
  const _HoverBarShowcase();

  @override
  Widget build(BuildContext context) {
    final style = LinagoraHoverStyle.material();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Figma: On Action Hovered Bar',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Shown when user hovers over a message/list item',
              style: TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 20),

          // Default — no hover
          const Text('Default (no hover)',
              style: TextStyle(fontSize: 10, color: Colors.black54)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Expanded(child: Text('Message content here...')),
                // Actions hidden
                Opacity(
                  opacity: 0,
                  child: _actionBar(style),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Hovered state
          const Text('Hovered (actions visible)',
              style: TextStyle(fontSize: 10, color: Colors.black54)),
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              color: style.hoverColor,
              borderRadius: style.hoverBorderRadius,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Expanded(child: Text('Message content here...')),
                _actionBar(style),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Selected state
          const Text('Selected (highlight + actions)',
              style: TextStyle(fontSize: 10, color: Colors.black54)),
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              color: style.selectedColor,
              borderRadius: style.borderRadius,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Expanded(
                  child: Text('Selected message',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                ),
                _actionBar(style),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _actionBar(LinagoraHoverStyle style) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Color(0x1A000000), blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(icon: const Icon(Icons.reply, size: 18), onPressed: () {}, padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 32, minHeight: 32)),
          IconButton(icon: const Icon(Icons.emoji_emotions_outlined, size: 18), onPressed: () {}, padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 32, minHeight: 32)),
          IconButton(icon: const Icon(Icons.more_vert, size: 18), onPressed: () {}, padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 32, minHeight: 32)),
        ],
      ),
    );
  }
}
