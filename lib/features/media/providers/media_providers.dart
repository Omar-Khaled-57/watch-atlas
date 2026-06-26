import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_providers.dart';
import '../../../models/media_model.dart';
import '../../../models/review_model.dart';
import '../../../core/models/media_enums.dart';

final mediaIdProvider = StateProvider<int?>((ref) => null);
final mediaTypeProvider = StateProvider<MediaType>((ref) => MediaType.movie);

final mediaDetailsProvider = FutureProvider<MediaModel>((ref) async {
  final mediaId = ref.watch(mediaIdProvider);
  final mediaType = ref.watch(mediaTypeProvider);
  if (mediaId == null) throw Exception('No media ID provided');

  if (mediaType == MediaType.anime) {
    return _animeDetails(mediaId, ref);
  }

  final tmdb = ref.watch(tmdbServiceProvider);
  final bool isTv = mediaType == MediaType.tv;
  final data = isTv ? await tmdb.tvDetails(mediaId) : await tmdb.movieDetails(mediaId);

  return MediaModel(
    id: data['id'] as int,
    mediaType: mediaType,
    title: _tmdbField(data, isTv, 'title', 'name'),
    originalTitle: _tmdbField(data, isTv, 'original_title', 'original_name'),
    overview: data['overview'] as String?,
    posterPath: data['poster_path'] as String?,
    backdropPath: data['backdrop_path'] as String?,
    trailerUrl: _extractTrailerUrl(data['videos'] as Map<String, dynamic>?),
    voteAverage: (data['vote_average'] as num?)?.toDouble(),
    voteCount: data['vote_count'] as int?,
    popularity: (data['popularity'] as num?)?.toDouble() ?? 0,
    releaseDate: _parseDateTv(data, isTv),
    runtime: data['runtime'] as int? ??
        (data['episode_run_time'] as List<dynamic>?)?.firstOrNull as int?,
    genres: (data['genres'] as List<dynamic>?)
        ?.map((g) => g['name'] as String)
        .toList(),
    countries: (data['production_countries'] as List<dynamic>?)
        ?.map((c) => c['name'] as String)
        .toList(),
    status: data['status'] as String?,
    language: (data['original_language'] as String?)?.toUpperCase(),
    totalEpisodes: (data['number_of_episodes'] as int?) ?? 0,
    totalSeasons: (data['number_of_seasons'] as int?) ?? 0,
  );
});

final mediaCreditsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final mediaId = ref.watch(mediaIdProvider);
  final mediaType = ref.watch(mediaTypeProvider);
  if (mediaId == null) throw Exception('No media ID provided');
  if (mediaType == MediaType.anime) return {'cast': [], 'crew': []};
  final tmdb = ref.watch(tmdbServiceProvider);
  final isTv = mediaType == MediaType.tv;
  final data = isTv ? await tmdb.tvDetails(mediaId) : await tmdb.movieDetails(mediaId);
  final credits = data['credits'] as Map<String, dynamic>? ?? {};
  return {
    'cast': (credits['cast'] as List<dynamic>?) ?? [],
    'crew': (credits['crew'] as List<dynamic>?) ?? [],
  };
});

final mediaRecommendationsProvider = FutureProvider<List<MediaModel>>((ref) async {
  final mediaId = ref.watch(mediaIdProvider);
  final mediaType = ref.watch(mediaTypeProvider);
  if (mediaId == null) throw Exception('No media ID provided');
  if (mediaType == MediaType.anime) return [];
  final tmdb = ref.watch(tmdbServiceProvider);
  final isTv = mediaType == MediaType.tv;
  final data = isTv ? await tmdb.tvDetails(mediaId) : await tmdb.movieDetails(mediaId);
  final recs = data['recommendations'] as Map<String, dynamic>? ?? {};
  final results = recs['results'] as List<dynamic>? ?? [];
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
  final mediaType = ref.watch(mediaTypeProvider);
  if (mediaId == null) throw Exception('No media ID provided');
  if (mediaType == MediaType.anime) return [];
  final tmdb = ref.watch(tmdbServiceProvider);
  final isTv = mediaType == MediaType.tv;
  final data = isTv ? await tmdb.tvDetails(mediaId) : await tmdb.movieDetails(mediaId);
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
  final mediaType = ref.watch(mediaTypeProvider);
  if (mediaId == null) throw Exception('No media ID provided');
  final tmdb = ref.watch(tmdbServiceProvider);
  try {
    final data = mediaType == MediaType.movie
        ? await tmdb.movieDetails(mediaId)
        : await tmdb.tvDetails(mediaId);
    final reviews = (data['reviews'] as Map<String, dynamic>?) ?? {};
    final results = (reviews['results'] as List<dynamic>?) ?? [];
    return results.map((r) {
      final json = r as Map<String, dynamic>;
      final author = json['author_details'] as Map<String, dynamic>? ?? {};
      return ReviewModel(
        id: json['id'] as String,
        mediaId: mediaId,
        userId: author['username'] as String? ?? json['author'] as String? ?? 'Anonymous',
        content: json['content'] as String? ?? '',
        rating: (author['rating'] as num?)?.toDouble(),
        createdAt: DateTime.tryParse(json['created_at'] as String? ?? ''),
      );
    }).toList();
  } catch (e) {
    debugPrint('Failed to fetch reviews: $e');
    return [];
  }
});

final mediaTrailersProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final mediaId = ref.watch(mediaIdProvider);
  final mediaType = ref.watch(mediaTypeProvider);
  if (mediaId == null) throw Exception('No media ID provided');
  final tmdb = ref.watch(tmdbServiceProvider);
  final bool isTv = mediaType == MediaType.tv;
  final data = isTv ? await tmdb.tvDetails(mediaId) : await tmdb.movieDetails(mediaId);
  final videos = data['videos'] as Map<String, dynamic>? ?? {};
  final results = videos['results'] as List<dynamic>? ?? [];
  return results
      .where((v) => (v['site'] as String?) == 'YouTube' && (v['type'] as String?) == 'Trailer')
      .map((v) => v as Map<String, dynamic>)
      .take(5)
      .toList();
});

Future<MediaModel> _animeDetails(int mediaId, Ref ref) async {
  final anilist = ref.read(anilistServiceProvider);
  final data = await anilist.animeDetails(mediaId);
  final titleData = data['title'] as Map<String, dynamic>? ?? {};
  return MediaModel(
    id: mediaId,
    mediaType: MediaType.anime,
    title: titleData['userPreferred'] as String? ??
        titleData['romaji'] as String? ??
        titleData['english'] as String? ??
        '',
    originalTitle: titleData['native'] as String?,
    romanizedTitle: titleData['romaji'] as String?,
    nativeTitle: titleData['native'] as String?,
    overview: _stripHtml(data['description'] as String?),
    posterPath: data['coverImage'] is Map
        ? (data['coverImage'] as Map)['large'] as String?
        : null,
    backdropPath: data['bannerImage'] as String?,
    voteAverage: (data['averageScore'] as num?)?.toDouble(),
    voteCount: data['favourites'] as int?,
    popularity: (data['popularity'] as num?)?.toDouble() ?? 0,
    releaseDate: _parseAnimeDate(data['startDate'] as Map<String, dynamic>?),
    runtime: data['duration'] as int?,
    genres: (data['genres'] as List<dynamic>?)?.cast<String>(),
    status: data['status'] as String?,
    language: data['countryOfOrigin'] as String?,
    totalEpisodes: data['episodes'] as int? ?? 0,
  );
}

String? _stripHtml(String? html) {
  if (html == null) return null;
  return html.replaceAll(RegExp(r'<[^>]*>'), '').replaceAll('&nbsp;', ' ').trim();
}

String _tmdbField(Map<String, dynamic> data, bool isTv, String movieKey, String tvKey) {
  return (data[isTv ? tvKey : movieKey] as String?) ?? '';
}

DateTime? _parseDateTv(Map<String, dynamic> data, bool isTv) {
  final dateStr = isTv ? data['first_air_date'] as String? : data['release_date'] as String?;
  if (dateStr == null) return null;
  return DateTime.tryParse(dateStr);
}

DateTime? _parseAnimeDate(Map<String, dynamic>? dateMap) {
  if (dateMap == null) return null;
  final year = dateMap['year'] as int?;
  final month = dateMap['month'] as int?;
  final day = dateMap['day'] as int?;
  if (year == null || month == null || day == null) return null;
  return DateTime(year, month, day);
}

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
