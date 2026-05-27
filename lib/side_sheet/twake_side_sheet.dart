import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';

/// Variant type for the side sheet
enum TwakeSideSheetType { standard, modal }

/// A side sheet widget following Linagora / Material3 design.
///
/// Supports:
/// - [type]: [TwakeSideSheetType.standard] (flat) or [TwakeSideSheetType.modal] (elevated/card)
/// - [showBack]: whether to show the back arrow before the title
/// - [showActions]: whether to show the Save / Cancel action bar at the bottom
/// - [title]: headline text
/// - [body]: scrollable body content
/// - [onClose]: callback for the × button
/// - [onBack]: callback for the ← button (only relevant when [showBack] is true)
/// - [onSave]: callback for the Save button
/// - [onCancel]: callback for the Cancel button
class TwakeSideSheet extends StatelessWidget {
  final TwakeSideSheetType type;
  final bool showBack;
  final bool showActions;
  final String title;
  final Widget? body;
  final VoidCallback? onClose;
  final VoidCallback? onBack;
  final VoidCallback? onSave;
  final VoidCallback? onCancel;

  const TwakeSideSheet({
    Key? key,
    this.type = TwakeSideSheetType.standard,
    this.showBack = false,
    this.showActions = true,
    this.title = 'Title',
    this.body,
    this.onClose,
    this.onBack,
    this.onSave,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isModal = type == TwakeSideSheetType.modal;

    final Color surfaceColor = isModal
        ? colorScheme.surface
        : colorScheme.surface;
    final Color borderColor = colorScheme.outlineVariant;

    final borderRadius = isModal
        ? const BorderRadius.all(Radius.circular(16))
        : BorderRadius.zero;

    Widget sheet = Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: borderRadius,
        border: isModal
            ? null
            : Border(
                left: BorderSide(
                  color: borderColor,
                  width: 1,
                ),
              ),
        boxShadow: isModal
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(-2, 0),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TwakeSideSheetHeader(
            title: title,
            showBack: showBack,
            onClose: onClose,
            onBack: onBack,
          ),
          Expanded(
            child: body ?? const SizedBox.shrink(),
          ),
          if (showActions)
            _TwakeSideSheetActions(
              onSave: onSave,
              onCancel: onCancel,
            ),
        ],
      ),
    );

    return sheet;
  }
}

/// Header row: optional back arrow, title, close button.
class _TwakeSideSheetHeader extends StatelessWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onClose;
  final VoidCallback? onBack;

  const _TwakeSideSheetHeader({
    required this.title,
    required this.showBack,
    this.onClose,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (showBack) ...
            [
              InkWell(
                onTap: onBack,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.arrow_back,
                    size: 20,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          Expanded(
            child: Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          InkWell(
            onTap: onClose,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.close,
                size: 20,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom action bar with Save (filled) and Cancel (outlined) buttons.
class _TwakeSideSheetActions extends StatelessWidget {
  final VoidCallback? onSave;
  final VoidCallback? onCancel;

  const _TwakeSideSheetActions({
    this.onSave,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Divider(
          height: 1,
          thickness: 1,
          color: colorScheme.outlineVariant,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              _SaveButton(onTap: onSave),
              const SizedBox(width: 8),
              _CancelButton(onTap: onCancel),
            ],
          ),
        ),
      ],
    );
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _SaveButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          'Save',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
    );
  }
}

class _CancelButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _CancelButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colorScheme.outline,
            width: 1,
          ),
        ),
        child: Text(
          'Cancel',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
    );
  }
}
