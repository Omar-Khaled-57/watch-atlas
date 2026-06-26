import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/tmdb_service.dart';
import '../../../models/media_model.dart';
import '../../../models/user_media_model.dart';
import '../../../core/models/media_enums.dart';
import '../../tracking/providers/tracking_providers.dart';

final _tmdbService = TmdbService.instance;

class ContinueWatchingData {
  final UserMediaModel userMedia;
  final MediaModel media;
  const ContinueWatchingData({required this.userMedia, required this.media});
}

final trendingProvider = FutureProvider<List<MediaModel>>((ref) async {
  final moviesJson = await _tmdbService.trendingMovies();
  final tvJson = await _tmdbService.trendingTv();

  final movies = _tmdbResultsToMediaModels(
    moviesJson['results'] as List<dynamic>,
    MediaType.movie,
  );
  final tv = _tmdbResultsToMediaModels(
    tvJson['results'] as List<dynamic>,
    MediaType.tv,
  );

  final combined = [...movies, ...tv];
  combined.sort((a, b) => b.popularity.compareTo(a.popularity));
  return combined.take(20).toList();
});

final continueWatchingProvider = FutureProvider<List<ContinueWatchingData>>((ref) async {
  final userMediaList = ref.watch(userMediaByStatusProvider(WatchStatus.watching));
  if (userMediaList.isEmpty) return [];

  final results = <ContinueWatchingData>[];
  for (final um in userMediaList) {
    try {
      final json = um.mediaType == MediaType.tv
          ? await _tmdbService.tvDetails(um.mediaId)
          : await _tmdbService.movieDetails(um.mediaId);
      final media = _jsonToMediaModel(json, um.mediaType);
      results.add(ContinueWatchingData(userMedia: um, media: media));
    } catch (_) {}
  }
  return results;
});

final popularThisWeekProvider = FutureProvider<List<MediaModel>>((ref) async {
  final moviesJson = await _tmdbService.popularMovies();
  final tvJson = await _tmdbService.popularTv();

  final movies = _tmdbResultsToMediaModels(
    moviesJson['results'] as List<dynamic>,
    MediaType.movie,
  );
  final tv = _tmdbResultsToMediaModels(
    tvJson['results'] as List<dynamic>,
    MediaType.tv,
  );

  final combined = [...movies, ...tv];
  combined.sort((a, b) => b.popularity.compareTo(a.popularity));
  return combined.take(20).toList();
});

final recentlyAddedProvider = FutureProvider<List<MediaModel>>((ref) async {
  final json = await _tmdbService.nowPlaying();

  return _tmdbResultsToMediaModels(
    json['results'] as List<dynamic>,
    MediaType.movie,
  );
});

final upcomingReleasesProvider = FutureProvider<List<MediaModel>>((ref) async {
  final json = await _tmdbService.upcoming();

  return _tmdbResultsToMediaModels(
    json['results'] as List<dynamic>,
    MediaType.movie,
  );
});

final recommendedProvider = FutureProvider<List<MediaModel>>((ref) async {
  final json = await _tmdbService.popularTv();

  return _tmdbResultsToMediaModels(
    json['results'] as List<dynamic>,
    MediaType.tv,
  );
});

List<MediaModel> _tmdbResultsToMediaModels(
  List<dynamic> results,
  MediaType type,
) {
  return results.map((json) => _jsonToMediaModel(json as Map<String, dynamic>, type)).toList();
}

MediaModel _jsonToMediaModel(Map<String, dynamic> map, MediaType type) {
  return MediaModel(
    id: map['id'] as int,
    mediaType: type,
    title: (map['title'] ?? map['name'] ?? '') as String,
    overview: map['overview'] as String?,
    posterPath: map['poster_path'] as String?,
    backdropPath: map['backdrop_path'] as String?,
    voteAverage: (map['vote_average'] as num?)?.toDouble(),
    voteCount: map['vote_count'] as int?,
    popularity: (map['popularity'] as num?)?.toDouble() ?? 0,
    releaseDate: _parseDate(
      map['release_date'] as String? ?? map['first_air_date'] as String?,
    ),
    language: map['original_language'] as String?,
    adult: map['adult'] as bool?,
  );
}

final homeSearchQueryProvider = StateProvider<String>((ref) => '');

final homeSearchResultsProvider = FutureProvider<List<MediaModel>>((ref) async {
  final query = ref.watch(homeSearchQueryProvider);
  if (query.trim().length < 2) return [];

  try {
    final results = await _tmdbService.search(query, page: 1);
    return results.map((json) {
      final map = json as Map<String, dynamic>;
      return MediaModel(
        id: map['id'] as int,
        mediaType: _parseSearchMediaType(map['media_type'] as String?),
        title: map['title'] as String? ?? map['name'] as String? ?? '',
        originalTitle: map['original_title'] as String? ?? map['original_name'] as String?,
        overview: map['overview'] as String?,
        posterPath: map['poster_path'] as String?,
        backdropPath: map['backdrop_path'] as String?,
        voteAverage: (map['vote_average'] as num?)?.toDouble(),
        voteCount: map['vote_count'] as int?,
        popularity: (map['popularity'] as num?)?.toDouble() ?? 0,
        releaseDate: _parseDate(map['release_date'] as String?),
        language: map['original_language'] as String?,
        adult: map['adult'] as bool?,
      );
    }).toList();
  } catch (e) {
    return [];
  }
});

MediaType _parseSearchMediaType(String? type) {
  switch (type) {
    case 'movie':
      return MediaType.movie;
    case 'tv':
      return MediaType.tv;
    case 'person':
      return MediaType.custom;
    default:
      return MediaType.movie;
  }
}

DateTime? _parseDate(String? dateStr) {
  if (dateStr == null || dateStr.isEmpty) return null;
  return DateTime.tryParse(dateStr);
}
