import 'package:flutter/material.dart';

/// Style tokens for TwakeBottomSheet.
class TwakeBottomSheetStyle {
  static const double dragHandleWidth = 32.0;
  static const double dragHandleHeight = 4.0;
  static const double dragHandleTopPadding = 12.0;
  static const double dragHandleBottomPadding = 8.0;
  static const BorderRadius sheetBorderRadius = BorderRadius.only(
    topLeft: Radius.circular(28.0),
    topRight: Radius.circular(28.0),
  );
  static const Color lightSurfaceColor = Color(0xFFFEF7FF);
  static const Color darkSurfaceColor = Color(0xFF141218);
  static const Color lightDragHandleColor = Color(0xFF79747E);
  static const Color darkDragHandleColor = Color(0xFF938F99);

  const TwakeBottomSheetStyle._();
}

/// A bottom sheet widget following the Linagora / Twake design system.
///
/// Supports two variants:
/// - [modal] = false: standard (non-modal) bottom sheet
/// - [modal] = true: modal bottom sheet with scrim
///
/// Optionally shows a drag handle at the top.
class TwakeBottomSheet extends StatelessWidget {
  /// Whether to show the drag handle at the top of the sheet.
  final bool showDragHandle;

  /// Whether this is a modal bottom sheet (affects background scrim rendering).
  final bool modal;

  /// The content to display inside the bottom sheet.
  final Widget? child;

  /// Background color override. Defaults to theme surface.
  final Color? backgroundColor;

  const TwakeBottomSheet({
    Key? key,
    this.showDragHandle = true,
    this.modal = false,
    this.child,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedBackground = backgroundColor ??
        (isDark
            ? TwakeBottomSheetStyle.darkSurfaceColor
            : TwakeBottomSheetStyle.lightSurfaceColor);
    final dragHandleColor = isDark
        ? TwakeBottomSheetStyle.darkDragHandleColor
        : TwakeBottomSheetStyle.lightDragHandleColor;

    return Container(
      decoration: BoxDecoration(
        color: resolvedBackground,
        borderRadius: TwakeBottomSheetStyle.sheetBorderRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showDragHandle) _DragHandle(color: dragHandleColor),
          if (child != null) Flexible(child: child!),
        ],
      ),
    );
  }
}

/// Internal drag handle widget.
class _DragHandle extends StatelessWidget {
  final Color color;

  const _DragHandle({required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: TwakeBottomSheetStyle.dragHandleTopPadding,
        bottom: TwakeBottomSheetStyle.dragHandleBottomPadding,
      ),
      child: Center(
        child: Container(
          width: TwakeBottomSheetStyle.dragHandleWidth,
          height: TwakeBottomSheetStyle.dragHandleHeight,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(
              TwakeBottomSheetStyle.dragHandleHeight / 2,
            ),
          ),
        ),
      ),
    );
  }
}
