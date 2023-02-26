import 'package:flutter_test/flutter_test.dart';
import 'package:project_linux_linux_home_page/src/presentation/presentation.dart';
import 'package:project_linux_ui_linux/project_linux_ui_linux.dart';
import 'package:project_linux_linux_routing/project_linux_linux_routing.dart';

import 'helpers/helpers.dart';

HomePage _getHomePage() {
  return const HomePage();
}

void main() {
  group('HomePage', () {
    testWidgets('renders ProjectLinuxScaffold correctly', (tester) async {
      // Act
      await tester.pumpApp(
        const HomePageRoute(),
        _getHomePage(),
      );

      // Assert
      expect(find.byType(ProjectLinuxScaffold), findsOneWidget);
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
