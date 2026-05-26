@TestOn('vm')
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/style/linagora_divider_style.dart';

import '../../helpers/golden_test_helper.dart';

void main() {
  group('LinagoraDividerStyle golden tests', () {
    testWidgets('horizontal divider variants', (tester) async {
      await pumpGolden(
        tester,
        const _HorizontalDividerShowcase(),
        size: const Size(500, 600),
      );

      await expectLater(
        find.byType(_HorizontalDividerShowcase),
        matchesGoldenFile('divider_horizontal.png'),
      );
    });

    testWidgets('divider in list context', (tester) async {
      await pumpGolden(
        tester,
        const _DividerInListContext(),
        size: const Size(400, 500),
      );

      await expectLater(
        find.byType(_DividerInListContext),
        matchesGoldenFile('divider_in_list.png'),
      );
    });

    testWidgets('divider style properties', (tester) async {
      await pumpGolden(
        tester,
        const _DividerProperties(),
        size: const Size(500, 300),
      );

      await expectLater(
        find.byType(_DividerProperties),
        matchesGoldenFile('divider_properties.png'),
      );
    });
  });
}

// ── Horizontal divider variants matching Figma: full-width, inset, middle-inset, with subhead ──
class _HorizontalDividerShowcase extends StatelessWidget {
  const _HorizontalDividerShowcase();

  @override
  Widget build(BuildContext context) {
    final style = LinagoraDividerStyle.material();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Figma: Horizontal Divider Variants',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),

          // Full-width
          const Text('horizontal/full-width',
              style: TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 8),
          Divider(color: style.color, thickness: style.thickness, height: 1),
          const SizedBox(height: 24),

          // Inset (left padding 16)
          const Text('horizontal/inset (left: 16)',
              style: TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Divider(color: style.color, thickness: style.thickness, height: 1),
          ),
          const SizedBox(height: 24),

          // Middle-inset (both sides 16)
          const Text('horizontal/middle-inset (left: 16, right: 16)',
              style: TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(color: style.color, thickness: style.thickness, height: 1),
          ),
          const SizedBox(height: 24),

          // With subhead
          const Text('horizontal/with subhead',
              style: TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16, right: 8),
                child: Text('Section', style: TextStyle(fontSize: 12, color: Colors.black54)),
              ),
              Expanded(
                child: Divider(color: style.color, thickness: style.thickness, height: 1),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Border decoration (as used in TwakeListItem)
          const Text('borderDecoration (bottom border)',
              style: TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(border: style.borderDecoration),
            child: const Text('Container with bottom border from LinagoraDividerStyle',
                style: TextStyle(fontSize: 12)),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(border: style.borderDecoration),
            child: const Text('Another item with divider border',
                style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

// ── Divider used in a list context ──
class _DividerInListContext extends StatelessWidget {
  const _DividerInListContext();

  @override
  Widget build(BuildContext context) {
    final style = LinagoraDividerStyle.material();
    final items = ['Inbox', 'Starred', 'Sent', 'Drafts', 'Trash'];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Divider in List Context',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...items.map((item) => Container(
            decoration: BoxDecoration(border: style.borderDecoration),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  item == 'Inbox' ? Icons.inbox :
                  item == 'Starred' ? Icons.star_outline :
                  item == 'Sent' ? Icons.send :
                  item == 'Drafts' ? Icons.drafts :
                  Icons.delete_outline,
                  size: 20,
                  color: Colors.black54,
                ),
                const SizedBox(width: 12),
                Text(item, style: const TextStyle(fontSize: 14)),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

// ── Divider properties showcase ──
class _DividerProperties extends StatelessWidget {
  const _DividerProperties();

  @override
  Widget build(BuildContext context) {
    final style = LinagoraDividerStyle.material();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('LinagoraDividerStyle Properties',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _propRow('color', style.color),
          _propRow('thickness', '${style.thickness}px'),
          const SizedBox(height: 16),
          const Text('Visual comparison:',
              style: TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 8),
          // DS divider
          Row(
            children: [
              const SizedBox(width: 80, child: Text('DS style', style: TextStyle(fontSize: 10))),
              Expanded(child: Divider(color: style.color, thickness: style.thickness, height: 1)),
            ],
          ),
          const SizedBox(height: 12),
          // Material default
          const Row(
            children: [
              SizedBox(width: 80, child: Text('Material', style: TextStyle(fontSize: 10))),
              Expanded(child: Divider(height: 1)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _propRow(String label, dynamic value) {
    String display;
    Widget? swatch;
    if (value is Color) {
      display = '#${value.value.toRadixString(16).toUpperCase().padLeft(8, '0')}';
      swatch = Container(
        width: 16, height: 16,
        decoration: BoxDecoration(color: value, border: Border.all(color: Colors.black12)),
      );
    } else {
      display = value.toString();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(fontSize: 11, color: Colors.black54))),
          if (swatch != null) ...[swatch, const SizedBox(width: 8)],
          Text(display, style: const TextStyle(fontSize: 11, fontFamily: 'monospace')),
        ],
      ),
    );
  }
}
