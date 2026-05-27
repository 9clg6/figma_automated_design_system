import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';

/// Enum representing the visual/functional type of the typing bar.
enum TypingBarType {
  /// Plain input, no preview.
  defaultType,

  /// User is actively typing (send button visible).
  typing,

  /// A link preview card is shown above the input.
  link,

  /// A reply preview card is shown above the input.
  reply,
}

/// Data model for a reply/quote preview shown in the typing bar.
class TypingBarReplyData {
  final String authorName;
  final String previewText;

  const TypingBarReplyData({
    required this.authorName,
    required this.previewText,
  });
}

/// Data model for a link preview shown in the typing bar.
class TypingBarLinkData {
  final String title;
  final String description;
  final String url;
  final ImageProvider<Object>? thumbnail;

  const TypingBarLinkData({
    required this.title,
    required this.description,
    required this.url,
    this.thumbnail,
  });
}

/// A message-composition bar supporting Default, Typing, Link-preview,
/// and Reply-preview variants, with optional send button (DM mode).
class TwakeTypingBar extends StatefulWidget {
  /// Visual variant of the bar.
  final TypingBarType type;

  /// When true the send button is shown (DM / direct-message style).
  final bool showSendButton;

  /// Hint text shown inside the text field.
  final String hintText;

  /// Optional pre-populated text.
  final String? initialText;

  /// Controller — if null an internal one is created.
  final TextEditingController? controller;

  /// Called when the user taps the send button or submits the field.
  final VoidCallback? onSend;

  /// Called when text changes.
  final ValueChanged<String>? onChanged;

  /// Called when the close/dismiss button on the reply/link preview is tapped.
  final VoidCallback? onDismissPreview;

  /// Data for the reply preview card (used when [type] == [TypingBarType.reply]).
  final TypingBarReplyData? replyData;

  /// Data for the link preview card (used when [type] == [TypingBarType.link]).
  final TypingBarLinkData? linkData;

  /// Called when the emoji / attachment icon is tapped.
  final VoidCallback? onEmojiTap;

  const TwakeTypingBar({
    Key? key,
    this.type = TypingBarType.defaultType,
    this.showSendButton = false,
    this.hintText = 'New message',
    this.initialText,
    this.controller,
    this.onSend,
    this.onChanged,
    this.onDismissPreview,
    this.replyData,
    this.linkData,
    this.onEmojiTap,
  }) : super(key: key);

  @override
  State<TwakeTypingBar> createState() => _TwakeTypingBarState();
}

class _TwakeTypingBarState extends State<TwakeTypingBar> {
  late final TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.initialText);
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
    widget.onChanged?.call(_controller.text);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_onTextChanged);
    }
    super.dispose();
  }

  bool get _showSend {
    switch (widget.type) {
      case TypingBarType.typing:
        return true;
      case TypingBarType.link:
      case TypingBarType.reply:
        return _hasText;
      case TypingBarType.defaultType:
        return widget.showSendButton && _hasText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.type == TypingBarType.link && widget.linkData != null)
            _LinkPreviewCard(
              data: widget.linkData!,
              onDismiss: widget.onDismissPreview,
            ),
          if (widget.type == TypingBarType.reply && widget.replyData != null)
            _ReplyPreviewCard(
              data: widget.replyData!,
              onDismiss: widget.onDismissPreview,
            ),
          _InputRow(
            controller: _controller,
            hintText: widget.hintText,
            showSend: _showSend,
            onSend: widget.onSend,
            onEmojiTap: widget.onEmojiTap,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Private sub-widgets
// ---------------------------------------------------------------------------

class _InputRow extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool showSend;
  final VoidCallback? onSend;
  final VoidCallback? onEmojiTap;

  const _InputRow({
    required this.controller,
    required this.hintText,
    required this.showSend,
    this.onSend,
    this.onEmojiTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Emoji / attachment icon
          IconButton(
            onPressed: onEmojiTap,
            icon: const Icon(Icons.sentiment_satisfied_alt_outlined),
            color: colorScheme.onSurfaceVariant,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 40,
              minHeight: 40,
            ),
          ),
          const SizedBox(width: 4),
          // Text input
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 40),
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 6,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: colorScheme.outline.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                  isDense: true,
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend?.call(),
              ),
            ),
          ),
          const SizedBox(width: 4),
          // Send button
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: showSend
                ? _SendButton(key: const ValueKey('send'), onTap: onSend)
                : const SizedBox(width: 40, height: 40, key: ValueKey('empty')),
          ),
        ],
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _SendButton({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.primary,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: const SizedBox(
          width: 40,
          height: 40,
          child: Icon(
            Icons.send,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class _ReplyPreviewCard extends StatelessWidget {
  final TypingBarReplyData data;
  final VoidCallback? onDismiss;

  const _ReplyPreviewCard({
    required this.data,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: colorScheme.primary,
            width: 3,
          ),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.reply, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.authorName,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  data.previewText,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDismiss,
            icon: const Icon(Icons.close, size: 18),
            color: colorScheme.onSurfaceVariant,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }
}

class _LinkPreviewCard extends StatelessWidget {
  final TypingBarLinkData data;
  final VoidCallback? onDismiss;

  const _LinkPreviewCard({
    required this.data,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail if available
          if (data.thumbnail != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              child: Image(
                image: data.thumbnail!,
                width: double.infinity,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.title,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        data.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.url,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: colorScheme.primary,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onDismiss,
                  icon: const Icon(Icons.close, size: 18),
                  color: colorScheme.onSurfaceVariant,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
