import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/dimensions.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/extensions/number_extensions.dart';
import '../../core/models/media_enums.dart';
import '../../core/shared/app_modal.dart';
import '../../core/shared/expandable_text.dart';
import '../lists/providers/lists_providers.dart';
import '../lists/widgets/create_list_dialog.dart';
import '../tracking/providers/tracking_providers.dart';
import 'providers/media_providers.dart';
import 'widgets/cast_card.dart';
import 'widgets/media_stats.dart';
import 'widgets/review_card.dart';
import 'widgets/status_dropdown.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/services/behavior_service.dart';
import '../../models/media_model.dart';
import '../../models/review_model.dart';

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
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded, size: 64, color: context.colorScheme.error),
              SizedBox(height: Spacing.lg),
              Text('Failed to load details', style: context.textTheme.bodyLarge),
              SizedBox(height: Spacing.sm),
              TextButton(onPressed: () => ref.invalidate(mediaDetailsProvider), child: Text('Retry')),
            ],
          ),
        ),
      ),
    );
  }

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
                Shimmer.fromColors(
                  baseColor: context.colorScheme.surfaceContainerHighest,
                  highlightColor: context.colorScheme.surface,
                  child: Container(
                    height: 24,
                    width: 200,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: Spacing.lg),
                Shimmer.fromColors(
                  baseColor: context.colorScheme.surfaceContainerHighest,
                  highlightColor: context.colorScheme.surface,
                  child: Container(
                    height: 16,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: Spacing.sm),
                Shimmer.fromColors(
                  baseColor: context.colorScheme.surfaceContainerHighest,
                  highlightColor: context.colorScheme.surface,
                  child: Container(
                    height: 16,
                    width: 300,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    media,
    AsyncValue<Map<String, dynamic>> creditsAsync,
    AsyncValue<List> recommendationsAsync,
    AsyncValue<List> similarAsync,
    AsyncValue<List> reviewsAsync,
    AsyncValue<List<Map<String, dynamic>>> trailersAsync,
  ) {
    final isDesktop = context.isDesktop;
    final backdropUrl = AppConstants.mediaImageUrl(media.backdropPath, size: 'w1280');
    final posterUrl = AppConstants.mediaImageUrl(media.posterPath, size: 'w500');

    if (isDesktop) {
      return _buildDesktopLayout(
        context, media, backdropUrl, posterUrl,
        creditsAsync, recommendationsAsync, similarAsync,
        reviewsAsync, trailersAsync,
      );
    }

    return _buildMobileLayout(
      context, media, backdropUrl, posterUrl,
      creditsAsync, recommendationsAsync, similarAsync,
      reviewsAsync, trailersAsync,
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    media,
    String? backdropUrl,
    String? posterUrl,
    AsyncValue<Map<String, dynamic>> creditsAsync,
    AsyncValue<List> recommendationsAsync,
    AsyncValue<List> similarAsync,
    AsyncValue<List> reviewsAsync,
    AsyncValue<List<Map<String, dynamic>>> trailersAsync,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            child: _buildMainContent(
              context, media, backdropUrl, posterUrl,
              creditsAsync, recommendationsAsync, similarAsync,
              reviewsAsync, trailersAsync,
            ),
          ),
        ),
        SizedBox(
          width: 320,
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.only(
              top: Spacing.lg,
              bottom: Spacing.section,
              start: 0,
              end: 0,
            ),
            child: _buildSidePanel(media),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    media,
    String? backdropUrl,
    String? posterUrl,
    AsyncValue<Map<String, dynamic>> creditsAsync,
    AsyncValue<List> recommendationsAsync,
    AsyncValue<List> similarAsync,
    AsyncValue<List> reviewsAsync,
    AsyncValue<List<Map<String, dynamic>>> trailersAsync,
  ) {
    return SingleChildScrollView(
      child: _buildMainContent(
        context, media, backdropUrl, posterUrl,
        creditsAsync, recommendationsAsync, similarAsync,
        reviewsAsync, trailersAsync,
      ),
    );
  }

  Widget _buildMainContent(
    BuildContext context,
    media,
    String? backdropUrl,
    String? posterUrl,
    AsyncValue<Map<String, dynamic>> creditsAsync,
    AsyncValue<List> recommendationsAsync,
    AsyncValue<List> similarAsync,
    AsyncValue<List> reviewsAsync,
    AsyncValue<List<Map<String, dynamic>>> trailersAsync,
  ) {
    final isDesktop = context.isDesktop;
    final mediaQuery = context.mediaQuery;
    final horizontalPadding = isDesktop ? Spacing.xxl : Spacing.lg;
    final bottomPadding = isDesktop
        ? Spacing.section
        : Spacing.section + mediaQuery.padding.bottom + kBottomNavigationBarHeight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeroSection(context, media, backdropUrl, posterUrl),
        Padding(
          padding: EdgeInsetsDirectional.only(
            top: Spacing.lg,
            bottom: bottomPadding,
            start: horizontalPadding,
            end: horizontalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleSection(context, media),
              SizedBox(height: Spacing.md),
              _buildRatingSection(context, media),
              SizedBox(height: Spacing.md),
              if (media.genres != null && media.genres!.isNotEmpty)
                _buildGenreChips(context, media.genres!),
              SizedBox(height: Spacing.lg),
              _buildOverviewSection(context, media),
              SizedBox(height: Spacing.xxl),
              _buildStats(context, media),
              SizedBox(height: Spacing.xxl),
              creditsAsync.when(
                data: (credits) => _buildCastSection(context, credits),
                loading: () => SizedBox.shrink(),
                error: (_, __) => SizedBox.shrink(),
              ),
              SizedBox(height: Spacing.xxl),
              creditsAsync.when(
                data: (credits) => _buildCrewSection(context, credits),
                loading: () => SizedBox.shrink(),
                error: (_, __) => SizedBox.shrink(),
              ),
              SizedBox(height: Spacing.xxl),
              trailersAsync.when(
                data: (trailers) => _buildTrailersSection(context, trailers),
                loading: () => SizedBox.shrink(),
                error: (_, __) => SizedBox.shrink(),
              ),
              SizedBox(height: Spacing.xxl),
              recommendationsAsync.when(
                data: (recs) => _buildMediaRow(context, 'Recommendations', recs),
                loading: () => SizedBox.shrink(),
                error: (_, __) => SizedBox.shrink(),
              ),
              SizedBox(height: Spacing.xxl),
              similarAsync.when(
                data: (similar) => _buildMediaRow(context, 'Similar', similar),
                loading: () => SizedBox.shrink(),
                error: (_, __) => SizedBox.shrink(),
              ),
              SizedBox(height: Spacing.xxl),
              _buildReviewsSection(context, reviewsAsync),
              SizedBox(height: Spacing.xxl),
              _buildActivitySection(context),
              SizedBox(height: Spacing.section),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeroSection(BuildContext context, MediaModel media, String? backdropUrl, String? posterUrl) {
    return Stack(
      children: [
        Container(
          height: AppConstants.backdropHeight,
          width: double.infinity,
          child: backdropUrl != null
              ? CachedNetworkImage(
                  imageUrl: backdropUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    color: context.colorScheme.surfaceContainerHighest,
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: context.colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.movie_outlined,
                      size: 64,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              : Container(
                  color: context.colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.movie_outlined,
                    size: 64,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
          foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(
              begin: AlignmentDirectional.topCenter,
              end: AlignmentDirectional.bottomCenter,
              colors: [
                Colors.transparent,
                context.colorScheme.surface.withValues(alpha: 0.9),
              ],
            ),
          ),
        ),
        PositionedDirectional(
          start: 16,
          bottom: 0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (posterUrl != null)
                ClipRRect(
                  borderRadius: BorderRadiusDirectional.all(
                    Radius.circular(12),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: posterUrl,
                    width: 100,
                    height: 150,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Shimmer.fromColors(
                      baseColor: context.colorScheme.surfaceContainerHighest,
                      highlightColor: context.colorScheme.surface,
                      child: Container(color: Colors.white),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      color: context.colorScheme.surfaceContainerHighest,
                      child: Icon(Icons.movie_outlined),
                    ),
                  ),
                ),
            ],
          ),
        ),
        PositionedDirectional(
          top: MediaQuery.of(context).padding.top + 8,
          start: 8,
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

  Widget _buildTitleSection(BuildContext context, MediaModel media) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: media.posterPath != null ? 116 : 0),
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

  Widget _buildRatingSection(BuildContext context, MediaModel media) {
    if (media.voteAverage == null) return SizedBox.shrink();
    final percentage = (media.voteAverage! / 10 * 100).toPercentage();

    return Row(
      children: [
        ...List.generate(5, (i) {
          final filled = media.voteAverage! / 2 >= i + 1;
          final half = !filled && media.voteAverage! / 2 >= i + 0.5;
          return Icon(
            filled ? Icons.star_rounded : half ? Icons.star_half_rounded : Icons.star_outline_rounded,
            color: Colors.amber,
            size: 24,
          );
        }),
        SizedBox(width: Spacing.sm),
        Container(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: context.colorScheme.secondaryContainer,
            borderRadius: BorderRadiusDirectional.all(Radius.circular(8)),
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

  Widget _buildGenreChips(BuildContext context, List<String> genres) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: genres.map((genre) {
        return Chip(
          label: Text(genre),
          labelStyle: context.textTheme.labelSmall,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          padding: EdgeInsetsDirectional.zero,
        );
      }).toList(),
    );
  }

  Widget _buildOverviewSection(BuildContext context, MediaModel media) {
    if (media.overview == null || media.overview!.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: Spacing.sm),
        ExpandableText(
          text: media.overview!,
          style: context.textTheme.bodyMedium?.copyWith(height: 1.6),
        ),
      ],
    );
  }

  Widget _buildStats(BuildContext context, MediaModel media) {
    return MediaStats(
      runtime: media.runtime,
      releaseDate: media.releaseDate,
      countries: media.countries,
      language: media.language,
    );
  }

  Widget _buildCastSection(BuildContext context, Map<String, dynamic> credits) {
    final cast = credits['cast'] as List<dynamic>? ?? [];
    if (cast.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cast',
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: Spacing.md),
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsetsDirectional.zero,
            itemCount: cast.length,
            separatorBuilder: (_, __) => SizedBox(width: Spacing.md),
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

  Widget _buildCrewSection(BuildContext context, Map<String, dynamic> credits) {
    final crew = credits['crew'] as List<dynamic>? ?? [];
    if (crew.isEmpty) return SizedBox.shrink();

    final keyRoles = crew
        .where((c) => ['Director', 'Producer', 'Writer', 'Screenplay'].contains(c['job'] as String?))
        .take(6)
        .toList();
    if (keyRoles.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Crew',
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: Spacing.sm),
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
    );
  }

  Widget _buildTrailersSection(BuildContext context, List<Map<String, dynamic>> trailers) {
    if (trailers.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trailers',
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: Spacing.md),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsetsDirectional.zero,
            itemCount: trailers.length,
            separatorBuilder: (_, __) => SizedBox(width: Spacing.md),
            itemBuilder: (context, index) {
              final trailer = trailers[index];
              final key = trailer['key'] as String? ?? '';
              return GestureDetector(
                onTap: () => launchUrl(Uri.parse('https://www.youtube.com/watch?v=$key')),
                child: Container(
                  width: 320,
                  decoration: BoxDecoration(
                    color: context.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadiusDirectional.all(
                      Radius.circular(12),
                    ),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        'https://img.youtube.com/vi/$key/maxresdefault.jpg',
                      ),
                      fit: BoxFit.cover,
                      onError: (_, __) {},
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
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMediaRow(BuildContext context, String title, List items) {
    if (items.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),
          ],
        ),
        SizedBox(height: Spacing.md),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsetsDirectional.zero,
            itemCount: items.length,
            separatorBuilder: (_, __) => SizedBox(width: Spacing.sm),
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
                          borderRadius: BorderRadiusDirectional.all(Radius.circular(8)),
                          child: item.posterPath != null
                              ? CachedNetworkImage(
                                  imageUrl: '${AppConstants.tmdbImageBaseUrl}/w342${item.posterPath}',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                )
                              : Container(
                                  color: context.colorScheme.surfaceContainerHighest,
                                  child: Icon(Icons.movie_outlined, size: 32),
                                ),
                        ),
                      ),
                      SizedBox(height: Spacing.xs),
                      Text(
                        item.title ?? '',
                        style: context.textTheme.bodySmall,
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

  Widget _buildReviewsSection(BuildContext context, AsyncValue<List> reviewsAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Reviews',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),
            TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.edit_rounded, size: 18),
              label: Text('Write Review'),
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
                child: Column(
                  children: [
                    Icon(
                      Icons.rate_review_outlined,
                      size: 48,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(height: Spacing.md),
                    Text(
                      'No reviews yet. Be the first to review!',
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
                return ReviewCard(
                  review: rev,
                  authorName: rev.userId,
                );
              },
            );
          },
          loading: () => Center(child: CircularProgressIndicator()),
          error: (_, __) => Text('Failed to load reviews'),
        ),
      ],
    );
  }

  Widget _buildActivitySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activity',
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: Spacing.md),
        Container(
          width: double.infinity,
          padding: EdgeInsetsDirectional.all(Spacing.xl),
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadiusDirectional.all(Radius.circular(12)),
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
                'No recent activity',
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

  Widget _buildSidePanel(MediaModel media) {
    final userMediaList = ref.watch(userMediaProvider).valueOrNull ?? [];
    final currentUserMedia = userMediaList.where((m) => m.mediaId == media.id).firstOrNull;
    final currentStatus = currentUserMedia?.status;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StatusDropdown(
          currentStatus: currentStatus,
          onChanged: (status) {
            final notifier = ref.read(userMediaProvider.notifier);
            if (status == null) {
              if (currentUserMedia != null) {
                notifier.removeMedia(currentUserMedia);
                BehaviorService.instance.trackMediaUnsave(media.id);
              }
            } else if (currentUserMedia != null) {
              notifier.updateStatus(currentUserMedia, status);
              if (status == WatchStatus.completed) {
                BehaviorService.instance.trackMediaComplete(media.id);
              }
            } else {
              notifier.addMedia(
                mediaId: media.id,
                mediaType: media.mediaType,
                status: status,
              );
              BehaviorService.instance.trackMediaSave(media.id);
              if (status == WatchStatus.completed) {
                BehaviorService.instance.trackMediaComplete(media.id);
              }
            }
          },
        ),
        SizedBox(height: Spacing.lg),
        OutlinedButton.icon(
          onPressed: () => _showAddToListSheet(media),
          icon: Icon(Icons.playlist_add_rounded),
          label: Text('Add to List'),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsetsDirectional.symmetric(vertical: Spacing.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.all(Radius.circular(12)),
            ),
          ),
        ),
        SizedBox(height: Spacing.xl),
        _buildSidePanelStats(media),
      ],
    );
  }

  void _showAddToListSheet(MediaModel media) {
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
            error: (e, _) => const Center(
              child: Padding(
                padding: EdgeInsets.all(Spacing.xl),
                child: Text('Failed to load lists'),
              ),
            ),
            data: (lists) {
              if (lists.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(Spacing.xl),
                  child: Center(
                    child: Text('No lists yet.'),
                  ),
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
                      subtitle: Text('${list.itemCount} items'),
                      onTap: () {
                        ref.read(userListsProvider.notifier).addItemToList(
                          list.id, media,
                        );
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Added to "${list.title}"'),
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
            title: const Text('Create New List'),
            onTap: () async {
              final created = await showDialog<bool>(
                context: context,
                builder: (dialogContext) => const CreateListDialog(),
              );
              if (created == true && context.mounted) {
                final updatedLists = ref.read(userListsProvider).valueOrNull ?? [];
                final newList = updatedLists.isNotEmpty ? updatedLists.first : null;
                if (newList != null) {
                  ref.read(userListsProvider.notifier).addItemToList(
                    newList.id, media,
                  );
                }
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(newList != null
                        ? 'Added to "${newList.title}"'
                        : 'List created'),
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
      title: 'Add to List',
      content: content,
    );
  }

  Widget _buildSidePanelStats(MediaModel media) {
    final stats = <Map<String, dynamic>>[];

    if (media.runtime != null) {
      stats.add({
        'label': 'Runtime',
        'value': media.runtime!.toRuntimeString(),
      });
    }
    if (media.releaseDate != null) {
      stats.add({
        'label': 'Release Date',
        'value': '${media.releaseDate!.year}-${media.releaseDate!.month.toString().padLeft(2, '0')}-${media.releaseDate!.day.toString().padLeft(2, '0')}',
      });
    }
    if (media.countries != null && media.countries!.isNotEmpty) {
      stats.add({
        'label': 'Country',
        'value': media.countries!.join(', '),
      });
    }
    if (media.language != null) {
      stats.add({
        'label': 'Language',
        'value': media.language!,
      });
    }
    if (media.status != null) {
      stats.add({
        'label': 'Status',
        'value': media.status!,
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Details',
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
                stat['label'] as String,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(width: Spacing.sm),
              Expanded(
                child: Text(
                  stat['value'] as String,
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
