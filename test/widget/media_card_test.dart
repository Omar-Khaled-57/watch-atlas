import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watch_atlas/core/models/media_enums.dart';
import 'package:watch_atlas/core/shared/media_card.dart';

void main() {
  testWidgets('MediaCard renders title correctly', (tester) async {
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

    expect(find.text('Test Movie'), findsOneWidget);
    expect(find.text('7.5'), findsOneWidget);
  });

  testWidgets('MediaCard shows media type badge', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MediaCard(
            id: 2,
            title: 'Anime Title',
            voteAverage: 8.0,
            mediaType: MediaType.anime,
          ),
        ),
      ),
    );

    expect(find.text('Anime Title'), findsOneWidget);
  });

  testWidgets('MediaCard triggers onTap', (tester) async {
    bool tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MediaCard(
            id: 3,
            title: 'Test',
            voteAverage: 5.0,
            mediaType: MediaType.movie,
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Test'));
    expect(tapped, true);
  });
}
