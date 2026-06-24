import 'package:watch_atlas/core/models/media_enums.dart';
import 'package:watch_atlas/models/media_model.dart';
import 'package:watch_atlas/models/user_model.dart';

MediaModel createMockMedia({
  int id = 1,
  MediaType mediaType = MediaType.movie,
  String title = 'Test Movie',
}) {
  return MediaModel(
    id: id,
    mediaType: mediaType,
    title: title,
    originalTitle: 'Original $title',
    overview: 'Overview for $title',
    posterPath: '/poster_$id.jpg',
    backdropPath: '/backdrop_$id.jpg',
    voteAverage: 7.5,
    voteCount: 100,
    popularity: 50.0,
    releaseDate: DateTime(2024),
    runtime: 120,
    genres: ['Action', 'Drama'],
    countries: ['US'],
    status: 'Released',
    language: 'en',
  );
}

UserModel createMockUser({
  String id = 'user_1',
  String username = 'testuser',
}) {
  return UserModel(
    id: id,
    email: '$username@example.com',
    username: username,
    displayName: 'Test User',
    avatarUrl: 'https://example.com/avatar.jpg',
    bio: 'A test user',
  );
}

Map<String, dynamic> createMockTmdbMovieJson({int id = 1}) {
  return {
    'id': id,
    'title': 'Test Movie $id',
    'original_title': 'Original Title $id',
    'overview': 'A test movie overview.',
    'poster_path': '/poster_$id.jpg',
    'backdrop_path': '/backdrop_$id.jpg',
    'vote_average': 7.5,
    'vote_count': 100,
    'popularity': 50.0,
    'release_date': '2024-01-15',
    'runtime': 120,
    'genre_ids': [28, 18],
    'original_language': 'en',
    'adult': false,
    'media_type': 'movie',
  };
}

Map<String, dynamic> createMockTmdbSeriesJson({int id = 1}) {
  return {
    'id': id,
    'name': 'Test Series $id',
    'original_name': 'Original Series $id',
    'overview': 'A test series overview.',
    'poster_path': '/poster_$id.jpg',
    'backdrop_path': '/backdrop_$id.jpg',
    'vote_average': 8.0,
    'vote_count': 200,
    'popularity': 80.0,
    'first_air_date': '2023-01-01',
    'genre_ids': [18, 80],
    'original_language': 'en',
    'media_type': 'tv',
  };
}

List<Map<String, dynamic>> createMockTmdbMovieList({int count = 5}) {
  return List.generate(count, (i) => createMockTmdbMovieJson(id: i + 1));
}

List<Map<String, dynamic>> createMockTmdbSeriesList({int count = 5}) {
  return List.generate(count, (i) => createMockTmdbSeriesJson(id: i + 1));
}
