import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watch_atlas/core/shared/media_card.dart';

void main() {
  testWidgets('MediaCard renders title correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MediaCard(
            title: 'Test Movie',
            posterPath: null,
            rating: 7.5,
            mediaType: 'movie',
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
            title: 'Anime Title',
            posterPath: null,
            rating: 8.0,
            mediaType: 'anime',
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
            title: 'Test',
            posterPath: null,
            rating: 5.0,
            mediaType: 'movie',
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Test'));
    expect(tapped, true);
  });
}
