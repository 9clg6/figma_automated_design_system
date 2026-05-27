import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';

/// Configuration (color role) variants for [TwakeSmallFab].
enum SmallFabConfiguration { surface, primary, secondary, tertiary }

/// Interaction state variants for [TwakeSmallFab].
enum SmallFabState { enabled, hovered, focused, pressed }

/// Style tokens for [TwakeSmallFab].
class TwakeSmallFabStyle {
  // Size
  static const double size = 40.0;
  static const double iconSize = 24.0;
  static const BorderRadius borderRadius = BorderRadius.all(Radius.circular(12));

  // State overlay opacities (Material3 spec)
  static const double hoverOpacity = 0.08;
  static const double focusOpacity = 0.12;
  static const double pressOpacity = 0.12;

  const TwakeSmallFabStyle._();
}

/// A Small Floating Action Button following Linagora / Twake design system.
///
/// Supports four color [configuration]s (surface, primary, secondary, tertiary)
/// and four interaction [state]s (enabled, hovered, focused, pressed).
/// Pass [onTap] to handle user interaction; the widget manages hover/press
/// state internally when [state] is left as [SmallFabState.enabled].
class TwakeSmallFab extends StatefulWidget {
  /// Color role of the FAB container.
  final SmallFabConfiguration configuration;

  /// Explicit interaction state. When provided, the widget renders that state
  /// statically (useful for Figma-driven showcases / golden tests).
  /// When null the widget manages hover/press internally.
  final SmallFabState? state;

  /// Icon to display inside the FAB.
  final IconData icon;

  /// Callback when the FAB is tapped.
  final VoidCallback? onTap;

  const TwakeSmallFab({
    Key? key,
    this.configuration = SmallFabConfiguration.surface,
    this.state,
    this.icon = Icons.edit_outlined,
    this.onTap,
  }) : super(key: key);

  @override
  State<TwakeSmallFab> createState() => _TwakeSmallFabState();
}

class _TwakeSmallFabState extends State<TwakeSmallFab> {
  bool _hovered = false;
  bool _pressed = false;

  SmallFabState get _effectiveState {
    if (widget.state != null) return widget.state!;
    if (_pressed) return SmallFabState.pressed;
    if (_hovered) return SmallFabState.hovered;
    return SmallFabState.enabled;
  }

  // ── Color helpers ──────────────────────────────────────────────────────────

  Color _containerColor(ColorScheme cs) {
    switch (widget.configuration) {
      case SmallFabConfiguration.surface:
        return cs.surfaceContainerHigh;
      case SmallFabConfiguration.primary:
        return cs.primaryContainer;
      case SmallFabConfiguration.secondary:
        return cs.secondaryContainer;
      case SmallFabConfiguration.tertiary:
        return cs.tertiaryContainer;
    }
  }

  Color _iconColor(ColorScheme cs) {
    switch (widget.configuration) {
      case SmallFabConfiguration.surface:
        return cs.primary;
      case SmallFabConfiguration.primary:
        return cs.onPrimaryContainer;
      case SmallFabConfiguration.secondary:
        return cs.onSecondaryContainer;
      case SmallFabConfiguration.tertiary:
        return cs.onTertiaryContainer;
    }
  }

  Color _overlayColor(ColorScheme cs) {
    return _iconColor(cs);
  }

  double _overlayOpacity() {
    switch (_effectiveState) {
      case SmallFabState.hovered:
        return TwakeSmallFabStyle.hoverOpacity;
      case SmallFabState.focused:
        return TwakeSmallFabStyle.focusOpacity;
      case SmallFabState.pressed:
        return TwakeSmallFabStyle.pressOpacity;
      case SmallFabState.enabled:
        return 0.0;
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final containerColor = _containerColor(cs);
    final iconColor = _iconColor(cs);
    final overlayColor = _overlayColor(cs);
    final overlayOpacity = _overlayOpacity();

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        if (widget.state == null) setState(() => _hovered = true);
      },
      onExit: (_) {
        if (widget.state == null) setState(() => _hovered = false);
      },
      child: GestureDetector(
        onTapDown: (_) {
          if (widget.state == null) setState(() => _pressed = true);
        },
        onTapUp: (_) {
          if (widget.state == null) setState(() => _pressed = false);
          widget.onTap?.call();
        },
        onTapCancel: () {
          if (widget.state == null) setState(() => _pressed = false);
        },
        child: SizedBox(
          width: TwakeSmallFabStyle.size,
          height: TwakeSmallFabStyle.size,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: TwakeSmallFabStyle.borderRadius,
              boxShadow: _effectiveState == SmallFabState.enabled ||
                      _effectiveState == SmallFabState.focused
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.20),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.14),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
            ),
            child: ClipRRect(
              borderRadius: TwakeSmallFabStyle.borderRadius,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // State overlay
                  if (overlayOpacity > 0)
                    Positioned.fill(
                      child: ColoredBox(
                        color: overlayColor.withOpacity(overlayOpacity),
                      ),
                    ),
                  // Icon
                  Icon(
                    widget.icon,
                    size: TwakeSmallFabStyle.iconSize,
                    color: iconColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
