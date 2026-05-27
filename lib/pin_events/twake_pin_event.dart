import 'package:flutter/material.dart';

/// Enum for pin event content type.
enum PinEventType {
  file,
  photo,
  link,
  contact,
  poll,
  video,
  audio,
  text,
}

/// Enum for pin event theme.
enum PinEventTheme { light, dark }

/// Style tokens for [TwakePinEvent].
class TwakePinEventStyle {
  static const double height = 48.0;
  static const double iconSize = 16.0;
  static const double thumbnailSize = 32.0;
  static const EdgeInsets padding =
      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
  static const EdgeInsets mobilePadding =
      EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0);

  // Light theme
  static const Color lightBackground = Colors.transparent;
  static const Color lightText = Color(0xFF1C1B1F);
  static const Color lightSubText = Color(0xFF49454F);
  static const Color lightAccent = Color(0xFF0066CC);
  static const Color lightIcon = Color(0xFF49454F);

  // Dark theme
  static const Color darkBackground = Color(0xFF2B2930);
  static const Color darkText = Color(0xFFE6E1E5);
  static const Color darkSubText = Color(0xFFCAC4D0);
  static const Color darkAccent = Color(0xFF90CAFF);
  static const Color darkIcon = Color(0xFFCAC4D0);

  // Pin accent bar
  static const Color pinAccentBar = Color(0xFF0066CC);
  static const double pinBarWidth = 3.0;

  const TwakePinEventStyle._();
}

/// A widget that renders a "pin event" row — showing who pinned what type
/// of message, with optional caption, supporting light/dark themes and
/// mobile/web layouts.
///
/// Matches the Figma "Pin Events" component set.
class TwakePinEvent extends StatelessWidget {
  /// The name of the user who pinned the message.
  final String name;

  /// The caption / message content (shown when [noCaption] is false).
  final String messageContent;

  /// The contact's name (used when [type] is [PinEventType.contact]).
  final String contactName;

  /// The link URL (used when [type] is [PinEventType.link]).
  final String link;

  /// The type of pinned content.
  final PinEventType type;

  /// Whether the theme is dark.
  final PinEventTheme theme;

  /// When true, no caption is shown — only a short type label.
  final bool noCaption;

  /// Whether to use mobile layout (tighter padding, shorter truncation).
  final bool isMobile;

  /// Optional thumbnail image for photo/video types.
  final ImageProvider<Object>? thumbnail;

  const TwakePinEvent({
    Key? key,
    required this.name,
    this.messageContent =
        'Lorem ipsum dolor sit amet consectetur. Amet quis leo pulvinar condimentum.',
    this.contactName = 'Davis Calzoni',
    this.link =
        'https://edition.cnn.com/2023/10/25/world/ancient-landscape-antarctica-climate-scn/index.html',
    this.type = PinEventType.file,
    this.theme = PinEventTheme.light,
    this.noCaption = false,
    this.isMobile = false,
    this.thumbnail,
  }) : super(key: key);

  // ── Derived theme helpers ────────────────────────────────────────────────

  bool get _isDark => theme == PinEventTheme.dark;

  Color get _bg => _isDark
      ? TwakePinEventStyle.darkBackground
      : TwakePinEventStyle.lightBackground;

  Color get _textColor =>
      _isDark ? TwakePinEventStyle.darkText : TwakePinEventStyle.lightText;

  Color get _subTextColor => _isDark
      ? TwakePinEventStyle.darkSubText
      : TwakePinEventStyle.lightSubText;

  Color get _accentColor =>
      _isDark ? TwakePinEventStyle.darkAccent : TwakePinEventStyle.pinAccentBar;

  Color get _iconColor =>
      _isDark ? TwakePinEventStyle.darkIcon : TwakePinEventStyle.lightIcon;

  // ── Type helpers ─────────────────────────────────────────────────────────

  IconData get _typeIcon {
    switch (type) {
      case PinEventType.file:
        return Icons.insert_drive_file_outlined;
      case PinEventType.photo:
        return Icons.image_outlined;
      case PinEventType.link:
        return Icons.link_outlined;
      case PinEventType.contact:
        return Icons.person_outline;
      case PinEventType.poll:
        return Icons.poll_outlined;
      case PinEventType.video:
        return Icons.videocam_outlined;
      case PinEventType.audio:
        return Icons.headphones_outlined;
      case PinEventType.text:
        return Icons.text_fields_outlined;
    }
  }

  String get _typeLabel {
    switch (type) {
      case PinEventType.file:
        return 'a file';
      case PinEventType.photo:
        return 'a photo';
      case PinEventType.link:
        return 'a link';
      case PinEventType.contact:
        return 'a contact';
      case PinEventType.poll:
        return 'a poll';
      case PinEventType.video:
        return 'a video';
      case PinEventType.audio:
        return 'an audio';
      case PinEventType.text:
        return '';
    }
  }

  bool get _hasThumbnail =>
      type == PinEventType.photo || type == PinEventType.video;

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final EdgeInsets contentPadding = isMobile
        ? TwakePinEventStyle.mobilePadding
        : TwakePinEventStyle.padding;

    return Container(
      height: TwakePinEventStyle.height,
      color: _bg,
      child: Row(
        children: [
          // Left accent bar
          Container(
            width: TwakePinEventStyle.pinBarWidth,
            color: _accentColor,
          ),
          Expanded(
            child: Padding(
              padding: contentPadding,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Thumbnail (photo/video only)
                  if (_hasThumbnail) ..._buildThumbnail(),
                  // Content
                  Expanded(
                    child: _buildContent(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildThumbnail() {
    return [
      Container(
        width: TwakePinEventStyle.thumbnailSize,
        height: TwakePinEventStyle.thumbnailSize,
        margin: const EdgeInsets.only(right: 8.0),
        decoration: BoxDecoration(
          color: _isDark ? const Color(0xFF49454F) : const Color(0xFFE8DEF8),
          borderRadius: BorderRadius.circular(4),
          image: thumbnail != null
              ? DecorationImage(
                  image: thumbnail!,
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: thumbnail == null
            ? Icon(
                _typeIcon,
                size: TwakePinEventStyle.iconSize,
                color: _iconColor,
              )
            : null,
      ),
    ];
  }

  Widget _buildContent() {
    if (noCaption) {
      return _buildNoCaptionRow();
    }
    return _buildWithCaptionRow();
  }

  /// With caption: "[Name] pinned [icon] [caption text]"
  Widget _buildWithCaptionRow() {
    final nameStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: _textColor,
    );
    final bodyStyle = TextStyle(
      fontSize: 12,
      color: _subTextColor,
    );

    Widget contentText;
    if (type == PinEventType.contact) {
      contentText = Text(
        contactName,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _accentColor,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
    } else if (type == PinEventType.link) {
      contentText = Text(
        link,
        style: bodyStyle.copyWith(color: _accentColor),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
    } else if (type == PinEventType.text) {
      contentText = Text(
        '" $messageContent "',
        style: bodyStyle,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
    } else {
      contentText = Text(
        messageContent,
        style: bodyStyle,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$name pinned ',
          style: nameStyle,
          overflow: TextOverflow.clip,
          maxLines: 1,
        ),
        if (type != PinEventType.text && type != PinEventType.link) ...
          [
            Icon(
              _typeIcon,
              size: TwakePinEventStyle.iconSize,
              color: _iconColor,
            ),
            const SizedBox(width: 4),
          ],
        if (type == PinEventType.link)
          Icon(
            _typeIcon,
            size: TwakePinEventStyle.iconSize,
            color: _accentColor,
          ),
        if (type == PinEventType.link) const SizedBox(width: 4),
        Expanded(child: contentText),
      ],
    );
  }

  /// No caption: "[Name] pinned [icon] [type label]"
  Widget _buildNoCaptionRow() {
    final nameStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: _textColor,
    );
    final labelStyle = TextStyle(
      fontSize: 12,
      color: _subTextColor,
    );

    Widget labelWidget;
    if (type == PinEventType.contact) {
      labelWidget = Text(
        contactName,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _accentColor,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
    } else if (type == PinEventType.link) {
      labelWidget = Text(
        link,
        style: labelStyle.copyWith(color: _accentColor),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
    } else if (type == PinEventType.text) {
      labelWidget = Text(
        '" ${isMobile ? _truncate(messageContent, 18) : _truncate(messageContent, 40)} "',
        style: labelStyle,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
    } else {
      labelWidget = Text(
        _typeLabel,
        style: labelStyle,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$name pinned ',
          style: nameStyle,
          overflow: TextOverflow.clip,
          maxLines: 1,
        ),
        if (type != PinEventType.text) ...
          [
            Icon(
              _typeIcon,
              size: TwakePinEventStyle.iconSize,
              color: type == PinEventType.link ? _accentColor : _iconColor,
            ),
            const SizedBox(width: 4),
          ],
        Expanded(child: labelWidget),
      ],
    );
  }

  String _truncate(String s, int max) =>
      s.length > max ? '${s.substring(0, max)}...' : s;
}
