@TestOn('vm')
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/style/linagora_divider_style.dart';
import 'package:linagora_design_flutter/style/linagora_hover_style.dart';
import 'package:linagora_design_flutter/colors/linagora_state_layer.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';

import '../../helpers/golden_test_helper.dart';

void main() {
  group('LinagoraDividerStyle golden tests', () {
    testWidgets('divider rendering', (tester) async {
      final divider = LinagoraDividerStyle.material();

      await pumpGolden(
        tester,
        _DividerShowcase(dividerStyle: divider),
        size: const Size(400, 300),
      );

      await expectLater(
        find.byType(_DividerShowcase),
        matchesGoldenFile('divider_style.png'),
      );
    });
  });

  group('LinagoraHoverStyle golden tests', () {
    testWidgets('hover and selected states', (tester) async {
      final hover = LinagoraHoverStyle.material();

      await pumpGolden(
        tester,
        _HoverShowcase(hoverStyle: hover),
        size: const Size(400, 300),
      );

      await expectLater(
        find.byType(_HoverShowcase),
        matchesGoldenFile('hover_style.png'),
      );
    });
  });

  group('LinagoraStateLayer golden tests', () {
    testWidgets('opacity layers', (tester) async {
      final sys = LinagoraSysColors.material();
      final layer = LinagoraStateLayer(sys.primary);

      await pumpGolden(
        tester,
        _StateLayerShowcase(
          baseColor: sys.primary,
          layer: layer,
        ),
        size: const Size(500, 250),
      );

      await expectLater(
        find.byType(_StateLayerShowcase),
        matchesGoldenFile('state_layer.png'),
      );
    });
  });
}

class _DividerShowcase extends StatelessWidget {
  final LinagoraDividerStyle dividerStyle;

  const _DividerShowcase({required this.dividerStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('LinagoraDividerStyle',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text('Item above divider'),
                Container(
                  decoration: BoxDecoration(border: dividerStyle.borderDecoration),
                  child: const SizedBox(height: 1),
                ),
                const Text('Item below divider'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'color: ${dividerStyle.color}  thickness: ${dividerStyle.thickness}',
            style: const TextStyle(fontSize: 9, color: Colors.black45),
          ),
        ],
      ),
    );
  }
}

class _HoverShowcase extends StatelessWidget {
  final LinagoraHoverStyle hoverStyle;

  const _HoverShowcase({required this.hoverStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('LinagoraHoverStyle',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              _stateBox('Default', Colors.transparent),
              const SizedBox(width: 12),
              _stateBox('Hovered', hoverStyle.hoverColor),
              const SizedBox(width: 12),
              _stateBox('Selected', hoverStyle.selectedColor),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'borderRadius: ${hoverStyle.borderRadius}',
            style: const TextStyle(fontSize: 9, color: Colors.black45),
          ),
        ],
      ),
    );
  }

  Widget _stateBox(String label, Color color) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 48,
          decoration: BoxDecoration(
            color: color,
            borderRadius: hoverStyle.hoverBorderRadius,
            border: Border.all(color: Colors.black12),
          ),
          child: Center(
            child: Text(label, style: const TextStyle(fontSize: 11)),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
          style: const TextStyle(fontSize: 8, color: Colors.black45),
        ),
      ],
    );
  }
}

class _StateLayerShowcase extends StatelessWidget {
  final Color baseColor;
  final LinagoraStateLayer layer;

  const _StateLayerShowcase({
    required this.baseColor,
    required this.layer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('LinagoraStateLayer',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              _layerSwatch('Base', baseColor),
              const SizedBox(width: 12),
              _layerSwatch('Layer 1 (8%)', layer.opacityLayer1),
              const SizedBox(width: 12),
              _layerSwatch('Layer 2 (12%)', layer.opacityLayer2),
              const SizedBox(width: 12),
              _layerSwatch('Layer 3 (16%)', layer.opacityLayer3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _layerSwatch(String label, Color color) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.black12),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
