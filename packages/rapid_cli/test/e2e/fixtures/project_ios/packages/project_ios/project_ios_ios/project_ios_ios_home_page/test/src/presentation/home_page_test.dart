import 'package:flutter_test/flutter_test.dart';
import 'package:project_ios_ios_home_page/src/presentation/presentation.dart';
import 'package:project_ios_ui_ios/project_ios_ui_ios.dart';
import 'package:project_ios_ios_routing/project_ios_ios_routing.dart';

import 'helpers/helpers.dart';

HomePage _getHomePage() {
  return const HomePage();
}

void main() {
  group('HomePage', () {
    testWidgets('renders ProjectIosScaffold correctly', (tester) async {
      // Act
      await tester.pumpApp(
        const HomePageRoute(),
        _getHomePage(),
      );

      // Assert
      expect(find.byType(ProjectIosScaffold), findsOneWidget);
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
