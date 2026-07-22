import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/dimensions.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/shared/featured_carousel.dart';
import '../../core/shared/horizontal_carousel.dart';
import '../../core/shared/media_row.dart';
import '../../core/shared/section_header.dart';
import '../../models/media_model.dart';
import '../tracking/widgets/progress_card.dart';
import '../../l10n/l10n.dart';
import 'providers/home_providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.invalidate(trendingProvider));
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(homeSearchQueryProvider);
    final searchResultsAsync = ref.watch(homeSearchResultsProvider);
    final isSearching = searchQuery.trim().length >= 2;

    final trendingAsync = ref.watch(trendingProvider);
    final continueWatchingAsync = ref.watch(continueWatchingProvider);
    final popularAsync = ref.watch(popularThisWeekProvider);
    final recentlyAddedAsync = ref.watch(recentlyAddedProvider);
    final upcomingAsync = ref.watch(upcomingReleasesProvider);
    final recommendedAsync = ref.watch(recommendedProvider);

    final trending = trendingAsync.asData?.value ?? [];
    final popular = popularAsync.asData?.value ?? [];
    final recentlyAdded = recentlyAddedAsync.asData?.value ?? [];
    final upcoming = upcomingAsync.asData?.value ?? [];
    final recommended = recommendedAsync.asData?.value ?? [];
    final l10n = context.l10n;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => _refresh(),
        child: ListView(
          padding: EdgeInsetsDirectional.only(
            top: MediaQuery.of(context).padding.top,
            bottom: MediaQuery.of(context).padding.bottom + kBottomNavigationBarHeight,
          ),
          children: [
            SizedBox(height: Spacing.sm),
            _buildSearchBar(context),
            if (isSearching)
              ..._buildSearchResults(context, searchResultsAsync)
            else ...[
              SizedBox(height: Spacing.sm),
            trending.isEmpty
                ? _buildShimmerCarousel()
                : FeaturedCarousel(
                    items: trending.map((m) => FeaturedCarouselItem(
                      title: m.title,
                      backdropUrl: AppConstants.mediaImageUrl(m.backdropPath, size: 'w1280'),
                      voteAverage: m.voteAverage,
                      onTap: () => _navigateToDetail(m),
                    )).toList(),
                  ).animate().fadeIn(duration: 400.ms),
            SizedBox(height: Spacing.lg),
            continueWatchingAsync.when(
              loading: () => _buildContinueWatchingShimmer().animate().fadeIn(duration: 300.ms).slideX(begin: 0.05),
              error: (err, _) => Padding(
                padding: const EdgeInsetsDirectional.only(start: Spacing.lg, bottom: Spacing.md),
                child: Text(
                  l10n.couldNotLoadContinueWatching,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.05),
              data: (items) {
                if (items.isEmpty) {
                  return Padding(
                    padding: const EdgeInsetsDirectional.only(start: Spacing.lg, bottom: Spacing.md),
                    child: Text(
                      l10n.noContentInProgress,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.05);
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: Spacing.lg, end: Spacing.lg, bottom: Spacing.md),
                      child: SectionHeader(title: l10n.continueWatching),
                    ),
                    HorizontalCarousel(
                      height: 200,
                      padding: const EdgeInsetsDirectional.only(start: Spacing.md, end: Spacing.md),
                      separatorWidth: Spacing.sm,
                      itemExtent: 148,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return ProgressCard(
                          userMedia: item.userMedia,
                          title: item.media.title,
                          posterUrl: AppConstants.mediaImageUrl(item.media.posterPath),
                          onTap: () => _navigateToDetail(item.media),
                        );
                      },
                    ),
                  ],
                ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.05);
              },
            ),
            if (popular.isNotEmpty) ...[
              SizedBox(height: Spacing.xl),
              MediaRow(
                title: l10n.popularThisWeek,
                items: popular.map((m) => MediaRowItem(
                  id: m.id,
                  title: m.title,
                  posterUrl: AppConstants.mediaImageUrl(m.posterPath),
                  voteAverage: m.voteAverage,
                  mediaType: m.mediaType,
                  onTap: () => _navigateToDetail(m),
                )).toList(),
              ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.05),
            ],
            if (recentlyAdded.isNotEmpty) ...[
              SizedBox(height: Spacing.xl),
              MediaRow(
                title: l10n.recentlyAdded,
                items: recentlyAdded.map((m) => MediaRowItem(
                  id: m.id,
                  title: m.title,
                  posterUrl: AppConstants.mediaImageUrl(m.posterPath),
                  voteAverage: m.voteAverage,
                  mediaType: m.mediaType,
                  onTap: () => _navigateToDetail(m),
                )).toList(),
              ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.05),
            ],
            if (upcoming.isNotEmpty) ...[
              SizedBox(height: Spacing.xl),
              MediaRow(
                title: l10n.upcomingReleases,
                items: upcoming.map((m) => MediaRowItem(
                  id: m.id,
                  title: m.title,
                  posterUrl: AppConstants.mediaImageUrl(m.posterPath),
                  voteAverage: m.voteAverage,
                  mediaType: m.mediaType,
                  onTap: () => _navigateToDetail(m),
                )).toList(),
              ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.05),
            ],
            if (recommended.isNotEmpty) ...[
              SizedBox(height: Spacing.xl),
              MediaRow(
                title: l10n.recommendedForYou,
                items: recommended.map((m) => MediaRowItem(
                  id: m.id,
                  title: m.title,
                  posterUrl: AppConstants.mediaImageUrl(m.posterPath),
                  voteAverage: m.voteAverage,
                  mediaType: m.mediaType,
                  onTap: () => _navigateToDetail(m),
                )).toList(),
              ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.05),
            ],
            SizedBox(height: Spacing.xxl),
          ],
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(Spacing.lg, 0, Spacing.lg, Spacing.md),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          _searchDebounce?.cancel();
          _searchDebounce = Timer(const Duration(milliseconds: 300), () {
            ref.read(homeSearchQueryProvider.notifier).update(value);
          });
        },
        decoration: InputDecoration(
          hintText: context.l10n.searchMoviesTv,
          hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
          prefixIcon: Icon(Icons.search_rounded, color: colorScheme.onSurfaceVariant),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear_rounded, color: colorScheme.onSurfaceVariant),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(homeSearchQueryProvider.notifier).update('');
                  },
                )
              : null,
          filled: true,
          fillColor: colorScheme.surfaceContainerHighest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsetsDirectional.symmetric(vertical: Spacing.md),
        ),
        style: TextStyle(color: colorScheme.onSurface),
      ),
    );
  }

  List<Widget> _buildSearchResults(
    BuildContext context,
    AsyncValue<List<MediaModel>> searchResultsAsync,
  ) {
    return [
      Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: Spacing.lg, vertical: Spacing.xs),
        child: Text(
          context.l10n.searchResults,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      ...searchResultsAsync.when(
        data: (results) {
          if (results.isEmpty) {
            return [
              Padding(
                padding: EdgeInsetsDirectional.all(Spacing.section),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search_off_rounded, size: 64,
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                      SizedBox(height: Spacing.lg),
                      Text(context.l10n.noResults,
                        style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                ),
              ),
            ];
          }
          return [
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: Spacing.lg),
              child: _buildSearchGrid(results),
            ),
          ];
        },
        loading: () => [
          Center(
            child: Padding(
              padding: EdgeInsetsDirectional.all(Spacing.xxl),
              child: CircularProgressIndicator(),
            ),
          ),
        ],
        error: (e, _) => [
          Center(
            child: Padding(
              padding: EdgeInsetsDirectional.all(Spacing.xxl),
              child: Text(context.l10n.errorWithDetails(e.toString())),
            ),
          ),
        ],
      ),
      SizedBox(height: Spacing.xl),
    ];
  }

  Widget _buildSearchGrid(List<MediaModel> results) {
    final screenWidth = context.screenWidth;
    final columns = screenWidth >= 1024 ? 6 : screenWidth >= 768 ? 4 : 3;
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        childAspectRatio: 0.6,
        crossAxisSpacing: Spacing.sm,
        mainAxisSpacing: Spacing.sm,
      ),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return GestureDetector(
          onTap: () => _navigateToDetail(item),
          child: Card(
            clipBehavior: Clip.antiAlias,
            elevation: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: item.posterPath != null
                      ? Image.network(
                          AppConstants.mediaImageUrl(item.posterPath)!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Center(
                            child: Icon(Icons.movie_outlined,
                              color: Theme.of(context).colorScheme.onSurfaceVariant),
                          ),
                        )
                      : Center(
                          child: Icon(Icons.movie_outlined,
                            color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.all(6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2),
                      if (item.voteAverage != null)
                        Row(
                          children: [
                            Icon(Icons.star_rounded, size: 12, color: Colors.amber),
                            SizedBox(width: 2),
                            Text(item.voteAverage!.toStringAsFixed(1),
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _refresh() async {
    ref.invalidate(trendingProvider);
    ref.invalidate(continueWatchingProvider);
    ref.invalidate(popularThisWeekProvider);
    ref.invalidate(recentlyAddedProvider);
    ref.invalidate(upcomingReleasesProvider);
    ref.invalidate(recommendedProvider);
  }

  void _navigateToDetail(MediaModel media) {
    context.push('/media/${media.mediaType.name}/${media.id}');
  }

  Widget _buildShimmerCarousel() {
    return SizedBox(
      height: 480,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildContinueWatchingShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 16, end: 16, bottom: 12),
          child: SectionHeader(title: context.l10n.continueWatching),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsetsDirectional.only(start: 12, end: 12),
            itemCount: 5,
            itemExtent: 148,
            itemBuilder: (context, index) => Container(
              width: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.all(Radius.circular(10)),
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
