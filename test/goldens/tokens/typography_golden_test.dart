@TestOn('vm')
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/style/linagora_text_style.dart';

import '../../helpers/golden_test_helper.dart';

void main() {
  group('LinagoraTextStyle golden tests', () {
    testWidgets('all text styles', (tester) async {
      final ts = LinagoraTextStyle.material();

      final styles = <MapEntry<String, TextStyle>>[
        MapEntry('displayMedium', ts.displayMedium),
        MapEntry('displaySmall', ts.displaySmall),
        MapEntry('headlineLarge', ts.headlineLarge),
        MapEntry('headlineMedium', ts.headlineMedium),
        MapEntry('headlineSmall', ts.headlineSmall),
        MapEntry('titleLarge', ts.titleLarge),
        MapEntry('titleMedium', ts.titleMedium),
        MapEntry('titleSemibold', ts.titleSemibold),
        MapEntry('titleSmall', ts.titleSmall),
        MapEntry('labelLarge', ts.labelLarge),
        MapEntry('labelMedium', ts.labelMedium),
        MapEntry('labelSmall', ts.labelSmall),
        MapEntry('bodyLarge', ts.bodyLarge),
        MapEntry('bodyLargeBold', ts.bodyLargeBold),
        MapEntry('bodyLarge1', ts.bodyLarge1),
        MapEntry('bodyLarge2', ts.bodyLarge2),
        MapEntry('bodyMedium', ts.bodyMedium),
        MapEntry('bodyMedium1', ts.bodyMedium1),
        MapEntry('bodyMedium2', ts.bodyMedium2),
        MapEntry('bodyMedium3', ts.bodyMedium3),
        MapEntry('bodySmall', ts.bodySmall),
      ];

      await pumpGolden(
        tester,
        _TypographyShowcase(styles: styles),
        size: const Size(600, 2500),
      );

      await expectLater(
        find.byType(_TypographyShowcase),
        matchesGoldenFile('typography.png'),
      );
    });
  });
}

class _TypographyShowcase extends StatelessWidget {
  final List<MapEntry<String, TextStyle>> styles;

  const _TypographyShowcase({required this.styles});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'LinagoraTextStyle',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...styles.map((entry) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'The quick brown fox jumps over the lazy dog',
                  style: entry.value.copyWith(color: Colors.black),
                ),
                const SizedBox(height: 2),
                Text(
                  'size: ${entry.value.fontSize}  '
                  'weight: ${entry.value.fontWeight}  '
                  'spacing: ${entry.value.letterSpacing}',
                  style: const TextStyle(fontSize: 8, color: Colors.black45),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
