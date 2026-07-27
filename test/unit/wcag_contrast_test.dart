import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:watch_atlas/core/theme/app_theme.dart';

/// WCAG 2.1 contrast ratio utilities.
double _relativeLuminance(Color color) {
  double channel(double value) {
    final s = value / 255.0;
    return s <= 0.03928 ? s / 12.92 : ((s + 0.055) / 1.055);
  }

  return 0.2126 * channel(color.red.toDouble()) +
      0.7152 * channel(color.green.toDouble()) +
      0.0722 * channel(color.blue.toDouble());
}

double contrastRatio(Color a, Color b) {
  final l1 = _relativeLuminance(a);
  final l2 = _relativeLuminance(b);
  final lighter = l1 > l2 ? l1 : l2;
  final darker = l1 > l2 ? l2 : l1;
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  group('WCAG AA contrast ratios', () {
    test('dark theme: onSurface vs surface meets AA (4.5:1)', () {
      const surface = Color(0xFF0F1115);
      const onSurface = Color(0xFFFFFFFF);
      final ratio = contrastRatio(onSurface, surface);
      expect(ratio, greaterThanOrEqualTo(4.5));
    });

    test(
      'dark theme: onSurfaceVariant vs surface meets large-text AA (3:1)',
      () {
        const surface = Color(0xFF0F1115);
        const onSurfaceVariant = Color(0xFFA1A1AA);
        final ratio = contrastRatio(onSurfaceVariant, surface);
        expect(ratio, greaterThanOrEqualTo(3.0));
      },
    );

    test('light theme: onSurface vs surface meets AA (4.5:1)', () {
      const surface = Color(0xFFFDFBF7);
      const onSurface = Color(0xFF252120);
      final ratio = contrastRatio(onSurface, surface);
      expect(ratio, greaterThanOrEqualTo(4.5));
    });

    test('dark theme: primary vs surface meets large-text AA (3:1)', () {
      const surface = Color(0xFF0F1115);
      const primary = Color(0xFF00B8FF);
      final ratio = contrastRatio(primary, surface);
      expect(ratio, greaterThanOrEqualTo(3.0));
    });

    test('dark theme: error vs surface meets large-text AA (3:1)', () {
      const surface = Color(0xFF0F1115);
      const error = Color(0xFFF04646);
      final ratio = contrastRatio(error, surface);
      expect(ratio, greaterThanOrEqualTo(3.0));
    });

    test('star color on dark background meets large-text AA (3:1)', () {
      const surface = Color(0xFF0F1115);
      const star = Color(0xFFFFC107);
      final ratio = contrastRatio(star, surface);
      expect(ratio, greaterThanOrEqualTo(3.0));
    });
  });

  group('AppTheme smoke tests', () {
    test('dark theme body text meets AA (4.5:1)', () {
      final theme = AppTheme.dark();
      final cs = theme.colorScheme;
      final ratio = contrastRatio(cs.onSurface, cs.surface);
      expect(ratio, greaterThanOrEqualTo(4.5));
    });

    test('light theme body text meets AA (4.5:1)', () {
      final theme = AppTheme.light();
      final cs = theme.colorScheme;
      final ratio = contrastRatio(cs.onSurface, cs.surface);
      expect(ratio, greaterThanOrEqualTo(4.5));
    });

    test('dark theme primary on surface meets 3:1', () {
      final theme = AppTheme.dark();
      final cs = theme.colorScheme;
      final ratio = contrastRatio(cs.primary, cs.surface);
      expect(ratio, greaterThanOrEqualTo(3.0));
    });

    test('dark theme error on surface meets 3:1', () {
      final theme = AppTheme.dark();
      final cs = theme.colorScheme;
      final ratio = contrastRatio(cs.error, cs.surface);
      expect(ratio, greaterThanOrEqualTo(3.0));
    });
  });

  group('Contrast ratio report', () {
    test('log all key color pair ratios', () {
      const darkSurface = Color(0xFF0F1115);
      const lightSurface = Color(0xFFFDFBF7);
      const onSurface = Color(0xFFFFFFFF);
      const onSurfaceLight = Color(0xFF252120);
      const primary = Color(0xFF00B8FF);
      const onPrimary = Color(0xFFFFFFFF);
      const error = Color(0xFFF04646);
      const star = Color(0xFFFFC107);
      const muted = Color(0xFFA1A1AA);
      const secondaryLight = Color(0xFF6B6460);

      final pairs = {
        'Dark: white on bg': contrastRatio(onSurface, darkSurface),
        'Dark: muted on bg': contrastRatio(muted, darkSurface),
        'Dark: primary on bg': contrastRatio(primary, darkSurface),
        'Dark: error on bg': contrastRatio(error, darkSurface),
        'Dark: star on bg': contrastRatio(star, darkSurface),
        'Light: text on bg': contrastRatio(onSurfaceLight, lightSurface),
        'Light: secondary on bg': contrastRatio(secondaryLight, lightSurface),
        'Light: primary on bg': contrastRatio(primary, lightSurface),
        'Light: error on bg': contrastRatio(error, lightSurface),
        'Light: star on bg': contrastRatio(star, lightSurface),
        'onPrimary vs primary': contrastRatio(onPrimary, primary),
      };

      for (final entry in pairs.entries) {
        // ignore: avoid_print
        print('  ${entry.key}: ${entry.value.toStringAsFixed(2)}:1');
      }

      // Verify the critical pairs pass
      expect(pairs['Dark: white on bg']!, greaterThanOrEqualTo(4.5));
      expect(pairs['Light: text on bg']!, greaterThanOrEqualTo(4.5));
      expect(pairs['Dark: primary on bg']!, greaterThanOrEqualTo(3.0));
      expect(pairs['Dark: error on bg']!, greaterThanOrEqualTo(3.0));
      expect(pairs['Dark: star on bg']!, greaterThanOrEqualTo(3.0));
    });
  });
}
