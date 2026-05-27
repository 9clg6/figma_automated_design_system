import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A web header bar that displays the Twake Chat logo on the left
/// and optional action icons (help, application grid) on the right.
///
/// Matches the Figma "Bar logo web" component.
class TwakeBarLogoWeb extends StatelessWidget {
  /// Whether to show the help/settings icon on the right.
  final bool showIconHelp;

  /// Whether to show the application grid icon on the right.
  final bool showApplicationGrid;

  /// Called when the help icon is tapped.
  final VoidCallback? onHelpTap;

  /// Called when the application grid icon is tapped.
  final VoidCallback? onApplicationGridTap;

  /// Called when the logo is tapped.
  final VoidCallback? onLogoTap;

  const TwakeBarLogoWeb({
    Key? key,
    this.showIconHelp = true,
    this.showApplicationGrid = false,
    this.onHelpTap,
    this.onApplicationGridTap,
    this.onLogoTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo section
          GestureDetector(
            onTap: onLogoTap,
            behavior: HitTestBehavior.opaque,
            child: const _TwakeChatLogo(),
          ),
          // Actions section
          if (showIconHelp || showApplicationGrid)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showIconHelp)
                  _IconAction(
                    icon: Icons.settings_outlined,
                    onTap: onHelpTap,
                    semanticsLabel: 'Help',
                  ),
                if (showIconHelp && showApplicationGrid)
                  const SizedBox(width: 8),
                if (showApplicationGrid)
                  _IconAction(
                    icon: Icons.grid_view_rounded,
                    onTap: onApplicationGridTap,
                    semanticsLabel: 'Application grid',
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

/// The Twake Chat logo widget composed of a purple icon + styled text.
class _TwakeChatLogo extends StatelessWidget {
  const _TwakeChatLogo();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Twake icon placeholder (purple speech-bubble style icon)
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: const Color(0xFF6B4EFF),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(
            Icons.chat_bubble_rounded,
            color: Colors.white,
            size: 16,
          ),
        ),
        const SizedBox(width: 6),
        // "Twake" text in dark/black
        const Text(
          'Twake',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
            letterSpacing: 0,
          ),
        ),
        const SizedBox(width: 3),
        // "Chat" text in purple
        const Text(
          'Chat',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF6B4EFF),
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}

/// A small tappable icon button used in the action area.
class _IconAction extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String semanticsLabel;

  const _IconAction({
    required this.icon,
    this.onTap,
    required this.semanticsLabel,
  });

  @override
  State<_IconAction> createState() => _IconActionState();
}

class _IconActionState extends State<_IconAction> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Semantics(
          label: widget.semanticsLabel,
          button: true,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _hovered
                  ? const Color(0xFFEEEEEE)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              widget.icon,
              size: 20,
              color: const Color(0xFF625B71),
            ),
          ),
        ),
      ),
    );
  }
}
