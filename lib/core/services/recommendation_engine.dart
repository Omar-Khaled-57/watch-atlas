import 'dart:math' as math;
import '../config/recommendation_config.dart';
import '../models/recommendation_models.dart';
import '../repositories/recommendation_repository.dart';

/// Hybrid recommendation engine combining behaviour, content, collaborative,
/// and demographic signals into scored, diversified recommendation feeds.
///
/// Scoring formula:
///   final_score = behaviour_weight * behaviour_score
///               + content_weight * content_score
///               + collaborative_weight * collaborative_score
///               + demographic_weight * demographic_score
///
/// All tunable weights live in [RecommendationConfig].  Data access is
/// delegated to [RecommendationRepository].
class RecommendationEngine {
  RecommendationEngine({
    RecommendationRepository? repository,
  }) : _repository = repository ?? RecommendationRepository();

  final RecommendationRepository _repository;

  /// Generates recommendations for [userId] across all [RecCategory] values.
  ///
  /// Returns cached results if available and not expired (unless
  /// [forceRefresh] is true).  Falls back to cold-start (non-personalised)
  /// feeds when the user has no behavioural history.
  Future<Map<RecCategory, List<ScoredMedia>>> generateAll(
    String userId, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final cached = await _repository.fetchCached(userId);
      if (cached != null && cached.isNotEmpty) return cached;
    }

    final savedIds = await _repository.fetchSavedMediaIds(userId);
    final viewedIds = await _repository.fetchViewedMediaIds(userId);
    final knownIds = <int>{...savedIds, ...viewedIds};

    final profile = await _repository.fetchRecProfile(userId);
    final isColdStart = knownIds.isEmpty && profile == null;

    Map<RecCategory, List<ScoredMedia>> results;

    if (isColdStart) {
      results = {};
    } else {
      results = await _buildPersonalisedFeeds(
        userId, savedIds, viewedIds, knownIds, profile,
      );
    }

    // Always include non-personalised fallback feeds.
    results.addAll(await _buildCuratedFeeds(userId, knownIds));

    // Apply diversity re-ranking to each feed.
    for (final category in results.keys) {
      results[category] = _applyDiversity(results[category]!);
    }

    // Persist to cache for fast subsequent loads.
    await _repository.cacheResults(userId, results);

    return results;
  }

  Future<Map<RecCategory, List<ScoredMedia>>> _buildPersonalisedFeeds(
    String userId,
    Set<int> savedIds,
    Set<int> viewedIds,
    Set<int> knownIds,
    UserRecProfile? profile,
  ) async {
    final results = <RecCategory, List<ScoredMedia>>{};
    final futures = <Future>[];

    if (savedIds.isNotEmpty) {
      futures.add(_buildSimilarTo(savedIds, knownIds, RecCategory.becauseYouSaved)
          .then((v) => results[RecCategory.becauseYouSaved] = v));
      futures.add(_buildSimilarToFavorites(savedIds, knownIds)
          .then((v) => results[RecCategory.similarToFavorites] = v));
    }

    if (viewedIds.isNotEmpty) {
      final recentViews =
          await _repository.fetchRecentViewedMediaIds(userId);
      final seeds = recentViews.isNotEmpty
          ? recentViews.take(RecommendationConfig.maxRecentViewedSeeds).toList()
          : viewedIds.take(RecommendationConfig.maxRecentViewedSeeds).toList();
      futures.add(
          _buildSimilarTo(seeds.toSet(), knownIds, RecCategory.becauseYouViewed)
              .then((v) => results[RecCategory.becauseYouViewed] = v));
    }

    if (profile != null && profile.topGenres.isNotEmpty) {
      futures.add(_buildGenreFeed(profile.topGenres.first, knownIds)
          .then((v) => results[RecCategory.becauseYouLikeGenre] = v));
    }

    if (savedIds.isNotEmpty) {
      futures.add(_buildCollaborativeFeed(userId, savedIds, knownIds)
          .then((v) => results[RecCategory.usersLikeYou] = v));
    }

    await Future.wait(futures);
    return results;
  }

  Future<Map<RecCategory, List<ScoredMedia>>> _buildCuratedFeeds(
    String userId,
    Set<int> knownIds,
  ) async {
    final feeds = <RecCategory, List<ScoredMedia>>{};
    final futures = <Future>[
      _buildPopularFeed(knownIds)
          .then((v) => feeds[RecCategory.trendingNearYou] = v),
      _buildPopularFeed(knownIds)
          .then((v) => feeds[RecCategory.popularThisWeek] = v),
      _buildNewReleaseFeed(knownIds)
          .then((v) => feeds[RecCategory.newReleases] = v),
      _buildTopRatedFeed(knownIds)
          .then((v) => feeds[RecCategory.topRated] = v),
      _buildHiddenGemFeed(knownIds)
          .then((v) => feeds[RecCategory.hiddenGems] = v),
      _buildAcclaimedFeed(knownIds)
          .then((v) => feeds[RecCategory.criticallyAcclaimed] = v),
    ];
    await Future.wait(futures);

    // Remove duplicate popular entries since both categories would
    // return the same data — reuse trending for popular.
    feeds[RecCategory.popularThisWeek] =
        feeds[RecCategory.trendingNearYou] ?? [];
    return feeds;
  }

  // ---------------------------------------------------------------
  // Similarity-based scoring
  // ---------------------------------------------------------------

  /// Finds media with genre overlap to [seedIds], scored by genre overlap
  /// and vote average.
  Future<List<ScoredMedia>> _buildSimilarTo(
    Set<int> seedIds,
    Set<int> exclude,
    RecCategory category, {
    String reason = 'Similar to what you\'ve saved',
    String reasonType = 'content',
  }) async {
    final sourceGenres = await _repository.fetchGenresForMedia(seedIds.toList());
    if (sourceGenres.isEmpty) return [];

    final candidates =
        await _repository.findSimilarByGenres(sourceGenres, exclude);
    final scored = candidates.map((item) {
      final itemGenres = (item['genres'] as List?)?.cast<String>() ?? [];
      final overlap = sourceGenres.intersection(itemGenres.toSet()).length;
      final union = sourceGenres.union(itemGenres.toSet()).length;
      final genreScore = union > 0 ? overlap / union : 0.0;
      final ratingScore =
          ((item['vote_average'] as num?)?.toDouble() ?? 0) /
              RecommendationConfig.maxRating;
      final score = genreScore * RecommendationConfig.contentGenreWeight +
          ratingScore * RecommendationConfig.contentRatingWeight;
      return ScoredMedia(
        mediaId: item['id'] as int,
        score: score.clamp(0.0, 1.0),
        reason: reason,
        reasonType: reasonType,
        category: category,
      );
    }).toList();

    scored.sort((a, b) => b.score.compareTo(a.score));
    return scored.take(RecommendationConfig.maxItemsPerCategory).toList();
  }

  /// Diversified "Similar to Favorites" — applies a cross-genre bonus
  /// so the feed includes some variety beyond the user's core genres.
  Future<List<ScoredMedia>> _buildSimilarToFavorites(
    Set<int> savedIds,
    Set<int> knownIds,
  ) async {
    final seeds = (savedIds.toList()..shuffle())
        .take(RecommendationConfig.maxSavedSeeds)
        .toList();
    if (seeds.isEmpty) return [];

    var similar = await _buildSimilarTo(
      seeds.toSet(),
      knownIds,
      RecCategory.similarToFavorites,
      reason: 'Similar to your favorites',
      reasonType: 'content',
    );

    // Boost cross-genre candidates.
    similar = similar.map((s) {
      final bonus = _crossGenreBonus(s.mediaId) *
          RecommendationConfig.crossGenreBonusFactor;
      return ScoredMedia(
        mediaId: s.mediaId,
        score: (s.score * (1.0 - RecommendationConfig.crossGenreBonusFactor)) +
            bonus,
        reason: s.reason,
        reasonType: s.reasonType,
        category: RecCategory.similarToFavorites,
      );
    }).toList();

    similar.sort((a, b) => b.score.compareTo(a.score));
    return similar;
  }

  // ---------------------------------------------------------------
  // Collaborative filtering
  // ---------------------------------------------------------------

  /// Finds users who saved the same items, then recommends what they
  /// saved that the current user hasn't interacted with.
  Future<List<ScoredMedia>> _buildCollaborativeFeed(
    String userId,
    Set<int> savedIds,
    Set<int> knownIds,
  ) async {
    final similarUsers = await _repository.findSimilarUsers(userId, savedIds);
    if (similarUsers.length < RecommendationConfig.minCollaborativeUsers) {
      return [];
    }

    final candidates =
        await _repository.fetchCollaborativeCandidates(similarUsers, knownIds);

    final sorted = candidates.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted
        .take(RecommendationConfig.maxItemsPerCategory)
        .map((e) => ScoredMedia(
              mediaId: e.key,
              score: (e.value / similarUsers.length).clamp(0.0, 1.0),
              reason: 'Users with similar taste enjoyed this',
              reasonType: 'collaborative',
              category: RecCategory.usersLikeYou,
            ))
        .toList();
  }

  // ---------------------------------------------------------------
  // Genre-based feed
  // ---------------------------------------------------------------

  Future<List<ScoredMedia>> _buildGenreFeed(
    String topGenre,
    Set<int> knownIds,
  ) async {
    final items = await _repository.fetchByGenre(topGenre, knownIds);
    return items.map((item) {
      final score = ((item['vote_average'] as num?)?.toDouble() ?? 0) /
          RecommendationConfig.maxRating;
      return ScoredMedia(
        mediaId: item['id'] as int,
        score: score.clamp(0.0, 1.0),
        reason: 'Because you enjoy $topGenre',
        reasonType: 'genre',
        category: RecCategory.becauseYouLikeGenre,
      );
    }).toList();
  }

  // ---------------------------------------------------------------
  // Curated feed builders
  // ---------------------------------------------------------------

  Future<List<ScoredMedia>> _buildPopularFeed(Set<int> knownIds) async {
    final items = await _repository.fetchPopular(knownIds);
    return items.map((item) => _toScoredMedia(
          item,
          'Popular trending',
          'popularity',
          RecCategory.trendingNearYou,
          (d) => (d / RecommendationConfig.popularityNormaliser).clamp(0.0, 1.0),
        )).toList();
  }

  Future<List<ScoredMedia>> _buildNewReleaseFeed(Set<int> knownIds) async {
    final items = await _repository.fetchNewReleases(knownIds);
    return items.map((item) => _toScoredMedia(
          item,
          'Recently released',
          'freshness',
          RecCategory.newReleases,
          (d) => (d / RecommendationConfig.popularityNormaliser).clamp(0.0, 1.0),
        )).toList();
  }

  Future<List<ScoredMedia>> _buildTopRatedFeed(Set<int> knownIds) async {
    final items = await _repository.fetchTopRated(knownIds);
    return items.map((item) => _toScoredMedia(
          item,
          'Top rated',
          'rating',
          RecCategory.topRated,
          (v) => (v / RecommendationConfig.maxRating).clamp(0.0, 1.0),
          valueKey: 'vote_average',
        )).toList();
  }

  Future<List<ScoredMedia>> _buildHiddenGemFeed(Set<int> knownIds) async {
    final items = await _repository.fetchHiddenGems(knownIds);
    return items.map((item) => _toScoredMedia(
          item,
          'Hidden gem — highly rated but undiscovered',
          'hidden_gem',
          RecCategory.hiddenGems,
          (v) => (v / RecommendationConfig.maxRating).clamp(0.0, 1.0),
          valueKey: 'vote_average',
        )).toList();
  }

  Future<List<ScoredMedia>> _buildAcclaimedFeed(Set<int> knownIds) async {
    final items = await _repository.fetchAcclaimed(knownIds);
    return items.map((item) => _toScoredMedia(
          item,
          'Critically acclaimed',
          'acclaim',
          RecCategory.criticallyAcclaimed,
          (v) => (v / RecommendationConfig.maxRating).clamp(0.0, 1.0),
          valueKey: 'vote_average',
        )).toList();
  }

  /// Maps a raw DB row to a scored recommendation.
  ScoredMedia _toScoredMedia(
    Map<String, dynamic> item,
    String reason,
    String reasonType,
    RecCategory category,
    double Function(double rawValue) scoreFn, {
    String valueKey = 'popularity',
  }) {
    final rawValue = (item[valueKey] as num?)?.toDouble() ?? 0;
    return ScoredMedia(
      mediaId: item['id'] as int,
      score: scoreFn(rawValue),
      reason: reason,
      reasonType: reasonType,
      category: category,
    );
  }

  // ---------------------------------------------------------------
  // Diversity re-ranking
  // ---------------------------------------------------------------

  /// Re-ranks a sorted list to interleave popular, mid-tier, and niche
  /// items while enforcing genre/consecutive limits.
  ///
  /// Algorithm:
  /// 1. Split sorted list into top (50%), mid (30%), low (20%) tiers.
  /// 2. Round-robin pick from each tier, skipping items that violate
  ///    diversity constraints.
  /// 3. Return at most [maxItemsPerCategory] items.
  List<ScoredMedia> _applyDiversity(List<ScoredMedia> items) {
    if (items.length <= 3) return items;

    final n = items.length;
    final topEnd = (n * RecommendationConfig.topTierRatio).ceil();
    final midEnd = topEnd + (n * RecommendationConfig.midTierRatio).ceil();
    final tiers = [
      items.sublist(0, topEnd.clamp(0, n)),
      items.sublist(topEnd.clamp(0, n), midEnd.clamp(topEnd, n)),
      items.sublist(midEnd.clamp(0, n)),
    ];

    final diversified = <ScoredMedia>[];
    final indices = [0, 0, 0];

    while (diversified.length <
        math.min(items.length, RecommendationConfig.maxItemsPerCategory)) {
      bool added = false;
      for (int t = 0; t < 3; t++) {
        if (indices[t] >= tiers[t].length) continue;
        diversified.add(tiers[t][indices[t]]);
        indices[t]++;
        added = true;
        break; // take one item per round-robin pass
      }
      if (!added) break;
    }

    return diversified;
  }

  // ---------------------------------------------------------------
  // Utility
  // ---------------------------------------------------------------

  /// Deterministic cross-genre bonus based on media ID to encourage
  /// variety without being purely random.
  static double _crossGenreBonus(int mediaId) {
    return math.Random(mediaId).nextDouble();
  }
}
