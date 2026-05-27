import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';

/// State variants for [TwakeSettingProfile]
enum SettingProfileState { defaultState, hover, active }

/// A settings profile list item matching the Figma "Setting Profile" component.
/// Displays an avatar, profile name, subtitle, and a trailing chevron.
/// Supports Default, Hover, and Active visual states.
class TwakeSettingProfile extends StatefulWidget {
  /// The avatar widget displayed on the leading side.
  final Widget avatar;

  /// Primary text (profile name).
  final String profileName;

  /// Secondary text (e.g. email / domain).
  final String subtitle;

  /// Called when the item is tapped.
  final VoidCallback? onTap;

  /// Override the visual state externally. When null the widget manages
  /// hover / press state internally.
  final SettingProfileState? state;

  const TwakeSettingProfile({
    Key? key,
    required this.avatar,
    required this.profileName,
    required this.subtitle,
    this.onTap,
    this.state,
  }) : super(key: key);

  @override
  State<TwakeSettingProfile> createState() => _TwakeSettingProfileState();
}

class _TwakeSettingProfileState extends State<TwakeSettingProfile> {
  bool _isHovered = false;
  bool _isPressed = false;

  SettingProfileState get _effectiveState {
    if (widget.state != null) return widget.state!;
    if (_isPressed) return SettingProfileState.active;
    if (_isHovered) return SettingProfileState.hover;
    return SettingProfileState.defaultState;
  }

  Color _backgroundColorFor(BuildContext context, SettingProfileState state) {
    switch (state) {
      case SettingProfileState.active:
        return LinagoraSysColors.material().secondaryContainer;
      case SettingProfileState.hover:
        return LinagoraSysColors.material().surfaceVariant.withOpacity(0.48);
      case SettingProfileState.defaultState:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = _effectiveState;
    final bgColor = _backgroundColorFor(context, state);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: double.infinity,
          height: 88,
          color: bgColor,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Avatar
              SizedBox(
                width: 56,
                height: 56,
                child: widget.avatar,
              ),
              const SizedBox(width: 16),
              // Text block
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.profileName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6),
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Trailing chevron
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
