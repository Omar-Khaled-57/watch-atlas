/// Types of user behaviour events tracked for recommendation signals.
enum EventType {
  mediaView,
  mediaViewDuration,
  mediaSave,
  mediaUnsave,
  mediaFavorite,
  mediaUnfavorite,
  mediaComplete,
  rating,
  search,
  genreBrowse,
  collectionOpen,
  filterApply,
  recommendationClick,
  recommendationDismiss,
  share,
  comment,
  listAdd,
  listRemove,
}

/// Categories of recommendation feeds displayed to the user.
///
/// Each category targets a different signal source (behaviour, content,
/// collaborative, or curated) and maps to a DB value and UI label.
enum RecCategory {
  becauseYouSaved('because_you_saved', 'Because You Saved...'),
  becauseYouViewed('because_you_viewed', 'Because You Viewed...'),
  trendingNearYou('trending_near_you', 'Trending Near You'),
  popularThisWeek('popular_this_week', 'Popular This Week'),
  continueExploring('continue_exploring', 'Continue Exploring'),
  newReleases('new_releases', 'New Releases'),
  hiddenGems('hidden_gems', 'Hidden Gems'),
  criticallyAcclaimed('critically_acclaimed', 'Critically Acclaimed'),
  topRated('top_rated', 'Top Rated'),
  similarToFavorites('similar_to_favorites', 'Similar to Your Favorites'),
  becauseYouLikeGenre('because_you_like_genre', 'Because You Like...'),
  friendsAlsoSaved('friends_also_saved', 'Friends Also Saved'),
  usersLikeYou('users_like_you', 'Users Like You Enjoyed'),
  awardWinners('award_winners', 'Award Winners'),
  underratedClassics('underrated_classics', 'Underrated Classics'),
  upcomingReleases('upcoming_releases', 'Upcoming Releases');

  final String dbValue;
  final String displayName;
  const RecCategory(this.dbValue, this.displayName);

  static RecCategory fromDb(String value) =>
      RecCategory.values.firstWhere((c) => c.dbValue == value);
}

/// A single recommendation result with hybrid score and explanation.
class ScoredMedia {
  final int mediaId;
  final double score;
  final String? reason;
  final String? reasonType;
  final RecCategory category;
  final bool isDismissed;

  const ScoredMedia({
    required this.mediaId,
    required this.score,
    this.reason,
    this.reasonType,
    required this.category,
    this.isDismissed = false,
  });

  factory ScoredMedia.fromJson(Map<String, dynamic> json) => ScoredMedia(
        mediaId: json['media_id'] as int,
        score: (json['score'] as num).toDouble(),
        reason: json['reason'] as String?,
        reasonType: json['reason_type'] as String?,
        category: RecCategory.fromDb(json['category'] as String),
        isDismissed: json['is_dismissed'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'media_id': mediaId,
        'score': score,
        'reason': reason,
        'reason_type': reasonType,
        'category': category.dbValue,
        'is_dismissed': isDismissed,
      };
}

/// A single user behaviour event recorded for recommendation signals.
class BehaviorEvent {
  final String? id;
  final String userId;
  final EventType eventType;
  final int? mediaId;
  final Map<String, dynamic> metadata;
  final String? device;
  final String? platform;
  final String? sessionId;
  final DateTime? createdAt;

  const BehaviorEvent({
    this.id,
    required this.userId,
    required this.eventType,
    this.mediaId,
    this.metadata = const {},
    this.device,
    this.platform,
    this.sessionId,
    this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'user_id': userId,
        'event_type': eventType.name,
        if (mediaId != null) 'media_id': mediaId,
        'metadata': metadata,
        if (device != null) 'device': device,
        if (platform != null) 'platform': platform,
        if (sessionId != null) 'session_id': sessionId,
        if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      };
}

/// Aggregated user interest profile computed from behaviour events.
///
/// Stored in `user_rec_profiles` table and updated periodically.
/// Used by the recommendation engine to personalise content-based scoring.
class UserRecProfile {
  final String userId;
  final Map<String, double> genreWeights;
  final Map<String, double> actorWeights;
  final Map<String, double> directorWeights;
  final Map<String, double> keywordWeights;
  final List<String> preferredLanguages;
  final List<String> preferredCountries;
  final double avgSessionDuration;
  final String preferredRuntime;
  final List<String> topGenres;
  final List<String> topActors;
  final List<String> topDirectors;
  final int diversitySeenCount;
  final DateTime? lastComputedAt;

  const UserRecProfile({
    required this.userId,
    this.genreWeights = const {},
    this.actorWeights = const {},
    this.directorWeights = const {},
    this.keywordWeights = const {},
    this.preferredLanguages = const [],
    this.preferredCountries = const [],
    this.avgSessionDuration = 0,
    this.preferredRuntime = 'any',
    this.topGenres = const [],
    this.topActors = const [],
    this.topDirectors = const [],
    this.diversitySeenCount = 0,
    this.lastComputedAt,
  });

  factory UserRecProfile.fromJson(Map<String, dynamic> json) => UserRecProfile(
        userId: json['user_id'] as String,
        genreWeights: Map<String, double>.from(
            (json['genre_weights'] as Map?)?.map((k, v) => MapEntry(k, (v as num).toDouble())) ?? {}),
        actorWeights: Map<String, double>.from(
            (json['actor_weights'] as Map?)?.map((k, v) => MapEntry(k, (v as num).toDouble())) ?? {}),
        directorWeights: Map<String, double>.from(
            (json['director_weights'] as Map?)?.map((k, v) => MapEntry(k, (v as num).toDouble())) ?? {}),
        keywordWeights: Map<String, double>.from(
            (json['keyword_weights'] as Map?)?.map((k, v) => MapEntry(k, (v as num).toDouble())) ?? {}),
        preferredLanguages: (json['preferred_languages'] as List?)?.cast<String>() ?? [],
        preferredCountries: (json['preferred_countries'] as List?)?.cast<String>() ?? [],
        avgSessionDuration: (json['avg_session_duration'] as num?)?.toDouble() ?? 0,
        preferredRuntime: json['preferred_runtime'] as String? ?? 'any',
        topGenres: (json['top_genres'] as List?)?.cast<String>() ?? [],
        topActors: (json['top_actors'] as List?)?.cast<String>() ?? [],
        topDirectors: (json['top_directors'] as List?)?.cast<String>() ?? [],
        diversitySeenCount: (json['diversity_seen_count'] as num?)?.toInt() ?? 0,
        lastComputedAt: json['last_computed_at'] != null
            ? DateTime.parse(json['last_computed_at'] as String)
            : null,
      );
}


