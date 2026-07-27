import 'package:flutter_test/flutter_test.dart';
import 'package:watch_atlas/core/models/media_enums.dart';

void main() {
  group('MediaType', () {
    test('has expected values', () {
      expect(MediaType.values, contains(MediaType.movie));
      expect(MediaType.values, contains(MediaType.tv));
      expect(MediaType.values, contains(MediaType.anime));
      expect(MediaType.values, contains(MediaType.kdrama));
      expect(MediaType.values, contains(MediaType.custom));
    });

    test('has 15 values', () {
      expect(MediaType.values.length, 15);
    });
  });

  group('WatchStatus', () {
    test('has expected values', () {
      expect(WatchStatus.values, contains(WatchStatus.watching));
      expect(WatchStatus.values, contains(WatchStatus.completed));
      expect(WatchStatus.values, contains(WatchStatus.onHold));
      expect(WatchStatus.values, contains(WatchStatus.dropped));
      expect(WatchStatus.values, contains(WatchStatus.planToWatch));
      expect(WatchStatus.values, contains(WatchStatus.rewatching));
    });

    test('has 6 values', () {
      expect(WatchStatus.values.length, 6);
    });
  });

  group('MediaListType', () {
    test('has expected values', () {
      expect(MediaListType.values, contains(MediaListType.public));
      expect(MediaListType.values, contains(MediaListType.private));
      expect(MediaListType.values, contains(MediaListType.collaborative));
    });

    test('has 3 values', () {
      expect(MediaListType.values.length, 3);
    });
  });

  group('UserRole', () {
    test('has expected values', () {
      expect(UserRole.values, contains(UserRole.user));
      expect(UserRole.values, contains(UserRole.moderator));
      expect(UserRole.values, contains(UserRole.admin));
    });

    test('has 3 values', () {
      expect(UserRole.values.length, 3);
    });
  });

  group('ReportReason', () {
    test('has 5 values', () {
      expect(ReportReason.values.length, 5);
      expect(ReportReason.values, contains(ReportReason.spam));
      expect(ReportReason.values, contains(ReportReason.inappropriate));
      expect(ReportReason.values, contains(ReportReason.copyright));
      expect(ReportReason.values, contains(ReportReason.incorrect));
      expect(ReportReason.values, contains(ReportReason.other));
    });
  });

  group('NotificationType', () {
    test('has 7 values', () {
      expect(NotificationType.values.length, 7);
    });

    test('includes expected types', () {
      expect(NotificationType.values, contains(NotificationType.newSeason));
      expect(NotificationType.values, contains(NotificationType.newEpisode));
      expect(NotificationType.values, contains(NotificationType.friendFollow));
      expect(
        NotificationType.values,
        contains(NotificationType.recommendation),
      );
    });
  });
}
