import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';

/// Enum for the visual style of [TwakeInputChip].
enum InputChipStyle { unselected, selected }

/// Enum for the configuration (slot layout) of [TwakeInputChip].
enum InputChipConfiguration {
  labelOnly,
  labelAndTrailingIcon,
  leadingIconAndLabel,
  leadingIconLabelTrailingIcon,
  labelAndAvatar,
  labelAvatarAndTrailingIcon,
}

/// Enum for the interactive state of [TwakeInputChip].
enum InputChipState { enabled, hovered, focused, dragged }

/// A Material 3-style Input Chip following the Linagora / Twake design system.
///
/// Supports all six configurations, two styles (selected / unselected) and
/// four interactive states (enabled, hovered, focused, dragged).
class TwakeInputChip extends StatefulWidget {
  // ── Content ────────────────────────────────────────────────────────────────
  /// Primary label text shown inside the chip.
  final String label;

  /// Leading icon widget (used when [configuration] includes a leading icon).
  final Widget? leadingIcon;

  /// Avatar widget (used when [configuration] includes an avatar).
  final Widget? avatar;

  /// Trailing close / delete icon. Defaults to [Icons.close] when null and a
  /// trailing-icon configuration is active.
  final Widget? trailingIcon;

  // ── Variant knobs ──────────────────────────────────────────────────────────
  final InputChipStyle style;
  final InputChipConfiguration configuration;

  /// When null the widget manages its own hover / press state internally.
  /// Pass an explicit value to override (e.g. for Storybook-like previews).
  final InputChipState? state;

  // ── Callbacks ──────────────────────────────────────────────────────────────
  final VoidCallback? onTap;
  final VoidCallback? onDeleted;

  const TwakeInputChip({
    super.key,
    required this.label,
    this.leadingIcon,
    this.avatar,
    this.trailingIcon,
    this.style = InputChipStyle.unselected,
    this.configuration = InputChipConfiguration.labelOnly,
    this.state,
    this.onTap,
    this.onDeleted,
  });

  @override
  State<TwakeInputChip> createState() => _TwakeInputChipState();
}

class _TwakeInputChipState extends State<TwakeInputChip> {
  bool _hovered = false;
  bool _pressed = false;

  InputChipState get _effectiveState {
    if (widget.state != null) return widget.state!;
    if (_pressed) return InputChipState.dragged;
    if (_hovered) return InputChipState.hovered;
    return InputChipState.enabled;
  }

  // ── Colours ────────────────────────────────────────────────────────────────
  Color _surfaceColor(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final selected = widget.style == InputChipStyle.selected;

    switch (_effectiveState) {
      case InputChipState.enabled:
        return selected ? cs.secondaryContainer : Colors.transparent;
      case InputChipState.hovered:
        return selected
            ? cs.secondaryContainer.withOpacity(0.92)
            : cs.onSurface.withOpacity(0.08);
      case InputChipState.focused:
        return selected
            ? cs.secondaryContainer.withOpacity(0.88)
            : cs.onSurface.withOpacity(0.12);
      case InputChipState.dragged:
        return selected
            ? cs.secondaryContainer.withOpacity(0.84)
            : cs.onSurface.withOpacity(0.16);
    }
  }

  Color _borderColor(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (widget.style == InputChipStyle.selected) return Colors.transparent;
    switch (_effectiveState) {
      case InputChipState.enabled:
        return cs.outline;
      case InputChipState.hovered:
        return cs.outline;
      case InputChipState.focused:
        return cs.primary;
      case InputChipState.dragged:
        return cs.outline;
    }
  }

  Color _labelColor(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return widget.style == InputChipStyle.selected
        ? cs.onSecondaryContainer
        : cs.onSurfaceVariant;
  }

  Color _iconColor(BuildContext context) => _labelColor(context);

  // ── Layout helpers ─────────────────────────────────────────────────────────
  bool get _hasLeadingIcon =>
      widget.configuration == InputChipConfiguration.leadingIconAndLabel ||
      widget.configuration ==
          InputChipConfiguration.leadingIconLabelTrailingIcon;

  bool get _hasAvatar =>
      widget.configuration == InputChipConfiguration.labelAndAvatar ||
      widget.configuration == InputChipConfiguration.labelAvatarAndTrailingIcon;

  bool get _hasTrailingIcon =>
      widget.configuration == InputChipConfiguration.labelAndTrailingIcon ||
      widget.configuration ==
          InputChipConfiguration.leadingIconLabelTrailingIcon ||
      widget.configuration == InputChipConfiguration.labelAvatarAndTrailingIcon;

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final labelColor = _labelColor(context);
    final iconColor = _iconColor(context);
    final surface = _surfaceColor(context);
    final border = _borderColor(context);

    final elevation =
        _effectiveState == InputChipState.dragged ? 4.0 : 0.0;

    Widget chip = AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      height: 32,
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border, width: 1),
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.14),
                  blurRadius: elevation * 2,
                  offset: const Offset(0, 2),
                )
              ]
            : null,
      ),
      child: Padding(
        padding: _contentPadding(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: _buildChildren(context, labelColor, iconColor),
        ),
      ),
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onTap?.call();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: chip,
      ),
    );
  }

  EdgeInsets _contentPadding() {
    // leading side: 4 if avatar/icon present, else 12
    final double left = (_hasLeadingIcon || _hasAvatar) ? 4.0 : 12.0;
    // trailing side: 4 if trailing icon, else 12
    final double right = _hasTrailingIcon ? 4.0 : 12.0;
    return EdgeInsets.only(left: left, right: right, top: 6, bottom: 6);
  }

  List<Widget> _buildChildren(
      BuildContext context, Color labelColor, Color iconColor) {
    final children = <Widget>[];

    // ── Leading ──
    if (_hasLeadingIcon && widget.leadingIcon != null) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: SizedBox(
            width: 18,
            height: 18,
            child: IconTheme(
              data: IconThemeData(color: iconColor, size: 18),
              child: widget.leadingIcon!,
            ),
          ),
        ),
      );
    } else if (_hasLeadingIcon) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Icon(Icons.label_outline, color: iconColor, size: 18),
        ),
      );
    }

    if (_hasAvatar) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: SizedBox(
            width: 24,
            height: 24,
            child: widget.avatar ??
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    label.isNotEmpty ? label[0].toUpperCase() : '?',
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
          ),
        ),
      );
    }

    // ── Label ──
    children.add(
      Text(
        widget.label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: labelColor,
              fontWeight: FontWeight.w500,
            ) ??
            TextStyle(
              fontSize: 14,
              color: labelColor,
              fontWeight: FontWeight.w500,
            ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );

    // ── Trailing ──
    if (_hasTrailingIcon) {
      children.add(
        GestureDetector(
          onTap: widget.onDeleted,
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: SizedBox(
              width: 18,
              height: 18,
              child: widget.trailingIcon ??
                  Icon(Icons.close, color: iconColor, size: 18),
            ),
          ),
        ),
      );
    }

    return children;
  }

  String get label => widget.label;
}
