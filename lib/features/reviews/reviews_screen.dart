import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/dimensions.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/providers/app_providers.dart';
import '../../l10n/l10n.dart';
import '../../models/review_model.dart';
import '../media/widgets/review_card.dart';

final _userReviewsProvider = FutureProvider<List<ReviewModel>>((ref) async {
  final user = ref.watch(authServiceProvider).currentUser;
  if (user == null) return [];
  try {
    final supabase = ref.read(supabaseServiceProvider);
    final data = await supabase.client
        .from('reviews')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);
    return (data as List<dynamic>)
        .map((json) => ReviewModel.fromJson(json as Map<String, dynamic>))
        .toList();
  } catch (e) {
    debugPrint('_userReviewsProvider: $e');
    return [];
  }
});

class ReviewsScreen extends ConsumerWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final reviewsAsync = ref.watch(_userReviewsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.allReviews)),
      body: reviewsAsync.when(
        data: (reviews) {
          if (reviews.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsetsDirectional.all(Spacing.xxl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.rate_review_outlined,
                      size: 64,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(height: Spacing.lg),
                    Text(
                      l10n.noUserReviews,
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsetsDirectional.all(Spacing.lg),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              return ReviewCard(review: reviews[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: EdgeInsetsDirectional.all(Spacing.xxl),
            child: Text(
              l10n.failedToLoadReviews,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.error,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
