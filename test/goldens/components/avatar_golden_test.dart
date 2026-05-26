@TestOn('vm')
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/avatar/round_avatar.dart';
import 'package:linagora_design_flutter/avatar/round_avatar_style.dart';

import '../../helpers/golden_test_helper.dart';

void main() {
  group('RoundAvatar golden tests', () {
    testWidgets('default avatar with text', (tester) async {
      await pumpGolden(
        tester,
        const _AvatarShowcase(),
        size: const Size(500, 500),
      );

      await expectLater(
        find.byType(_AvatarShowcase),
        matchesGoldenFile('avatar_default.png'),
      );
    });

    testWidgets('avatar sizes', (tester) async {
      await pumpGolden(
        tester,
        const _AvatarSizesShowcase(),
        size: const Size(500, 200),
      );

      await expectLater(
        find.byType(_AvatarSizesShowcase),
        matchesGoldenFile('avatar_sizes.png'),
      );
    });
  });
}

class _AvatarShowcase extends StatelessWidget {
  const _AvatarShowcase();

  @override
  Widget build(BuildContext context) {
    // Test different text inputs to trigger different gradient colors
    final texts = ['AB', 'CD', 'EF', 'GH', 'IJ', 'KL', 'MN', 'OP', 'QR', 'ST'];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('RoundAvatar — Text Variants',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: texts.map((t) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RoundAvatar(text: t),
                const SizedBox(height: 4),
                Text(t, style: const TextStyle(fontSize: 10, color: Colors.black54)),
              ],
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class _AvatarSizesShowcase extends StatelessWidget {
  const _AvatarSizesShowcase();

  @override
  Widget build(BuildContext context) {
    final sizes = [24.0, 32.0, 40.0, 48.0, 56.0, 72.0, 96.0];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('RoundAvatar — Sizes',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: sizes.map((s) => Padding(
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
        ],
      ),
    );
  }
}
