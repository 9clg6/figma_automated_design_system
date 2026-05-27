import 'package:flutter/material.dart';

/// Tooltip type variants matching Figma spec.
enum TwakeTooltipType { plain, rich }

/// Style tokens for [TwakeTooltip].
class TwakeTooltipStyle {
  // Plain
  static const Color plainBackground = Color(0xFF313033);
  static const Color plainTextColor = Color(0xFFFFFFFF);
  static const BorderRadius plainBorderRadius =
      BorderRadius.all(Radius.circular(4));
  static const EdgeInsets plainPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 8);
  static const double plainMaxWidth = 336;

  // Rich
  static const Color richBackground = Color(0xFFFFFFFF);
  static const Color richSubheadColor = Color(0xFF1C1B1F);
  static const Color richSupportingTextColor = Color(0xFF49454F);
  static const Color richActionColor = Color(0xFF6750A4);
  static const BorderRadius richBorderRadius =
      BorderRadius.all(Radius.circular(12));
  static const EdgeInsets richPadding = EdgeInsets.all(16);
  static const double richMaxWidth = 352;
  static const List<BoxShadow> richBoxShadow = [
    BoxShadow(
      color: Color(0x1F000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 3,
      offset: Offset(0, 1),
    ),
  ];

  const TwakeTooltipStyle._();
}

/// A tooltip widget with two variants — **Plain** and **Rich** —
/// matching the Linagora / Twake Figma design spec.
///
/// - [TwakeTooltipType.plain]: dark rounded-rectangle with a single text line.
/// - [TwakeTooltipType.rich]: white card with subhead, supporting text and up
///   to two optional action buttons.
class TwakeTooltip extends StatelessWidget {
  /// Tooltip variant (plain or rich).
  final TwakeTooltipType type;

  /// Primary supporting / body text shown in both variants.
  final String supportingText;

  /// Subhead shown only in the rich variant.
  final String subhead;

  /// Label for the first action button (rich only). Hidden when null.
  final String? button1Label;

  /// Label for the second action button (rich only). Hidden when null.
  final String? button2Label;

  /// Callback for the first action button.
  final VoidCallback? onButton1Pressed;

  /// Callback for the second action button.
  final VoidCallback? onButton2Pressed;

  /// Whether to show a leading icon (rich only).
  final bool showIconLeft;

  /// Whether to show a trailing icon (rich only).
  final bool showIconRight;

  const TwakeTooltip({
    Key? key,
    this.type = TwakeTooltipType.plain,
    this.supportingText =
        "Rich tooltip bring attention to a particular element of feature that warrants the user's focus",
    this.subhead = 'Rich tooltip',
    this.button1Label = 'Enabled',
    this.button2Label = 'Enabled',
    this.onButton1Pressed,
    this.onButton2Pressed,
    this.showIconLeft = false,
    this.showIconRight = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return type == TwakeTooltipType.plain
        ? _PlainTooltip(supportingText: supportingText)
        : _RichTooltip(
            subhead: subhead,
            supportingText: supportingText,
            button1Label: button1Label,
            button2Label: button2Label,
            onButton1Pressed: onButton1Pressed,
            onButton2Pressed: onButton2Pressed,
            showIconLeft: showIconLeft,
            showIconRight: showIconRight,
          );
  }
}

// ---------------------------------------------------------------------------
// Private sub-widgets
// ---------------------------------------------------------------------------

class _PlainTooltip extends StatelessWidget {
  final String supportingText;

  const _PlainTooltip({required this.supportingText});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: TwakeTooltipStyle.plainMaxWidth),
      child: Container(
        decoration: const BoxDecoration(
          color: TwakeTooltipStyle.plainBackground,
          borderRadius: TwakeTooltipStyle.plainBorderRadius,
        ),
        padding: TwakeTooltipStyle.plainPadding,
        child: Text(
          supportingText,
          style: const TextStyle(
            color: TwakeTooltipStyle.plainTextColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.43,
          ),
        ),
      ),
    );
  }
}

class _RichTooltip extends StatelessWidget {
  final String subhead;
  final String supportingText;
  final String? button1Label;
  final String? button2Label;
  final VoidCallback? onButton1Pressed;
  final VoidCallback? onButton2Pressed;
  final bool showIconLeft;
  final bool showIconRight;

  const _RichTooltip({
    required this.subhead,
    required this.supportingText,
    this.button1Label,
    this.button2Label,
    this.onButton1Pressed,
    this.onButton2Pressed,
    this.showIconLeft = false,
    this.showIconRight = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasButtons = button1Label != null || button2Label != null;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: TwakeTooltipStyle.richMaxWidth),
      child: Container(
        decoration: const BoxDecoration(
          color: TwakeTooltipStyle.richBackground,
          borderRadius: TwakeTooltipStyle.richBorderRadius,
          boxShadow: TwakeTooltipStyle.richBoxShadow,
        ),
        padding: TwakeTooltipStyle.richPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subhead row
            Row(
              children: [
                if (showIconLeft) ...
                  [
                    const Icon(Icons.info_outline, size: 18,
                        color: TwakeTooltipStyle.richSubheadColor),
                    const SizedBox(width: 8),
                  ],
                Expanded(
                  child: Text(
                    subhead,
                    style: const TextStyle(
                      color: TwakeTooltipStyle.richSubheadColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                    ),
                  ),
                ),
                if (showIconRight) ...
                  [
                    const SizedBox(width: 8),
                    const Icon(Icons.close, size: 18,
                        color: TwakeTooltipStyle.richSubheadColor),
                  ],
              ],
            ),
            const SizedBox(height: 8),
            // Supporting text
            Text(
              supportingText,
              style: const TextStyle(
                color: TwakeTooltipStyle.richSupportingTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.43,
              ),
            ),
            if (hasButtons) ...
              [
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (button1Label != null)
                      _ActionButton(
                        label: button1Label!,
                        onPressed: onButton1Pressed,
                      ),
                    if (button1Label != null && button2Label != null)
                      const SizedBox(width: 8),
                    if (button2Label != null)
                      _ActionButton(
                        label: button2Label!,
                        onPressed: onButton2Pressed,
                      ),
                  ],
                ),
              ],
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const _ActionButton({required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        minimumSize: const Size(0, 36),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: TwakeTooltipStyle.richActionColor,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: TwakeTooltipStyle.richActionColor,
        ),
      ),
    );
  }
}
