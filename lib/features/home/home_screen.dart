import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extensions/context_extensions.dart';
import '../../core/shared/featured_carousel.dart';
import '../../core/shared/media_row.dart';
import '../../models/media_model.dart';
import 'providers/home_providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.invalidate(trendingProvider));
  }

  @override
  Widget build(BuildContext context) {
    final trendingAsync = ref.watch(trendingProvider);
    final continueWatchingAsync = ref.watch(continueWatchingProvider);
    final popularAsync = ref.watch(popularThisWeekProvider);
    final recentlyAddedAsync = ref.watch(recentlyAddedProvider);
    final upcomingAsync = ref.watch(upcomingReleasesProvider);
    final recommendedAsync = ref.watch(recommendedProvider);

    final trending = trendingAsync.asData?.value ?? [];
    final continueWatching = continueWatchingAsync.asData?.value ?? [];
    final popular = popularAsync.asData?.value ?? [];
    final recentlyAdded = recentlyAddedAsync.asData?.value ?? [];
    final upcoming = upcomingAsync.asData?.value ?? [];
    final recommended = recommendedAsync.asData?.value ?? [];

    final isDesktop = context.isDesktop;
    final isTablet = context.isTablet;
    final itemWidth = isDesktop
        ? 180.0
        : isTablet
            ? 160.0
            : 140.0;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => _refresh(),
        child: ListView(
          padding: EdgeInsetsDirectional.only(top: MediaQuery.of(context).padding.top),
          children: [
            SizedBox(height: 8),
            trending.isEmpty
                ? _buildShimmerCarousel()
                : FeaturedCarousel(
                    items: trending,
                    onItemTap: (media) => _navigateToDetail(media),
                  ).animate().fadeIn(duration: 400.ms),
            SizedBox(height: 16),
            if (continueWatching.isNotEmpty)
              MediaRow(
                title: 'Continue Watching',
                items: continueWatching,
                itemWidth: itemWidth,
                isLoading: continueWatchingAsync.isLoading,
              ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.05),
            if (popular.isNotEmpty)
              MediaRow(
                title: 'Popular This Week',
                items: popular,
                itemWidth: itemWidth,
                isLoading: popularAsync.isLoading,
                onSeeAll: () {},
              ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.05),
            if (recentlyAdded.isNotEmpty)
              MediaRow(
                title: 'Recently Added',
                items: recentlyAdded,
                itemWidth: itemWidth,
                isLoading: recentlyAddedAsync.isLoading,
                onSeeAll: () {},
              ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.05),
            if (upcoming.isNotEmpty)
              MediaRow(
                title: 'Upcoming Releases',
                items: upcoming,
                itemWidth: itemWidth,
                isLoading: upcomingAsync.isLoading,
                onSeeAll: () {},
              ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.05),
            if (recommended.isNotEmpty)
              MediaRow(
                title: 'Recommended For You',
                items: recommended,
                itemWidth: itemWidth,
                isLoading: recommendedAsync.isLoading,
                onSeeAll: () {},
              ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.05),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    await Future.wait([
      ref.refresh(trendingProvider).future,
      ref.refresh(continueWatchingProvider).future,
      ref.refresh(popularThisWeekProvider).future,
      ref.refresh(recentlyAddedProvider).future,
      ref.refresh(upcomingReleasesProvider).future,
      ref.refresh(recommendedProvider).future,
    ]);
  }

  void _navigateToDetail(MediaModel media) {
    Navigator.of(context).pushNamed('/media/${media.id}');
  }

  Widget _buildShimmerCarousel() {
    return SizedBox(
      height: 480,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
