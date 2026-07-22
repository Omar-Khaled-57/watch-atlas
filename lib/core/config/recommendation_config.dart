/// Configuration for the recommendation engine.
///
/// All tunable weights, limits, and thresholds are defined here
/// so the system can be calibrated without code changes.
class RecommendationConfig {
  const RecommendationConfig._();

  // ---------------------------------------------------------------
  // Hybrid score weights (must sum to 1.0)
  // ---------------------------------------------------------------

  /// Weight applied to direct user behavior signals (saves, views, etc.)
  static const double behaviorWeight = 0.45;

  /// Weight applied to content-similarity scoring
  static const double contentWeight = 0.30;

  /// Weight applied to collaborative filtering signals
  static const double collaborativeWeight = 0.20;

  /// Weight applied to demographic personalisation
  static const double demographicWeight = 0.05;

  // ---------------------------------------------------------------
  // Query limits
  // ---------------------------------------------------------------

  /// Max media items returned per recommendation category
  static const int maxItemsPerCategory = 20;

  /// Max items fetched from DB for intermediate scoring
  static const int dbFetchLimit = 50;

  /// Max recent view events to consider for "Because You Viewed"
  static const int maxRecentViewedSeeds = 5;

  /// Max saved items used as seeds for content similarity
  static const int maxSavedSeeds = 3;

  /// Max similar users to consider in collaborative filtering
  static const int maxCollaborativeUsers = 20;

  /// Min similarity users needed to produce collaborative results
  static const int minCollaborativeUsers = 1;

  /// Max collaborative candidate media
  static const int maxCollaborativeCandidates = 50;

  // ---------------------------------------------------------------
  // Score blending
  // ---------------------------------------------------------------

  /// Genre-overlap weight in content similarity score
  static const double contentGenreWeight = 0.7;

  /// Rating-score weight in content similarity score
  static const double contentRatingWeight = 0.3;

  /// Cross-genre diversity bonus factor
  static const double crossGenreBonusFactor = 0.1;

  // ---------------------------------------------------------------
  // Popularity / rating thresholds for curated feeds
  // ---------------------------------------------------------------

  /// Minimum vote average for "Top Rated" inclusion
  static const double topRatedMinVoteAverage = 7.0;

  /// Minimum vote average for "Hidden Gems" inclusion
  static const double hiddenGemMinVoteAverage = 7.0;

  /// Maximum popularity for "Hidden Gems" inclusion  (low pop = undiscovered)
  static const double hiddenGemMaxPopularity = 20.0;

  /// Minimum vote average for "Critically Acclaimed" inclusion
  static const double acclaimedMinVoteAverage = 8.0;

  /// Minimum vote count for "Critically Acclaimed" inclusion
  static const int acclaimedMinVoteCount = 500;

  /// Days considered "new release"
  static const int newReleaseWindowDays = 90;

  // ---------------------------------------------------------------
  // Popuplarity scaling
  // ---------------------------------------------------------------

  /// Divides raw popularity to normalise into 0..1 range
  static const double popularityNormaliser = 100.0;

  /// Max rating value used in normalisation
  static const double maxRating = 10.0;

  // ---------------------------------------------------------------
  // Diversity constraints
  // ---------------------------------------------------------------

  /// Max items from the same franchise allowed per category
  static const int maxPerFranchise = 2;

  /// Max consecutive items sharing a genre
  static const int maxConsecutiveSameGenre = 3;

  /// Max consecutive items featuring the same lead actor
  static const int maxConsecutiveSameActor = 2;

  /// Interleave ratio: fraction of slots from the top-scoring tier
  static const double topTierRatio = 0.5;

  /// Interleave ratio: fraction of slots from the mid-scoring tier
  static const double midTierRatio = 0.3;

  /// Interleave ratio: fraction of slots from the low-scoring tier
  static const double lowTierRatio = 0.2;

  /// Target diversity proportion across all feeds (0..1)
  static const double diversityTarget = 0.30;

  // ---------------------------------------------------------------
  // Freshness decay
  // ---------------------------------------------------------------

  /// Days after which an interaction's boost is fully decayed
  static const double freshnessDecayDays = 90;

  // ---------------------------------------------------------------
  // Caching
  // ---------------------------------------------------------------

  /// TTL for cached recommendations in hours
  static const int cacheTtlHours = 24;

  /// Max rows per batch insert
  static const int cacheBatchSize = 20;
}
