/// Plain data classes for offline caching backed by SQLite.
///
/// Each class provides [toMap] for database inserts and [fromMap] for reads.
library;

class CachedUserMedia {
  CachedUserMedia({
    this.id = 0,
    this.remoteId = '',
    this.mediaId = 0,
    this.userId = '',
    this.mediaType = '',
    this.status = '',
    this.seasonProgress = 0,
    this.episodeProgress = 0,
    this.totalEpisodes = 0,
    this.rewatchCount = 0,
    this.userRating,
    this.startedAt,
    this.completedAt,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String remoteId;
  int mediaId;
  String userId;
  String mediaType;
  String status;
  int seasonProgress;
  int episodeProgress;
  int totalEpisodes;
  int rewatchCount;
  double? userRating;
  DateTime? startedAt;
  DateTime? completedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  Map<String, dynamic> toMap() => {
    'remote_id': remoteId,
    'media_id': mediaId,
    'user_id': userId,
    'media_type': mediaType,
    'status': status,
    'season_progress': seasonProgress,
    'episode_progress': episodeProgress,
    'total_episodes': totalEpisodes,
    'rewatch_count': rewatchCount,
    'user_rating': userRating,
    'started_at': startedAt?.toIso8601String(),
    'completed_at': completedAt?.toIso8601String(),
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  factory CachedUserMedia.fromMap(Map<String, dynamic> map) => CachedUserMedia(
    id: map['id'] as int? ?? 0,
    remoteId: map['remote_id'] as String? ?? '',
    mediaId: map['media_id'] as int? ?? 0,
    userId: map['user_id'] as String? ?? '',
    mediaType: map['media_type'] as String? ?? '',
    status: map['status'] as String? ?? '',
    seasonProgress: map['season_progress'] as int? ?? 0,
    episodeProgress: map['episode_progress'] as int? ?? 0,
    totalEpisodes: map['total_episodes'] as int? ?? 0,
    rewatchCount: map['rewatch_count'] as int? ?? 0,
    userRating: (map['user_rating'] as num?)?.toDouble(),
    startedAt: map['started_at'] != null
        ? DateTime.tryParse(map['started_at'] as String)
        : null,
    completedAt: map['completed_at'] != null
        ? DateTime.tryParse(map['completed_at'] as String)
        : null,
    createdAt: map['created_at'] != null
        ? DateTime.tryParse(map['created_at'] as String)
        : null,
    updatedAt: map['updated_at'] != null
        ? DateTime.tryParse(map['updated_at'] as String)
        : null,
  );
}

class CachedMedia {
  CachedMedia({
    this.id = 0,
    this.remoteId = 0,
    this.mediaType = '',
    this.title = '',
    this.originalTitle,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.trailerUrl,
    this.voteAverage,
    this.voteCount,
    this.popularity = 0,
    this.releaseDate,
    this.runtime,
    this.genres = const [],
    this.countries = const [],
    this.status,
    this.language,
    this.adult,
    this.isCustom = false,
    this.totalEpisodes = 0,
    this.totalSeasons = 0,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int remoteId;
  String mediaType;
  String title;
  String? originalTitle;
  String? overview;
  String? posterPath;
  String? backdropPath;
  String? trailerUrl;
  double? voteAverage;
  int? voteCount;
  double popularity;
  DateTime? releaseDate;
  int? runtime;
  List<String> genres;
  List<String> countries;
  String? status;
  String? language;
  bool? adult;
  bool isCustom;
  int totalEpisodes;
  int totalSeasons;
  DateTime? createdAt;
  DateTime? updatedAt;

  Map<String, dynamic> toMap() => {
    'remote_id': remoteId,
    'media_type': mediaType,
    'title': title,
    'original_title': originalTitle,
    'overview': overview,
    'poster_path': posterPath,
    'backdrop_path': backdropPath,
    'trailer_url': trailerUrl,
    'vote_average': voteAverage,
    'vote_count': voteCount,
    'popularity': popularity,
    'release_date': releaseDate?.toIso8601String(),
    'runtime': runtime,
    'genres': genres.join(','),
    'countries': countries.join(','),
    'status': status,
    'language': language,
    'adult': adult == true ? 1 : 0,
    'is_custom': isCustom ? 1 : 0,
    'total_episodes': totalEpisodes,
    'total_seasons': totalSeasons,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  factory CachedMedia.fromMap(Map<String, dynamic> map) => CachedMedia(
    id: map['id'] as int? ?? 0,
    remoteId: map['remote_id'] as int? ?? 0,
    mediaType: map['media_type'] as String? ?? '',
    title: map['title'] as String? ?? '',
    originalTitle: map['original_title'] as String?,
    overview: map['overview'] as String?,
    posterPath: map['poster_path'] as String?,
    backdropPath: map['backdrop_path'] as String?,
    trailerUrl: map['trailer_url'] as String?,
    voteAverage: (map['vote_average'] as num?)?.toDouble(),
    voteCount: map['vote_count'] as int?,
    popularity: (map['popularity'] as num?)?.toDouble() ?? 0,
    releaseDate: map['release_date'] != null
        ? DateTime.tryParse(map['release_date'] as String)
        : null,
    runtime: map['runtime'] as int?,
    genres:
        (map['genres'] as String?)
            ?.split(',')
            .where((s) => s.isNotEmpty)
            .toList() ??
        [],
    countries:
        (map['countries'] as String?)
            ?.split(',')
            .where((s) => s.isNotEmpty)
            .toList() ??
        [],
    status: map['status'] as String?,
    language: map['language'] as String?,
    adult: (map['adult'] as int?) == 1,
    isCustom: (map['is_custom'] as int?) == 1,
    totalEpisodes: map['total_episodes'] as int? ?? 0,
    totalSeasons: map['total_seasons'] as int? ?? 0,
    createdAt: map['created_at'] != null
        ? DateTime.tryParse(map['created_at'] as String)
        : null,
    updatedAt: map['updated_at'] != null
        ? DateTime.tryParse(map['updated_at'] as String)
        : null,
  );
}

class CachedUserList {
  CachedUserList({
    this.id = 0,
    this.remoteId = '',
    this.userId = '',
    this.title = '',
    this.description,
    this.listType = 'public',
    this.isPinned = false,
    this.tags = const [],
    this.createdAt,
    this.updatedAt,
    this.itemCount = 0,
    this.likesCount = 0,
  });

  int id;
  String remoteId;
  String userId;
  String title;
  String? description;
  String listType;
  bool isPinned;
  List<String> tags;
  DateTime? createdAt;
  DateTime? updatedAt;
  int itemCount;
  int likesCount;

  Map<String, dynamic> toMap() => {
    'remote_id': remoteId,
    'user_id': userId,
    'title': title,
    'description': description,
    'list_type': listType,
    'is_pinned': isPinned ? 1 : 0,
    'tags': tags.join(','),
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'item_count': itemCount,
    'likes_count': likesCount,
  };

  factory CachedUserList.fromMap(Map<String, dynamic> map) => CachedUserList(
    id: map['id'] as int? ?? 0,
    remoteId: map['remote_id'] as String? ?? '',
    userId: map['user_id'] as String? ?? '',
    title: map['title'] as String? ?? '',
    description: map['description'] as String?,
    listType: map['list_type'] as String? ?? 'public',
    isPinned: (map['is_pinned'] as int?) == 1,
    tags:
        (map['tags'] as String?)
            ?.split(',')
            .where((s) => s.isNotEmpty)
            .toList() ??
        [],
    createdAt: map['created_at'] != null
        ? DateTime.tryParse(map['created_at'] as String)
        : null,
    updatedAt: map['updated_at'] != null
        ? DateTime.tryParse(map['updated_at'] as String)
        : null,
    itemCount: map['item_count'] as int? ?? 0,
    likesCount: map['likes_count'] as int? ?? 0,
  );
}
