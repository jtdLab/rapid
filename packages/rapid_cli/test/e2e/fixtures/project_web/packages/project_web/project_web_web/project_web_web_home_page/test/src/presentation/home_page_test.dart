import 'package:flutter_test/flutter_test.dart';
import 'package:project_web_web_home_page/src/presentation/presentation.dart';
import 'package:project_web_ui_web/project_web_ui_web.dart';
import 'package:project_web_web_routing/project_web_web_routing.dart';

import 'helpers/helpers.dart';

HomePage _getHomePage() {
  return const HomePage();
}

void main() {
  group('HomePage', () {
    testWidgets('renders ProjectWebScaffold correctly', (tester) async {
      // Act
      await tester.pumpApp(
        const HomePageRoute(),
        _getHomePage(),
      );

      // Assert
      expect(find.byType(ProjectWebScaffold), findsOneWidget);
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
