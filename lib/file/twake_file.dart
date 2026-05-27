import 'package:flutter/material.dart';

/// Enum representing the two display variants of [TwakeFile].
enum TwakeFileType {
  /// Shows a static file preview thumbnail (image / icon).
  preview,

  /// Shows a media file with optional time overlay and play button.
  media,
}

/// A 64 × 64 file thumbnail widget with two variants:
/// - [TwakeFileType.preview] — plain thumbnail, no overlay.
/// - [TwakeFileType.media]  — thumbnail with optional duration label
///   and optional play-button overlay.
class TwakeFile extends StatelessWidget {
  // ── Core ────────────────────────────────────────────────────────────────

  /// Visual variant of the widget.
  final TwakeFileType type;

  /// The image / icon to display as the file thumbnail.
  /// Fills the entire 64 × 64 tile.
  final Widget thumbnail;

  // ── Media-variant options ────────────────────────────────────────────────

  /// Whether to show the duration label (bottom-left corner).
  /// Only used when [type] is [TwakeFileType.media].
  final bool showTime;

  /// Duration text shown in the bottom-left corner, e.g. "1:20".
  /// Only used when [type] is [TwakeFileType.media] and [showTime] is true.
  final String howLong;

  /// Whether to show the circular play button overlay in the centre.
  /// Only used when [type] is [TwakeFileType.media].
  final bool showPlay;

  /// Called when the user taps the widget.
  final VoidCallback? onTap;

  const TwakeFile({
    Key? key,
    required this.type,
    required this.thumbnail,
    this.showTime = true,
    this.howLong = '1:20',
    this.showPlay = true,
    this.onTap,
  }) : super(key: key);

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 64,
          height: 64,
          child: type == TwakeFileType.preview
              ? _PreviewTile(thumbnail: thumbnail)
              : _MediaTile(
                  thumbnail: thumbnail,
                  showTime: showTime,
                  howLong: howLong,
                  showPlay: showPlay,
                ),
        ),
      ),
    );
  }
}

// ── Private sub-widgets ──────────────────────────────────────────────────────

/// Plain thumbnail — no overlay at all.
class _PreviewTile extends StatelessWidget {
  final Widget thumbnail;

  const _PreviewTile({required this.thumbnail});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: thumbnail,
      ),
    );
  }
}

/// Thumbnail with optional duration label and play-button overlay.
class _MediaTile extends StatelessWidget {
  final Widget thumbnail;
  final bool showTime;
  final String howLong;
  final bool showPlay;

  const _MediaTile({
    required this.thumbnail,
    required this.showTime,
    required this.howLong,
    required this.showPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Thumbnail
        FittedBox(
          fit: BoxFit.cover,
          child: thumbnail,
        ),

        // Dark scrim so overlays are legible
        if (showTime || showPlay)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color(0x66000000),
                ],
              ),
            ),
          ),

        // Play button — centre
        if (showPlay)
          const Center(
            child: _PlayButton(),
          ),

        // Duration label — bottom left
        if (showTime)
          Positioned(
            left: 4,
            bottom: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0x99000000),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                howLong,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Small circular play-button overlay.
class _PlayButton extends StatelessWidget {
  const _PlayButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(
        color: Color(0x99000000),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.play_arrow_rounded,
        color: Colors.white,
        size: 18,
      ),
    );
  }
}
