import 'package:flutter_test/flutter_test.dart';
import 'package:project_android_android_home_page/project_android_android_home_page.dart';
import 'package:project_android_ui_android/project_android_ui_android.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('HomePage', () {
    setUp(() {});

    HomePage homePage() => const HomePage();

    testWidgets('renders ProjectAndroidScaffold', (tester) async {
      // Act
      await tester.pumpApp(homePage());

      // Assert
      expect(find.byType(ProjectAndroidScaffold), findsOneWidget);
    });

    testWidgets('renders title correctly (en)', (tester) async {
      // Act
      await tester.pumpApp(homePage());

      // Assert
      expect(find.text('Home Page title in english'), findsOneWidget);
    });
  });
}
