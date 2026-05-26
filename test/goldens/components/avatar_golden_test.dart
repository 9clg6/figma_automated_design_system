@TestOn('vm')
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/avatar/round_avatar.dart';
import 'package:linagora_design_flutter/avatar/round_avatar_style.dart';

import '../../helpers/golden_test_helper.dart';

void main() {
  group('RoundAvatar golden tests', () {
    testWidgets('monogram style — text gradient variants', (tester) async {
      await pumpGolden(
        tester,
        const _AvatarMonogramShowcase(),
        size: const Size(600, 500),
      );

      await expectLater(
        find.byType(_AvatarMonogramShowcase),
        matchesGoldenFile('avatar_monogram.png'),
      );
    });

    testWidgets('Figma sizes — 40, 56, 60, 96, 160', (tester) async {
      await pumpGolden(
        tester,
        const _AvatarFigmaSizes(),
        size: const Size(700, 300),
      );

      await expectLater(
        find.byType(_AvatarFigmaSizes),
        matchesGoldenFile('avatar_figma_sizes.png'),
      );
    });

    testWidgets('custom gradient colors', (tester) async {
      await pumpGolden(
        tester,
        const _AvatarCustomGradients(),
        size: const Size(600, 200),
      );

      await expectLater(
        find.byType(_AvatarCustomGradients),
        matchesGoldenFile('avatar_custom_gradients.png'),
      );
    });

    testWidgets('all 10 default gradient palettes', (tester) async {
      await pumpGolden(
        tester,
        const _AvatarAllGradients(),
        size: const Size(600, 500),
      );

      await expectLater(
        find.byType(_AvatarAllGradients),
        matchesGoldenFile('avatar_all_gradients.png'),
      );
    });

    testWidgets('single char and long text truncation', (tester) async {
      await pumpGolden(
        tester,
        const _AvatarTextEdgeCases(),
        size: const Size(600, 200),
      );

      await expectLater(
        find.byType(_AvatarTextEdgeCases),
        matchesGoldenFile('avatar_text_edge_cases.png'),
      );
    });

    testWidgets('box shadow variant', (tester) async {
      await pumpGolden(
        tester,
        const _AvatarBoxShadow(),
        size: const Size(400, 200),
      );

      await expectLater(
        find.byType(_AvatarBoxShadow),
        matchesGoldenFile('avatar_box_shadow.png'),
      );
    });
  });
}

// ── Monogram style: 10 different initials showing gradient diversity ──
class _AvatarMonogramShowcase extends StatelessWidget {
  const _AvatarMonogramShowcase();

  @override
  Widget build(BuildContext context) {
    final texts = [
      'AB', 'CD', 'EF', 'GH', 'IJ',
      'KL', 'MN', 'OP', 'QR', 'ST',
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Style=monogram — gradient variants',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Figma: 10 gradient palettes, topLeft→bottomRight',
              style: TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: texts.map((t) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RoundAvatar(text: t, size: 56),
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

// ── Figma defined sizes: 40 (chips md), 56, 60, 96, 160 ──
class _AvatarFigmaSizes extends StatelessWidget {
  const _AvatarFigmaSizes();

  @override
  Widget build(BuildContext context) {
    final sizes = [
      (40.0, 'chips md (40)'),
      (56.0, 'default (56)'),
      (60.0, '60'),
      (96.0, '96'),
      (160.0, '160'),
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Figma Size Variants',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: sizes.map((s) => Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RoundAvatar(text: 'CL', size: s.$1),
                  const SizedBox(height: 6),
                  Text(s.$2,
                      style: const TextStyle(fontSize: 9, color: Colors.black54)),
                ],
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

// ── Custom gradient colors (user-provided) ──
class _AvatarCustomGradients extends StatelessWidget {
  const _AvatarCustomGradients();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Custom Gradient Colors',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              RoundAvatar(
                text: 'AB',
                size: 56,
                linearGradientColors: const [Color(0xFFFF6B6B), Color(0xFFFFE66D)],
                stops: const [0.0, 1.0],
              ),
              const SizedBox(width: 16),
              RoundAvatar(
                text: 'CD',
                size: 56,
                linearGradientColors: const [Color(0xFF667EEA), Color(0xFF764BA2)],
                stops: const [0.0, 1.0],
              ),
              const SizedBox(width: 16),
              RoundAvatar(
                text: 'EF',
                size: 56,
                linearGradientColors: const [Color(0xFF11998E), Color(0xFF38EF7D)],
                stops: const [0.0, 1.0],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── All 10 default gradient palettes from RoundAvatarStyle ──
class _AvatarAllGradients extends StatelessWidget {
  const _AvatarAllGradients();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('All 10 Default Gradient Palettes',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('RoundAvatarStyle.defaultGradientColors',
              style: TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 16,
            children: List.generate(10, (i) {
              final colors = RoundAvatarStyle.defaultGradientColors[i];
              final label = '#${i + 1}';
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RoundAvatar(
                    text: label,
                    size: 56,
                    linearGradientColors: colors,
                    stops: RoundAvatarStyle.defaultGradientStops,
                  ),
                  const SizedBox(height: 4),
                  Text(label,
                      style: const TextStyle(fontSize: 9, color: Colors.black54)),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ── Edge cases: single char, long text, special chars ──
class _AvatarTextEdgeCases extends StatelessWidget {
  const _AvatarTextEdgeCases();

  @override
  Widget build(BuildContext context) {
    final cases = [
      ('A', 'single'),
      ('ABCDEF', 'long (truncated)'),
      ('JD', 'ascii pair'),
      ('XY', 'latin pair'),
      ('ZZ', 'repeated'),
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Text Edge Cases',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: cases.map((c) => Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RoundAvatar(text: c.$1, size: 56),
                  const SizedBox(height: 4),
                  Text(c.$2,
                      style: const TextStyle(fontSize: 9, color: Colors.black54)),
                ],
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

// ── Box shadow variant ──
class _AvatarBoxShadow extends StatelessWidget {
  const _AvatarBoxShadow();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Box Shadow',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              Column(
                children: const [
                  RoundAvatar(text: 'NS', size: 56),
                  SizedBox(height: 4),
                  Text('no shadow', style: TextStyle(fontSize: 9, color: Colors.black54)),
                ],
              ),
              const SizedBox(width: 32),
              Column(
                children: [
                  RoundAvatar(
                    text: 'WS',
                    size: 56,
                    boxShadows: const [
                      BoxShadow(
                        color: Color(0x40000000),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text('with shadow', style: TextStyle(fontSize: 9, color: Colors.black54)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
