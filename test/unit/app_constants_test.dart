import 'package:flutter_test/flutter_test.dart';
import 'package:watch_atlas/core/constants/app_constants.dart';

void main() {
  group('AppConstants', () {
    test('appVersion is non-empty', () {
      expect(AppConstants.appVersion, isNotEmpty);
    });

    test('appName is WatchAtlas', () {
      expect(AppConstants.appName, 'WatchAtlas');
    });

    test('mediaImageUrl returns null for null path', () {
      expect(AppConstants.mediaImageUrl(null), isNull);
    });

    test('mediaImageUrl returns full URL for relative path', () {
      final url = AppConstants.mediaImageUrl('/abc123.jpg');
      expect(url, contains('image.tmdb.org'));
      expect(url, contains('/w342/abc123.jpg'));
    });

    test('mediaImageUrl uses custom size', () {
      final url = AppConstants.mediaImageUrl('/abc.jpg', size: 'w500');
      expect(url, contains('/w500/abc.jpg'));
    });

    test('mediaImageUrl returns HTTPS URLs unchanged', () {
      const input = 'https://example.com/image.jpg';
      expect(AppConstants.mediaImageUrl(input), input);
    });

    test('mediaImageUrl returns HTTP URLs unchanged', () {
      const input = 'http://example.com/image.jpg';
      expect(AppConstants.mediaImageUrl(input), input);
    });

    test('searchDebounce is 400ms', () {
      expect(AppConstants.searchDebounce.inMilliseconds, 400);
    });

    test('pageSize is 20', () {
      expect(AppConstants.pageSize, 20);
    });

    test('maxRetries is 3', () {
      expect(AppConstants.maxRetries, 3);
    });
  });
}
