import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:watch_atlas/core/services/cache_service.dart';
import 'package:watch_atlas/core/services/cache_models.dart';

void main() {
  late CacheService cache;

  setUpAll(() {
    sqfliteFfiInit();
  });

  setUp(() async {
    cache = CacheService();
    // Force database creation
    await cache.database;
  });

  tearDown(() async {
    await cache.clearAll();
    await cache.dispose();
  });

  group('CachedUserMedia toMap/fromMap', () {
    test('roundtrip preserves all fields', () {
      final now = DateTime(2025, 6, 15, 12, 0, 0);
      final item = CachedUserMedia(
        remoteId: 'rm_123',
        mediaId: 42,
        userId: 'user_1',
        mediaType: 'movie',
        status: 'watching',
        seasonProgress: 2,
        episodeProgress: 5,
        totalEpisodes: 10,
        rewatchCount: 1,
        userRating: 8.5,
        startedAt: now,
        completedAt: null,
        createdAt: now,
        updatedAt: now,
      );

      final map = item.toMap();
      final restored = CachedUserMedia.fromMap(map);

      expect(restored.remoteId, 'rm_123');
      expect(restored.mediaId, 42);
      expect(restored.userId, 'user_1');
      expect(restored.mediaType, 'movie');
      expect(restored.status, 'watching');
      expect(restored.seasonProgress, 2);
      expect(restored.episodeProgress, 5);
      expect(restored.totalEpisodes, 10);
      expect(restored.rewatchCount, 1);
      expect(restored.userRating, 8.5);
      expect(restored.startedAt, now);
      expect(restored.completedAt, isNull);
    });

    test('fromMap handles missing fields with defaults', () {
      final item = CachedUserMedia.fromMap({});
      expect(item.remoteId, '');
      expect(item.mediaId, 0);
      expect(item.userId, '');
      expect(item.seasonProgress, 0);
      expect(item.userRating, isNull);
    });
  });

  group('CachedMedia toMap/fromMap', () {
    test('roundtrip preserves all fields', () {
      final item = CachedMedia(
        remoteId: 999,
        mediaType: 'tv',
        title: 'Test Show',
        originalTitle: 'Test Show JP',
        overview: 'A great show',
        posterPath: '/poster.jpg',
        backdropPath: '/backdrop.jpg',
        voteAverage: 8.7,
        voteCount: 1000,
        popularity: 99.5,
        genres: ['Action', 'Drama'],
        countries: ['US', 'JP'],
        totalEpisodes: 24,
        totalSeasons: 3,
      );

      final map = item.toMap();
      final restored = CachedMedia.fromMap(map);

      expect(restored.remoteId, 999);
      expect(restored.title, 'Test Show');
      expect(restored.originalTitle, 'Test Show JP');
      expect(restored.genres, ['Action', 'Drama']);
      expect(restored.countries, ['US', 'JP']);
      expect(restored.totalEpisodes, 24);
      expect(restored.totalSeasons, 3);
    });
  });

  group('CachedUserList toMap/fromMap', () {
    test('roundtrip preserves all fields', () {
      final item = CachedUserList(
        remoteId: 'list_1',
        userId: 'user_1',
        title: 'My List',
        description: 'A cool list',
        listType: 'collaborative',
        isPinned: true,
        tags: ['action', 'scifi'],
        itemCount: 15,
        likesCount: 3,
      );

      final map = item.toMap();
      final restored = CachedUserList.fromMap(map);

      expect(restored.remoteId, 'list_1');
      expect(restored.title, 'My List');
      expect(restored.description, 'A cool list');
      expect(restored.listType, 'collaborative');
      expect(restored.isPinned, true);
      expect(restored.tags, ['action', 'scifi']);
      expect(restored.itemCount, 15);
      expect(restored.likesCount, 3);
    });
  });

  group('CacheService operations', () {
    test('cacheUserMedia and getCachedUserMedia roundtrip', () async {
      final item = CachedUserMedia(
        remoteId: 'rm_test',
        mediaId: 100,
        userId: 'u1',
        mediaType: 'movie',
        status: 'completed',
      );

      await cache.cacheUserMedia(item);
      final results = await cache.getCachedUserMedia('u1');

      expect(results, hasLength(1));
      expect(results.first.remoteId, 'rm_test');
      expect(results.first.mediaId, 100);
    });

    test('cacheAllUserMedia stores multiple items', () async {
      final items = List.generate(
        5,
        (i) => CachedUserMedia(
          remoteId: 'rm_$i',
          mediaId: i,
          userId: 'u1',
          mediaType: 'movie',
          status: 'watching',
        ),
      );

      await cache.cacheAllUserMedia(items);
      final results = await cache.getCachedUserMedia('u1');

      expect(results, hasLength(5));
    });

    test('deleteCachedUserMedia removes item', () async {
      final item = CachedUserMedia(
        remoteId: 'rm_del',
        mediaId: 200,
        userId: 'u1',
        mediaType: 'tv',
        status: 'plan_to_watch',
      );

      await cache.cacheUserMedia(item);
      var results = await cache.getCachedUserMedia('u1');
      expect(results, hasLength(1));

      await cache.deleteCachedUserMedia('rm_del');
      results = await cache.getCachedUserMedia('u1');
      expect(results, isEmpty);
    });

    test('cacheMedia and getCachedMedia roundtrip', () async {
      final item = CachedMedia(
        remoteId: 500,
        mediaType: 'movie',
        title: 'Cached Movie',
      );

      await cache.cacheMedia(item);
      final result = await cache.getCachedMedia(500);

      expect(result, isNotNull);
      expect(result!.title, 'Cached Movie');
    });

    test('getCachedMedia returns null for missing item', () async {
      final result = await cache.getCachedMedia(9999);
      expect(result, isNull);
    });

    test('cacheUserList and getCachedUserLists roundtrip', () async {
      final item = CachedUserList(
        remoteId: 'list_test',
        userId: 'u1',
        title: 'Test List',
      );

      await cache.cacheUserList(item);
      final results = await cache.getCachedUserLists('u1');

      expect(results, hasLength(1));
      expect(results.first.title, 'Test List');
    });

    test('clearAll removes everything', () async {
      await cache.cacheUserMedia(
        CachedUserMedia(remoteId: 'rm_1', mediaId: 1, userId: 'u1', mediaType: 'movie', status: 'watching'),
      );
      await cache.cacheMedia(
        CachedMedia(remoteId: 10, mediaType: 'movie', title: 'M'),
      );
      await cache.cacheUserList(
        CachedUserList(remoteId: 'l1', userId: 'u1', title: 'L'),
      );

      await cache.clearAll();

      expect(await cache.getCachedUserMedia('u1'), isEmpty);
      expect(await cache.getCachedMedia(10), isNull);
      expect(await cache.getCachedUserLists('u1'), isEmpty);
    });

    test('replaceConflictAlgorithm overwrites duplicate remoteId', () async {
      final item1 = CachedUserMedia(
        remoteId: 'rm_dup',
        mediaId: 1,
        userId: 'u1',
        mediaType: 'movie',
        status: 'watching',
      );
      final item2 = CachedUserMedia(
        remoteId: 'rm_dup',
        mediaId: 1,
        userId: 'u1',
        mediaType: 'movie',
        status: 'completed',
      );

      await cache.cacheUserMedia(item1);
      await cache.cacheUserMedia(item2);
      final results = await cache.getCachedUserMedia('u1');

      expect(results, hasLength(1));
      expect(results.first.status, 'completed');
    });
  });
}
