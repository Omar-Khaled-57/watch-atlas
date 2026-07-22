import 'package:flutter_test/flutter_test.dart';
import 'package:watch_atlas/core/services/isar_collections.dart';

void main() {
  group('CachedUserMedia', () {
    test('default values are correct', () {
      final item = CachedUserMedia();

      expect(item.id, 0);
      expect(item.remoteId, '');
      expect(item.mediaId, 0);
      expect(item.userId, '');
      expect(item.mediaType, '');
      expect(item.status, '');
      expect(item.seasonProgress, 0);
      expect(item.episodeProgress, 0);
      expect(item.totalEpisodes, 0);
      expect(item.rewatchCount, 0);
      expect(item.userRating, isNull);
      expect(item.startedAt, isNull);
      expect(item.completedAt, isNull);
    });

    test('fields can be set', () {
      final item = CachedUserMedia()
        ..remoteId = 'remote_1'
        ..mediaId = 42
        ..userId = 'user_1'
        ..mediaType = 'movie'
        ..status = 'completed'
        ..seasonProgress = 2
        ..episodeProgress = 24
        ..totalEpisodes = 24
        ..rewatchCount = 1
        ..userRating = 8.5
        ..startedAt = DateTime(2026, 1, 1)
        ..completedAt = DateTime(2026, 6, 30);

      expect(item.remoteId, 'remote_1');
      expect(item.mediaId, 42);
      expect(item.userId, 'user_1');
      expect(item.mediaType, 'movie');
      expect(item.status, 'completed');
      expect(item.seasonProgress, 2);
      expect(item.episodeProgress, 24);
      expect(item.totalEpisodes, 24);
      expect(item.rewatchCount, 1);
      expect(item.userRating, 8.5);
    });
  });

  group('CachedMedia', () {
    test('default values are correct', () {
      final item = CachedMedia();

      expect(item.id, 0);
      expect(item.remoteId, 0);
      expect(item.mediaType, '');
      expect(item.title, '');
      expect(item.popularity, 0);
      expect(item.isCustom, false);
      expect(item.totalEpisodes, 0);
      expect(item.totalSeasons, 0);
      expect(item.genres, isEmpty);
      expect(item.countries, isEmpty);
    });

    test('fields can be set', () {
      final item = CachedMedia()
        ..remoteId = 100
        ..mediaType = 'tv'
        ..title = 'Test Series'
        ..originalTitle = 'Original Title'
        ..overview = 'A great series'
        ..posterPath = '/poster.jpg'
        ..backdropPath = '/backdrop.jpg'
        ..trailerUrl = 'https://youtube.com/watch?v=abc'
        ..voteAverage = 8.5
        ..voteCount = 500
        ..popularity = 99.9
        ..releaseDate = DateTime(2026, 1, 1)
        ..runtime = 45
        ..genres = ['Action', 'Drama']
        ..countries = ['US', 'JP']
        ..status = 'Released'
        ..language = 'en'
        ..adult = false
        ..isCustom = true
        ..totalEpisodes = 24
        ..totalSeasons = 3;

      expect(item.remoteId, 100);
      expect(item.title, 'Test Series');
      expect(item.genres, ['Action', 'Drama']);
      expect(item.countries, ['US', 'JP']);
      expect(item.voteAverage, 8.5);
      expect(item.isCustom, true);
    });
  });

  group('CachedUserList', () {
    test('default values are correct', () {
      final item = CachedUserList();

      expect(item.id, 0);
      expect(item.remoteId, '');
      expect(item.userId, '');
      expect(item.title, '');
      expect(item.listType, 'public');
      expect(item.isPinned, false);
      expect(item.tags, isEmpty);
      expect(item.itemCount, 0);
      expect(item.likesCount, 0);
    });

    test('fields can be set', () {
      final item = CachedUserList()
        ..remoteId = 'list_1'
        ..userId = 'user_1'
        ..title = 'My Watchlist'
        ..description = 'Things to watch'
        ..listType = 'private'
        ..isPinned = true
        ..tags = ['action', 'sci-fi']
        ..itemCount = 25
        ..likesCount = 10;

      expect(item.remoteId, 'list_1');
      expect(item.title, 'My Watchlist');
      expect(item.listType, 'private');
      expect(item.isPinned, true);
      expect(item.tags, ['action', 'sci-fi']);
      expect(item.itemCount, 25);
    });
  });
}
