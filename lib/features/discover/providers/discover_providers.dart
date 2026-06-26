import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/anilist_service.dart';
import '../../../core/services/tmdb_service.dart';
import '../../../models/media_model.dart';
import '../../../core/models/media_enums.dart';

enum DiscoverMediaTab { movies, tv, anime }

class Genre {
  final int id;
  final String name;

  const Genre({required this.id, required this.name});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Genre && runtimeType == other.runtimeType && id == other.id && name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}

class DiscoverFilters {
  final DiscoverMediaTab tab;
  final int? genreId;
  final String? country;
  final int? yearFrom;
  final int? yearTo;
  final double? ratingFrom;
  final double? ratingTo;
  final String? searchQuery;

  const DiscoverFilters({
    this.tab = DiscoverMediaTab.movies,
    this.genreId,
    this.country,
    this.yearFrom,
    this.yearTo,
    this.ratingFrom,
    this.ratingTo,
    this.searchQuery,
  });

  DiscoverFilters copyWith({
    DiscoverMediaTab? tab,
    Object? genreId = _sentinel,
    Object? country = _sentinel,
    Object? yearFrom = _sentinel,
    Object? yearTo = _sentinel,
    Object? ratingFrom = _sentinel,
    Object? ratingTo = _sentinel,
    Object? searchQuery = _sentinel,
  }) {
    return DiscoverFilters(
      tab: tab ?? this.tab,
      genreId: _unwrap<int>(genreId, this.genreId),
      country: _unwrap<String>(country, this.country),
      yearFrom: _unwrap<int>(yearFrom, this.yearFrom),
      yearTo: _unwrap<int>(yearTo, this.yearTo),
      ratingFrom: _unwrap<double>(ratingFrom, this.ratingFrom),
      ratingTo: _unwrap<double>(ratingTo, this.ratingTo),
      searchQuery: _unwrap<String>(searchQuery, this.searchQuery),
    );
  }

  static const _sentinel = Object();

  static T? _unwrap<T>(Object? value, T? current) {
    if (value == _sentinel) return current;
    return value as T?;
  }

  DiscoverFilters clearAll() => const DiscoverFilters();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiscoverFilters &&
          runtimeType == other.runtimeType &&
          tab == other.tab &&
          genreId == other.genreId &&
          country == other.country &&
          yearFrom == other.yearFrom &&
          yearTo == other.yearTo &&
          ratingFrom == other.ratingFrom &&
          ratingTo == other.ratingTo &&
          searchQuery == other.searchQuery;

  @override
  int get hashCode =>
      tab.hashCode ^
      genreId.hashCode ^
      country.hashCode ^
      yearFrom.hashCode ^
      yearTo.hashCode ^
      ratingFrom.hashCode ^
      ratingTo.hashCode ^
      searchQuery.hashCode;
}

class DiscoverFilterNotifier extends Notifier<DiscoverFilters> {
  @override
  DiscoverFilters build() => const DiscoverFilters();

  void setTab(DiscoverMediaTab tab) => state = state.copyWith(tab: tab);
  void setGenreId(int? id) => state = state.copyWith(genreId: id);
  void setCountry(String? country) => state = state.copyWith(country: country);
  void setYearRange(int? from, int? to) =>
      state = state.copyWith(yearFrom: from, yearTo: to);
  void setRatingRange(double? from, double? to) =>
      state = state.copyWith(ratingFrom: from, ratingTo: to);
  void setSearchQuery(String? query) => state = state.copyWith(searchQuery: query);
  void clearAll() => state = state.clearAll();
}

final discoverFilterProvider =
    NotifierProvider<DiscoverFilterNotifier, DiscoverFilters>(
  DiscoverFilterNotifier.new,
);

final genreListProvider = FutureProvider<List<Genre>>((ref) async {
  final filters = ref.watch(discoverFilterProvider);
  final tmdb = TmdbService.instance;

  try {
    switch (filters.tab) {
      case DiscoverMediaTab.movies:
      case DiscoverMediaTab.anime:
        final data = await tmdb.genres();
        return _parseGenres(data);
      case DiscoverMediaTab.tv:
        final data = await tmdb.tvGenres();
        return _parseGenres(data);
    }
  } catch (_) {
    return [];
  }
});

List<Genre> _parseGenres(List<dynamic> data) {
  return data.map((g) {
    final map = g as Map<String, dynamic>;
    return Genre(id: map['id'] as int, name: map['name'] as String);
  }).toList();
}

Future<List<MediaModel>> fetchDiscoverPage({
  required int page,
  required DiscoverFilters filters,
  required AnilistService anilist,
}) async {
  switch (filters.tab) {
    case DiscoverMediaTab.anime:
      return _fetchAnimePage(page, filters, anilist);
    case DiscoverMediaTab.movies:
      return _fetchMoviePage(page, filters);
    case DiscoverMediaTab.tv:
      return _fetchTvPage(page, filters);
  }
}

Future<List<MediaModel>> _fetchMoviePage(
  int page,
  DiscoverFilters filters,
) async {
  final tmdb = TmdbService.instance;

  if (filters.searchQuery != null && filters.searchQuery!.isNotEmpty) {
    final json = await tmdb.searchMovie(filters.searchQuery!, page: page);
    return _tmdbResultsToMediaModels(
      json['results'] as List<dynamic>,
      MediaType.movie,
    );
  }

  final params = <String, dynamic>{
    'page': page,
    'sort_by': 'popularity.desc',
  };

  if (filters.genreId != null) {
    params['with_genres'] = filters.genreId.toString();
  }
  if (filters.country != null) {
    params['region'] = filters.country;
  }
  if (filters.yearFrom != null) {
    params['primary_release_date.gte'] = '${filters.yearFrom}-01-01';
  }
  if (filters.yearTo != null) {
    params['primary_release_date.lte'] = '${filters.yearTo}-12-31';
  }
  if (filters.ratingFrom != null) {
    params['vote_average.gte'] = filters.ratingFrom.toString();
  }
  if (filters.ratingTo != null) {
    params['vote_average.lte'] = filters.ratingTo.toString();
  }

  final json = await tmdb.discoverMovie(filters: params);
  return _tmdbResultsToMediaModels(
    json['results'] as List<dynamic>,
    MediaType.movie,
  );
}

Future<List<MediaModel>> _fetchTvPage(
  int page,
  DiscoverFilters filters,
) async {
  final tmdb = TmdbService.instance;

  if (filters.searchQuery != null && filters.searchQuery!.isNotEmpty) {
    final json = await tmdb.searchTv(filters.searchQuery!, page: page);
    return _tmdbResultsToMediaModels(
      json['results'] as List<dynamic>,
      MediaType.tv,
    );
  }

  final params = <String, dynamic>{
    'page': page,
    'sort_by': 'popularity.desc',
  };

  if (filters.genreId != null) {
    params['with_genres'] = filters.genreId.toString();
  }
  if (filters.country != null) {
    params['with_origin_country'] = filters.country;
  }
  if (filters.yearFrom != null) {
    params['first_air_date.gte'] = '${filters.yearFrom}-01-01';
  }
  if (filters.yearTo != null) {
    params['first_air_date.lte'] = '${filters.yearTo}-12-31';
  }
  if (filters.ratingFrom != null) {
    params['vote_average.gte'] = filters.ratingFrom.toString();
  }
  if (filters.ratingTo != null) {
    params['vote_average.lte'] = filters.ratingTo.toString();
  }

  final json = await tmdb.discoverTv(filters: params);
  return _tmdbResultsToMediaModels(
    json['results'] as List<dynamic>,
    MediaType.tv,
  );
}

Future<List<MediaModel>> _fetchAnimePage(
  int page,
  DiscoverFilters filters,
  AnilistService anilist,
) async {
  if (filters.searchQuery != null && filters.searchQuery!.isNotEmpty) {
    final mediaList = await anilist.searchAnime(filters.searchQuery!, page: page);
    return mediaList.map((m) => _animeToMediaModel(m as Map<String, dynamic>)).toList();
  }

  const gql = '''
    query (\$page: Int, \$perPage: Int, \$genre: String) {
      Page(page: \$page, perPage: \$perPage) {
        media(type: ANIME, sort: POPULARITY_DESC, genre: \$genre) {
          id
          title { romaji english }
          coverImage { large }
          bannerImage
          genres
          averageScore
          popularity
          episodes
          seasonYear
          description
          season
        }
      }
    }
  ''';

  final variables = <String, dynamic>{
    'page': page,
    'perPage': 20,
  };
  if (filters.genreId != null) {
    final genre = _animeGenreById(filters.genreId!);
    if (genre != null) variables['genre'] = genre;
  }

  final raw = await anilist.query(gql, variables: variables);
  final mediaList = raw['data']['Page']['media'] as List<dynamic>;

  return mediaList.map((m) => _animeToMediaModel(m as Map<String, dynamic>)).toList();
}

MediaModel _animeToMediaModel(Map<String, dynamic> map) {
  final title = map['title'] as Map<String, dynamic>?;
  final cover = map['coverImage'] as Map<String, dynamic>?;

  return MediaModel(
    id: map['id'] as int,
    mediaType: MediaType.anime,
    title: (title?['english'] ?? title?['romaji'] ?? '') as String,
    romanizedTitle: title?['romaji'] as String?,
    overview: map['description'] as String?,
    posterPath: cover?['large'] as String?,
    backdropPath: map['bannerImage'] as String?,
    voteAverage: (map['averageScore'] as num?)?.toDouble() != null
        ? (map['averageScore'] as num).toDouble() / 10
        : null,
    popularity: (map['popularity'] as num?)?.toDouble() ?? 0,
    totalEpisodes: (map['episodes'] as num?)?.toInt() ?? 0,
    releaseDate: map['seasonYear'] != null
        ? DateTime.tryParse('${map['seasonYear']}-01-01')
        : null,
    genres: (map['genres'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList(),
    status: map['status'] as String?,
  );
}

String? _animeGenreById(int id) {
  const animeGenres = {
    1: 'Action',
    2: 'Adventure',
    3: 'Comedy',
    4: 'Drama',
    5: 'Fantasy',
    6: 'Horror',
    7: 'Mystery',
    8: 'Romance',
    9: 'Sci-Fi',
    10: 'Slice of Life',
    11: 'Sports',
    12: 'Supernatural',
    13: 'Thriller',
    14: 'Ecchi',
    15: 'Mecha',
    16: 'Music',
    17: 'Psychological',
    18: 'Seinen',
    19: 'Shoujo',
    20: 'Shounen',
  };
  return animeGenres[id];
}

List<MediaModel> _tmdbResultsToMediaModels(
  List<dynamic> results,
  MediaType type,
) {
  return results.map((json) {
    final map = json as Map<String, dynamic>;
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
  }).toList();
}

DateTime? _parseDate(String? dateStr) {
  if (dateStr == null || dateStr.isEmpty) return null;
  return DateTime.tryParse(dateStr);
}
