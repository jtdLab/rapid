import 'package:flutter_test/flutter_test.dart';
import 'package:project_windows_windows_home_page/src/presentation/presentation.dart';
import 'package:project_windows_ui_windows/project_windows_ui_windows.dart';

import 'helpers/helpers.dart';

void main() {
  group('HomePage', () {
    testWidgets('renders correctly (en)', (tester) async {
      // Act
      await tester.pumpApp(
        initialRoutes: [
          const HomeRoute(),
        ],
        locale: const Locale('en'),
      );

      // Assert
      expect(find.byType(ProjectWindowsScaffold), findsOneWidget);
      expect(find.text('Home Page title for en'), findsOneWidget);
    });
  });
}
