import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';

/// Theme variants for [TwakeThreadsBubble]
enum ThreadsBubbleTheme { light, dark }

/// State variants for [TwakeThreadsBubble]
enum ThreadsBubbleState {
  dmWithReact,
  dmNoReact,
  senderWithReact,
  senderNoReact,
}

/// A bubble widget displaying a thread with optional reactions,
/// last comment preview, and comment input section.
///
/// Supports Light/Dark themes, Desktop/Mobile devices, and
/// four interaction states: DM+react, DM+no-react, Sender+react, Sender+no-react.
class TwakeThreadsBubble extends StatelessWidget {
  // Thread metadata
  final String threadTitle;
  final String threadDescription;
  final String timeCreated;

  // Owner info
  final String? threadOwner;
  final bool showOwnerInfo;

  // Last comment
  final String lastCommentedBy;
  final String lastComment;
  final String timeOfLastComment;
  final int commentCount;

  // Reactions (emoji + count pairs)
  final List<_ReactionData> reactions;

  // Visibility flags
  final bool showInputCommentSection;
  final bool showInteractionWithThread;
  final bool showIconThreadLeft;

  // Style
  final ThreadsBubbleTheme bubbleTheme;
  final bool isMobile;
  final ThreadsBubbleState state;

  // Callbacks
  final VoidCallback? onViewAllReplies;
  final VoidCallback? onLeaveComment;
  final ValueChanged<String>? onCommentChanged;
  final VoidCallback? onEmojiTap;

  const TwakeThreadsBubble({
    Key? key,
    this.threadTitle = 'Mira Kenter',
    this.threadDescription =
        'Digital Ledger Technologies (DLT) such as blockchain are being deployed as part of diverse applications that span multiple market segments. Application developers have successfully lev...',
    this.timeCreated = '15:35',
    this.threadOwner,
    this.showOwnerInfo = false,
    this.lastCommentedBy = 'Ashlynn Schleifer',
    this.lastComment =
        'Indochine is a family, we have a lot of complicity and respect for each other.',
    this.timeOfLastComment = '15:37',
    this.commentCount = 12,
    this.reactions = const [],
    this.showInputCommentSection = true,
    this.showInteractionWithThread = true,
    this.showIconThreadLeft = false,
    this.bubbleTheme = ThreadsBubbleTheme.light,
    this.isMobile = false,
    this.state = ThreadsBubbleState.dmWithReact,
    this.onViewAllReplies,
    this.onLeaveComment,
    this.onCommentChanged,
    this.onEmojiTap,
  }) : super(key: key);

  bool get _isDark => bubbleTheme == ThreadsBubbleTheme.dark;
  bool get _hasReact =>
      state == ThreadsBubbleState.dmWithReact ||
      state == ThreadsBubbleState.senderWithReact;
  bool get _isSender =>
      state == ThreadsBubbleState.senderWithReact ||
      state == ThreadsBubbleState.senderNoReact;

  Color get _backgroundColor {
    if (_isDark) return const Color(0xFF1F1B24);
    if (_isSender) return const Color(0xFFEADDFF);
    return const Color(0xFFF4F4F4);
  }

  Color get _cardColor {
    if (_isDark) return const Color(0xFF2B2930);
    return Colors.white;
  }

  Color get _primaryTextColor {
    if (_isDark) return const Color(0xFFECE6F0);
    return const Color(0xFF1C1B1F);
  }

  Color get _secondaryTextColor {
    if (_isDark) return const Color(0xFFCAC4D0);
    return const Color(0xFF49454F);
  }

  Color get _viewAllRepliesColor {
    if (_isDark) return const Color(0xFFD0BCFF);
    return const Color(0xFF6750A4);
  }

  Color get _inputFillColor {
    if (_isDark) return const Color(0xFF36343B);
    return const Color(0xFFECE6F0);
  }

  double get _maxWidth => isMobile ? 320.0 : 300.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: _maxWidth),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ThreadHeader(
            title: threadTitle,
            description: threadDescription,
            timeCreated: timeCreated,
            backgroundColor: _backgroundColor,
            primaryTextColor: _primaryTextColor,
            secondaryTextColor: _secondaryTextColor,
            isDark: _isDark,
            isSender: _isSender,
            showIconThreadLeft: showIconThreadLeft,
          ),
          if (_hasReact && showInteractionWithThread)
            _ReactionsRow(
              reactions: reactions.isNotEmpty
                  ? reactions
                  : _defaultReactions,
              commentCount: commentCount,
              secondaryTextColor: _secondaryTextColor,
              isDark: _isDark,
              onEmojiTap: onEmojiTap,
            ),
          if (_hasReact && showInteractionWithThread)
            _LastCommentSection(
              lastCommentedBy: lastCommentedBy,
              lastComment: lastComment,
              timeOfLastComment: timeOfLastComment,
              primaryTextColor: _primaryTextColor,
              secondaryTextColor: _secondaryTextColor,
              viewAllRepliesColor: _viewAllRepliesColor,
              isDark: _isDark,
              onViewAllReplies: onViewAllReplies,
            ),
          if (!_hasReact && showInteractionWithThread)
            _CommentCountRow(
              commentCount: commentCount,
              secondaryTextColor: _secondaryTextColor,
            ),
          if (showInputCommentSection)
            _CommentInputSection(
              isDark: _isDark,
              isSender: _isSender,
              inputFillColor: _inputFillColor,
              primaryTextColor: _primaryTextColor,
              secondaryTextColor: _secondaryTextColor,
              hasReact: _hasReact,
              onLeaveComment: onLeaveComment,
              onCommentChanged: onCommentChanged,
            ),
          if (!_hasReact)
            _BottomAvatarRow(
              commentCount: commentCount,
              secondaryTextColor: _secondaryTextColor,
              isDark: _isDark,
            ),
          if (_hasReact)
            _BottomAvatarRow(
              commentCount: commentCount,
              secondaryTextColor: _secondaryTextColor,
              isDark: _isDark,
            ),
        ],
      ),
    );
  }

  List<_ReactionData> get _defaultReactions => const [
        _ReactionData(emoji: '😊', count: 0),
        _ReactionData(emoji: '👍', count: 1),
        _ReactionData(emoji: '❤️', count: 0),
        _ReactionData(emoji: '😂', count: 24),
      ];
}

// ─── Sub-widgets ───────────────────────────────────────────────────────────

class _ReactionData {
  final String emoji;
  final int count;
  const _ReactionData({required this.emoji, required this.count});
}

class _ThreadHeader extends StatelessWidget {
  final String title;
  final String description;
  final String timeCreated;
  final Color backgroundColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final bool isDark;
  final bool isSender;
  final bool showIconThreadLeft;

  const _ThreadHeader({
    required this.title,
    required this.description,
    required this.timeCreated,
    required this.backgroundColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.isDark,
    required this.isSender,
    required this.showIconThreadLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (showIconThreadLeft) ...[  
                Icon(
                  Icons.forum_outlined,
                  size: 14,
                  color: secondaryTextColor,
                ),
                const SizedBox(width: 4),
              ],
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: secondaryTextColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            description,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: primaryTextColor,
              height: 1.4,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              timeCreated,
              style: TextStyle(
                fontSize: 10,
                color: secondaryTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReactionsRow extends StatelessWidget {
  final List<_ReactionData> reactions;
  final int commentCount;
  final Color secondaryTextColor;
  final bool isDark;
  final VoidCallback? onEmojiTap;

  const _ReactionsRow({
    required this.reactions,
    required this.commentCount,
    required this.secondaryTextColor,
    required this.isDark,
    this.onEmojiTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          ...reactions.map((r) => _EmojiChip(
                emoji: r.emoji,
                count: r.count,
                isDark: isDark,
                onTap: onEmojiTap,
              )),
          const Spacer(),
          Text(
            '$commentCount comments',
            style: TextStyle(
              fontSize: 11,
              color: secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmojiChip extends StatelessWidget {
  final String emoji;
  final int count;
  final bool isDark;
  final VoidCallback? onTap;

  const _EmojiChip({
    required this.emoji,
    required this.count,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 2),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF4A4458)
              : const Color(0xFFEADDFF),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 12)),
            if (count > 0) ...[  
              const SizedBox(width: 2),
              Text(
                '$count',
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? const Color(0xFFD0BCFF) : const Color(0xFF6750A4),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LastCommentSection extends StatelessWidget {
  final String lastCommentedBy;
  final String lastComment;
  final String timeOfLastComment;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final Color viewAllRepliesColor;
  final bool isDark;
  final VoidCallback? onViewAllReplies;

  const _LastCommentSection({
    required this.lastCommentedBy,
    required this.lastComment,
    required this.timeOfLastComment,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.viewAllRepliesColor,
    required this.isDark,
    this.onViewAllReplies,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MiniAvatar(isDark: isDark),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            lastCommentedBy,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: primaryTextColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          timeOfLastComment,
                          style: TextStyle(
                            fontSize: 10,
                            color: secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      lastComment,
                      style: TextStyle(
                        fontSize: 12,
                        color: primaryTextColor,
                        height: 1.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: onViewAllReplies,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: viewAllRepliesColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'View all replies',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentCountRow extends StatelessWidget {
  final int commentCount;
  final Color secondaryTextColor;

  const _CommentCountRow({
    required this.commentCount,
    required this.secondaryTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Text(
        '$commentCount comments',
        style: TextStyle(
          fontSize: 11,
          color: secondaryTextColor,
        ),
      ),
    );
  }
}

class _CommentInputSection extends StatelessWidget {
  final bool isDark;
  final bool isSender;
  final bool hasReact;
  final Color inputFillColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final VoidCallback? onLeaveComment;
  final ValueChanged<String>? onCommentChanged;

  const _CommentInputSection({
    required this.isDark,
    required this.isSender,
    required this.hasReact,
    required this.inputFillColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    this.onLeaveComment,
    this.onCommentChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hintText = hasReact ? 'Leave a quick reply...' : 'Leave a comment';
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
      child: GestureDetector(
        onTap: onLeaveComment,
        child: Container(
          height: 36,
          decoration: BoxDecoration(
            color: inputFillColor,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              if (isSender) ...[  
                _MiniAvatar(isDark: isDark, size: 20),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Text(
                  hintText,
                  style: TextStyle(
                    fontSize: 12,
                    color: secondaryTextColor,
                  ),
                ),
              ),
              Icon(
                Icons.sentiment_satisfied_alt_outlined,
                size: 16,
                color: secondaryTextColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomAvatarRow extends StatelessWidget {
  final int commentCount;
  final Color secondaryTextColor;
  final bool isDark;

  const _BottomAvatarRow({
    required this.commentCount,
    required this.secondaryTextColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      child: Row(
        children: [
          _StackedAvatars(isDark: isDark),
          const SizedBox(width: 6),
          Text(
            '1+ · $commentCount comments',
            style: TextStyle(
              fontSize: 11,
              color: secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _StackedAvatars extends StatelessWidget {
  final bool isDark;
  const _StackedAvatars({required this.isDark});

  static const _colors = [
    Color(0xFF6750A4),
    Color(0xFF958DA5),
    Color(0xFFB0A7C0),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 20,
      child: Stack(
        children: List.generate(3, (i) {
          return Positioned(
            left: i * 13.0,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _colors[i],
                border: Border.all(
                  color: isDark ? const Color(0xFF2B2930) : Colors.white,
                  width: 1.5,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _MiniAvatar extends StatelessWidget {
  final bool isDark;
  final double size;

  const _MiniAvatar({required this.isDark, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark ? const Color(0xFF958DA5) : const Color(0xFF6750A4),
      ),
    );
  }
}
