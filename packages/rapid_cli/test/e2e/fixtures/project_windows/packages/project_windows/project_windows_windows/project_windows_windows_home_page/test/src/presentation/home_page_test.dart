import 'package:flutter_test/flutter_test.dart';
import 'package:project_windows_windows_home_page/src/presentation/presentation.dart';
import 'package:project_windows_ui_windows/project_windows_ui_windows.dart';
import 'package:project_windows_windows_routing/project_windows_windows_routing.dart';

import 'helpers/helpers.dart';

HomePage _getHomePage() {
  return const HomePage();
}

void main() {
  group('HomePage', () {
    testWidgets('renders ProjectWindowsScaffold correctly', (tester) async {
      // Act
      await tester.pumpApp(
        const HomePageRoute(),
        _getHomePage(),
      );

      // Assert
      expect(find.byType(ProjectWindowsScaffold), findsOneWidget);
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
