import 'package:flutter_test/flutter_test.dart';
import 'package:project_android_android_home_page/src/presentation/presentation.dart';
import 'package:project_android_ui_android/project_android_ui_android.dart';

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
      expect(find.byType(ProjectAndroidScaffold), findsOneWidget);
      expect(find.text('Home Page title for en'), findsOneWidget);
    });
  });
}
