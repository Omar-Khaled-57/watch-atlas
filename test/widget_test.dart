import 'package:flutter_test/flutter_test.dart';

import 'package:watch_atlas/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const WatchAtlasApp());
    expect(find.text('WatchAtlas'), findsNothing);
  });
}
