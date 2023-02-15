import 'package:flutter_test/flutter_test.dart';
import 'package:project_windows_windows_home_page/project_windows_windows_home_page.dart';
import 'package:project_windows_ui_windows/project_windows_ui_windows.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('HomePage', () {
    setUp(() {});

    HomePage homePage() => const HomePage();

    testWidgets('renders ProjectWindowsScaffold', (tester) async {
      // Act
      await tester.pumpApp(homePage());

      // Assert
      expect(find.byType(ProjectWindowsScaffold), findsOneWidget);
    });

    testWidgets('renders title correctly (en)', (tester) async {
      // Act
      await tester.pumpApp(homePage());

      // Assert
      expect(find.text('Home Page title for en'), findsOneWidget);
    });
  });
}
