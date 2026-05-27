import 'package:flutter/material.dart';

/// A dialog card widget with a title, sub text, and optional close/action buttons.
/// Matches the Figma "Dialog 2" component spec.
class TwakeDialog2 extends StatelessWidget {
  /// The title displayed at the top of the dialog card.
  final String title;

  /// The sub text displayed below the title.
  final String subText;

  /// Whether to show the close (text) button.
  final bool showButtonClose;

  /// Whether to show the right (filled) action button.
  final bool showButtonRight;

  /// Label for the close button.
  final String closeLabel;

  /// Label for the right action button.
  final String rightLabel;

  /// Callback for the close button tap.
  final VoidCallback? onClose;

  /// Callback for the right action button tap.
  final VoidCallback? onRightAction;

  /// Optional leading icon for the right button.
  final Widget? rightButtonIcon;

  const TwakeDialog2({
    Key? key,
    this.title = 'Title',
    this.subText = 'Sub text',
    this.showButtonClose = true,
    this.showButtonRight = true,
    this.closeLabel = 'Close',
    this.rightLabel = 'Label',
    this.onClose,
    this.onRightAction,
    this.rightButtonIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: 340,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subText,
            style: textTheme.bodySmall?.copyWith(
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          if (showButtonClose || showButtonRight)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (showButtonClose)
                  TextButton(
                    onPressed: onClose,
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF1976D2),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    child: Text(
                      closeLabel,
                      style: textTheme.labelLarge?.copyWith(
                        color: const Color(0xFF1976D2),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                if (showButtonClose && showButtonRight)
                  const SizedBox(width: 4),
                if (showButtonRight)
                  ElevatedButton(
                    onPressed: onRightAction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3),
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      rightLabel,
                      style: textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
