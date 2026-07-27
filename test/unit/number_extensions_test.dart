import 'package:flutter_test/flutter_test.dart';
import 'package:watch_atlas/core/extensions/number_extensions.dart';

void main() {
  group('NumberExtensions.toDurationString', () {
    test('formats minutes only', () {
      expect(30.toDurationString(), '30m');
    });

    test('formats hours and minutes', () {
      expect(90.toDurationString(), '1h 30m');
    });

    test('formats exact hours', () {
      expect(120.toDurationString(), '2h 0m');
    });

    test('formats zero', () {
      expect(0.toDurationString(), '0m');
    });
  });

  group('NumberExtensions.toRuntimeString', () {
    test('formats minutes only', () {
      expect(45.toRuntimeString(), '45m');
    });

    test('formats hours and minutes', () {
      expect(135.toRuntimeString(), '2h 15m');
    });

    test('formats exact hours', () {
      expect(60.toRuntimeString(), '1h 0m');
    });
  });

  group('NumberExtensions.formatCount', () {
    test('formats small numbers as-is', () {
      expect(0.formatCount(), '0');
      expect(999.formatCount(), '999');
    });

    test('formats thousands with K suffix', () {
      expect(1000.formatCount(), '1.0K');
      expect(1500.formatCount(), '1.5K');
      expect(999999.formatCount(), '1000.0K');
    });

    test('formats millions with M suffix', () {
      expect(1000000.formatCount(), '1.0M');
      expect(2500000.formatCount(), '2.5M');
    });
  });

  group('NumberExtensions.toPercentage', () {
    test('formats as percentage', () {
      expect(85.toPercentage(), '85%');
      expect(0.toPercentage(), '0%');
      expect(100.toPercentage(), '100%');
    });
  });
}
