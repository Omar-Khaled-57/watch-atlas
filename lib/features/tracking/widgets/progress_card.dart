import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/models/media_enums.dart';
import '../../../models/user_media_model.dart';
import '../../../l10n/l10n.dart';

class ProgressCard extends StatelessWidget {
  final UserMediaModel userMedia;
  final String? posterUrl;
  final String title;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ProgressCard({
    super.key,
    required this.userMedia,
    this.posterUrl,
    required this.title,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final hasProgress = userMedia.totalEpisodes > 0;
    final progress = hasProgress
        ? (userMedia.episodeProgress / userMedia.totalEpisodes).clamp(0.0, 1.0)
        : 0.0;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  if (posterUrl != null)
                    CachedNetworkImage(
                      imageUrl: posterUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorWidget: (context, url, error) => _Placeholder(colorScheme: colorScheme),
                    )
                  else
                    _Placeholder(colorScheme: colorScheme),
                  PositionedDirectional(
                    top: 8,
                    end: 8,
                    child: _StatusBadge(status: userMedia.status, colorScheme: colorScheme, textTheme: textTheme),
                  ),
                  if (userMedia.userRating != null)
                    PositionedDirectional(
                      bottom: 8,
                      start: 8,
                      child: _RatingBadge(rating: userMedia.userRating!, textTheme: textTheme),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(Spacing.sm, Spacing.sm, Spacing.sm, Spacing.xs),
              child: Text(
                title,
                style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (hasProgress)
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadiusDirectional.all(Radius.circular(4)),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 4,
                        backgroundColor: colorScheme.surfaceContainerHighest,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(
                      '${userMedia.episodeProgress} / ${userMedia.totalEpisodes}',
                      style: textTheme.labelSmall?.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              )
            else
              const SizedBox(height: Spacing.xs),
          ],
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final ColorScheme colorScheme;
  const _Placeholder({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(Icons.movie_outlined, size: 32, color: colorScheme.onSurfaceVariant),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final WatchStatus status;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  const _StatusBadge({required this.status, required this.colorScheme, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.85),
        borderRadius: BorderRadiusDirectional.all(Radius.circular(4)),
      ),
      child: Text(
        statusLabel(status, context),
        style: textTheme.labelSmall?.copyWith(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
      ),
    );
  }

  String statusLabel(WatchStatus status, BuildContext context) {
    switch (status) {
      case WatchStatus.watching: return context.l10n.watchingBadge;
      case WatchStatus.completed: return context.l10n.completedBadge;
      case WatchStatus.onHold: return context.l10n.onHoldBadge;
      case WatchStatus.dropped: return context.l10n.droppedBadge;
      case WatchStatus.planToWatch: return context.l10n.planToWatchBadge;
      case WatchStatus.rewatching: return context.l10n.rewatchingBadge;
    }
  }
}

class _RatingBadge extends StatelessWidget {
  final double rating;
  final TextTheme textTheme;
  const _RatingBadge({required this.rating, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.75),
        borderRadius: BorderRadiusDirectional.all(Radius.circular(4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 10, color: Colors.amber),
          const SizedBox(width: 2),
          Text(
            rating.toStringAsFixed(1),
            style: textTheme.labelSmall?.copyWith(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
