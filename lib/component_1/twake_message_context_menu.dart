import 'package:flutter/material.dart';

/// A context menu for messages, matching Figma "actionbar" / "actioncontact".
/// Supports an optional emoji reaction bar and a variable list of action items.
///
/// Variants:
/// - [showEmojiBar] → bool (emoji bar=true/false)
/// - [items] → list of [TwakeContextMenuItem] (5–11 items)
class TwakeMessageContextMenu extends StatelessWidget {
  /// Whether to show the emoji reaction bar at the top.
  final bool showEmojiBar;

  /// The list of menu action items to display.
  final List<TwakeContextMenuItem> items;

  /// Emojis shown in the reaction bar. Defaults to the 5 standard emojis.
  final List<String> emojis;

  /// Called when the expand/more button in the emoji bar is tapped.
  final VoidCallback? onEmojiMoreTap;

  const TwakeMessageContextMenu({
    Key? key,
    required this.items,
    this.showEmojiBar = true,
    this.emojis = const ['👍', '😍', '😎', '🤔', '😀'],
    this.onEmojiMoreTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showEmojiBar) _EmojiReactionBar(
            emojis: emojis,
            onMoreTap: onEmojiMoreTap,
          ),
          if (showEmojiBar) const SizedBox(height: 4),
          _MenuCard(items: items),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Emoji reaction bar
// ---------------------------------------------------------------------------

class _EmojiReactionBar extends StatelessWidget {
  final List<String> emojis;
  final VoidCallback? onMoreTap;

  const _EmojiReactionBar({
    required this.emojis,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 80,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...emojis.map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(e, style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 4),
          _MoreButton(onTap: onMoreTap),
        ],
      ),
    );
  }
}

class _MoreButton extends StatelessWidget {
  final VoidCallback? onTap;
  const _MoreButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(
          color: Color(0xFFE8E8E8),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.keyboard_arrow_down_rounded,
          size: 20,
          color: Color(0xFF49454F),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Menu card
// ---------------------------------------------------------------------------

class _MenuCard extends StatelessWidget {
  final List<TwakeContextMenuItem> items;

  const _MenuCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 80,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < items.length; i++) ...
                [
                  _MenuItemRow(item: items[i]),
                  if (i < items.length - 1)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFF4F4F4),
                    ),
                ],
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Single menu item row
// ---------------------------------------------------------------------------

class _MenuItemRow extends StatefulWidget {
  final TwakeContextMenuItem item;
  const _MenuItemRow({required this.item});

  @override
  State<_MenuItemRow> createState() => _MenuItemRowState();
}

class _MenuItemRowState extends State<_MenuItemRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDestructive = widget.item.isDestructive;
    final textColor =
        isDestructive ? const Color(0xFFB3261E) : const Color(0xFF1C1B1F);
    final iconColor =
        isDestructive ? const Color(0xFFB3261E) : const Color(0xFF49454F);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.item.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: 216,
          height: 45,
          color: _hovered ? const Color(0xFFF4F4F4) : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.item.icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    widget.item.icon,
                    size: 18,
                    color: iconColor,
                  ),
                ),
              Expanded(
                child: Text(
                  widget.item.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: textColor,
                    height: 1.43,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Data model
// ---------------------------------------------------------------------------

/// Represents a single item in the [TwakeMessageContextMenu].
class TwakeContextMenuItem {
  /// Label displayed in the item.
  final String label;

  /// Icon displayed on the left of the label.
  final IconData? icon;

  /// When true the item is rendered in red (destructive action like Delete).
  final bool isDestructive;

  /// Callback when the item is tapped.
  final VoidCallback? onTap;

  const TwakeContextMenuItem({
    required this.label,
    this.icon,
    this.isDestructive = false,
    this.onTap,
  });
}

// ---------------------------------------------------------------------------
// Pre-built factory helpers
// ---------------------------------------------------------------------------

/// Returns the standard action bar item list used in Figma (actionbar).
List<TwakeContextMenuItem> twakeDefaultMenuItems({
  VoidCallback? onReply,
  VoidCallback? onForward,
  VoidCallback? onPin,
  VoidCallback? onCopy,
  VoidCallback? onDelete,
}) =>
    [
      TwakeContextMenuItem(
        label: 'Reply',
        icon: Icons.reply_rounded,
        onTap: onReply,
      ),
      TwakeContextMenuItem(
        label: 'Forward',
        icon: Icons.reply_rounded,
        onTap: onForward,
      ),
      TwakeContextMenuItem(
        label: 'Pin message',
        icon: Icons.push_pin_outlined,
        onTap: onPin,
      ),
      TwakeContextMenuItem(
        label: 'Copy text',
        icon: Icons.copy_outlined,
        onTap: onCopy,
      ),
      TwakeContextMenuItem(
        label: 'Delete',
        icon: Icons.delete_outline_rounded,
        isDestructive: true,
        onTap: onDelete,
      ),
    ];

/// Returns the contact action menu items used in Figma (actioncontact).
List<TwakeContextMenuItem> twakeContactMenuItems({
  VoidCallback? onMarkAsRead,
  VoidCallback? onPinChat,
  VoidCallback? onMuteChat,
}) =>
    [
      TwakeContextMenuItem(
        label: 'Mark this chat as read',
        icon: Icons.done_all_outlined,
        onTap: onMarkAsRead,
      ),
      TwakeContextMenuItem(
        label: 'Pin this chat',
        icon: Icons.push_pin_outlined,
        onTap: onPinChat,
      ),
      TwakeContextMenuItem(
        label: 'Mute this chat',
        icon: Icons.notifications_off_outlined,
        onTap: onMuteChat,
      ),
    ];
