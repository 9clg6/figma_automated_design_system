import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';

/// State variants for [TwakeMessageListItem]
enum MessageListItemState {
  defaultState,
  unselect,
  selected,
  typing,
  reaction,
  mediaPhoto,
  mediaVideo,
}

/// A chat/message list item widget matching the Figma "Message list" component set.
///
/// Supports all Figma variant axes:
/// - [isChat] → Chat?=True/False
/// - [state] → State? enum
/// - [isMuted] → Mute?=True/False
/// - [isHovered] → Hovered?=True/False
/// - [isRead] → Read?=True/False
/// - [hasChatMedia] → Chat+Media=True/False
/// - [isSelected] → Selected?=True/False
class TwakeMessageListItem extends StatefulWidget {
  // ── Content ────────────────────────────────────────────────────────────────
  final String name;
  final String textContent;
  final String time;
  final String lastOneCommented;
  final ImageProvider<Object>? avatarImage;
  final String? avatarInitials;
  final Widget? mediaWidget;
  final Widget? reactionWidget;

  // ── Flags / variant axes ───────────────────────────────────────────────────
  final bool isChat;
  final MessageListItemState state;
  final bool isMuted;
  final bool isHovered;
  final bool isRead;
  final bool hasChatMedia;
  final bool isSelected;
  final bool isPinned;
  final bool hasMention;
  final bool showSent;
  final bool showEncrypted;

  // ── Unread badge count ─────────────────────────────────────────────────────
  final int unreadCount;

  // ── Callbacks ─────────────────────────────────────────────────────────────
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const TwakeMessageListItem({
    Key? key,
    // content
    this.name = 'Sophie Marceau',
    this.textContent =
        'Acting is wonderful therapy for people. Instead of suffering for yourself, someone will do it for you.',
    this.time = '10:00',
    this.lastOneCommented = 'Last one commented',
    this.avatarImage,
    this.avatarInitials,
    this.mediaWidget,
    this.reactionWidget,
    // variant axes
    this.isChat = false,
    this.state = MessageListItemState.defaultState,
    this.isMuted = false,
    this.isHovered = false,
    this.isRead = false,
    this.hasChatMedia = false,
    this.isSelected = false,
    this.isPinned = false,
    this.hasMention = false,
    this.showSent = false,
    this.showEncrypted = false,
    this.unreadCount = 0,
    // callbacks
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  State<TwakeMessageListItem> createState() => _TwakeMessageListItemState();
}

class _TwakeMessageListItemState extends State<TwakeMessageListItem> {
  bool _hovering = false;

  // ── Derived helpers ────────────────────────────────────────────────────────
  bool get _effectiveHovered => widget.isHovered || _hovering;

  Color _backgroundColor(BuildContext context) {
    if (widget.isSelected ||
        widget.state == MessageListItemState.selected) {
      return const Color(0xFFE3EDF8);
    }
    if (_effectiveHovered) {
      return const Color(0xFFECF3FB);
    }
    return Colors.white;
  }

  // ── Height ─────────────────────────────────────────────────────────────────
  double get _itemHeight {
    switch (widget.state) {
      case MessageListItemState.typing:
      case MessageListItemState.reaction:
      case MessageListItemState.mediaPhoto:
      case MessageListItemState.mediaVideo:
        return 64.0;
      default:
        return 72.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: _itemHeight,
          color: _backgroundColor(context),
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Leading: checkbox (unselect/selected) or avatar ────────────
              if (widget.state == MessageListItemState.unselect ||
                  widget.state == MessageListItemState.selected)
                _SelectionCheckbox(
                  isSelected: widget.state == MessageListItemState.selected,
                ),
              if (widget.state != MessageListItemState.unselect &&
                  widget.state != MessageListItemState.selected)
                _Avatar(
                  image: widget.avatarImage,
                  initials: widget.avatarInitials ?? _initials(widget.name),
                  size: 48.0,
                ),
              const SizedBox(width: 12),
              // ── Content ───────────────────────────────────────────────────
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TopRow(widget: widget),
                    const SizedBox(height: 2),
                    _BottomRow(widget: widget),
                  ],
                ),
              ),
              // ── Trailing: unread + time ───────────────────────────────────
              _TrailingSection(widget: widget),
            ],
          ),
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Private sub-widgets
// ────────────────────────────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  final ImageProvider<Object>? image;
  final String initials;
  final double size;

  const _Avatar({
    required this.initials,
    this.image,
    this.size = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundImage: image,
      backgroundColor: const Color(0xFF9E9E9E),
      child: image == null
          ? Text(
              initials,
              style: TextStyle(
                color: Colors.white,
                fontSize: size * 0.35,
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
    );
  }
}

class _SelectionCheckbox extends StatelessWidget {
  final bool isSelected;

  const _SelectionCheckbox({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? const Color(0xFF4B6EAF) : Colors.transparent,
          border: Border.all(
            color: isSelected ? const Color(0xFF4B6EAF) : const Color(0xFF9E9E9E),
            width: 2,
          ),
        ),
        child: isSelected
            ? const Icon(Icons.check, size: 14, color: Colors.white)
            : null,
      ),
    );
  }
}

class _TopRow extends StatelessWidget {
  final TwakeMessageListItem widget;

  const _TopRow({required this.widget});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Mute icon
        if (widget.isMuted) ...[
          const Icon(Icons.volume_off, size: 14, color: Color(0xFF9E9E9E)),
          const SizedBox(width: 4),
        ],
        // Name
        Expanded(
          child: Text(
            widget.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontWeight:
                  widget.isRead ? FontWeight.w400 : FontWeight.w600,
              color: const Color(0xFF1C1B1F),
            ),
          ),
        ),
        // Pin icon
        if (widget.isPinned) ...[
          const SizedBox(width: 4),
          const Icon(Icons.push_pin, size: 14, color: Color(0xFF9E9E9E)),
        ],
        // Time
        const SizedBox(width: 4),
        Text(
          widget.time,
          style: TextStyle(
            fontSize: 12,
            color: widget.isRead
                ? const Color(0xFF9E9E9E)
                : const Color(0xFF4B6EAF),
          ),
        ),
      ],
    );
  }
}

class _BottomRow extends StatelessWidget {
  final TwakeMessageListItem widget;

  const _BottomRow({required this.widget});

  @override
  Widget build(BuildContext context) {
    Widget contentWidget;

    switch (widget.state) {
      case MessageListItemState.typing:
        contentWidget = const _TypingIndicator();
        break;

      case MessageListItemState.reaction:
        contentWidget = Row(
          children: [
            widget.reactionWidget ??
                const Text('⭐', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                widget.textContent,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 13, color: Color(0xFF49454F)),
              ),
            ),
          ],
        );
        break;

      case MessageListItemState.mediaPhoto:
        contentWidget = Row(
          children: [
            const Icon(Icons.image, size: 16, color: Color(0xFF9E9E9E)),
            const SizedBox(width: 4),
            widget.mediaWidget ??
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.image,
                      size: 20, color: Color(0xFF9E9E9E)),
                ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                widget.textContent,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 13, color: Color(0xFF49454F)),
              ),
            ),
          ],
        );
        break;

      case MessageListItemState.mediaVideo:
        contentWidget = Row(
          children: [
            const Icon(Icons.videocam, size: 16, color: Color(0xFF9E9E9E)),
            const SizedBox(width: 4),
            widget.mediaWidget ??
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.play_circle_outline,
                      size: 20, color: Color(0xFF9E9E9E)),
                ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                widget.textContent,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 13, color: Color(0xFF49454F)),
              ),
            ),
          ],
        );
        break;

      default:
        // Default / Unselect / Selected: show text + optional chat extras
        contentWidget = Row(
          children: [
            // Sent icon
            if (widget.showSent) ...[
              const Icon(Icons.done_all, size: 14, color: Color(0xFF4B6EAF)),
              const SizedBox(width: 2),
            ],
            // Encrypted icon
            if (widget.showEncrypted) ...[
              const Icon(Icons.lock, size: 12, color: Color(0xFF9E9E9E)),
              const SizedBox(width: 2),
            ],
            Expanded(
              child: Text(
                widget.isChat
                    ? widget.lastOneCommented
                    : widget.textContent,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  color: widget.isRead
                      ? const Color(0xFF9E9E9E)
                      : const Color(0xFF49454F),
                  fontWeight: widget.isRead
                      ? FontWeight.w400
                      : FontWeight.w400,
                ),
              ),
            ),
            // Chat+Media send media button
            if (widget.hasChatMedia) ...[
              const SizedBox(width: 4),
              const _SendMediaButton(),
            ],
          ],
        );
    }

    return Row(
      children: [
        Expanded(child: contentWidget),
        // Unread count badge
        if (!widget.isRead && widget.unreadCount > 0) ...[
          const SizedBox(width: 4),
          _UnreadBadge(
            count: widget.unreadCount,
            isMuted: widget.isMuted,
          ),
        ],
        // Mention badge
        if (widget.hasMention && !widget.isRead) ...[
          const SizedBox(width: 4),
          const _MentionBadge(),
        ],
      ],
    );
  }
}

class _TrailingSection extends StatelessWidget {
  final TwakeMessageListItem widget;

  const _TrailingSection({required this.widget});

  @override
  Widget build(BuildContext context) {
    // For chat+media variant show action buttons when hovered
    if (widget.hasChatMedia && (widget.isHovered)) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ActionIconButton(
            icon: Icons.call,
            color: const Color(0xFF4B6EAF),
            onTap: () {},
          ),
          const SizedBox(width: 4),
          _ActionIconButton(
            icon: Icons.videocam,
            color: const Color(0xFF4B6EAF),
            onTap: () {},
          ),
          const SizedBox(width: 4),
          _ActionIconButton(
            icon: Icons.send,
            color: const Color(0xFF4B6EAF),
            onTap: () {},
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}

class _UnreadBadge extends StatelessWidget {
  final int count;
  final bool isMuted;

  const _UnreadBadge({required this.count, this.isMuted = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isMuted ? const Color(0xFF9E9E9E) : const Color(0xFF4B6EAF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MentionBadge extends StatelessWidget {
  const _MentionBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: const BoxDecoration(
        color: Color(0xFF4B6EAF),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: const Text(
        '@',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _DotIndicator(delay: 0),
        const SizedBox(width: 3),
        _DotIndicator(delay: 150),
        const SizedBox(width: 3),
        _DotIndicator(delay: 300),
        const SizedBox(width: 8),
        const Text(
          'typing…',
          style: TextStyle(fontSize: 13, color: Color(0xFF4B6EAF)),
        ),
      ],
    );
  }
}

class _DotIndicator extends StatelessWidget {
  final int delay;
  const _DotIndicator({required this.delay});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF4B6EAF),
      ),
    );
  }
}

class _SendMediaButton extends StatelessWidget {
  const _SendMediaButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: const Color(0xFF4B6EAF),
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.send, size: 14, color: Colors.white),
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _ActionIconButton({
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 16, color: Colors.white),
      ),
    );
  }
}
