import 'package:flutter/material.dart';

/// Lines variant for [TwakeSnackbar].
enum SnackbarLines { oneLine, twoLines }

/// A Twake/Linagora-design snackbar widget matching the Figma spec.
///
/// Supports:
/// - One-line and two-line layouts
/// - Optional inline action button
/// - Optional longer (full-width bottom) action button
/// - Optional close affordance icon
class TwakeSnackbar extends StatelessWidget {
  /// The main message text.
  final String message;

  /// Number of lines for the message area.
  final SnackbarLines lines;

  /// When true, shows an inline [actionLabel] button next to the message.
  final bool showAction;

  /// When true, the action label is rendered on its own bottom row (longer action).
  final bool longerAction;

  /// When true, shows a close (×) icon button.
  final bool showCloseAffordance;

  /// Label for the action button. Defaults to 'Action'.
  final String actionLabel;

  /// Called when the action button is tapped.
  final VoidCallback? onActionTap;

  /// Called when the close button is tapped.
  final VoidCallback? onCloseTap;

  const TwakeSnackbar({
    Key? key,
    required this.message,
    this.lines = SnackbarLines.oneLine,
    this.showAction = false,
    this.longerAction = false,
    this.showCloseAffordance = false,
    this.actionLabel = 'Action',
    this.onActionTap,
    this.onCloseTap,
  }) : super(key: key);

  // ── Design tokens ────────────────────────────────────────────────────────
  static const Color _containerColor = Color(0xFF313033);
  static const Color _onContainerColor = Color(0xFFE6E1E5);
  static const Color _actionColor = Color(0xFF90CAF9); // blue accent
  static const double _borderRadius = 4.0;
  static const EdgeInsets _contentPadding =
      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);
  static const EdgeInsets _actionRowPadding =
      EdgeInsets.only(left: 16.0, right: 8.0, bottom: 8.0);
  static const double _closeIconSize = 18.0;

  // ── Helpers ──────────────────────────────────────────────────────────────

  /// Returns the action text button widget.
  Widget _actionButton() => TextButton(
        onPressed: onActionTap,
        style: TextButton.styleFrom(
          foregroundColor: _actionColor,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          actionLabel,
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: _actionColor,
          ),
        ),
      );

  /// Returns the close icon button widget.
  Widget _closeButton() => GestureDetector(
        onTap: onCloseTap,
        child: const Icon(
          Icons.close,
          size: _closeIconSize,
          color: _onContainerColor,
        ),
      );

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Longer-action layout: message on top, action full-width on bottom row.
    if (longerAction && showAction) {
      return _LongerActionLayout(
        message: message,
        actionLabel: actionLabel,
        showCloseAffordance: showCloseAffordance,
        onActionTap: onActionTap,
        onCloseTap: onCloseTap,
      );
    }

    final bool isTwoLine = lines == SnackbarLines.twoLines;

    return Container(
      decoration: const BoxDecoration(
        color: _containerColor,
        borderRadius: BorderRadius.all(Radius.circular(_borderRadius)),
      ),
      child: Padding(
        padding: _contentPadding,
        child: Row(
          crossAxisAlignment:
              isTwoLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            // Message
            Expanded(
              child: Text(
                message,
                maxLines: isTwoLine ? 2 : 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: _onContainerColor,
                  height: 1.43,
                ),
              ),
            ),
            // Inline action
            if (showAction) ...[const SizedBox(width: 8.0), _actionButton()],
            // Close button
            if (showCloseAffordance) ...[const SizedBox(width: 8.0), _closeButton()],
          ],
        ),
      ),
    );
  }
}

/// Private layout for the "longer action" variant where the action label
/// sits on its own row at the bottom-right.
class _LongerActionLayout extends StatelessWidget {
  final String message;
  final String actionLabel;
  final bool showCloseAffordance;
  final VoidCallback? onActionTap;
  final VoidCallback? onCloseTap;

  static const Color _containerColor = Color(0xFF313033);
  static const Color _onContainerColor = Color(0xFFE6E1E5);
  static const Color _actionColor = Color(0xFF90CAF9);
  static const double _borderRadius = 4.0;
  static const double _closeIconSize = 18.0;

  const _LongerActionLayout({
    Key? key,
    required this.message,
    required this.actionLabel,
    required this.showCloseAffordance,
    this.onActionTap,
    this.onCloseTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _containerColor,
        borderRadius: BorderRadius.all(Radius.circular(_borderRadius)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top row: message + optional close
          Padding(
            padding:
                const EdgeInsets.only(left: 16.0, right: 8.0, top: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: _onContainerColor,
                      height: 1.43,
                    ),
                  ),
                ),
                if (showCloseAffordance) ...
                  [
                    const SizedBox(width: 8.0),
                    GestureDetector(
                      onTap: onCloseTap,
                      child: const Icon(
                        Icons.close,
                        size: _closeIconSize,
                        color: _onContainerColor,
                      ),
                    ),
                  ],
              ],
            ),
          ),
          // Bottom row: longer action button aligned right
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 8.0, top: 8.0, bottom: 8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onActionTap,
                style: TextButton.styleFrom(
                  foregroundColor: _actionColor,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  actionLabel,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: _actionColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
