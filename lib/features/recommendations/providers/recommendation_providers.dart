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

  final recsEnabled = ref.watch(recsEnabledProvider).value ?? true;
  if (!recsEnabled) return {};

  final engine = ref.read(recommendationEngineProvider);
  final recs = await engine.generateAll(uid);
  return recs;
});

/// Returns recommendations for a single category.
final recommendationCategoryProvider =
    FutureProvider.family<List<ScoredMedia>, RecCategory>(
        (ref, category) async {
  final all = ref.watch(recommendationsProvider).value ?? {};
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

/// Loads `profiles.recs_enabled` from Supabase for the current user.
///
/// Returns `true` as default when the user is unauthenticated or the query
/// fails, so the recommendation system is never accidentally blocked.
final recsEnabledProvider = FutureProvider<bool>((ref) async {
  final uid = ref.watch(authServiceProvider).userId;
  if (uid.isEmpty) return true;
  try {
    return await BehaviorService.instance.isRecsEnabled();
  } catch (_) {
    return true;
  }
});

/// Writable counterpart that toggles recommendations in Supabase
/// and invalidates [recsEnabledProvider] so the UI and data layer react.
final recsEnabledActionsProvider = Provider<RecsEnabledActions>((ref) {
  return RecsEnabledActions(ref);
});

class RecsEnabledActions {
  final Ref _ref;
  RecsEnabledActions(this._ref);

  Future<void> setEnabled(bool enabled) async {
    if (enabled) {
      await BehaviorService.instance.enableRecommendations();
    } else {
      await BehaviorService.instance.disableRecommendations();
    }
    _ref.invalidate(recsEnabledProvider);
    _ref.invalidate(recommendationsProvider);
  }
}