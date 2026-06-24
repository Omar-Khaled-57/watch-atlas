import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers/app_providers.dart';
import '../../../models/media_model.dart';
import '../../../models/review_model.dart';

final mediaIdProvider = StateProvider<int?>((ref) => null);

final mediaDetailsProvider = FutureProvider<MediaModel>((ref) async {
  final mediaId = ref.watch(mediaIdProvider);
  if (mediaId == null) throw Exception('No media ID provided');
  final tmdb = ref.watch(tmdbServiceProvider);
  final data = await tmdb.movieDetails(mediaId);
  return MediaModel(
    id: data['id'] as int,
    mediaType: MediaType.movie,
    title: data['title'] as String? ?? data['name'] as String? ?? '',
    originalTitle: data['original_title'] as String? ?? data['original_name'] as String?,
    overview: data['overview'] as String?,
    posterPath: data['poster_path'] as String?,
    backdropPath: data['backdrop_path'] as String?,
    trailerUrl: _extractTrailerUrl(data['videos'] as Map<String, dynamic>?),
    voteAverage: (data['vote_average'] as num?)?.toDouble(),
    voteCount: data['vote_count'] as int?,
    popularity: (data['popularity'] as num?)?.toDouble() ?? 0,
    releaseDate: _parseDate(data['release_date'] as String?),
    runtime: data['runtime'] as int?,
    genres: (data['genres'] as List<dynamic>?)
        ?.map((g) => g['name'] as String)
        .toList(),
    countries: (data['production_countries'] as List<dynamic>?)
        ?.map((c) => c['name'] as String)
        .toList(),
    status: data['status'] as String?,
    language: (data['original_language'] as String?)?.toUpperCase(),
  );
});

final mediaCreditsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final mediaId = ref.watch(mediaIdProvider);
  if (mediaId == null) throw Exception('No media ID provided');
  final tmdb = ref.watch(tmdbServiceProvider);
  final data = await tmdb.movieDetails(mediaId);
  final credits = data['credits'] as Map<String, dynamic>? ?? {};
  return {
    'cast': (credits['cast'] as List<dynamic>?) ?? [],
    'crew': (credits['crew'] as List<dynamic>?) ?? [],
  };
});

final mediaRecommendationsProvider = FutureProvider<List<MediaModel>>((ref) async {
  final mediaId = ref.watch(mediaIdProvider);
  if (mediaId == null) throw Exception('No media ID provided');
  final tmdb = ref.watch(tmdbServiceProvider);
  final data = await tmdb.movieDetails(mediaId);
  final recommendations = data['recommendations'] as Map<String, dynamic>? ?? {};
  final results = recommendations['results'] as List<dynamic>? ?? [];
  return results.map((json) {
    return MediaModel(
      id: json['id'] as int,
      mediaType: MediaType.movie,
      title: json['title'] as String? ?? json['name'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
    );
  }).toList();
});

final similarMediaProvider = FutureProvider<List<MediaModel>>((ref) async {
  final mediaId = ref.watch(mediaIdProvider);
  if (mediaId == null) throw Exception('No media ID provided');
  final tmdb = ref.watch(tmdbServiceProvider);
  final data = await tmdb.movieDetails(mediaId);
  final similar = data['similar'] as Map<String, dynamic>? ?? {};
  final results = similar['results'] as List<dynamic>? ?? [];
  return results.map((json) {
    return MediaModel(
      id: json['id'] as int,
      mediaType: MediaType.movie,
      title: json['title'] as String? ?? json['name'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
    );
  }).toList();
});

final mediaReviewsProvider = FutureProvider<List<ReviewModel>>((ref) async {
  final mediaId = ref.watch(mediaIdProvider);
  if (mediaId == null) throw Exception('No media ID provided');
  return [];
});

final mediaTrailersProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final mediaId = ref.watch(mediaIdProvider);
  if (mediaId == null) throw Exception('No media ID provided');
  final tmdb = ref.watch(tmdbServiceProvider);
  final data = await tmdb.movieDetails(mediaId);
  final videos = data['videos'] as Map<String, dynamic>? ?? {};
  final results = videos['results'] as List<dynamic>? ?? [];
  return results
      .where((v) => (v['site'] as String?) == 'YouTube' && (v['type'] as String?) == 'Trailer')
      .map((v) => v as Map<String, dynamic>)
      .take(5)
      .toList();
});

DateTime? _parseDate(String? dateStr) {
  if (dateStr == null) return null;
  return DateTime.tryParse(dateStr);
}

String? _extractTrailerUrl(Map<String, dynamic>? videos) {
  if (videos == null) return null;
  final results = videos['results'] as List<dynamic>? ?? [];
  for (final v in results) {
    if ((v['site'] as String?) == 'YouTube' && (v['type'] as String?) == 'Trailer') {
      final key = v['key'] as String?;
      if (key != null) return 'https://www.youtube.com/watch?v=$key';
    }
  }
  return null;
}
