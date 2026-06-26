import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/models/recommendation_models.dart';
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
          child: Semantics(
            header: true,
            label: category.displayName,
            child: Text(
              category.displayName,
              style: textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: Spacing.md),
        SizedBox(
          height: 250,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: Spacing.md),
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
        ),
        const SizedBox(height: Spacing.lg),
      ],
    );
  }
}
