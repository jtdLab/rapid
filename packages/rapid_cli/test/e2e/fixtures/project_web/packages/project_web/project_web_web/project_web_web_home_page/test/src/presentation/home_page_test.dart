import 'package:flutter_test/flutter_test.dart';
import 'package:project_web_web_home_page/project_web_web_home_page.dart';
import 'package:project_web_ui_web/project_web_ui_web.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('HomePage', () {
    setUp(() {});

    HomePage homePage() => const HomePage();

    testWidgets('renders ProjectWebScaffold', (tester) async {
      // Act
      await tester.pumpApp(homePage());

      // Assert
      expect(find.byType(ProjectWebScaffold), findsOneWidget);
    });

    testWidgets('renders title correctly (en)', (tester) async {
      // Act
      await tester.pumpApp(homePage());

      // Assert
      expect(find.text('Home Page title for en'), findsOneWidget);
    });
  });
}
