/// Plain data classes for offline caching.
///
/// These were originally Isar @collection classes, but isar_generator
/// conflicts with riverpod_generator (incompatible source_gen versions).
/// They are now used as plain Dart data classes with an in-memory Map cache.
///
/// TODO: Migrate to drift or sqflite for proper persistence.

class CachedUserMedia {
  int id = 0;
  String remoteId = '';
  int mediaId = 0;
  String userId = '';
  String mediaType = '';
  String status = '';
  int seasonProgress = 0;
  int episodeProgress = 0;
  int totalEpisodes = 0;
  int rewatchCount = 0;
  double? userRating;
  DateTime? startedAt;
  DateTime? completedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
}

class CachedMedia {
  int id = 0;
  int remoteId = 0;
  String mediaType = '';
  String title = '';
  String? originalTitle;
  String? overview;
  String? posterPath;
  String? backdropPath;
  String? trailerUrl;
  double? voteAverage;
  int? voteCount;
  double popularity = 0;
  DateTime? releaseDate;
  int? runtime;
  List<String> genres = [];
  List<String> countries = [];
  String? status;
  String? language;
  bool? adult;
  bool isCustom = false;
  int totalEpisodes = 0;
  int totalSeasons = 0;
  DateTime? createdAt;
  DateTime? updatedAt;
}

class CachedUserList {
  int id = 0;
  String remoteId = '';
  String userId = '';
  String title = '';
  String? description;
  String listType = 'public';
  bool isPinned = false;
  List<String> tags = [];
  DateTime? createdAt;
  DateTime? updatedAt;
  int itemCount = 0;
  int likesCount = 0;
}
