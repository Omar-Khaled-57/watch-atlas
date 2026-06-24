import 'package:flutter_test/flutter_test.dart';
import 'package:watch_atlas/core/models/media_enums.dart';
import 'package:watch_atlas/models/media_model.dart';

void main() {
  group('MediaModel', () {
    test('fromJson creates model correctly', () {
      final json = {
        'id': 1,
        'mediaType': 'movie',
        'title': 'Test Movie',
        'overview': 'A test movie',
        'posterPath': '/poster.jpg',
        'backdropPath': '/backdrop.jpg',
        'voteAverage': 7.5,
        'voteCount': 100,
        'popularity': 50.0,
        'releaseDate': '2024-01-01',
        'runtime': 120,
        'genres': ['Action', 'Drama'],
        'countries': ['US'],
        'status': 'Released',
        'language': 'en',
        'adult': false,
        'isCustom': false,
        'totalEpisodes': 0,
        'totalSeasons': 0,
      };

      final model = MediaModel.fromJson(json);

      expect(model.id, 1);
      expect(model.mediaType, MediaType.movie);
      expect(model.title, 'Test Movie');
      expect(model.overview, 'A test movie');
      expect(model.posterPath, '/poster.jpg');
      expect(model.voteAverage, 7.5);
      expect(model.voteCount, 100);
      expect(model.popularity, 50.0);
      expect(model.genres, ['Action', 'Drama']);
      expect(model.releaseDate, DateTime(2024, 1, 1));
      expect(model.runtime, 120);
      expect(model.isCustom, false);
    });

    test('toJson produces correct map', () {
      final model = MediaModel(
        id: 1,
        mediaType: MediaType.movie,
        title: 'Test',
      );

      final json = model.toJson();

      expect(json['id'], 1);
      expect(json['mediaType'], 'movie');
      expect(json['title'], 'Test');
    });

    test('default values are correct', () {
      final model = MediaModel(
        id: 1,
        mediaType: MediaType.tv,
        title: 'Test TV',
      );

      expect(model.popularity, 0.0);
      expect(model.isCustom, false);
      expect(model.totalEpisodes, 0);
      expect(model.totalSeasons, 0);
    });

    test('serialization roundtrip', () {
      final original = MediaModel(
        id: 42,
        mediaType: MediaType.anime,
        title: 'Test Anime',
        originalTitle: 'Original Title',
        overview: 'An overview',
        posterPath: '/path.jpg',
        voteAverage: 8.5,
        voteCount: 500,
        popularity: 99.9,
        genres: ['Action', 'Comedy'],
      );

      final json = original.toJson();
      final decoded = MediaModel.fromJson(json);

      expect(decoded.id, original.id);
      expect(decoded.mediaType, original.mediaType);
      expect(decoded.title, original.title);
      expect(decoded.originalTitle, original.originalTitle);
      expect(decoded.overview, original.overview);
      expect(decoded.voteAverage, original.voteAverage);
    });

    test('handles null optional fields', () {
      final json = {
        'id': 1,
        'mediaType': 'movie',
        'title': 'Test',
      };

      final model = MediaModel.fromJson(json);

      expect(model.overview, isNull);
      expect(model.posterPath, isNull);
      expect(model.voteAverage, isNull);
      expect(model.genres, isNull);
    });
  });
}
