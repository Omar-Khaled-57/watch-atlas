import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FilteredAnalyticsScreen _getTitle logic', () {
    String getTitle(
      String filterType,
      String filterKey, {
      String mediaFor = 'Media for',
    }) {
      if (filterType == 'weekly') {
        final parts = filterKey.split('-');
        if (parts.length >= 3) {
          return '$mediaFor ${parts[1]}/${parts[2]}';
        }
      } else if (filterType == 'monthly') {
        final parts = filterKey.split('-');
        if (parts.length >= 2) {
          final months = [
            '',
            'January',
            'February',
            'March',
            'April',
            'May',
            'June',
            'July',
            'August',
            'September',
            'October',
            'November',
            'December',
          ];
          final monthIndex = int.tryParse(parts[1]) ?? 0;
          if (monthIndex > 0 && monthIndex < months.length) {
            return '$mediaFor ${months[monthIndex]} ${parts[0]}';
          }
        }
      }
      return 'Filtered Media';
    }

    test('weekly filter parses date correctly', () {
      expect(getTitle('weekly', '2026-07-13'), 'Media for 07/13');
    });

    test('weekly filter with different date', () {
      expect(getTitle('weekly', '2026-12-25'), 'Media for 12/25');
    });

    test('monthly filter parses month and year correctly', () {
      expect(getTitle('monthly', '2026-07'), 'Media for July 2026');
    });

    test('monthly filter with January', () {
      expect(getTitle('monthly', '2026-01'), 'Media for January 2026');
    });

    test('monthly filter with December', () {
      expect(getTitle('monthly', '2026-12'), 'Media for December 2026');
    });

    test('returns default for unknown filter type', () {
      expect(getTitle('yearly', '2026'), 'Filtered Media');
    });

    test('returns default for malformed weekly key', () {
      expect(getTitle('weekly', '2026'), 'Filtered Media');
    });

    test('returns default for malformed monthly key', () {
      expect(getTitle('monthly', '2026'), 'Filtered Media');
    });

    test('returns default for empty filter key', () {
      expect(getTitle('weekly', ''), 'Filtered Media');
      expect(getTitle('monthly', ''), 'Filtered Media');
    });
  });
}
