import 'package:flutter/material.dart';

/// Design tokens for [TwakeBubbleMessage].
class TwakeBubbleMessageStyle {
  TwakeBubbleMessageStyle._();

  // ── Bubble colours ────────────────────────────────────────────
  static const Color senderBubbleColor = Color(0xFF006D3A);
  static Color receiverBubbleColor(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceContainerHighest;

  static const Color senderTextColor = Colors.white;

  // ── Sender name ───────────────────────────────────────────────
  static const double senderNameFontSize = 12.0;
  static const Color senderNameColor = Color(0xFF006D3A);

  // ── Message text ──────────────────────────────────────────────
  static const double messageFontSize = 14.0;
  static const double messageLineHeight = 1.4;

  // ── Meta / timestamp ──────────────────────────────────────────
  static const double timeFontSize = 11.0;
  static const double metaIconSize = 14.0;
  static const Color senderMetaColor = Color(0xB3FFFFFF); // white 70%
  static Color receiverMetaColor(BuildContext context) =>
      Theme.of(context).colorScheme.onSurfaceVariant;

  // ── Sizing ────────────────────────────────────────────────────
  static const double mobileMaxBubbleWidth = 280.0;
  static const double desktopMaxBubbleWidth = 480.0;

  // ── Border radii ──────────────────────────────────────────────
  static const BorderRadius senderBorderRadius = BorderRadius.only(
    topLeft: Radius.circular(16),
    topRight: Radius.circular(16),
    bottomLeft: Radius.circular(16),
    bottomRight: Radius.circular(4),
  );

  static const BorderRadius receiverBorderRadius = BorderRadius.only(
    topLeft: Radius.circular(4),
    topRight: Radius.circular(16),
    bottomLeft: Radius.circular(16),
    bottomRight: Radius.circular(16),
  );

  // ── Paddings ──────────────────────────────────────────────────
  static const EdgeInsets bubblePadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 8);
  static const EdgeInsets callBubblePadding = EdgeInsets.all(12);
  static const EdgeInsets reactionPadding = EdgeInsets.only(top: 4);
  static const EdgeInsets rowPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 2);

  // ── Checkbox ──────────────────────────────────────────────────
  static const double checkboxSize = 24.0;
  static const Color checkboxSelectedColor = Color(0xFF006D3A);
  static const Color checkboxUnselectedColor = Color(0xFF79747E);

  // ── Avatar ────────────────────────────────────────────────────
  static const double avatarRadius = 16.0;

  // ── Call bubble ───────────────────────────────────────────────
  static const double callIconContainerSize = 40.0;
  static const double callIconSize = 20.0;
  static const Color callIconBgSender = Color(0x33FFFFFF);
  static Color callIconBgReceiver(BuildContext context) =>
      Theme.of(context).colorScheme.primaryContainer;
}
