import 'package:flutter_test/flutter_test.dart';
import 'package:project_web_web_home_page/src/presentation/presentation.dart';
import 'package:project_web_ui_web/project_web_ui_web.dart';

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
      expect(find.byType(ProjectWebScaffold), findsOneWidget);
      expect(find.text('Home Page title for en'), findsOneWidget);
    });
  });
}
