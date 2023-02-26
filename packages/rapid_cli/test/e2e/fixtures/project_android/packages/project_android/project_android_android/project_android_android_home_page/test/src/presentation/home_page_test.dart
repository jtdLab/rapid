import 'package:flutter_test/flutter_test.dart';
import 'package:project_android_android_home_page/src/presentation/presentation.dart';
import 'package:project_android_ui_android/project_android_ui_android.dart';
import 'package:project_android_android_routing/project_android_android_routing.dart';

import 'helpers/helpers.dart';

HomePage _getHomePage() {
  return const HomePage();
}

void main() {
  group('HomePage', () {
    testWidgets('renders ProjectAndroidScaffold correctly', (tester) async {
      // Act
      await tester.pumpApp(
        const HomePageRoute(),
        _getHomePage(),
      );

      // Assert
      expect(find.byType(ProjectAndroidScaffold), findsOneWidget);
    });

    localizationTest(
      'renders title correctly',
      route: const HomePageRoute(),
      widget: _getHomePage(),
      translations: {
        const Locale('en'): 'Home Page title for en',
      },
    );
  });
}
