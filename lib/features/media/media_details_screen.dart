import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/l10n.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/dimensions.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/extensions/number_extensions.dart';
import '../../core/models/media_enums.dart';
import '../../core/services/behavior_service.dart';
import '../../core/shared/app_modal.dart';
import '../../core/shared/expandable_text.dart';
import '../../models/media_model.dart';
import '../../models/review_model.dart';
import '../lists/providers/lists_providers.dart';
import '../lists/widgets/create_list_dialog.dart';
import '../tracking/providers/tracking_providers.dart';
import 'providers/media_providers.dart';
import 'widgets/cast_card.dart';
import 'widgets/media_stats.dart';
import 'widgets/review_card.dart';
import 'widgets/status_dropdown.dart';

class MediaDetailsScreen extends ConsumerStatefulWidget {
  final String mediaId;
  final String mediaType;

  const MediaDetailsScreen({
    super.key,
    required this.mediaId,
    this.mediaType = 'movie',
  });

  @override
  ConsumerState<MediaDetailsScreen> createState() => _MediaDetailsScreenState();
}

class _MediaDetailsScreenState extends ConsumerState<MediaDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final id = int.tryParse(widget.mediaId);
      ref.read(mediaIdProvider.notifier).state = id;
      ref.read(mediaTypeProvider.notifier).state = _parseMediaType(widget.mediaType);
      if (id != null) {
        BehaviorService.instance.trackMediaView(id);
      }
    });
  }

  MediaType _parseMediaType(String type) {
    switch (type) {
      case 'tv':
        return MediaType.tv;
      case 'anime':
        return MediaType.anime;
      default:
        return MediaType.movie;
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailsAsync = ref.watch(mediaDetailsProvider);
    final creditsAsync = ref.watch(mediaCreditsProvider);
    final recommendationsAsync = ref.watch(mediaRecommendationsProvider);
    final similarAsync = ref.watch(similarMediaProvider);
    final reviewsAsync = ref.watch(mediaReviewsProvider);
    final trailersAsync = ref.watch(mediaTrailersProvider);

    return Scaffold(
      body: detailsAsync.when(
        data: (media) => _buildContent(
          context,
          media,
          creditsAsync,
          recommendationsAsync,
          similarAsync,
          reviewsAsync,
          trailersAsync,
        ),
        loading: () => _buildLoading(),
        error: (_, _) => _buildError(),
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Layout Router
  // ──────────────────────────────────────────────

  Widget _buildContent(
    BuildContext context,
    MediaModel media,
    AsyncValue<Map<String, dynamic>> creditsAsync,
    AsyncValue<List> recommendationsAsync,
    AsyncValue<List> similarAsync,
    AsyncValue<List> reviewsAsync,
    AsyncValue<List<Map<String, dynamic>>> trailersAsync,
  ) {
    final isDesktop = context.isDesktop;
    final orientation = context.mediaQuery.orientation;

    if (isDesktop) {
      return _desktopLayout(
        media: media,
        creditsAsync: creditsAsync,
        recommendationsAsync: recommendationsAsync,
        similarAsync: similarAsync,
        reviewsAsync: reviewsAsync,
        trailersAsync: trailersAsync,
      );
    }

    if (orientation == Orientation.landscape) {
      return _landscapeLayout(
        media: media,
        creditsAsync: creditsAsync,
        recommendationsAsync: recommendationsAsync,
        similarAsync: similarAsync,
        reviewsAsync: reviewsAsync,
        trailersAsync: trailersAsync,
      );
    }

      return _portraitLayout(
      media: media,
      creditsAsync: creditsAsync,
      recommendationsAsync: recommendationsAsync,
      similarAsync: similarAsync,
      reviewsAsync: reviewsAsync,
      trailersAsync: trailersAsync,
    );
  }

  // ──────────────────────────────────────────────
  // Loading & Error States
  // ──────────────────────────────────────────────

  Widget _buildLoading() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: context.colorScheme.surfaceContainerHighest,
            highlightColor: context.colorScheme.surface,
            child: Container(
              height: AppConstants.backdropHeight,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.all(Spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Spacing.xl),
                _shimmerLine(width: 240, height: 24),
                SizedBox(height: Spacing.lg),
                _shimmerLine(width: double.infinity, height: 14),
                SizedBox(height: Spacing.sm),
                _shimmerLine(width: 320, height: 14),
                SizedBox(height: Spacing.xl),
                _shimmerLine(width: double.infinity, height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmerLine({double? width, double? height}) {
    return Shimmer.fromColors(
      baseColor: context.colorScheme.surfaceContainerHighest,
      highlightColor: context.colorScheme.surface,
      child: Container(
        height: height ?? 16,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusDirectional.all(Radius.circular(Spacing.cardRadiusSm)),
        ),
      ),
    );
  }

  Widget _buildError() {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: EdgeInsetsDirectional.all(Spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 64, color: context.colorScheme.error),
            SizedBox(height: Spacing.lg),
            Text(l10n.failedToLoadDetails, style: context.textTheme.bodyLarge),
            SizedBox(height: Spacing.lg),
            FilledButton.tonalIcon(
              onPressed: () => ref.invalidate(mediaDetailsProvider),
              icon: Icon(Icons.refresh_rounded),
              label: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Portrait Layout
  // ──────────────────────────────────────────────

  Widget _portraitLayout({
    required MediaModel media,
    required AsyncValue<Map<String, dynamic>> creditsAsync,
    required AsyncValue<List> recommendationsAsync,
    required AsyncValue<List> similarAsync,
    required AsyncValue<List> reviewsAsync,
    required AsyncValue<List<Map<String, dynamic>>> trailersAsync,
  }) {
    final backdropUrl = AppConstants.mediaImageUrl(media.backdropPath, size: 'w1280');
    final posterUrl = AppConstants.mediaImageUrl(media.posterPath, size: 'w342');

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PortraitHero(
            backdropUrl: backdropUrl,
            posterUrl: posterUrl,
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(Spacing.lg, 0, Spacing.lg, Spacing.section),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TitleBlock(media: media, hasPoster: media.posterPath != null),
                SizedBox(height: Spacing.md),
                _RatingRow(media: media),
                if (media.genres != null && media.genres!.isNotEmpty) ...[
                  SizedBox(height: Spacing.md),
                  _GenreChips(genres: media.genres!),
                ],
                SizedBox(height: Spacing.lg),
                _OverviewSection(media: media),
                SizedBox(height: Spacing.xl),
                _ActionButtons(media: media),
                SizedBox(height: Spacing.xl),
                _StatsCard(media: media),
                SizedBox(height: Spacing.lg),
                _ListEntrySection(media: media),
                SizedBox(height: Spacing.xxl),
                creditsAsync.when(
                  data: (credits) => _CastSection(credits: credits),
                  loading: () => SizedBox.shrink(),
                  error: (_, _) => SizedBox.shrink(),
                ),
                SizedBox(height: Spacing.xxl),
                creditsAsync.when(
                  data: (credits) => _CrewSection(credits: credits),
                  loading: () => SizedBox.shrink(),
                  error: (_, _) => SizedBox.shrink(),
                ),
                SizedBox(height: Spacing.xxl),
                trailersAsync.when(
                  data: (trailers) => _TrailersSection(trailers: trailers),
                  loading: () => SizedBox.shrink(),
                  error: (_, _) => SizedBox.shrink(),
                ),
                SizedBox(height: Spacing.xxl),
                recommendationsAsync.when(
                  data: (recs) => _MediaRowSection(title: context.l10n.recommendations, items: recs),
                  loading: () => SizedBox.shrink(),
                  error: (_, _) => SizedBox.shrink(),
                ),
                SizedBox(height: Spacing.xxl),
                similarAsync.when(
                  data: (similar) => _MediaRowSection(title: context.l10n.similar, items: similar),
                  loading: () => SizedBox.shrink(),
                  error: (_, _) => SizedBox.shrink(),
                ),
                SizedBox(height: Spacing.xxl),
                _ReviewsSection(reviewsAsync: reviewsAsync),
                SizedBox(height: Spacing.xxl),
                _ActivitySection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Landscape Layout
  // ──────────────────────────────────────────────

  Widget _landscapeLayout({
    required MediaModel media,
    required AsyncValue<Map<String, dynamic>> creditsAsync,
    required AsyncValue<List> recommendationsAsync,
    required AsyncValue<List> similarAsync,
    required AsyncValue<List> reviewsAsync,
    required AsyncValue<List<Map<String, dynamic>>> trailersAsync,
  }) {
    final screenWidth = context.screenWidth;
    final isCompact = screenWidth < 600;
    final posterUrl = AppConstants.mediaImageUrl(media.posterPath, size: 'w342');

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          top: context.mediaQuery.padding.top + Spacing.sm,
          bottom: Spacing.section,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: Spacing.sm),
              child: IconButton(
                icon: Icon(Icons.arrow_back_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: Spacing.lg),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (media.posterPath != null)
                    ClipRRect(
                      borderRadius: BorderRadiusDirectional.all(
                        Radius.circular(Spacing.cardRadiusMd),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: posterUrl!,
                        width: isCompact ? 90 : 120,
                        height: isCompact ? 135 : 180,
                        fit: BoxFit.cover,
                        placeholder: (_, _) => _posterPlaceholder(isCompact ? 90 : 120, isCompact ? 135 : 180),
                        errorWidget: (_, _, _) => _posterPlaceholder(isCompact ? 90 : 120, isCompact ? 135 : 180),
                      ),
                    ),
                  SizedBox(width: Spacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          media.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (media.originalTitle != null && media.originalTitle != media.title) ...[
                          SizedBox(height: Spacing.xs),
                          Text(
                            media.originalTitle!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                        SizedBox(height: Spacing.sm),
                        _RatingRow(media: media),
                        SizedBox(height: Spacing.sm),
                        if (media.genres != null && media.genres!.isNotEmpty)
                          _GenreChips(genres: media.genres!),
                        SizedBox(height: Spacing.md),
                        _ActionButtons(media: media),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Spacing.lg),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: Spacing.lg),
              child: _LibraryCard(media: media),
            ),
            SizedBox(height: Spacing.lg),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: Spacing.lg),
              child: _OverviewSection(media: media),
            ),
            SizedBox(height: Spacing.lg),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: Spacing.lg),
              child: _StatsCard(media: media),
            ),
            SizedBox(height: Spacing.lg),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: Spacing.lg),
              child: _ListEntrySection(media: media),
            ),
            SizedBox(height: Spacing.xl),
            creditsAsync.when(
              data: (credits) => _CastSection(credits: credits),
              loading: () => SizedBox.shrink(),
              error: (_, _) => SizedBox.shrink(),
            ),
            SizedBox(height: Spacing.xl),
            creditsAsync.when(
              data: (credits) => _CrewSection(credits: credits),
              loading: () => SizedBox.shrink(),
              error: (_, _) => SizedBox.shrink(),
            ),
            SizedBox(height: Spacing.xl),
            trailersAsync.when(
              data: (trailers) => _TrailersSection(trailers: trailers),
              loading: () => SizedBox.shrink(),
              error: (_, _) => SizedBox.shrink(),
            ),
            SizedBox(height: Spacing.xl),
            recommendationsAsync.when(
              data: (recs) => _MediaRowSection(title: context.l10n.recommendations, items: recs),
              loading: () => SizedBox.shrink(),
              error: (_, _) => SizedBox.shrink(),
            ),
            SizedBox(height: Spacing.xl),
            similarAsync.when(
              data: (similar) => _MediaRowSection(title: context.l10n.similar, items: similar),
              loading: () => SizedBox.shrink(),
              error: (_, _) => SizedBox.shrink(),
            ),
            SizedBox(height: Spacing.xl),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: Spacing.lg),
              child: _ReviewsSection(reviewsAsync: reviewsAsync),
            ),
            SizedBox(height: Spacing.xl),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: Spacing.lg),
              child: _ActivitySection(),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Desktop Layout
  // ──────────────────────────────────────────────

  Widget _desktopLayout({
    required MediaModel media,
    required AsyncValue<Map<String, dynamic>> creditsAsync,
    required AsyncValue<List> recommendationsAsync,
    required AsyncValue<List> similarAsync,
    required AsyncValue<List> reviewsAsync,
    required AsyncValue<List<Map<String, dynamic>>> trailersAsync,
  }) {
    final backdropUrl = AppConstants.mediaImageUrl(media.backdropPath, size: 'w1280');
    final posterUrl = AppConstants.mediaImageUrl(media.posterPath, size: 'w342');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DesktopHero(
                  backdropUrl: backdropUrl,
                  posterUrl: posterUrl,
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(Spacing.xxl, 0, Spacing.xxl, Spacing.section),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _TitleBlock(media: media, hasPoster: media.posterPath != null),
                      SizedBox(height: Spacing.md),
                      _RatingRow(media: media),
                      if (media.genres != null && media.genres!.isNotEmpty) ...[
                        SizedBox(height: Spacing.md),
                        _GenreChips(genres: media.genres!),
                      ],
                SizedBox(height: Spacing.lg),
                _ActionButtons(media: media),
                SizedBox(height: Spacing.xl),
                _LibraryCard(media: media),
                SizedBox(height: Spacing.xl),
                _StatsCard(media: media),
                      SizedBox(height: Spacing.lg),
                      _ListEntrySection(media: media),
                      SizedBox(height: Spacing.xxl),
                      creditsAsync.when(
                        data: (credits) => _CastSection(credits: credits),
                        loading: () => SizedBox.shrink(),
                        error: (_, _) => SizedBox.shrink(),
                      ),
                      SizedBox(height: Spacing.xxl),
                      creditsAsync.when(
                        data: (credits) => _CrewSection(credits: credits),
                        loading: () => SizedBox.shrink(),
                        error: (_, _) => SizedBox.shrink(),
                      ),
                      SizedBox(height: Spacing.xxl),
                      trailersAsync.when(
                        data: (trailers) => _TrailersSection(trailers: trailers),
                        loading: () => SizedBox.shrink(),
                        error: (_, _) => SizedBox.shrink(),
                      ),
                      SizedBox(height: Spacing.xxl),
                      recommendationsAsync.when(
                        data: (recs) => _MediaRowSection(title: context.l10n.recommendations, items: recs),
                        loading: () => SizedBox.shrink(),
                        error: (_, _) => SizedBox.shrink(),
                      ),
                      SizedBox(height: Spacing.xxl),
                      similarAsync.when(
                        data: (similar) => _MediaRowSection(title: context.l10n.similar, items: similar),
                        loading: () => SizedBox.shrink(),
                        error: (_, _) => SizedBox.shrink(),
                      ),
                      SizedBox(height: Spacing.xxl),
                      _ReviewsSection(reviewsAsync: reviewsAsync),
                      SizedBox(height: Spacing.xxl),
                      _ActivitySection(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 320,
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.only(
              top: Spacing.lg,
              bottom: Spacing.section,
            ),
            child: _SidePanel(media: media),
          ),
        ),
      ],
    );
  }

  // ──────────────────────────────────────────────
  // Shared UI Components
  // ──────────────────────────────────────────────

  Widget _posterPlaceholder(double width, double height) {
    return Container(
      width: width,
      height: height,
      color: context.colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.movie_outlined,
        size: 32,
        color: context.colorScheme.onSurfaceVariant,
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Hero Section (Portrait)
// ──────────────────────────────────────────────

class _PortraitHero extends StatelessWidget {
  final String? backdropUrl;
  final String? posterUrl;

  const _PortraitHero({this.backdropUrl, this.posterUrl});

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
            icon: Container(
              padding: EdgeInsetsDirectional.all(Spacing.xs),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
              ),
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
      child: Container(color: Colors.white),
    );
  }

  Widget _posterError(BuildContext context) {
    return Container(
      color: context.colorScheme.surfaceContainerHighest,
      child: Icon(Icons.movie_outlined, color: context.colorScheme.onSurfaceVariant),
    );
  }
}

// ──────────────────────────────────────────────
// Hero Section (Desktop)
// ──────────────────────────────────────────────

class _DesktopHero extends StatelessWidget {
  final String? backdropUrl;
  final String? posterUrl;

  const _DesktopHero({this.backdropUrl, this.posterUrl});

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
            icon: Container(
              padding: EdgeInsetsDirectional.all(Spacing.xs),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
              ),
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
      child: Container(color: Colors.white),
    );
  }

  Widget _posterError(BuildContext context) {
    return Container(
      color: context.colorScheme.surfaceContainerHighest,
      child: Icon(Icons.movie_outlined, color: context.colorScheme.onSurfaceVariant),
    );
  }
}

// ──────────────────────────────────────────────
// Title Block
// ──────────────────────────────────────────────

class _TitleBlock extends StatelessWidget {
  final MediaModel media;
  final bool hasPoster;

  const _TitleBlock({required this.media, required this.hasPoster});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: Spacing.lg, start: hasPoster ? 116 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            media.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (media.originalTitle != null && media.originalTitle != media.title)
            Padding(
              padding: EdgeInsetsDirectional.only(top: Spacing.xs),
              child: Text(
                media.originalTitle!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Rating Row
// ──────────────────────────────────────────────

class _RatingRow extends StatelessWidget {
  final MediaModel media;

  const _RatingRow({required this.media});

  @override
  Widget build(BuildContext context) {
    if (media.voteAverage == null) return SizedBox.shrink();
    final percentage = (media.voteAverage! / 10 * 100).toPercentage();

    return Row(
      children: [
        ...List.generate(5, (i) {
          final filled = media.voteAverage! / 2 >= i + 1;
          final half = !filled && media.voteAverage! / 2 >= i + 0.5;
          return Icon(
            filled
                ? Icons.star_rounded
                : half
                    ? Icons.star_half_rounded
                    : Icons.star_outline_rounded,
            color: Colors.amber,
            size: 22,
          );
        }),
        SizedBox(width: Spacing.sm),
        Container(
          padding: EdgeInsetsDirectional.symmetric(horizontal: Spacing.sm, vertical: 2),
          decoration: BoxDecoration(
            color: context.colorScheme.secondaryContainer,
            borderRadius: BorderRadiusDirectional.all(Radius.circular(Spacing.chipRadius)),
          ),
          child: Text(
            percentage,
            style: context.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: context.colorScheme.onSecondaryContainer,
            ),
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────
// Genre Chips
// ──────────────────────────────────────────────

class _GenreChips extends StatelessWidget {
  final List<String> genres;

  const _GenreChips({required this.genres});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Spacing.sm,
      runSpacing: Spacing.xs,
      children: genres.map((genre) {
        return Chip(
          label: Text(genre, style: context.textTheme.labelSmall),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          padding: EdgeInsetsDirectional.zero,
          labelPadding: EdgeInsetsDirectional.symmetric(horizontal: Spacing.sm),
        );
      }).toList(),
    );
  }
}

// ──────────────────────────────────────────────
// Overview Section
// ──────────────────────────────────────────────

class _OverviewSection extends StatelessWidget {
  final MediaModel media;

  const _OverviewSection({required this.media});

  @override
  Widget build(BuildContext context) {
    if (media.overview == null || media.overview!.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: context.l10n.overview),
        SizedBox(height: Spacing.sm),
        ExpandableText(
          text: media.overview!,
          style: context.textTheme.bodyMedium?.copyWith(height: 1.6),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────
// Action Buttons
// ──────────────────────────────────────────────

class _ActionButtons extends ConsumerWidget {
  final MediaModel media;

  const _ActionButtons({required this.media});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMediaList = ref.watch(userMediaProvider).valueOrNull ?? [];
    final currentUserMedia = userMediaList.where((m) => m.mediaId == media.id).firstOrNull;
    final currentStatus = currentUserMedia?.status ?? WatchStatus.planToWatch;

    return Row(
      children: [
        Expanded(
          child: StatusDropdown(
            currentStatus: currentStatus,
            onChanged: (status) {
              final notifier = ref.read(userMediaProvider.notifier);
              if (currentUserMedia != null) {
                notifier.updateStatus(currentUserMedia, status);
              } else {
                notifier.addMedia(
                  mediaId: media.id,
                  mediaType: media.mediaType,
                  status: status,
                );
                BehaviorService.instance.trackMediaSave(media.id);
              }
              if (status == WatchStatus.completed) {
                BehaviorService.instance.trackMediaComplete(media.id);
              }
            },
          ),
        ),
        SizedBox(width: Spacing.md),
        OutlinedButton.icon(
          onPressed: () => _showAddToListSheet(context, ref, media),
          icon: Icon(Icons.playlist_add_rounded, size: 20),
          label: Text(context.l10n.navLists),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: Spacing.lg,
              vertical: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.all(Radius.circular(Spacing.cardRadiusMd)),
            ),
          ),
        ),
      ],
    );
  }

  void _showAddToListSheet(BuildContext context, WidgetRef ref, MediaModel media) {
    final l10n = context.l10n;
    final content = Consumer(builder: (context, ref, _) {
      final listsAsync = ref.watch(userListsProvider);
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          listsAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(Spacing.xl),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (_, _) => Center(
              child: Padding(
                padding: EdgeInsets.all(Spacing.xl),
                child: Text(l10n.failedToLoadList),
              ),
            ),
            data: (lists) {
              if (lists.isEmpty) {
                return Padding(
                  padding: EdgeInsets.all(Spacing.xl),
                  child: Center(child: Text(l10n.noListsYet)),
                );
              }
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  children: [
                    ...lists.map((list) => ListTile(
                      leading: Icon(
                        list.isPinned ? Icons.push_pin_rounded : Icons.folder_rounded,
                      ),
                      title: Text(
                        list.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(l10n.itemCount(list.itemCount)),
                      onTap: () {
                        ref.read(userListsProvider.notifier).addItemToList(list.id, media);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.addedToTitle(list.title)),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    )),
                  ],
                ),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.add_rounded),
            title: Text(l10n.createNewList),
            onTap: () async {
              final created = await showDialog<bool>(
                context: context,
                builder: (dialogContext) => const CreateListDialog(),
              );
              if (created == true && context.mounted) {
                final updatedLists = ref.read(userListsProvider).valueOrNull ?? [];
                final newList = updatedLists.isNotEmpty ? updatedLists.first : null;
                if (newList != null) {
                  ref.read(userListsProvider.notifier).addItemToList(newList.id, media);
                }
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(newList != null ? l10n.addedToTitle(newList.title) : l10n.listCreated),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
        ],
      );
    });

    AppDialog.show(
      context: context,
      title: l10n.addToList,
      content: content,
    );
  }
}

// ──────────────────────────────────────────────
// Stats Card
// ──────────────────────────────────────────────

class _StatsCard extends StatelessWidget {
  final MediaModel media;

  const _StatsCard({required this.media});

  @override
  Widget build(BuildContext context) {
    return MediaStats(
      runtime: media.runtime,
      releaseDate: media.releaseDate,
      countries: media.countries,
      language: media.language,
    );
  }
}

// ──────────────────────────────────────────────
// List Entry Section
// ──────────────────────────────────────────────

class _ListEntrySection extends ConsumerWidget {
  final MediaModel media;

  const _ListEntrySection({required this.media});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final userMediaList = ref.watch(userMediaProvider).valueOrNull ?? [];
    final entry = userMediaList.where((m) => m.mediaId == media.id).firstOrNull;
    if (entry == null) return SizedBox.shrink();

    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(Spacing.lg),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadiusDirectional.all(Radius.circular(Spacing.cardRadiusMd)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.list_alt_rounded, size: 18, color: context.colorScheme.primary),
              SizedBox(width: Spacing.sm),
              Text(
                context.l10n.inYourLibrary,
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: Spacing.md),
          _entryRow(context, l10n.status, _statusLabel(context, entry.status)),
          if (entry.userRating != null)
            _entryRow(context, l10n.ratings, '${entry.userRating!.toStringAsFixed(1)} / 10'),
          if (entry.episodeProgress > 0 && entry.totalEpisodes > 0)
            _entryRow(context, l10n.progress, '${entry.episodeProgress} / ${entry.totalEpisodes} episodes'),
          if (entry.createdAt != null)
            _entryRow(context, context.l10n.addedLabel, '${months[entry.createdAt!.month - 1]} ${entry.createdAt!.day}, ${entry.createdAt!.year}'),
          if (entry.updatedAt != null)
            _entryRow(context, context.l10n.updatedLabel, '${months[entry.updatedAt!.month - 1]} ${entry.updatedAt!.day}, ${entry.updatedAt!.year}'),
        ],
      ),
    );
  }

  Widget _entryRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: Spacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: context.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _statusLabel(BuildContext context, WatchStatus status) {
    final l10n = context.l10n;
    switch (status) {
      case WatchStatus.watching:
        return l10n.watching;
      case WatchStatus.completed:
        return l10n.completed;
      case WatchStatus.onHold:
        return l10n.onHold;
      case WatchStatus.dropped:
        return l10n.dropped;
      case WatchStatus.planToWatch:
        return l10n.planToWatch;
      case WatchStatus.rewatching:
        return l10n.rewatching;
    }
  }
}

// ──────────────────────────────────────────────
// Library Card
// ──────────────────────────────────────────────

class _LibraryCard extends ConsumerWidget {
  final MediaModel media;

  const _LibraryCard({required this.media});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membershipAsync = ref.watch(mediaListMembershipProvider(media.id));
    final userMediaList = ref.watch(userMediaProvider).valueOrNull ?? [];
    final trackingEntry = userMediaList.where((m) => m.mediaId == media.id).firstOrNull;

    return membershipAsync.when(
      data: (lists) {
        if (lists.isEmpty) return SizedBox.shrink();
        return Container(
          width: double.infinity,
          padding: EdgeInsetsDirectional.all(Spacing.lg),
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadiusDirectional.all(Radius.circular(Spacing.cardRadiusMd)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.bookmark_rounded, size: 18, color: context.colorScheme.primary),
                  SizedBox(width: Spacing.sm),
                  Text(
                    context.l10n.inYourList, style: context.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: Spacing.md),
              ...lists.map((list) => _listEntry(context, list, trackingEntry)),
            ],
          ),
        );
      },
      loading: () => SizedBox.shrink(),
      error: (_, _) => SizedBox.shrink(),
    );
  }

  Widget _listEntry(BuildContext context, Map<String, dynamic> list, dynamic trackingEntry) {
    final title = list['list_title'] as String? ?? 'Unknown List';
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    String? addedLabel;
    final addedAt = list['added_at'] as String?;
    if (addedAt != null) {
      try {
        final dt = DateTime.parse(addedAt);
        addedLabel = '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
      } catch (_) {}
    }

    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: Spacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: Spacing.xs),
          Row(
            children: [
              Icon(Icons.circle, size: 6, color: context.colorScheme.onSurfaceVariant),
              SizedBox(width: Spacing.xs),
              Text(
                trackingEntry != null ? _statusLabel(context, trackingEntry.status) : context.l10n.notTracked,
                style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.onSurfaceVariant),
              ),
              if (addedLabel != null) ...[
                SizedBox(width: Spacing.md),
                Icon(Icons.circle, size: 6, color: context.colorScheme.onSurfaceVariant),
                SizedBox(width: Spacing.xs),
                Text(
                  '${context.l10n.updatedLabel}: $addedLabel', style: context.textTheme.labelSmall?.copyWith(color: context.colorScheme.onSurfaceVariant),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _statusLabel(BuildContext context, WatchStatus status) {
    final l10n = context.l10n;
    switch (status) {
      case WatchStatus.watching: return l10n.watching;
      case WatchStatus.completed: return l10n.completed;
      case WatchStatus.onHold: return l10n.onHold;
      case WatchStatus.dropped: return l10n.dropped;
      case WatchStatus.planToWatch: return l10n.planToWatch;
      case WatchStatus.rewatching: return l10n.rewatching;
    }
  }
}

// ──────────────────────────────────────────────
// Section Header
// ──────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: context.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Cast Section
// ──────────────────────────────────────────────

class _CastSection extends StatelessWidget {
  final Map<String, dynamic> credits;

  const _CastSection({required this.credits});

  @override
  Widget build(BuildContext context) {
    final cast = credits['cast'] as List<dynamic>? ?? [];
    if (cast.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: Spacing.lg),
          child: _SectionHeader(title: context.l10n.cast),
        ),
        SizedBox(height: Spacing.md),
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsetsDirectional.symmetric(horizontal: Spacing.lg),
            itemCount: cast.length,
            separatorBuilder: (_, _) => SizedBox(width: Spacing.md),
            itemBuilder: (context, index) {
              final person = cast[index] as Map<String, dynamic>;
              return CastCard(
                name: person['name'] as String? ?? '',
                character: person['character'] as String?,
                profilePath: person['profile_path'] as String?,
              );
            },
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────
// Crew Section
// ──────────────────────────────────────────────

class _CrewSection extends StatelessWidget {
  final Map<String, dynamic> credits;

  const _CrewSection({required this.credits});

  @override
  Widget build(BuildContext context) {
    final crew = credits['crew'] as List<dynamic>? ?? [];
    if (crew.isEmpty) return SizedBox.shrink();

    final keyRoles = crew
        .where((c) => ['Director', 'Producer', 'Writer', 'Screenplay'].contains(c['job'] as String?))
        .take(6)
        .toList();
    if (keyRoles.isEmpty) return SizedBox.shrink();

    return Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: context.l10n.crew),
          SizedBox(height: Spacing.md),
          ...keyRoles.map((person) {
            return Padding(
              padding: EdgeInsetsDirectional.only(bottom: Spacing.sm),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: context.colorScheme.surfaceContainerHighest,
                    backgroundImage: person['profile_path'] != null
                        ? CachedNetworkImageProvider(
                            '${AppConstants.tmdbImageBaseUrl}/w185${person['profile_path']}',
                          )
                        : null,
                    child: person['profile_path'] == null
                        ? Icon(Icons.person_rounded, color: context.colorScheme.onSurfaceVariant)
                        : null,
                  ),
                  SizedBox(width: Spacing.md),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        person['name'] as String? ?? '',
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        person['job'] as String? ?? '',
                        style: context.textTheme.labelSmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Trailers Section
// ──────────────────────────────────────────────

class _TrailersSection extends StatelessWidget {
  final List<Map<String, dynamic>> trailers;

  const _TrailersSection({required this.trailers});

  @override
  Widget build(BuildContext context) {
    if (trailers.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: Spacing.lg),
          child: _SectionHeader(title: context.l10n.trailers),
        ),
        SizedBox(height: Spacing.md),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsetsDirectional.symmetric(horizontal: Spacing.lg),
            itemCount: trailers.length,
            separatorBuilder: (_, _) => SizedBox(width: Spacing.md),
            itemBuilder: ((context, index) {
              final trailer = trailers[index];
              final key = trailer['key'] as String? ?? '';
              return GestureDetector(
                onTap: () => launchUrl(Uri.parse('https://www.youtube.com/watch?v=$key')),
                child: Container(
                  width: 320,
                  decoration: BoxDecoration(
                    color: context.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadiusDirectional.all(
                      Radius.circular(Spacing.cardRadiusMd),
                    ),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        'https://img.youtube.com/vi/$key/maxresdefault.jpg',
                      ),
                      fit: BoxFit.cover,
                      onError: (_, _) {},
                    ),
                  ),
                  child: Center(
                    child: Container(
                      padding: EdgeInsetsDirectional.all(Spacing.lg),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────
// Media Row Section (Recommendations / Similar)
// ──────────────────────────────────────────────

class _MediaRowSection extends StatelessWidget {
  final String title;
  final List items;

  const _MediaRowSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: Spacing.lg),
          child: _SectionHeader(title: title),
        ),
        SizedBox(height: Spacing.md),
        SizedBox(
          height: 210,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsetsDirectional.symmetric(horizontal: Spacing.lg),
            itemCount: items.length,
            separatorBuilder: (_, _) => SizedBox(width: Spacing.sm),
            itemBuilder: (context, index) {
              final item = items[index] as MediaModel;
              final mediaTypeStr = item.mediaType == MediaType.tv ? 'tv' : 'movie';
              return SizedBox(
                width: AppConstants.posterWidth,
                child: GestureDetector(
                  onTap: () => context.navigateToMedia(mediaTypeStr, item.id.toString()),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadiusDirectional.all(
                            Radius.circular(Spacing.cardRadiusSm),
                          ),
                          child: item.posterPath != null
                              ? CachedNetworkImage(
                                  imageUrl: '${AppConstants.tmdbImageBaseUrl}/w342${item.posterPath}',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  placeholder: (_, _) => _itemPlaceholder(context),
                                  errorWidget: (_, _, _) => _itemPlaceholder(context),
                                )
                              : _itemPlaceholder(context),
                        ),
                      ),
                      SizedBox(height: Spacing.xs),
                      Text(
                        item.title,
                        style: context.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _itemPlaceholder(BuildContext context) {
    return Container(
      color: context.colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.movie_outlined,
        size: 32,
        color: context.colorScheme.onSurfaceVariant,
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Reviews Section
// ──────────────────────────────────────────────

class _ReviewsSection extends ConsumerWidget {
  final AsyncValue<List> reviewsAsync;

  const _ReviewsSection({required this.reviewsAsync});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _SectionHeader(title: context.l10n.reviews),
            Spacer(),
            TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.edit_rounded, size: 18),
              label: Text(context.l10n.writeReview),
            ),
          ],
        ),
        SizedBox(height: Spacing.md),
        reviewsAsync.when(
          data: (reviews) {
            if (reviews.isEmpty) {
              return Container(
                width: double.infinity,
                padding: EdgeInsetsDirectional.all(Spacing.xxl),
                decoration: BoxDecoration(
                  color: context.colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadiusDirectional.all(Radius.circular(Spacing.cardRadiusMd)),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.rate_review_outlined,
                      size: 48,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(height: Spacing.md),
                    Text(
                      context.l10n.noReviewsYet,
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final rev = reviews[index] as ReviewModel;
                return ReviewCard(review: rev, authorName: rev.userId);
              },
            );
          },
          loading: () => Center(
            child: Padding(
              padding: EdgeInsetsDirectional.all(Spacing.xl),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (_, _) => Padding(
            padding: EdgeInsetsDirectional.all(Spacing.xl),
            child: Center(
              child: Text(
                context.l10n.failedToLoadReviews,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.error,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────
// Activity Section
// ──────────────────────────────────────────────

class _ActivitySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: context.l10n.activity),
        SizedBox(height: Spacing.md),
        Container(
          width: double.infinity,
          padding: EdgeInsetsDirectional.all(Spacing.xl),
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadiusDirectional.all(Radius.circular(Spacing.cardRadiusMd)),
          ),
          child: Column(
            children: [
              Icon(
                Icons.timeline_rounded,
                size: 36,
                color: context.colorScheme.onSurfaceVariant,
              ),
              SizedBox(height: Spacing.sm),
              Text(
                context.l10n.noRecentActivity,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────
// Side Panel (Desktop)
// ──────────────────────────────────────────────

class _SidePanel extends ConsumerWidget {
  final MediaModel media;

  const _SidePanel({required this.media});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMediaList = ref.watch(userMediaProvider).valueOrNull ?? [];
    final currentUserMedia = userMediaList.where((m) => m.mediaId == media.id).firstOrNull;
    final currentStatus = currentUserMedia?.status ?? WatchStatus.planToWatch;

    return Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StatusDropdown(
            currentStatus: currentStatus,
            onChanged: (status) {
              final notifier = ref.read(userMediaProvider.notifier);
              if (currentUserMedia != null) {
                notifier.updateStatus(currentUserMedia, status);
              } else {
                notifier.addMedia(
                  mediaId: media.id,
                  mediaType: media.mediaType,
                  status: status,
                );
                BehaviorService.instance.trackMediaSave(media.id);
              }
              if (status == WatchStatus.completed) {
                BehaviorService.instance.trackMediaComplete(media.id);
              }
            },
          ),
          SizedBox(height: Spacing.lg),
          OutlinedButton.icon(
            onPressed: () => _showAddToListSheet(context, ref, media),
            icon: Icon(Icons.playlist_add_rounded),
            label: Text(context.l10n.addToList),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsetsDirectional.symmetric(vertical: Spacing.md),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.all(Radius.circular(Spacing.cardRadiusMd)),
              ),
            ),
          ),
          SizedBox(height: Spacing.lg),
          _LibraryCard(media: media),
          SizedBox(height: Spacing.xl),
          _SidePanelStats(media: media),
        ],
      ),
    );
  }

  void _showAddToListSheet(BuildContext context, WidgetRef ref, MediaModel media) {
    final l10n = context.l10n;
    final content = Consumer(builder: (context, ref, _) {
      final listsAsync = ref.watch(userListsProvider);
      final l10n = context.l10n;
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          listsAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(Spacing.xl),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (_, _) => Center(
              child: Padding(
                padding: EdgeInsets.all(Spacing.xl),
                child: Text(l10n.failedToLoadList),
              ),
            ),
            data: (lists) {
              if (lists.isEmpty) {
                return Padding(
                  padding: EdgeInsets.all(Spacing.xl),
                  child: Center(child: Text(l10n.noListsYet)),
                );
              }
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  children: [
                    ...lists.map((list) => ListTile(
                      leading: Icon(
                        list.isPinned ? Icons.push_pin_rounded : Icons.folder_rounded,
                      ),
                      title: Text(
                        list.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(l10n.itemCount(list.itemCount)),
                      onTap: () {
                        ref.read(userListsProvider.notifier).addItemToList(list.id, media);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.addedToTitle(list.title)),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    )),
                  ],
                ),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.add_rounded),
            title: Text(l10n.createNewList),
            onTap: () async {
              final created = await showDialog<bool>(
                context: context,
                builder: (dialogContext) => const CreateListDialog(),
              );
              if (created == true && context.mounted) {
                final updatedLists = ref.read(userListsProvider).valueOrNull ?? [];
                final newList = updatedLists.isNotEmpty ? updatedLists.first : null;
                if (newList != null) {
                  ref.read(userListsProvider.notifier).addItemToList(newList.id, media);
                }
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(newList != null ? l10n.addedToTitle(newList.title) : l10n.listCreated),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
        ],
      );
    });

    AppDialog.show(
      context: context,
      title: l10n.addToList,
      content: content,
    );
  }
}

// ──────────────────────────────────────────────
// Side Panel Stats
// ──────────────────────────────────────────────

class _SidePanelStats extends StatelessWidget {
  final MediaModel media;

  const _SidePanelStats({required this.media});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final stats = <Map<String, String>>[];

    if (media.runtime != null) {
      stats.add({'label': l10n.runtime, 'value': media.runtime!.toRuntimeString()});
    }
    if (media.releaseDate != null) {
      stats.add({
        'label': l10n.releaseDate,
        'value': '${media.releaseDate!.year}-${media.releaseDate!.month.toString().padLeft(2, '0')}-${media.releaseDate!.day.toString().padLeft(2, '0')}',
      });
    }
    if (media.countries != null && media.countries!.isNotEmpty) {
      stats.add({'label': l10n.country, 'value': media.countries!.join(', ')});
    }
    if (media.language != null) {
      stats.add({'label': l10n.language, 'value': media.language!});
    }
    if (media.status != null) {
      stats.add({'label': l10n.status, 'value': media.status!});
    }

    if (stats.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.detailsLabel,
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: Spacing.md),
        ...stats.map((stat) => Padding(
          padding: EdgeInsetsDirectional.only(bottom: Spacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stat['label']!,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(width: Spacing.sm),
              Expanded(
                child: Text(
                  stat['value']!,
                  textAlign: TextAlign.end,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}
