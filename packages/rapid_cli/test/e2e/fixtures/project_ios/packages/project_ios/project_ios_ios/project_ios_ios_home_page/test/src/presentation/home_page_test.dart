import 'package:flutter_test/flutter_test.dart';
import 'package:project_ios_ios_home_page/project_ios_ios_home_page.dart';
import 'package:project_ios_ui_ios/project_ios_ui_ios.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('HomePage', () {
    setUp(() {});

    HomePage homePage() => const HomePage();

    testWidgets('renders ProjectIosScaffold', (tester) async {
      // Act
      await tester.pumpApp(homePage());

      // Assert
      expect(find.byType(ProjectIosScaffold), findsOneWidget);
    });

    testWidgets('renders title correctly (en)', (tester) async {
      // Act
      await tester.pumpApp(homePage());

      // Assert
      expect(find.text('Home Page title for en'), findsOneWidget);
    });
  });
}
