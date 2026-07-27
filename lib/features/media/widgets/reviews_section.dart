import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../l10n/l10n.dart';
import '../../../models/review_model.dart';
import '../widgets/review_card.dart';
import 'detail_section_header.dart';

/// Reviews list with empty state and write-review CTA.
class ReviewsSection extends ConsumerWidget {
  final AsyncValue<List> reviewsAsync;

  const ReviewsSection({super.key, required this.reviewsAsync});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            DetailSectionHeader(title: context.l10n.reviews),
            const Spacer(),
            Semantics(
              button: true,
              label: context.l10n.writeReview,
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit_rounded, size: 18),
                label: Text(context.l10n.writeReview),
              ),
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
                  borderRadius: BorderRadiusDirectional.all(
                    Radius.circular(Spacing.cardRadiusMd),
                  ),
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
          loading: () => const Center(
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
