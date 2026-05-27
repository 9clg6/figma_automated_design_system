import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/bubble_message/twake_bubble_message_style.dart';

/// Enum for device type variants
enum BubbleDevice { mobile, desktop }

/// Enum for chat context variants
enum BubbleChat { dm, chat, sender, chatSender }

/// Enum for message type variants
enum BubbleType {
  shortMessage,
  multipleLines,
  media,
  mediaText,
  link,
  files,
  location,
  liveLocation,
  contact,
  reply,
  incomingCall,
  incomingVideoCall,
}

/// A chat bubble message widget matching the Linagora / Twake Figma spec.
///
/// Supports device (mobile / desktop), chat context (DM, Chat, Sender,
/// Chat Sender) and message type variants, as well as optional pin,
/// reaction and selection-mode overlays.
class TwakeBubbleMessage extends StatelessWidget {
  // ── Content ────────────────────────────────────────────────────────────────
  final String message;
  final String time;
  final String senderName;

  // ── Variant knobs ──────────────────────────────────────────────────────────
  final BubbleDevice device;
  final BubbleChat chat;
  final BubbleType type;

  // ── Feature flags ─────────────────────────────────────────────────────────
  final bool showPin;
  final bool showReaction;
  final bool showUploading;
  final bool selectionMode;
  final bool isSelected;

  // ── Optional slots ────────────────────────────────────────────────────────
  /// Widget shown inside the bubble above the message (e.g. media thumbnail).
  final Widget? mediaContent;

  /// Reaction bar widget rendered below the bubble.
  final Widget? reactionWidget;

  // ── Callbacks ─────────────────────────────────────────────────────────────
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onSelectionToggle;

  const TwakeBubbleMessage({
    Key? key,
    required this.message,
    required this.time,
    this.senderName = '',
    this.device = BubbleDevice.mobile,
    this.chat = BubbleChat.dm,
    this.type = BubbleType.shortMessage,
    this.showPin = false,
    this.showReaction = false,
    this.showUploading = false,
    this.selectionMode = false,
    this.isSelected = false,
    this.mediaContent,
    this.reactionWidget,
    this.onTap,
    this.onLongPress,
    this.onSelectionToggle,
  }) : super(key: key);

  // ── Derived helpers ────────────────────────────────────────────────────────
  bool get _isSender =>
      chat == BubbleChat.sender || chat == BubbleChat.chatSender;

  bool get _showSenderName =>
      (chat == BubbleChat.chat || chat == BubbleChat.chatSender) && !_isSender;

  bool get _isIncomingCall =>
      type == BubbleType.incomingCall || type == BubbleType.incomingVideoCall;

  // ── Colours ───────────────────────────────────────────────────────────────
  Color _bubbleColor(BuildContext context) {
    if (_isSender) {
      return TwakeBubbleMessageStyle.senderBubbleColor;
    }
    return TwakeBubbleMessageStyle.receiverBubbleColor(context);
  }

  Color _textColor(BuildContext context) {
    if (_isSender) {
      return TwakeBubbleMessageStyle.senderTextColor;
    }
    return Theme.of(context).colorScheme.onSurface;
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final bool isMobile = device == BubbleDevice.mobile;
    final double maxWidth = isMobile
        ? TwakeBubbleMessageStyle.mobileMaxBubbleWidth
        : TwakeBubbleMessageStyle.desktopMaxBubbleWidth;

    Widget bubble = _buildBubble(context, maxWidth);

    if (showReaction && reactionWidget != null) {
      bubble = Column(
        crossAxisAlignment:
            _isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          bubble,
          Padding(
            padding: TwakeBubbleMessageStyle.reactionPadding,
            child: reactionWidget,
          ),
        ],
      );
    }

    Widget row = Row(
      mainAxisAlignment:
          _isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (selectionMode) _buildCheckbox(),
        if (!_isSender && (chat == BubbleChat.chat || chat == BubbleChat.chatSender))
          _buildAvatar(context),
        Flexible(
          child: bubble,
        ),
      ],
    );

    return GestureDetector(
      onTap: selectionMode ? onSelectionToggle : onTap,
      onLongPress: onLongPress,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: TwakeBubbleMessageStyle.rowPadding,
        child: row,
      ),
    );
  }

  // ── Sub-widgets ────────────────────────────────────────────────────────────

  Widget _buildCheckbox() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Icon(
        isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
        color: isSelected
            ? TwakeBubbleMessageStyle.checkboxSelectedColor
            : TwakeBubbleMessageStyle.checkboxUnselectedColor,
        size: TwakeBubbleMessageStyle.checkboxSize,
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, bottom: 4.0),
      child: CircleAvatar(
        radius: TwakeBubbleMessageStyle.avatarRadius,
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        child: Text(
          senderName.isNotEmpty ? senderName[0].toUpperCase() : '?',
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildBubble(BuildContext context, double maxWidth) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Container(
        decoration: BoxDecoration(
          color: _bubbleColor(context),
          borderRadius: _bubbleBorderRadius(),
        ),
        padding: _isIncomingCall
            ? TwakeBubbleMessageStyle.callBubblePadding
            : TwakeBubbleMessageStyle.bubblePadding,
        child: _isIncomingCall
            ? _buildCallContent(context)
            : _buildMessageContent(context),
      ),
    );
  }

  BorderRadius _bubbleBorderRadius() {
    if (_isSender) {
      return TwakeBubbleMessageStyle.senderBorderRadius;
    }
    return TwakeBubbleMessageStyle.receiverBorderRadius;
  }

  Widget _buildMessageContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_showSenderName) _buildSenderName(context),
        if (mediaContent != null) ...[mediaContent!, const SizedBox(height: 6)],
        if (showUploading) _buildUploadingIndicator(context),
        _buildMessageRow(context),
      ],
    );
  }

  Widget _buildSenderName(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Text(
        senderName,
        style: TextStyle(
          fontSize: TwakeBubbleMessageStyle.senderNameFontSize,
          fontWeight: FontWeight.w600,
          color: TwakeBubbleMessageStyle.senderNameColor,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildMessageRow(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Text(
            message,
            style: TextStyle(
              fontSize: TwakeBubbleMessageStyle.messageFontSize,
              height: TwakeBubbleMessageStyle.messageLineHeight,
              color: _textColor(context),
            ),
          ),
        ),
        const SizedBox(width: 6),
        _buildTimestamp(context),
      ],
    );
  }

  Widget _buildTimestamp(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (showPin)
          Padding(
            padding: const EdgeInsets.only(right: 3.0),
            child: Icon(
              Icons.push_pin,
              size: TwakeBubbleMessageStyle.metaIconSize,
              color: _isSender
                  ? TwakeBubbleMessageStyle.senderMetaColor
                  : TwakeBubbleMessageStyle.receiverMetaColor(context),
            ),
          ),
        Text(
          time,
          style: TextStyle(
            fontSize: TwakeBubbleMessageStyle.timeFontSize,
            color: _isSender
                ? TwakeBubbleMessageStyle.senderMetaColor
                : TwakeBubbleMessageStyle.receiverMetaColor(context),
          ),
        ),
        if (_isSender) ..._buildReadReceipts(context),
      ],
    );
  }

  List<Widget> _buildReadReceipts(BuildContext context) {
    return [
      const SizedBox(width: 3),
      Icon(
        Icons.done_all,
        size: TwakeBubbleMessageStyle.metaIconSize,
        color: TwakeBubbleMessageStyle.senderMetaColor,
      ),
    ];
  }

  Widget _buildUploadingIndicator(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: _isSender
                  ? TwakeBubbleMessageStyle.senderMetaColor
                  : TwakeBubbleMessageStyle.senderNameColor,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'Uploading…',
            style: TextStyle(
              fontSize: 11,
              color: _isSender
                  ? TwakeBubbleMessageStyle.senderMetaColor
                  : TwakeBubbleMessageStyle.receiverMetaColor(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallContent(BuildContext context) {
    final bool isVideo = type == BubbleType.incomingVideoCall;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: TwakeBubbleMessageStyle.callIconContainerSize,
          height: TwakeBubbleMessageStyle.callIconContainerSize,
          decoration: BoxDecoration(
            color: _isSender
                ? TwakeBubbleMessageStyle.callIconBgSender
                : TwakeBubbleMessageStyle.callIconBgReceiver(context),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isVideo ? Icons.videocam : Icons.phone,
            color: _isSender
                ? TwakeBubbleMessageStyle.senderBubbleColor
                : Theme.of(context).colorScheme.primary,
            size: TwakeBubbleMessageStyle.callIconSize,
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isVideo ? 'Incoming video call' : 'Incoming call',
                style: TextStyle(
                  fontSize: TwakeBubbleMessageStyle.messageFontSize,
                  fontWeight: FontWeight.w600,
                  color: _textColor(context),
                ),
              ),
              const SizedBox(height: 2),
              _buildTimestamp(context),
            ],
          ),
        ),
      ],
    );
  }
}
