import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/style/linagora_hover_style.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Style properties', type: Container)
Widget hoverStylePropertiesUseCase(BuildContext context) {
  final style = LinagoraHoverStyle.material();
  return Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'LinagoraHoverStyle tokens',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        _StyleRow('hoverColor', style.hoverColor),
        _StyleRow('selectedColor', style.selectedColor),
        _StyleRow('containerColor', style.containerColor),
        const SizedBox(height: 16),
        Text('borderRadius: ${style.borderRadius}'),
        Text('hoverBorderRadius: ${style.hoverBorderRadius}'),
        Text('actionBubbleBorderRadius: ${style.actionBubbleBorderRadius}'),
        Text('actionBubbleWidth: ${style.actionBubbleWidth}'),
        Text('actionBubbleHeight: ${style.actionBubbleHeight}'),
        Text('containerHeight: ${style.containerHeight}'),
        const SizedBox(height: 24),
        const Text(
          'Action bar preview',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Container(
          width: style.actionBubbleWidth,
          height: style.actionBubbleHeight,
          decoration: BoxDecoration(
            color: style.containerColor,
            borderRadius: style.actionBubbleBorderRadius,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.reply, color: Colors.white, size: 20),
              Icon(Icons.emoji_emotions, color: Colors.white, size: 20),
              Icon(Icons.more_horiz, color: Colors.white, size: 20),
            ],
          ),
        ),
      ],
    ),
  );
}

class _StyleRow extends StatelessWidget {
  const _StyleRow(this.label, this.color);
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade300),
            ),
          ),
          const SizedBox(width: 12),
          Text('$label: ${color.toString()}'),
        ],
      ),
    );
  }
}
