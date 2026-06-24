import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers/app_providers.dart';
import '../../../models/media_model.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchTypeProvider = StateProvider<String>((ref) => 'all');

final _debouncedQueryProvider = Provider<String>((ref) {
  final query = ref.watch(searchQueryProvider);
  return query;
});

final searchSuggestionsProvider = FutureProvider<List<String>>((ref) async {
  final query = ref.watch(_debouncedQueryProvider);
  if (query.trim().length < 2) return [];
  final tmdb = ref.watch(tmdbServiceProvider);
  try {
    final results = await tmdb.search(query, page: 1);
    final suggestions = (results as List<dynamic>)
        .map((e) => e['title'] as String? ?? e['name'] as String? ?? '')
        .where((s) => s.isNotEmpty)
        .take(5)
        .toList();
    return suggestions.cast<String>();
  } catch (e) {
    debugPrint('Search suggestions error: $e');
    return [];
  }
});

final trendingSearchesProvider = FutureProvider<List<MediaModel>>((ref) async {
  final tmdb = ref.watch(tmdbServiceProvider);
  try {
    final results = await tmdb.trendingMovies();
    final list = results['results'] as List<dynamic>;
    return list.take(10).map((json) {
      return MediaModel(
        id: json['id'] as int,
        mediaType: _parseMediaType(json['media_type'] as String?),
        title: json['title'] as String? ?? json['name'] as String? ?? '',
        originalTitle: json['original_title'] as String?,
        overview: json['overview'] as String?,
        posterPath: json['poster_path'] as String?,
        backdropPath: json['backdrop_path'] as String?,
        voteAverage: (json['vote_average'] as num?)?.toDouble(),
        voteCount: json['vote_count'] as int?,
        popularity: (json['popularity'] as num?)?.toDouble() ?? 0,
        releaseDate: _parseDate(json['release_date'] as String?),
        genres: (json['genre_ids'] as List<dynamic>?)?.cast<String>(),
      );
    }).toList();
  } catch (e) {
    debugPrint('Trending search error: $e');
    return [];
  }
});

final searchResultsProvider = FutureProvider<List<MediaModel>>((ref) async {
  final query = ref.watch(_debouncedQueryProvider);
  final type = ref.watch(searchTypeProvider);

  if (query.trim().length < 2) return [];

  final tmdb = ref.watch(tmdbServiceProvider);
  try {
    final results = await tmdb.search(query, page: 1);
    final list = results as List<dynamic>;

    final mediaList = list.map((json) {
      return MediaModel(
        id: json['id'] as int,
        mediaType: _parseMediaType(json['media_type'] as String?),
        title: json['title'] as String? ?? json['name'] as String? ?? '',
        originalTitle: json['original_title'] as String? ?? json['original_name'] as String?,
        overview: json['overview'] as String?,
        posterPath: json['poster_path'] as String?,
        backdropPath: json['backdrop_path'] as String?,
        voteAverage: (json['vote_average'] as num?)?.toDouble(),
        voteCount: json['vote_count'] as int?,
        popularity: (json['popularity'] as num?)?.toDouble() ?? 0,
        releaseDate: _parseDate(json['release_date'] as String?),
        genres: (json['genre_ids'] as List<dynamic>?)?.cast<String>(),
      );
    }).toList();

    if (type == 'all') return mediaList;

    return mediaList.where((m) => m.mediaType.name == type).toList();
  } catch (e) {
    debugPrint('Search error: $e');
    return [];
  }
});

final searchHistoryProvider = StateNotifierProvider<SearchHistoryNotifier, List<String>>((ref) {
  return SearchHistoryNotifier(ref);
});

class SearchHistoryNotifier extends StateNotifier<List<String>> {
  final Ref _ref;
  static const int _maxItems = 10;

  SearchHistoryNotifier(this._ref) : super([]);

  void addQuery(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    final updated = [trimmed, ...state.where((s) => s != trimmed)].take(_maxItems).toList();
    state = updated;
  }

  void removeQuery(String query) {
    state = state.where((s) => s != query).toList();
  }

  void clearAll() {
    state = [];
  }
}

DateTime? _parseDate(String? dateStr) {
  if (dateStr == null) return null;
  return DateTime.tryParse(dateStr);
}

MediaType _parseMediaType(String? type) {
  switch (type) {
    case 'movie':
      return MediaType.movie;
    case 'tv':
      return MediaType.tv;
    case 'person':
      return MediaType.custom;
    default:
      return MediaType.custom;
  }
}
