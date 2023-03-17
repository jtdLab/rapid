import 'package:flutter_test/flutter_test.dart';
import 'package:project_macos_macos_home_page/src/presentation/presentation.dart';
import 'package:project_macos_ui_macos/project_macos_ui_macos.dart';
import 'package:project_macos_macos_routing/project_macos_macos_routing.dart';

import 'helpers/helpers.dart';

HomePage _getHomePage() {
  return const HomePage();
}

void main() {
  group('HomePage', () {
    testWidgets('renders ProjectMacosScaffold correctly', (tester) async {
      // Act
      await tester.pumpApp(
        const HomePageRoute(),
        _getHomePage(),
      );

      // Assert
      expect(find.byType(ProjectMacosScaffold), findsOneWidget);
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
