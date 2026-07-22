import 'package:flutter_test/flutter_test.dart';
import 'package:watch_atlas/core/models/media_enums.dart';
import 'package:watch_atlas/features/analytics/providers/analytics_providers.dart';
import 'package:watch_atlas/models/user_media_model.dart';

void main() {
  group('WatchStatistics.compute', () {
    test('computes zero stats for empty list', () {
      final stats = WatchStatistics.compute([]);

      expect(stats.totalWatched, 0);
      expect(stats.totalEpisodes, 0);
      expect(stats.totalHours, 0);
      expect(stats.averageRating, 0.0);
    });

    test('computes stats for completed + watching items', () {
      final userMedia = [
        const UserMediaModel(
          id: '1',
          mediaId: 100,
          userId: 'user1',
          mediaType: MediaType.movie,
          status: WatchStatus.completed,
          episodeProgress: 12,
          userRating: 8.0,
        ),
        const UserMediaModel(
          id: '2',
          mediaId: 200,
          userId: 'user1',
          mediaType: MediaType.tv,
          status: WatchStatus.watching,
          episodeProgress: 5,
        ),
        const UserMediaModel(
          id: '3',
          mediaId: 300,
          userId: 'user1',
          mediaType: MediaType.movie,
          status: WatchStatus.planToWatch,
          episodeProgress: 0,
        ),
      ];

      final stats = WatchStatistics.compute(userMedia);

      expect(stats.totalWatched, 2);
      expect(stats.totalEpisodes, 17);
      expect(stats.totalHours, 8);
      expect(stats.averageRating, 8.0);
    });

    test('computes average rating correctly', () {
      final userMedia = [
        const UserMediaModel(
          id: '1', mediaId: 1, userId: 'u', mediaType: MediaType.movie,
          status: WatchStatus.completed, userRating: 6.0,
        ),
        const UserMediaModel(
          id: '2', mediaId: 2, userId: 'u', mediaType: MediaType.movie,
          status: WatchStatus.completed, userRating: 8.0,
        ),
        const UserMediaModel(
          id: '3', mediaId: 3, userId: 'u', mediaType: MediaType.movie,
          status: WatchStatus.completed, userRating: 10.0,
        ),
      ];

      final stats = WatchStatistics.compute(userMedia);

      expect(stats.totalWatched, 3);
      expect(stats.averageRating, closeTo(8.0, 0.01));
    });

    test('averageRating is 0 when no ratings given', () {
      final userMedia = [
        const UserMediaModel(
          id: '1', mediaId: 1, userId: 'u', mediaType: MediaType.tv,
          status: WatchStatus.completed,
        ),
        const UserMediaModel(
          id: '2', mediaId: 2, userId: 'u', mediaType: MediaType.tv,
          status: WatchStatus.watching, episodeProgress: 3,
        ),
      ];

      final stats = WatchStatistics.compute(userMedia);

      expect(stats.totalWatched, 2);
      expect(stats.totalEpisodes, 3);
      expect(stats.averageRating, 0.0);
    });

    test('drops and rewatching statuses are not counted', () {
      final userMedia = [
        const UserMediaModel(
          id: '1', mediaId: 1, userId: 'u', mediaType: MediaType.movie,
          status: WatchStatus.dropped,
        ),
        const UserMediaModel(
          id: '2', mediaId: 2, userId: 'u', mediaType: MediaType.movie,
          status: WatchStatus.onHold,
        ),
      ];

      final stats = WatchStatistics.compute(userMedia);

      expect(stats.totalWatched, 0);
    });

    test('rewatching status IS counted as watched', () {
      final userMedia = [
        const UserMediaModel(
          id: '1', mediaId: 1, userId: 'u', mediaType: MediaType.movie,
          status: WatchStatus.rewatching, episodeProgress: 4,
        ),
      ];

      final stats = WatchStatistics.compute(userMedia);

      expect(stats.totalWatched, 1);
      expect(stats.totalEpisodes, 4);
    });
  });

  group('DistributionItem', () {
    test('constructor creates item correctly', () {
      final item = DistributionItem(
        label: 'Action',
        count: 15,
        percentage: 0.35,
      );

      expect(item.label, 'Action');
      expect(item.count, 15);
      expect(item.percentage, 0.35);
    });
  });

  group('ActivityDay', () {
    test('constructor creates day correctly', () {
      final day = ActivityDay(date: '2026-07-13', count: 5);

      expect(day.date, '2026-07-13');
      expect(day.count, 5);
    });
  });

  group('ActivityMonth', () {
    test('constructor creates month correctly', () {
      final month = ActivityMonth(month: '2026-07', count: 20);

      expect(month.month, '2026-07');
      expect(month.count, 20);
    });
  });

  group('ActivityYear', () {
    test('constructor creates year correctly', () {
      final year = ActivityYear(year: 2026, count: 100);

      expect(year.year, 2026);
      expect(year.count, 100);
    });
  });

  group('RatingBucket', () {
    test('constructor creates bucket correctly', () {
      final bucket = RatingBucket(label: '7-8', count: 12, total: 50);

      expect(bucket.label, '7-8');
      expect(bucket.count, 12);
      expect(bucket.total, 50);
    });
  });
}
