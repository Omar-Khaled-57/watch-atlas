import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/models/recommendation_models.dart';
import '../../../core/shared/horizontal_carousel.dart';
import '../../../l10n/l10n.dart';
import '../providers/recommendation_providers.dart';
import 'recommendation_card.dart';

/// A horizontal scrollable row of [RecommendationCard]s with a category header.
class RecommendationRow extends ConsumerWidget {
  const RecommendationRow({
    super.key,
    required this.category,
    required this.items,
  });

  final RecCategory category;
  final List<ScoredMedia> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) return const SizedBox.shrink();

    final textTheme = Theme.of(context).textTheme;

    final l10n = context.l10n;
    final categoryLabel = switch (category) {
      RecCategory.becauseYouSaved => l10n.recommendationBecauseYouSaved,
      RecCategory.becauseYouViewed => l10n.recommendationBecauseYouViewed,
      RecCategory.trendingNearYou => l10n.recommendationTrendingNearYou,
      RecCategory.popularThisWeek => l10n.recommendationPopularThisWeek,
      RecCategory.continueExploring => l10n.recommendationContinueExploring,
      RecCategory.newReleases => l10n.recommendationNewReleases,
      RecCategory.hiddenGems => l10n.recommendationHiddenGems,
      RecCategory.criticallyAcclaimed => l10n.recommendationCriticallyAcclaimed,
      RecCategory.topRated => l10n.recommendationTopRated,
      RecCategory.similarToFavorites => l10n.recommendationSimilarToFavorites,
      RecCategory.becauseYouLikeGenre => l10n.recommendationBecauseYouLikeGenre,
      RecCategory.friendsAlsoSaved => l10n.recommendationFriendsAlsoSaved,
      RecCategory.usersLikeYou => l10n.recommendationUsersLikeYou,
      RecCategory.awardWinners => l10n.recommendationAwardWinners,
      RecCategory.underratedClassics => l10n.recommendationUnderratedClassics,
      RecCategory.upcomingReleases => l10n.recommendationUpcomingReleases,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
          child: Semantics(
            header: true,
            label: categoryLabel,
            child: Text(
              categoryLabel,
              style: textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: Spacing.md),
        HorizontalCarousel(
          height: 250,
          itemCount: items.length,
          separatorWidth: Spacing.md,
          padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
          itemBuilder: (context, index) {
            final item = items[index];
            return RecommendationCard(
              scoredMedia: item,
              onTap: () {
                ref.read(behaviorServiceProvider).trackRecommendationClick(
                      item.mediaId,
                      category.dbValue,
                    );
                Navigator.pushNamed(
                  context,
                  '/media-details',
                  arguments: {'id': item.mediaId},
                );
              },
            );
          },
        ),
        const SizedBox(height: Spacing.lg),
      ],
    );
  }
}
