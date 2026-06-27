import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/dimensions.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/shared/horizontal_carousel.dart';
import '../../l10n/l10n.dart';
import '../../l10n/app_localizations.dart';
import '../../core/models/recommendation_models.dart';
import '../recommendations/providers/recommendation_providers.dart';
import 'widgets/recommendation_card.dart';

class RecommendationsScreen extends ConsumerWidget {
  const RecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    final recommendationsAsync = ref.watch(recommendationsProvider);
    final category = RecCategory.trendingNearYou;
    final categoryItemsAsync = ref.watch(recommendationCategoryProvider(category));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.personalizedRecommendations),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.landscape) {
            return _buildLandscapeLayout(
              context,
              ref,
              recommendationsAsync,
              categoryItemsAsync,
              colorScheme,
              textTheme,
              l10n,
            );
          }
          return _buildPortraitLayout(
            context,
            ref,
            recommendationsAsync,
            categoryItemsAsync,
            colorScheme,
            textTheme,
            l10n,
          );
        },
      ),
    );
  }

  Widget _buildPortraitLayout(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<Map<RecCategory, List<ScoredMedia>>> recommendationsAsync,
    AsyncValue<List<ScoredMedia>> categoryItemsAsync,
    ColorScheme colorScheme,
    TextTheme textTheme,
    AppLocalizations l10n,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.all(Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.forYou,
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: Spacing.sm),
          Text(
            l10n.activityImprovesSuggestions,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: Spacing.lg),
          _buildCategoryTabs(context, ref, l10n, colorScheme, textTheme),
          SizedBox(height: Spacing.md),
          categoryItemsAsync.when(
            loading: () => _buildShimmerCarousel(colorScheme),
            error: (err, _) => Center(
              child: Padding(
                padding: EdgeInsetsDirectional.all(Spacing.xl),
                child: Text(
                  l10n.failedToLoadRecommendations,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            data: (items) {
              if (items.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsetsDirectional.all(Spacing.xl),
                    child: Text(
                      l10n.noRecommendationsYet,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              return Column(
                children: [
                  HorizontalCarousel(
                    height: 250,
                    itemCount: items.length,
                    separatorWidth: Spacing.md,
                    padding: EdgeInsetsDirectional.zero,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return RecommendationCard(
                        scoredMedia: item,
                        onTap: () {
                          ref.read(behaviorServiceProvider).trackRecommendationClick(
                                item.mediaId,
                                item.category.dbValue,
                              );
                          context.navigateToMedia('movie', item.mediaId.toString());
                        },
                      );
                    },
                  ),
                  SizedBox(height: Spacing.lg),
                  Center(
                    child: FilledButton.icon(
                      onPressed: () => _showAllRecommendations(context, ref, recommendationsAsync, l10n),
                      icon: Icon(Icons.arrow_forward_rounded),
                      label: Text(l10n.seeMore),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLandscapeLayout(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<Map<RecCategory, List<ScoredMedia>>> recommendationsAsync,
    AsyncValue<List<ScoredMedia>> categoryItemsAsync,
    ColorScheme colorScheme,
    TextTheme textTheme,
    AppLocalizations l10n,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.all(Spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.forYou,
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: Spacing.sm),
                Text(
                  l10n.activityImprovesSuggestions,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: Spacing.lg),
                _buildCategoryTabs(context, ref, l10n, colorScheme, textTheme),
                SizedBox(height: Spacing.md),
                categoryItemsAsync.when(
                  loading: () => _buildShimmerGrid(context, colorScheme),
                  error: (err, _) => Center(
                    child: Padding(
                      padding: EdgeInsetsDirectional.all(Spacing.xl),
                      child: Text(
                        l10n.failedToLoadRecommendations,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  data: (items) {
                    if (items.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsetsDirectional.all(Spacing.xl),
                          child: Text(
                            l10n.noRecommendationsYet,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
return GridView.builder(
                       shrinkWrap: true,
                       physics: const NeverScrollableScrollPhysics(),
                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                         crossAxisCount: MediaQuery.of(context).size.width >= 1440 ? 5 : 4,
                         childAspectRatio: 0.65,
                         crossAxisSpacing: Spacing.md,
                         mainAxisSpacing: Spacing.md,
                       ),
                       itemCount: items.length,
                       itemBuilder: (context, index) {
                         final item = items[index];
                         return RecommendationCard(
                           scoredMedia: item,
                           onTap: () {
                             ref.read(behaviorServiceProvider).trackRecommendationClick(
                                   item.mediaId,
                                   item.category.dbValue,
                                 );
                             context.navigateToMedia('movie', item.mediaId.toString());
                           },
                         );
                       },
                     );
                  },
                ),
              ],
            ),
          ),
        ),
        Container(
          width: 1,
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.all(Spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.recommendationCategories,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: Spacing.md),
                ..._buildCategoryTiles(context, ref, l10n, colorScheme, textTheme),
                SizedBox(height: Spacing.lg),
FilledButton.icon(
                    onPressed: () => _showAllRecommendations(context, ref, recommendationsAsync, l10n),
                    icon: Icon(Icons.grid_view_rounded),
                    label: Text(l10n.viewAllRecommendations),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildCategoryTiles(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return RecCategory.values.map((cat) {
      return _CategoryTile(
        category: cat,
        onTap: () {
          ref.invalidate(recommendationCategoryProvider(cat));
        },
      );
    }).toList();
  }

  Widget _buildCategoryTabs(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final categories = RecCategory.values;
    return SizedBox(
      height: 40,
      child: HorizontalCarousel(
        height: 40,
        itemCount: categories.length,
        separatorWidth: 8,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return FilterChip(
            label: Text(_getCategoryLabel(cat, l10n)),
            selected: false,
            onSelected: (_) {
              ref.invalidate(recommendationCategoryProvider(cat));
            },
            backgroundColor: colorScheme.surfaceContainerHighest,
          );
        },
      ),
    );
  }

  String _getCategoryLabel(RecCategory category, AppLocalizations l10n) {
    switch (category) {
      case RecCategory.becauseYouSaved:
        return l10n.recommendationBecauseYouSaved;
      case RecCategory.becauseYouViewed:
        return l10n.recommendationBecauseYouViewed;
      case RecCategory.trendingNearYou:
        return l10n.recommendationTrendingNearYou;
      case RecCategory.popularThisWeek:
        return l10n.recommendationPopularThisWeek;
      case RecCategory.continueExploring:
        return l10n.recommendationContinueExploring;
      case RecCategory.newReleases:
        return l10n.recommendationNewReleases;
      case RecCategory.hiddenGems:
        return l10n.recommendationHiddenGems;
      case RecCategory.criticallyAcclaimed:
        return l10n.recommendationCriticallyAcclaimed;
      case RecCategory.topRated:
        return l10n.recommendationTopRated;
      case RecCategory.similarToFavorites:
        return l10n.recommendationSimilarToFavorites;
      case RecCategory.becauseYouLikeGenre:
        return l10n.recommendationBecauseYouLikeGenre;
      case RecCategory.friendsAlsoSaved:
        return l10n.recommendationFriendsAlsoSaved;
      case RecCategory.usersLikeYou:
        return l10n.recommendationUsersLikeYou;
      case RecCategory.awardWinners:
        return l10n.recommendationAwardWinners;
      case RecCategory.underratedClassics:
        return l10n.recommendationUnderratedClassics;
      case RecCategory.upcomingReleases:
        return l10n.recommendationUpcomingReleases;
    }
  }

  Widget _buildShimmerCarousel(ColorScheme colorScheme) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsetsDirectional.zero,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            width: 150,
            margin: EdgeInsetsDirectional.only(end: Spacing.md),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadiusDirectional.all(Radius.circular(12)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerGrid(BuildContext context, ColorScheme colorScheme) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width >= 1440 ? 5 : 4,
        childAspectRatio: 0.65,
        crossAxisSpacing: Spacing.md,
        mainAxisSpacing: Spacing.md,
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadiusDirectional.all(Radius.circular(12)),
          ),
        );
      },
    );
  }

  void _showAllRecommendations(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<Map<RecCategory, List<ScoredMedia>>> recommendationsAsync,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.allRecommendations),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: recommendationsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text(l10n.failedToLoadRecommendations)),
            data: (recs) {
              final allItems = recs.values.expand((e) => e).toList();
              if (allItems.isEmpty) {
                return Center(child: Text(l10n.noRecommendationsYet));
              }
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width >= 600 ? 4 : 3,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: Spacing.md,
                  mainAxisSpacing: Spacing.md,
                ),
                itemCount: allItems.length,
                itemBuilder: (context, index) {
                  final item = allItems[index];
                  return RecommendationCard(
                    scoredMedia: item,
                    onTap: () {
                      ref.read(behaviorServiceProvider).trackRecommendationClick(
                            item.mediaId,
                            item.category.dbValue,
                          );
                      Navigator.of(context).pop();
                      context.navigateToMedia('movie', item.mediaId.toString());
                    },
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final RecCategory category;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    String label;
    switch (category) {
      case RecCategory.becauseYouSaved:
        label = l10n.recommendationBecauseYouSaved;
        break;
      case RecCategory.becauseYouViewed:
        label = l10n.recommendationBecauseYouViewed;
        break;
      case RecCategory.trendingNearYou:
        label = l10n.recommendationTrendingNearYou;
        break;
      case RecCategory.popularThisWeek:
        label = l10n.recommendationPopularThisWeek;
        break;
      case RecCategory.continueExploring:
        label = l10n.recommendationContinueExploring;
        break;
      case RecCategory.newReleases:
        label = l10n.recommendationNewReleases;
        break;
      case RecCategory.hiddenGems:
        label = l10n.recommendationHiddenGems;
        break;
      case RecCategory.criticallyAcclaimed:
        label = l10n.recommendationCriticallyAcclaimed;
        break;
      case RecCategory.topRated:
        label = l10n.recommendationTopRated;
        break;
      case RecCategory.similarToFavorites:
        label = l10n.recommendationSimilarToFavorites;
        break;
      case RecCategory.becauseYouLikeGenre:
        label = l10n.recommendationBecauseYouLikeGenre;
        break;
      case RecCategory.friendsAlsoSaved:
        label = l10n.recommendationFriendsAlsoSaved;
        break;
      case RecCategory.usersLikeYou:
        label = l10n.recommendationUsersLikeYou;
        break;
      case RecCategory.awardWinners:
        label = l10n.recommendationAwardWinners;
        break;
      case RecCategory.underratedClassics:
        label = l10n.recommendationUnderratedClassics;
        break;
      case RecCategory.upcomingReleases:
        label = l10n.recommendationUpcomingReleases;
        break;
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(vertical: Spacing.sm, horizontal: Spacing.xs),
        child: Row(
          children: [
            Icon(
              Icons.auto_awesome_rounded,
              size: 20,
              color: colorScheme.primary,
            ),
            SizedBox(width: Spacing.sm),
            Expanded(
              child: Text(
                label,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
