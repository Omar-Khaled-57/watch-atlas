import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/recommendation_models.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/services/tmdb_service.dart';
import '../../../core/repositories/recommendation_repository.dart';
import '../../../core/services/behavior_service.dart';
import '../../../core/services/recommendation_engine.dart';
import '../../../core/services/supabase_service.dart';

// ---------------------------------------------------------------------------
// Service / engine providers
// ---------------------------------------------------------------------------

final behaviorServiceProvider = Provider<BehaviorService>((ref) => BehaviorService(
      supabase: SupabaseService.instance,
    ));

final recommendationRepositoryProvider =
    Provider<RecommendationRepository>((ref) => RecommendationRepository(
          supabase: SupabaseService.instance,
        ));

final recommendationEngineProvider =
    Provider<RecommendationEngine>((ref) {
  final repo = ref.read(recommendationRepositoryProvider);
  return RecommendationEngine(repository: repo);
});

// ---------------------------------------------------------------------------
// Recommendation data providers
// ---------------------------------------------------------------------------

/// Fetches all recommendation feeds for the authenticated user.
///
/// Returns an empty map when the user is not authenticated or when
/// personalised recommendations are disabled.
final recommendationsProvider =
    FutureProvider<Map<RecCategory, List<ScoredMedia>>>((ref) async {
  final uid = ref.watch(authServiceProvider).userId;
  if (uid.isEmpty) return {};

  final engine = ref.read(recommendationEngineProvider);
  final recs = await engine.generateAll(uid);
  return recs;
});

/// Returns recommendations for a single category.
final recommendationCategoryProvider =
    FutureProvider.family<List<ScoredMedia>, RecCategory>(
        (ref, category) async {
  final all = ref.watch(recommendationsProvider).valueOrNull ?? {};
  return all[category] ?? [];
});

/// Fallback non-personalised recommendations for new users with no history.
/// Uses TMDB API when Supabase media table is unavailable.
final coldStartRecommendationsProvider =
    FutureProvider<List<ScoredMedia>>((ref) async {
  final tmdb = TmdbService.instance;
  try {
    final response = await tmdb.get('/movie/popular');
    final results = response['results'] as List<dynamic>;
    return results.map((item) {
      final map = item as Map<String, dynamic>;
      return ScoredMedia(
        mediaId: map['id'] as int,
        score: ((map['popularity'] as num?)?.toDouble() ?? 0) / 100,
        reason: 'Popular trending',
        reasonType: 'popularity',
        category: RecCategory.trendingNearYou,
      );
    }).toList();
  } catch (e) {
    debugPrint('coldStartRecommendationsProvider: $e');
    return [];
  }
});

// ---------------------------------------------------------------------------
// Privacy / toggle
// ---------------------------------------------------------------------------

/// Client-side state mirror of `profiles.recs_enabled`.
///
/// Initialised to `true`; synced to the DB when toggled via [BehaviorService].
final recsEnabledProvider = StateProvider<bool>((ref) => true);