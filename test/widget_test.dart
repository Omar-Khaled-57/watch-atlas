import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App smoke test', (tester) async {
    // Basic smoke test to ensure test infrastructure works
    await tester.pumpWidget(
      const MaterialApp(
        home: Text('WatchAtlas'),
      ),
    );
    expect(find.text('WatchAtlas'), findsOneWidget);
  });
}
