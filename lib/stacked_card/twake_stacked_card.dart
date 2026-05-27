import 'package:flutter/material.dart';

/// Style variants matching Figma "Stacked card" component set.
enum TwakeStackedCardStyle {
  outlined,
  elevated,
  filled,
}

/// A stacked card widget with header (avatar + title/subhead + menu),
/// a media area, content section, and two action buttons.
///
/// Matches Figma spec: 360×480, variants Outlined / Elevated / Filled.
class TwakeStackedCard extends StatelessWidget {
  // --- Header ---
  /// Widget displayed as the leading avatar in the header.
  final Widget? avatar;

  /// Primary header text.
  final String headerTitle;

  /// Secondary header text.
  final String headerSubhead;

  /// Callback for the trailing three-dot menu button.
  final VoidCallback? onMenuTap;

  // --- Media ---
  /// Widget displayed in the media/image area. Defaults to a placeholder.
  final Widget? media;

  // --- Content ---
  final String title;
  final String subhead;
  final String supportingText;

  // --- Actions ---
  final String primaryActionLabel;
  final String secondaryActionLabel;
  final VoidCallback? onPrimaryAction;
  final VoidCallback? onSecondaryAction;

  // --- Style ---
  final TwakeStackedCardStyle style;

  const TwakeStackedCard({
    Key? key,
    this.avatar,
    this.headerTitle = 'Header',
    this.headerSubhead = 'Subhead',
    this.onMenuTap,
    this.media,
    this.title = 'Title',
    this.subhead = 'Subhead',
    this.supportingText =
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor',
    this.primaryActionLabel = 'Enabled',
    this.secondaryActionLabel = 'Enabled',
    this.onPrimaryAction,
    this.onSecondaryAction,
    this.style = TwakeStackedCardStyle.outlined,
  }) : super(key: key);

  // ---------------------------------------------------------------------------
  // Style helpers
  // ---------------------------------------------------------------------------

  Color _surfaceColor(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    switch (style) {
      case TwakeStackedCardStyle.outlined:
        return cs.surface;
      case TwakeStackedCardStyle.elevated:
        // MD3 elevated card tint: surface + surfaceTint @ 5%
        return ElevationOverlay.applySurfaceTint(cs.surface, cs.surfaceTint, 1);
      case TwakeStackedCardStyle.filled:
        return cs.surfaceVariant;
    }
  }

  Border? _border(BuildContext context) {
    if (style == TwakeStackedCardStyle.outlined) {
      return Border.all(
        color: Theme.of(context).colorScheme.outlineVariant,
        width: 1,
      );
    }
    return null;
  }

  List<BoxShadow>? _shadows() {
    if (style == TwakeStackedCardStyle.elevated) {
      return const [
        BoxShadow(
          color: Color(0x1F000000),
          blurRadius: 2,
          offset: Offset(0, 1),
        ),
        BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 6,
          offset: Offset(0, 2),
        ),
      ];
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final surface = _surfaceColor(context);

    return Container(
      width: 360,
      decoration: BoxDecoration(
        color: surface,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: _border(context),
        boxShadow: _shadows(),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CardHeader(
            avatar: avatar,
            title: headerTitle,
            subhead: headerSubhead,
            onMenuTap: onMenuTap,
          ),
          _CardMedia(media: media),
          _CardContent(
            title: title,
            subhead: subhead,
            supportingText: supportingText,
          ),
          _CardActions(
            primaryLabel: primaryActionLabel,
            secondaryLabel: secondaryActionLabel,
            onPrimary: onPrimaryAction,
            onSecondary: onSecondaryAction,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Private sub-widgets
// ---------------------------------------------------------------------------

class _CardHeader extends StatelessWidget {
  final Widget? avatar;
  final String title;
  final String subhead;
  final VoidCallback? onMenuTap;

  const _CardHeader({
    required this.title,
    required this.subhead,
    this.avatar,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          avatar ??
              CircleAvatar(
                radius: 20,
                backgroundColor: colorScheme.primary,
                child: Text(
                  'A',
                  style: textTheme.labelLarge
                      ?.copyWith(color: colorScheme.onPrimary),
                ),
              ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subhead,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: colorScheme.onSurfaceVariant,
            ),
            onPressed: onMenuTap,
            splashRadius: 20,
          ),
        ],
      ),
    );
  }
}

class _CardMedia extends StatelessWidget {
  final Widget? media;

  const _CardMedia({this.media});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 188,
      child: media ?? _MediaPlaceholder(),
    );
  }
}

class _MediaPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE0E0E0),
      child: Center(
        child: CustomPaint(
          size: const Size(120, 100),
          painter: _ShapesPainter(),
        ),
      ),
    );
  }
}

/// Paints the triangle + square + circle placeholder found in the Figma design.
class _ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF9E9E9E)
      ..style = PaintingStyle.fill;

    // Triangle (top-center)
    final trianglePath = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width / 2 + 30, 44)
      ..lineTo(size.width / 2 - 30, 44)
      ..close();
    canvas.drawPath(trianglePath, paint);

    // Square (bottom-left)
    canvas.drawRect(
      Rect.fromLTWH(size.width / 2 - 52, 54, 40, 40),
      paint,
    );

    // Circle (bottom-right)
    canvas.drawCircle(
      Offset(size.width / 2 + 32, 74),
      20,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CardContent extends StatelessWidget {
  final String title;
  final String subhead;
  final String supportingText;

  const _CardContent({
    required this.title,
    required this.subhead,
    required this.supportingText,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subhead,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            supportingText,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _CardActions extends StatelessWidget {
  final String primaryLabel;
  final String secondaryLabel;
  final VoidCallback? onPrimary;
  final VoidCallback? onSecondary;

  const _CardActions({
    required this.primaryLabel,
    required this.secondaryLabel,
    this.onPrimary,
    this.onSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: onSecondary,
            style: OutlinedButton.styleFrom(
              foregroundColor: colorScheme.primary,
              side: BorderSide(color: colorScheme.outline),
              shape: const StadiumBorder(),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            ),
            child: Text(secondaryLabel),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: onPrimary,
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              shape: const StadiumBorder(),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            ),
            child: Text(primaryLabel),
          ),
        ],
      ),
    );
  }
}
