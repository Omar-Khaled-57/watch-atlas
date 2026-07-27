import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watch_atlas/core/constants/app_colors.dart';
import 'package:watch_atlas/core/models/media_enums.dart';
import 'package:watch_atlas/core/shared/media_card.dart';
import 'package:watch_atlas/features/discover/widgets/filter_chip.dart';
import 'package:watch_atlas/features/profile/widgets/profile_widgets.dart';

void main() {
  group('AppColors', () {
    test('star color is defined', () {
      expect(AppColors.star, isA<Color>());
    });

    test('logoPurple color is defined', () {
      expect(AppColors.logoPurple, isA<Color>());
    });

    test('logoPurple matches brand purple #8B5CF6', () {
      expect(AppColors.logoPurple, const Color(0xFF8B5CF6));
    });
  });

  group('WatchStatusColor', () {
    test('each WatchStatus has a distinct color', () {
      final colors = WatchStatus.values.map((s) => s.color).toSet();
      expect(colors.length, WatchStatus.values.length);
    });

    test('watching status is blue', () {
      expect(WatchStatus.watching.color, const Color(0xFF2196F3));
    });

    test('completed status is green', () {
      expect(WatchStatus.completed.color, const Color(0xFF4CAF50));
    });

    test('dropped status is red', () {
      expect(WatchStatus.dropped.color, const Color(0xFFF44336));
    });
  });

  group('statusColorFromString', () {
    test('returns correct color for known status', () {
      expect(statusColorFromString('watching'), const Color(0xFF2196F3));
      expect(statusColorFromString('completed'), const Color(0xFF4CAF50));
      expect(statusColorFromString('dropped'), const Color(0xFFF44336));
    });

    test('returns fallback for unknown status', () {
      expect(statusColorFromString('unknown'), const Color(0xFF78716C));
    });

    test('returns custom fallback when provided', () {
      expect(
        statusColorFromString('unknown', fallback: Colors.pink),
        Colors.pink,
      );
    });
  });

  group('MediaCard accessibility', () {
    testWidgets('has Semantics with title and rating', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MediaCard(
              id: 1,
              title: 'Test Movie',
              voteAverage: 7.5,
              mediaType: MediaType.movie,
            ),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(MediaCard));
      expect(semantics.label, contains('Test Movie'));
      expect(semantics.label, contains('7.5'));
    });

    testWidgets('has semantic label with title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MediaCard(
              id: 1,
              title: 'Movie',
              voteAverage: 8.0,
              mediaType: MediaType.movie,
            ),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(MediaCard));
      expect(semantics.label, contains('Movie'));
      expect(semantics.label, contains('8.0'));
    });
  });

  group('FilterChipWidget accessibility', () {
    testWidgets('has Semantics with label and selected state', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FilterChipWidget(
              label: 'Action',
              isSelected: true,
              onTap: () {},
            ),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(FilterChipWidget));
      expect(semantics.label, contains('Action'));
      expect(semantics.label, contains('selected'));
    });

    testWidgets('has label when not selected', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FilterChipWidget(
              label: 'Drama',
              isSelected: false,
              onTap: () {},
            ),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(FilterChipWidget));
      expect(semantics.label, contains('Drama'));
      expect(semantics.label, isNot(contains('selected')));
    });
  });

  group('InfoRow accessibility', () {
    testWidgets('has Semantics with label combining label and value', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InfoRow(
              icon: Icons.person,
              label: 'Director',
              value: 'Nolan',
            ),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(InfoRow));
      expect(semantics.label, contains('Director'));
      expect(semantics.label, contains('Nolan'));
    });
  });
}
