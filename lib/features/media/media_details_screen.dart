import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../../l10n/l10n.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/dimensions.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/models/media_enums.dart';
import '../../core/providers/app_providers.dart';
import '../../models/media_model.dart';
import 'providers/media_providers.dart';
import 'widgets/action_buttons.dart';
import 'widgets/activity_section.dart';
import 'widgets/cast_section.dart';
import 'widgets/crew_section.dart';
import 'widgets/genre_chips.dart';
import 'widgets/hero_widgets.dart';
import 'widgets/library_card.dart';
import 'widgets/list_entry_section.dart';
import 'widgets/media_row_section.dart';
import 'widgets/overview_section.dart';
import 'widgets/rating_row.dart';
import 'widgets/reviews_section.dart';
import 'widgets/side_panel.dart';
import 'widgets/stats_card.dart';
import 'widgets/title_block.dart';
import 'widgets/trailers_section.dart';

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
      ref.read(mediaIdProvider.notifier).update(id);
      ref
          .read(mediaTypeProvider.notifier)
          .update(_parseMediaType(widget.mediaType));
      if (id != null) {
        ref.read(behaviorServiceProvider).trackMediaView(id);
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

  Widget _buildLoading() {
    return ExcludeSemantics(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Shimmer.fromColors(
              baseColor: context.colorScheme.surfaceContainerHighest,
              highlightColor: context.colorScheme.surface,
              child: Container(
                height: AppConstants.backdropHeight,
                color: context.colorScheme.surfaceContainerHighest,
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
          color: context.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadiusDirectional.all(
            Radius.circular(Spacing.cardRadiusSm),
          ),
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
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: context.colorScheme.error,
            ),
            SizedBox(height: Spacing.lg),
            Text(l10n.failedToLoadDetails, style: context.textTheme.bodyLarge),
            SizedBox(height: Spacing.lg),
            FilledButton.tonalIcon(
              onPressed: () => ref.invalidate(mediaDetailsProvider),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _portraitLayout({
    required MediaModel media,
    required AsyncValue<Map<String, dynamic>> creditsAsync,
    required AsyncValue<List> recommendationsAsync,
    required AsyncValue<List> similarAsync,
    required AsyncValue<List> reviewsAsync,
    required AsyncValue<List<Map<String, dynamic>>> trailersAsync,
  }) {
    final backdropUrl = AppConstants.mediaImageUrl(
      media.backdropPath,
      size: 'w1280',
    );
    final posterUrl = AppConstants.mediaImageUrl(
      media.posterPath,
      size: 'w342',
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PortraitHero(backdropUrl: backdropUrl, posterUrl: posterUrl),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
              Spacing.lg,
              0,
              Spacing.lg,
              Spacing.section,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleBlock(media: media, hasPoster: media.posterPath != null),
                SizedBox(height: Spacing.md),
                RatingRow(media: media),
                if (media.genres != null && media.genres!.isNotEmpty) ...[
                  SizedBox(height: Spacing.md),
                  GenreChips(genres: media.genres!),
                ],
                SizedBox(height: Spacing.lg),
                OverviewSection(media: media),
                SizedBox(height: Spacing.xl),
                ActionButtons(media: media),
                SizedBox(height: Spacing.xl),
                StatsCard(media: media),
                SizedBox(height: Spacing.lg),
                ListEntrySection(media: media),
                SizedBox(height: Spacing.xxl),
                creditsAsync.when(
                  data: (credits) => CastSection(credits: credits),
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
                SizedBox(height: Spacing.xxl),
                creditsAsync.when(
                  data: (credits) => CrewSection(credits: credits),
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
                SizedBox(height: Spacing.xxl),
                trailersAsync.when(
                  data: (trailers) => TrailersSection(trailers: trailers),
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
                SizedBox(height: Spacing.xxl),
                recommendationsAsync.when(
                  data: (recs) => MediaRowSection(
                    title: context.l10n.recommendations,
                    items: recs,
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
                SizedBox(height: Spacing.xxl),
                similarAsync.when(
                  data: (similar) => MediaRowSection(
                    title: context.l10n.similar,
                    items: similar,
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
                SizedBox(height: Spacing.xxl),
                ReviewsSection(reviewsAsync: reviewsAsync),
                SizedBox(height: Spacing.xxl),
                const ActivitySection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
                icon: const Icon(Icons.arrow_back_rounded),
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
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
                      child: Image.network(
                        AppConstants.mediaImageUrl(
                          media.posterPath,
                          size: 'w342',
                        )!,
                        width: isCompact ? 90 : 120,
                        height: isCompact ? 135 : 180,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _posterPlaceholder(
                          isCompact ? 90 : 120,
                          isCompact ? 135 : 180,
                        ),
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
                        if (media.originalTitle != null &&
                            media.originalTitle != media.title) ...[
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
                        RatingRow(media: media),
                        SizedBox(height: Spacing.sm),
                        if (media.genres != null && media.genres!.isNotEmpty)
                          GenreChips(genres: media.genres!),
                        SizedBox(height: Spacing.md),
                        ActionButtons(media: media),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Spacing.lg),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: Spacing.lg),
              child: LibraryCard(media: media),
            ),
            SizedBox(height: Spacing.lg),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: Spacing.lg),
              child: OverviewSection(media: media),
            ),
            SizedBox(height: Spacing.lg),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: Spacing.lg),
              child: StatsCard(media: media),
            ),
            SizedBox(height: Spacing.lg),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: Spacing.lg),
              child: ListEntrySection(media: media),
            ),
            SizedBox(height: Spacing.xl),
            creditsAsync.when(
              data: (credits) => CastSection(credits: credits),
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
            SizedBox(height: Spacing.xl),
            creditsAsync.when(
              data: (credits) => CrewSection(credits: credits),
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
            SizedBox(height: Spacing.xl),
            trailersAsync.when(
              data: (trailers) => TrailersSection(trailers: trailers),
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
            SizedBox(height: Spacing.xl),
            recommendationsAsync.when(
              data: (recs) => MediaRowSection(
                title: context.l10n.recommendations,
                items: recs,
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
            SizedBox(height: Spacing.xl),
            similarAsync.when(
              data: (similar) =>
                  MediaRowSection(title: context.l10n.similar, items: similar),
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
            SizedBox(height: Spacing.xl),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: Spacing.lg),
              child: ReviewsSection(reviewsAsync: reviewsAsync),
            ),
            SizedBox(height: Spacing.xl),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: Spacing.lg),
              child: const ActivitySection(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _desktopLayout({
    required MediaModel media,
    required AsyncValue<Map<String, dynamic>> creditsAsync,
    required AsyncValue<List> recommendationsAsync,
    required AsyncValue<List> similarAsync,
    required AsyncValue<List> reviewsAsync,
    required AsyncValue<List<Map<String, dynamic>>> trailersAsync,
  }) {
    final backdropUrl = AppConstants.mediaImageUrl(
      media.backdropPath,
      size: 'w1280',
    );
    final posterUrl = AppConstants.mediaImageUrl(
      media.posterPath,
      size: 'w342',
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DesktopHero(backdropUrl: backdropUrl, posterUrl: posterUrl),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    Spacing.xxl,
                    0,
                    Spacing.xxl,
                    Spacing.section,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleBlock(
                        media: media,
                        hasPoster: media.posterPath != null,
                      ),
                      SizedBox(height: Spacing.md),
                      RatingRow(media: media),
                      if (media.genres != null && media.genres!.isNotEmpty) ...[
                        SizedBox(height: Spacing.md),
                        GenreChips(genres: media.genres!),
                      ],
                      SizedBox(height: Spacing.lg),
                      ActionButtons(media: media),
                      SizedBox(height: Spacing.xl),
                      LibraryCard(media: media),
                      SizedBox(height: Spacing.xl),
                      StatsCard(media: media),
                      SizedBox(height: Spacing.lg),
                      ListEntrySection(media: media),
                      SizedBox(height: Spacing.xxl),
                      creditsAsync.when(
                        data: (credits) => CastSection(credits: credits),
                        loading: () => const SizedBox.shrink(),
                        error: (_, _) => const SizedBox.shrink(),
                      ),
                      SizedBox(height: Spacing.xxl),
                      creditsAsync.when(
                        data: (credits) => CrewSection(credits: credits),
                        loading: () => const SizedBox.shrink(),
                        error: (_, _) => const SizedBox.shrink(),
                      ),
                      SizedBox(height: Spacing.xxl),
                      trailersAsync.when(
                        data: (trailers) => TrailersSection(trailers: trailers),
                        loading: () => const SizedBox.shrink(),
                        error: (_, _) => const SizedBox.shrink(),
                      ),
                      SizedBox(height: Spacing.xxl),
                      recommendationsAsync.when(
                        data: (recs) => MediaRowSection(
                          title: context.l10n.recommendations,
                          items: recs,
                        ),
                        loading: () => const SizedBox.shrink(),
                        error: (_, _) => const SizedBox.shrink(),
                      ),
                      SizedBox(height: Spacing.xxl),
                      similarAsync.when(
                        data: (similar) => MediaRowSection(
                          title: context.l10n.similar,
                          items: similar,
                        ),
                        loading: () => const SizedBox.shrink(),
                        error: (_, _) => const SizedBox.shrink(),
                      ),
                      SizedBox(height: Spacing.xxl),
                      ReviewsSection(reviewsAsync: reviewsAsync),
                      SizedBox(height: Spacing.xxl),
                      const ActivitySection(),
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
            child: SidePanel(media: media),
          ),
        ),
      ],
    );
  }

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
