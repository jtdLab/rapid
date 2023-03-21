import 'package:flutter_test/flutter_test.dart';
import 'package:project_macos_macos_home_page/src/presentation/presentation.dart';
import 'package:project_macos_ui_macos/project_macos_ui_macos.dart';

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
      expect(find.byType(ProjectMacosScaffold), findsOneWidget);
      expect(find.text('Home Page title for en'), findsOneWidget);
    });
  });
}
