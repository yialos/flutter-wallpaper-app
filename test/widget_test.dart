import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallpaper_app/app.dart';

void main() {
  testWidgets('App initialization test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: WallpaperApp(),
      ),
    );

    // Verify that the app displays the coming soon message
    expect(find.text('Wallpaper App - Coming Soon'), findsOneWidget);
  });
}
