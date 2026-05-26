@TestOn('vm')
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/reaction/reaction_picker.dart';

import '../../helpers/golden_test_helper.dart';

void main() {
  group('ReactionsPicker golden tests', () {
    testWidgets('default emoji picker', (tester) async {
      await pumpGolden(
        tester,
        const _ReactionPickerDefault(),
        size: const Size(500, 200),
      );

      await expectLater(
        find.byType(_ReactionPickerDefault),
        matchesGoldenFile('reaction_picker_default.png'),
      );
    });

    testWidgets('with "more" button enabled', (tester) async {
      await pumpGolden(
        tester,
        const _ReactionPickerWithMore(),
        size: const Size(500, 200),
      );

      await expectLater(
        find.byType(_ReactionPickerWithMore),
        matchesGoldenFile('reaction_picker_more.png'),
      );
    });

    testWidgets('with own reaction highlighted', (tester) async {
      await pumpGolden(
        tester,
        const _ReactionPickerWithMyReaction(),
        size: const Size(500, 200),
      );

      await expectLater(
        find.byType(_ReactionPickerWithMyReaction),
        matchesGoldenFile('reaction_picker_my_reaction.png'),
      );
    });

    testWidgets('custom emojis + custom size', (tester) async {
      await pumpGolden(
        tester,
        const _ReactionPickerCustom(),
        size: const Size(500, 200),
      );

      await expectLater(
        find.byType(_ReactionPickerCustom),
        matchesGoldenFile('reaction_picker_custom.png'),
      );
    });

    testWidgets('all variants side by side', (tester) async {
      await pumpGolden(
        tester,
        const _ReactionPickerAllVariants(),
        size: const Size(500, 500),
      );

      await expectLater(
        find.byType(_ReactionPickerAllVariants),
        matchesGoldenFile('reaction_picker_all_variants.png'),
      );
    });
  });
}

// ── Default picker: 6 emojis, no "more" button ──
class _ReactionPickerDefault extends StatelessWidget {
  const _ReactionPickerDefault();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('ReactionsPicker — Default',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('6 default emojis, borderRadius: 32, height: 56',
              style: TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 16),
          const ReactionsPicker(
            enableMoreEmojiWidget: false,
          ),
        ],
      ),
    );
  }
}

// ── With "more" expand button ──
class _ReactionPickerWithMore extends StatelessWidget {
  const _ReactionPickerWithMore();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('ReactionsPicker — With More Button',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const ReactionsPicker(
            enableMoreEmojiWidget: true,
          ),
        ],
      ),
    );
  }
}

// ── With own reaction highlighted ──
class _ReactionPickerWithMyReaction extends StatelessWidget {
  const _ReactionPickerWithMyReaction();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('ReactionsPicker — Own Reaction Highlighted',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('myEmojiReacted: "👍" — shows circular highlight',
              style: TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 16),
          const ReactionsPicker(
            myEmojiReacted: '👍',
            enableMoreEmojiWidget: false,
          ),
        ],
      ),
    );
  }
}

// ── Custom emoji set and size ──
class _ReactionPickerCustom extends StatelessWidget {
  const _ReactionPickerCustom();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('ReactionsPicker — Custom Emojis',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Custom emoji set, emojiSize: 36, borderRadius: 16',
              style: TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 16),
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
}

// ── All variants stacked ──
class _ReactionPickerAllVariants extends StatelessWidget {
  const _ReactionPickerAllVariants();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('All ReactionsPicker Variants',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          const Text('Default', style: TextStyle(fontSize: 10, color: Colors.black54)),
          const SizedBox(height: 4),
          const ReactionsPicker(enableMoreEmojiWidget: false),

          const SizedBox(height: 16),
          const Text('With "more" button', style: TextStyle(fontSize: 10, color: Colors.black54)),
          const SizedBox(height: 4),
          const ReactionsPicker(enableMoreEmojiWidget: true),

          const SizedBox(height: 16),
          const Text('Own reaction (👍)', style: TextStyle(fontSize: 10, color: Colors.black54)),
          const SizedBox(height: 4),
          const ReactionsPicker(myEmojiReacted: '👍', enableMoreEmojiWidget: false),

          const SizedBox(height: 16),
          const Text('Custom colors', style: TextStyle(fontSize: 10, color: Colors.black54)),
          const SizedBox(height: 4),
          const ReactionsPicker(
            backgroundColor: Color(0xFFF0F4FF),
            enableMoreEmojiWidget: false,
          ),
        ],
      ),
    );
  }
}
