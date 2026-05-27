import 'package:flutter/material.dart';

/// Enum representing the type of message icon to display.
enum MessageIconType {
  audio,
  attach,
  photo,
  link,
  contact,
  poll,
  video,
}

/// Enum representing the theme variant (light or dark background).
enum MessageIconTheme {
  light,
  dark,
}

/// A 24×24 icon widget that represents different message content types.
///
/// Supports [MessageIconType] (audio, attach, photo, link, contact, poll, video)
/// and [MessageIconTheme] (light, dark) variants matching the Figma spec.
class TwakeMessageTypeIcon extends StatelessWidget {
  /// The type of message content this icon represents.
  final MessageIconType type;

  /// The theme variant controlling icon tint (light = dark icon, dark = light icon).
  final MessageIconTheme theme;

  const TwakeMessageTypeIcon({
    Key? key,
    required this.type,
    this.theme = MessageIconTheme.light,
  }) : super(key: key);

  static const double _size = 24.0;

  /// Returns the emoji string for the given type.
  String get _emoji {
    switch (type) {
      case MessageIconType.audio:
        return '📢';
      case MessageIconType.attach:
        return '📎';
      case MessageIconType.photo:
        return '🖼️';
      case MessageIconType.link:
        return '🔗';
      case MessageIconType.contact:
        return '👤';
      case MessageIconType.poll:
        return '📣';
      case MessageIconType.video:
        return '🎬';
    }
  }

  /// Returns the Material icon data for the given type (used as fallback / tinted overlay).
  IconData get _iconData {
    switch (type) {
      case MessageIconType.audio:
        return Icons.campaign_outlined;
      case MessageIconType.attach:
        return Icons.attach_file;
      case MessageIconType.photo:
        return Icons.image_outlined;
      case MessageIconType.link:
        return Icons.link;
      case MessageIconType.contact:
        return Icons.person_outline;
      case MessageIconType.poll:
        return Icons.campaign_outlined;
      case MessageIconType.video:
        return Icons.videocam_outlined;
    }
  }

  Color get _iconColor {
    switch (theme) {
      case MessageIconTheme.light:
        return const Color(0xFF44464E);
      case MessageIconTheme.dark:
        return const Color(0xFFE2E1E5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _size,
      height: _size,
      child: Icon(
        _iconData,
        size: _size,
        color: _iconColor,
      ),
    );
  }
}
