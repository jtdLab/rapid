import 'package:flutter_test/flutter_test.dart';
import 'package:project_windows_ui_windows/project_windows_ui_windows.dart';

import '../helpers/pump_app.dart';

void main() {
  group('ProjectWindowsScaffold', () {
    late ProjectWindowsScaffoldTheme? theme;
    const backgroundColor = Color(0xFF12FF12);

    late Widget body;

    setUp(() {
      theme =
          const ProjectWindowsScaffoldTheme(backgroundColor: backgroundColor);
      body = Container();
    });

    ProjectWindowsScaffold projectWindowsScaffold() => ProjectWindowsScaffold(
          theme: theme,
          body: body,
        );

    testWidgets('renders NavigationView correctly', (tester) async {
      // Act
      await tester.pumpApp(projectWindowsScaffold());

      // Assert
      final navigationView =
          tester.widget<NavigationView>(find.byType(NavigationView));
      final content = navigationView.content;
      expect(content, isA<Container>());
      expect((content as Container).color, backgroundColor);
    });

    testWidgets('renders NavigationView correctly when no theme is provided',
        (tester) async {
      // Arrange
      theme = null;

      // Act
      await tester.pumpApp(projectWindowsScaffold());

      // Assert
      final navigationView =
          tester.widget<NavigationView>(find.byType(NavigationView));
      final content = navigationView.content;
      expect(content, isA<Container>());
      expect(
        (content as Container).color,
        ProjectWindowsScaffoldTheme.light.backgroundColor,
      );
    });
  });
}
