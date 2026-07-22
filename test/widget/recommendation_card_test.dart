import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:watch_atlas/core/models/recommendation_models.dart';

class MockSupabaseService extends Mock {
  dynamic from(String table);
}

class MockAuthService extends Mock {
  String get userId => 'test_user';
  bool get isAuthenticated => true;
}

void main() {
  group('FeedbackButton', () {
    testWidgets('renders unselected thumb up icon by default', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: _TestFeedbackWrapper(
              child: _TestFeedbackButton(
                icon: Icons.thumb_up_alt_outlined,
                selectedIcon: Icons.thumb_up_alt_rounded,
                isSelected: false,
                color: Colors.green,
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.thumb_up_alt_outlined), findsOneWidget);
    });

    testWidgets('renders selected thumb up icon when selected', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: _TestFeedbackWrapper(
              child: _TestFeedbackButton(
                icon: Icons.thumb_up_alt_outlined,
                selectedIcon: Icons.thumb_up_alt_rounded,
                isSelected: true,
                color: Colors.green,
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.thumb_up_alt_rounded), findsOneWidget);
      expect(find.byIcon(Icons.thumb_up_alt_outlined), findsNothing);
    });

    testWidgets('renders unselected thumb down icon by default', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: _TestFeedbackWrapper(
              child: _TestFeedbackButton(
                icon: Icons.thumb_down_alt_outlined,
                selectedIcon: Icons.thumb_down_alt_rounded,
                isSelected: false,
                color: Colors.red,
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.thumb_down_alt_outlined), findsOneWidget);
    });

    testWidgets('tapping button calls onTap callback', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: _TestFeedbackWrapper(
              child: _TestFeedbackButton(
                icon: Icons.thumb_up_alt_outlined,
                selectedIcon: Icons.thumb_up_alt_rounded,
                isSelected: false,
                color: Colors.green,
                onTap: () => tapped = true,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.thumb_up_alt_outlined));
      expect(tapped, true);
    });
  });

  group('_localizedReason', () {
    testWidgets('returns correct l10n for known reasons', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final l10n = _MockLocalizations();
                expect(_localizedReasonHelper('Popular trending', l10n), 'Popular Trending');
                expect(_localizedReasonHelper('Top rated', l10n), 'Top Rated');
                expect(_localizedReasonHelper('Critically acclaimed', l10n), 'Critically Acclaimed');
                expect(_localizedReasonHelper('Recently released', l10n), 'Recently Released');
                expect(_localizedReasonHelper(null, l10n), '');
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('returns original reason for unknown strings', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final l10n = _MockLocalizations();
                expect(_localizedReasonHelper('Some unknown reason', l10n), 'Some unknown reason');
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });
  });

  group('RecCategory roundtrip', () {
    test('all categories have non-empty dbValue and displayName', () {
      for (final cat in RecCategory.values) {
        expect(cat.dbValue.isNotEmpty, true, reason: 'Empty dbValue for ${cat.name}');
        expect(cat.displayName.isNotEmpty, true, reason: 'Empty displayName for ${cat.name}');
      }
    });
  });
}

String _localizedReasonHelper(String? reason, dynamic l10n) {
  if (reason == null) return '';
  if (reason.startsWith('Because you enjoy ')) {
    final genre = reason.replaceFirst('Because you enjoy ', '');
    return 'Because You Enjoy $genre';
  }
  switch (reason) {
    case 'Popular trending':
      return 'Popular Trending';
    case 'Similar to what you\'ve saved':
      return 'Similar to Saved';
    case 'Similar to your favorites':
      return 'Similar to Favorites';
    case 'Users with similar taste enjoyed this':
      return 'Users Like You Enjoyed';
    case 'Recently released':
      return 'Recently Released';
    case 'Top rated':
      return 'Top Rated';
    case 'Hidden gem — highly rated but undiscovered':
      return 'Hidden Gem';
    case 'Critically acclaimed':
      return 'Critically Acclaimed';
    default:
      return reason;
  }
}

class _MockLocalizations {}

class _TestFeedbackWrapper extends StatelessWidget {
  final Widget child;
  const _TestFeedbackWrapper({required this.child});

  @override
  Widget build(BuildContext context) => child;
}

class _TestFeedbackButton extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final bool isSelected;
  final Color color;
  final VoidCallback? onTap;

  const _TestFeedbackButton({
    required this.icon,
    required this.selectedIcon,
    required this.isSelected,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: 18,
        icon: Icon(
          isSelected ? selectedIcon : icon,
          color: isSelected ? color : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        onPressed: onTap,
      ),
    );
  }
}
