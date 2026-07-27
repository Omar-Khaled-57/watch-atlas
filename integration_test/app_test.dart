import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:watch_atlas/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App launch', () {
    testWidgets('shows scaffold on launch', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final scaffold = find.byType(Scaffold);
      expect(scaffold, findsWidgets);
    });
  });

  group('Navigation', () {
    testWidgets('bottom nav switches between tabs', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final navBar = find.byType(NavigationBar);
      if (navBar.evaluate().isNotEmpty) {
        final destinations = find.byType(NavigationDestination);
        final count = destinations.evaluate().length;

        for (var i = 0; i < count; i++) {
          await tester.tap(destinations.at(i));
          await tester.pumpAndSettle();
        }

        expect(find.byType(Scaffold), findsWidgets);
      }
    });
  });
}
