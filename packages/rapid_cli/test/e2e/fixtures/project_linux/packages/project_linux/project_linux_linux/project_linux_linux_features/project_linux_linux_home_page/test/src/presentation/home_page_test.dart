import 'package:flutter_test/flutter_test.dart';
import 'package:project_linux_linux_home_page/src/presentation/presentation.dart';
import 'package:project_linux_ui_linux/project_linux_ui_linux.dart';

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
      expect(find.byType(ProjectLinuxScaffold), findsOneWidget);
      expect(find.text('Home Page title for en'), findsOneWidget);
    });
  });
}
