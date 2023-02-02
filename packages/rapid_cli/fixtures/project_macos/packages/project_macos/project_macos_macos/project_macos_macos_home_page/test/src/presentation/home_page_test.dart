import 'package:flutter_test/flutter_test.dart';
import 'package:project_macos_macos_home_page/project_macos_macos_home_page.dart';
import 'package:project_macos_ui_macos/project_macos_ui_macos.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('HomePage', () {
    setUp(() {});

    HomePage homePage() => const HomePage();

    testWidgets('renders ProjectMacosScaffold', (tester) async {
      // Act
      await tester.pumpApp(homePage());

      // Assert
      expect(find.byType(ProjectMacosScaffold), findsOneWidget);
    });

    testWidgets('renders title correctly (en)', (tester) async {
      // Act
      await tester.pumpApp(homePage());

      // Assert
      expect(find.text('Home Page title in english'), findsOneWidget);
    });
  });
}