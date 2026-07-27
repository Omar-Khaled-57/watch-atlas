import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/extensions/context_extensions.dart';

/// Backdrop + poster hero for portrait media detail layout.
class PortraitHero extends StatelessWidget {
  final String? backdropUrl;
  final String? posterUrl;

  const PortraitHero({super.key, this.backdropUrl, this.posterUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: AppConstants.backdropHeight,
          width: double.infinity,
          foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(
              begin: AlignmentDirectional.topCenter,
              end: AlignmentDirectional.bottomCenter,
              colors: [
                Colors.transparent,
                context.colorScheme.surface.withValues(alpha: 0.95),
              ],
            ),
          ),
          child: backdropUrl != null
              ? CachedNetworkImage(
                  imageUrl: backdropUrl!,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => _backdropPlaceholder(context),
                  errorWidget: (_, _, _) => _backdropPlaceholder(context),
                )
              : _backdropPlaceholder(context),
        ),
        if (posterUrl != null)
          PositionedDirectional(
            start: Spacing.lg,
            bottom: 0,
            child: ClipRRect(
              borderRadius: BorderRadiusDirectional.all(
                Radius.circular(Spacing.cardRadiusMd),
              ),
              child: CachedNetworkImage(
                imageUrl: posterUrl!,
                width: 100,
                height: 150,
                fit: BoxFit.cover,
                placeholder: (_, _) => _posterShimmer(context),
                errorWidget: (_, _, _) => _posterError(context),
              ),
            ),
          ),
        PositionedDirectional(
          top: MediaQuery.of(context).padding.top + Spacing.xs,
          start: Spacing.xs,
          child: IconButton(
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            icon: Container(
              padding: EdgeInsetsDirectional.all(Spacing.xs),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    );
  }

  Widget _backdropPlaceholder(BuildContext context) {
    return Container(
      color: context.colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.movie_outlined,
        size: 64,
        color: context.colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _posterShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.colorScheme.surfaceContainerHighest,
      highlightColor: context.colorScheme.surface,
      child: Container(color: context.colorScheme.surfaceContainerHighest),
    );
  }

  Widget _posterError(BuildContext context) {
    return Container(
      color: context.colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.movie_outlined,
        color: context.colorScheme.onSurfaceVariant,
      ),
    );
  }
}

/// Backdrop + poster hero for desktop media detail layout.
class DesktopHero extends StatelessWidget {
  final String? backdropUrl;
  final String? posterUrl;

  const DesktopHero({super.key, this.backdropUrl, this.posterUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: AppConstants.backdropHeight + 40,
          width: double.infinity,
          foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(
              begin: AlignmentDirectional.topCenter,
              end: AlignmentDirectional.bottomCenter,
              colors: [
                Colors.transparent,
                context.colorScheme.surface.withValues(alpha: 0.95),
              ],
            ),
          ),
          child: backdropUrl != null
              ? CachedNetworkImage(
                  imageUrl: backdropUrl!,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => _backdropPlaceholder(context),
                  errorWidget: (_, _, _) => _backdropPlaceholder(context),
                )
              : _backdropPlaceholder(context),
        ),
        if (posterUrl != null)
          PositionedDirectional(
            start: Spacing.xxl,
            bottom: 0,
            child: ClipRRect(
              borderRadius: BorderRadiusDirectional.all(
                Radius.circular(Spacing.cardRadiusMd),
              ),
              child: CachedNetworkImage(
                imageUrl: posterUrl!,
                width: 130,
                height: 195,
                fit: BoxFit.cover,
                placeholder: (_, _) => _posterShimmer(context),
                errorWidget: (_, _, _) => _posterError(context),
              ),
            ),
          ),
        PositionedDirectional(
          top: MediaQuery.of(context).padding.top + Spacing.xs,
          start: Spacing.sm,
          child: IconButton(
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            icon: Container(
              padding: EdgeInsetsDirectional.all(Spacing.xs),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    );
  }

  Widget _backdropPlaceholder(BuildContext context) {
    return Container(
      color: context.colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.movie_outlined,
        size: 64,
        color: context.colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _posterShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.colorScheme.surfaceContainerHighest,
      highlightColor: context.colorScheme.surface,
      child: Container(color: context.colorScheme.surfaceContainerHighest),
    );
  }

  Widget _posterError(BuildContext context) {
    return Container(
      color: context.colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.movie_outlined,
        color: context.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
