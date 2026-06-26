import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import '../config/recommendation_config.dart';
import '../models/recommendation_models.dart';
import '../services/supabase_service.dart';

/// Data-access layer for the recommendation engine.
///
/// Encapsulates all Supabase queries so the engine can focus on scoring
/// and ranking.  Each method returns strongly-typed domain objects and
/// wraps DB errors in descriptive exceptions.
class RecommendationRepository {
  RecommendationRepository({SupabaseService? supabase})
      : _supabase = supabase ?? SupabaseService.instance;

  final SupabaseService _supabase;

  // ---------------------------------------------------------------
  // User behaviour
  // ---------------------------------------------------------------

  /// Returns IDs of media the user has explicitly saved (any watch status).
  Future<Set<int>> fetchSavedMediaIds(String userId) async {
    try {
      final response = await _supabase.userMedia
          .select('media_id')
          .eq('user_id', userId);
      return (response as List).map((e) => e['media_id'] as int).toSet();
    } catch (e) {
      debugPrint('RecommendationRepository: fetchSavedMediaIds failed: $e');
      return {};
    }
  }

  /// Returns IDs of media the user has viewed (from behaviour events).
  Future<Set<int>> fetchViewedMediaIds(String userId) async {
    try {
      final response = await _supabase.userEvents
          .select('media_id')
          .eq('user_id', userId)
          .eq('event_type', 'media_view')
          .limit(RecommendationConfig.dbFetchLimit);
      return (response as List)
          .map((e) => e['media_id'] as int?)
          .whereType<int>()
          .toSet();
    } catch (e) {
      debugPrint('RecommendationRepository: fetchViewedMediaIds failed: $e');
      return {};
    }
  }

  /// Returns media IDs ordered by most recent view (max [limit] items).
  Future<List<int>> fetchRecentViewedMediaIds(String userId,
      {int limit = RecommendationConfig.dbFetchLimit}) async {
    try {
      final response = await _supabase.userEvents
          .select('media_id, created_at')
          .eq('user_id', userId)
          .eq('event_type', 'media_view')
          .order('created_at', ascending: false)
          .limit(limit);
      return (response as List)
          .map((e) => e['media_id'] as int?)
          .whereType<int>()
          .toList();
    } catch (e) {
      debugPrint(
          'RecommendationRepository: fetchRecentViewedMediaIds failed: $e');
      return [];
    }
  }

  // ---------------------------------------------------------------
  // User recommendation profile
  // ---------------------------------------------------------------

  /// Loads the aggregated recommendation profile for [userId].
  Future<UserRecProfile?> fetchRecProfile(String userId) async {
    try {
      final response = await _supabase.userRecProfiles
          .select()
          .eq('user_id', userId)
          .single();
      return UserRecProfile.fromJson(response);
    } catch (_) {
      return null;
    }
  }

  // ---------------------------------------------------------------
  // Collaborative signals
  // ---------------------------------------------------------------

  /// Finds users who saved at least one of [savedIds] and are not [userId].
  Future<List<String>> findSimilarUsers(
      String userId, Set<int> savedIds) async {
    try {
      final response = await _supabase.userMedia
          .select('user_id')
          .inFilter('media_id', savedIds.toList())
          .neq('user_id', userId)
          .limit(RecommendationConfig.dbFetchLimit);
      return (response as List)
          .map((e) => e['user_id'] as String)
          .toSet()
          .take(RecommendationConfig.maxCollaborativeUsers)
          .toList();
    } catch (e) {
      debugPrint('RecommendationRepository: findSimilarUsers failed: $e');
      return [];
    }
  }

  /// Returns media saved by [userIds] that are not in [exclude].
  Future<Map<int, int>> fetchCollaborativeCandidates(
      List<String> userIds, Set<int> exclude) async {
    try {
      final response = await _supabase.userMedia
          .select('media_id')
          .inFilter('user_id', userIds)
          .not(
            'media_id',
            'in',
            exclude.isEmpty ? '(0)' : '(${exclude.join(",")})',
          )
          .limit(RecommendationConfig.maxCollaborativeCandidates);

      final counts = <int, int>{};
      for (final e in response as List) {
        final mid = e['media_id'] as int;
        counts[mid] = (counts[mid] ?? 0) + 1;
      }
      return counts;
    } catch (e) {
      debugPrint(
          'RecommendationRepository: fetchCollaborativeCandidates failed: $e');
      return {};
    }
  }

  // ---------------------------------------------------------------
  // Content similarity
  // ---------------------------------------------------------------

  /// Returns genres for a list of media IDs.
  Future<Set<String>> fetchGenresForMedia(List<int> ids) async {
    try {
      final response =
          await _supabase.media.select('genres').inFilter('id', ids);
      final genres = <String>{};
      for (final s in response as List) {
        final itemGenres = (s['genres'] as List?)?.cast<String>() ?? [];
        genres.addAll(itemGenres);
      }
      return genres;
    } catch (e) {
      debugPrint('RecommendationRepository: fetchGenresForMedia failed: $e');
      return {};
    }
  }

  /// Finds media whose genres overlap with [targetGenres], excluding [exclude].
  Future<List<Map<String, dynamic>>> findSimilarByGenres(
    Set<String> targetGenres,
    Set<int> exclude, {
    int limit = RecommendationConfig.dbFetchLimit,
  }) async {
    try {
      final response = await _supabase.media
          .select('id, genres, vote_average, popularity')
          .overlaps('genres', targetGenres.toList())
          .not(
            'id',
            'in',
            exclude.isEmpty ? '(0)' : '(${exclude.join(",")})',
          )
          .order('vote_average', ascending: false)
          .limit(limit);
      return (response as List).cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint(
          'RecommendationRepository: findSimilarByGenres failed: $e');
      return [];
    }
  }

  // ---------------------------------------------------------------
  // Curated / non-personalised feeds
  // ---------------------------------------------------------------

  /// Generic popular query ordered by descending popularity.
  Future<List<Map<String, dynamic>>> fetchPopular(
    Set<int> exclude, {
    int limit = RecommendationConfig.maxItemsPerCategory,
  }) async {
    return _simpleQuery(
      exclude: exclude,
      orderColumn: 'popularity',
      ascending: false,
      limit: limit,
      columns: 'id, title, popularity, genres, poster_path',
    );
  }

  /// Media released within the new-release window.
  Future<List<Map<String, dynamic>>> fetchNewReleases(
    Set<int> exclude, {
    int limit = RecommendationConfig.maxItemsPerCategory,
  }) async {
    final cutoff = DateTime.now()
        .subtract(const Duration(days: RecommendationConfig.newReleaseWindowDays))
        .toIso8601String()
        .split('T')
        .first;
    try {
      final response = await _supabase.media
          .select('id, title, popularity, release_date, genres, poster_path')
          .gte('release_date', cutoff)
          .not(
            'id',
            'in',
            exclude.isEmpty ? '(0)' : '(${exclude.join(",")})',
          )
          .order('release_date', ascending: false)
          .limit(limit);
      return (response as List).cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('RecommendationRepository: fetchNewReleases failed: $e');
      return [];
    }
  }

  /// Media with high vote average.
  Future<List<Map<String, dynamic>>> fetchTopRated(
    Set<int> exclude, {
    int limit = RecommendationConfig.maxItemsPerCategory,
  }) async {
    return _simpleQuery(
      exclude: exclude,
      orderColumn: 'vote_average',
      ascending: false,
      limit: limit,
      columns: 'id, title, vote_average, genres, poster_path',
      minVoteAverage: RecommendationConfig.topRatedMinVoteAverage,
    );
  }

  /// High rating, low popularity — undiscovered quality media.
  Future<List<Map<String, dynamic>>> fetchHiddenGems(
    Set<int> exclude, {
    int limit = RecommendationConfig.maxItemsPerCategory,
  }) async {
    try {
      final response = await _supabase.media
          .select('id, title, vote_average, popularity, genres, poster_path')
          .not(
            'id',
            'in',
            exclude.isEmpty ? '(0)' : '(${exclude.join(",")})',
          )
          .gte('vote_average', RecommendationConfig.hiddenGemMinVoteAverage)
          .lt('popularity', RecommendationConfig.hiddenGemMaxPopularity)
          .order('vote_average', ascending: false)
          .limit(limit);
      return (response as List).cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('RecommendationRepository: fetchHiddenGems failed: $e');
      return [];
    }
  }

  /// High rating + high vote count (proxy for critically acclaimed).
  Future<List<Map<String, dynamic>>> fetchAcclaimed(
    Set<int> exclude, {
    int limit = RecommendationConfig.maxItemsPerCategory,
  }) async {
    try {
      final response = await _supabase.media
          .select(
              'id, title, vote_average, vote_count, genres, poster_path')
          .not(
            'id',
            'in',
            exclude.isEmpty ? '(0)' : '(${exclude.join(",")})',
          )
          .gte('vote_average', RecommendationConfig.acclaimedMinVoteAverage)
          .gte('vote_count', RecommendationConfig.acclaimedMinVoteCount)
          .order('vote_average', ascending: false)
          .limit(limit);
      return (response as List).cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('RecommendationRepository: fetchAcclaimed failed: $e');
      return [];
    }
  }

  /// Genre-based discovery for "Because You Like..." feed.
  Future<List<Map<String, dynamic>>> fetchByGenre(
    String genre,
    Set<int> exclude, {
    int limit = RecommendationConfig.maxItemsPerCategory,
  }) async {
    try {
      final response = await _supabase.media
          .select('id, title, vote_average, genres, poster_path')
          .contains('genres', [genre])
          .not(
            'id',
            'in',
            exclude.isEmpty ? '(0)' : '(${exclude.join(",")})',
          )
          .order('vote_average', ascending: false)
          .limit(limit);
      return (response as List).cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('RecommendationRepository: fetchByGenre failed: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _simpleQuery({
    required Set<int> exclude,
    required String orderColumn,
    required bool ascending,
    required int limit,
    required String columns,
    double? minVoteAverage,
  }) async {
    try {
      // NOTE: filter methods (gte, eq, etc.) must be called before
      // transform methods (order, limit) because the latter return
      // PostgrestTransformBuilder which does not carry filter methods.
      var query = _supabase.media
          .select(columns)
          .not(
            'id',
            'in',
            exclude.isEmpty ? '(0)' : '(${exclude.join(",")})',
          );
      if (minVoteAverage != null) {
        query = query.gte('vote_average', minVoteAverage);
      }
      return (await query
              .order(orderColumn, ascending: ascending)
              .limit(limit))
          .cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('RecommendationRepository: $orderColumn query failed: $e');
      return [];
    }
  }

  // ---------------------------------------------------------------
  // Caching
  // ---------------------------------------------------------------

  /// Reads cached recommendations for [userId] that haven't expired.
  Future<Map<RecCategory, List<ScoredMedia>>?> fetchCached(
      String userId) async {
    try {
      final response = await _supabase.recommendationsCache
          .select()
          .eq('user_id', userId)
          .gte('expires_at', DateTime.now().toIso8601String())
          .order('score', ascending: false);

      final list = response as List;
      if (list.isEmpty) return null;

      final grouped = <RecCategory, List<ScoredMedia>>{};
      for (final item in list) {
        final scored = ScoredMedia.fromJson(item);
        grouped.putIfAbsent(scored.category, () => []).add(scored);
      }
      return grouped;
    } catch (e) {
      debugPrint('RecommendationRepository: fetchCached failed: $e');
      return null;
    }
  }

  /// Stores recommendation results in the cache (batched upsert).
  Future<void> cacheResults(
      String userId, Map<RecCategory, List<ScoredMedia>> results) async {
    try {
      await _supabase.recommendationsCache.delete().eq('user_id', userId);
    } catch (_) {}

    for (final entry in results.entries) {
      if (entry.value.isEmpty) continue;
      final rows = entry.value.map(_buildCacheRow(userId)).toList();
      for (var i = 0; i < rows.length;
          i += RecommendationConfig.cacheBatchSize) {
        final end = math.min(
            i + RecommendationConfig.cacheBatchSize, rows.length);
        final batch = rows.sublist(i, end);
        try {
          await _supabase.recommendationsCache.insert(batch);
        } catch (e) {
          debugPrint(
              'RecommendationRepository: cache insert failed for ${entry.key}: $e');
        }
      }
    }
  }

  Map<String, dynamic> Function(ScoredMedia) _buildCacheRow(String userId) {
    return (s) => {
          'user_id': userId,
          'category': s.category.dbValue,
          'media_id': s.mediaId,
          'score': s.score,
          'reason': s.reason,
          'reason_type': s.reasonType,
          'expires_at': DateTime.now()
              .add(const Duration(hours: RecommendationConfig.cacheTtlHours))
              .toIso8601String(),
        };
  }

  /// Marks a single recommendation as dismissed by the user.
  Future<void> dismissRecommendation(
      String userId, ScoredMedia item) async {
    try {
      await _supabase.recommendationsCache
          .update({'is_dismissed': true})
          .eq('user_id', userId)
          .eq('category', item.category.dbValue)
          .eq('media_id', item.mediaId);
    } catch (e) {
      debugPrint(
          'RecommendationRepository: dismissRecommendation failed: $e');
    }
  }
}
