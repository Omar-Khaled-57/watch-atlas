import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/models/media_enums.dart';
import '../constants/dimensions.dart';

class MediaCard extends StatelessWidget {
  final int id;
  final String title;
  final String? posterUrl;
  final double? voteAverage;
  final MediaType? mediaType;
  final VoidCallback? onTap;
  final double width;
  final String? heroTag;

  const MediaCard({
    super.key,
    required this.id,
    required this.title,
    this.posterUrl,
    this.voteAverage,
    this.mediaType,
    this.onTap,
    this.width = 140,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.all(Radius.circular(Spacing.cardRadiusSm)),
                  border: Border.all(
                    color: colorScheme.brightness == Brightness.dark
                        ? Colors.white.withValues(alpha: 0.06)
                        : Colors.black.withValues(alpha: 0.04),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.transparent,
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadiusDirectional.all(Radius.circular(Spacing.cardRadiusSm - 1)),
                  child: heroTag != null
                      ? Hero(
                          tag: heroTag!,
                          child: _PosterImage(
                            posterUrl: posterUrl,
                            width: width,
                            voteAverage: voteAverage,
                            mediaType: mediaType,
                            colorScheme: colorScheme,
                            textTheme: textTheme,
                          ),
                        )
                      : _PosterImage(
                          posterUrl: posterUrl,
                          width: width,
                          voteAverage: voteAverage,
                          mediaType: mediaType,
                          colorScheme: colorScheme,
                          textTheme: textTheme,
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(top: Spacing.sm),
              child: Text(
                title,
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PosterImage extends StatelessWidget {
  final String? posterUrl;
  final double width;
  final double? voteAverage;
  final MediaType? mediaType;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _PosterImage({
    required this.posterUrl,
    required this.width,
    required this.voteAverage,
    required this.mediaType,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (posterUrl != null)
            CachedNetworkImage(
              imageUrl: posterUrl!,
              fit: BoxFit.cover,
              placeholder: (context, url) => const _ShimmerPlaceholder(),
              errorWidget: (context, url, error) => _ErrorPlaceholder(colorScheme: colorScheme),
            )
          else
            _ErrorPlaceholder(colorScheme: colorScheme),
          if (voteAverage != null && voteAverage! > 0)
            PositionedDirectional(
              top: 8,
              start: 8,
              child: _RatingBadge(
                voteAverage: voteAverage!,
                textTheme: textTheme,
              ),
            ),
          if (mediaType != null && mediaType != MediaType.movie)
            PositionedDirectional(
              top: 8,
              end: 8,
              child: _TypeBadge(
                mediaType: mediaType!,
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
            ),
        ],
      ),
    );
  }
}

class _ShimmerPlaceholder extends StatelessWidget {
  const _ShimmerPlaceholder();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF20242E) : const Color(0xFFE5E7EB),
      highlightColor: isDark ? const Color(0xFF2A2F3A) : const Color(0xFFF3F4F6),
      child: ColoredBox(
        color: isDark ? const Color(0xFF20242E) : const Color(0xFFE5E7EB),
      ),
    );
  }
}

class _ErrorPlaceholder extends StatelessWidget {
  final ColorScheme colorScheme;

  const _ErrorPlaceholder({
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.movie_outlined,
          size: 32,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  final double voteAverage;
  final TextTheme textTheme;

  const _RatingBadge({
    required this.voteAverage,
    required this.textTheme,
  });

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
          Icon(
            Icons.star_rounded,
            size: 12,
            color: Colors.amber,
          ),
          const SizedBox(width: 2),
          Text(
            voteAverage.toStringAsFixed(1),
            style: textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final MediaType mediaType;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _TypeBadge({
    required this.mediaType,
    required this.colorScheme,
    required this.textTheme,
  });

  String get _label {
    switch (mediaType) {
      case MediaType.tv:
        return 'TV';
      case MediaType.anime:
        return 'ANIME';
      case MediaType.kdrama:
        return 'K-DRAMA';
      case MediaType.cdrama:
        return 'C-DRAMA';
      case MediaType.jdrama:
        return 'J-DRAMA';
      case MediaType.thaiDrama:
        return 'THAI';
      case MediaType.asianDrama:
        return 'ASIAN';
      case MediaType.egyptianMovie:
        return 'EG-MOVIE';
      case MediaType.egyptianSeries:
        return 'EG-SERIES';
      case MediaType.arabicMovie:
        return 'AR-MOVIE';
      case MediaType.arabicSeries:
        return 'AR-SERIES';
      case MediaType.documentary:
        return 'DOC';
      case MediaType.webSeries:
        return 'WEB';
      case MediaType.custom:
        return '';
      case MediaType.movie:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_label.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.85),
        borderRadius: BorderRadiusDirectional.all(Radius.circular(4)),
      ),
      child: Text(
        _label,
        style: textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
