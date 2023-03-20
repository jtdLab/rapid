import 'package:flutter_test/flutter_test.dart';
import 'package:project_ios_ios_home_page/src/presentation/presentation.dart';
import 'package:project_ios_ui_ios/project_ios_ui_ios.dart';

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
      expect(find.byType(ProjectIosScaffold), findsOneWidget);
      expect(find.text('Home Page title for en'), findsOneWidget);
    });
  });
}
