import 'package:flutter_test/flutter_test.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:project_windows_ui_windows/src/scaffold.dart';
import 'package:project_windows_ui_windows/src/scaffold_theme.dart';

import 'helpers/pump_app.dart';

ProjectWindowsScaffold _getProjectWindowsScaffold({
  ProjectWindowsScaffoldTheme? theme,
  required Widget body,
}) {
  return ProjectWindowsScaffold(
    theme: theme,
    body: body,
  );
}

void main() {
  group('ProjectWindowsScaffold', () {
    testWidgets('renders NavigationView correctly', (tester) async {
      // Arrange
      const theme =
          ProjectWindowsScaffoldTheme(backgroundColor: Color(0xFF12FF12));
      final body = Container();
      final projectWindowsScaffold = _getProjectWindowsScaffold(
        theme: theme,
        body: body,
      );

      // Act
      await tester.pumpApp(projectWindowsScaffold);

      // Assert
      final navigationView =
          tester.widget<NavigationView>(find.byType(NavigationView));
      final content = navigationView.content;
      expect(content, isA<Container>());
      expect((content as Container).color, const Color(0xFF12FF12));
    });

    testWidgets('renders NavigationView correctly when no theme is provided',
        (tester) async {
      // Arrange
      final body = Container();
      final projectWindowsScaffold = _getProjectWindowsScaffold(
        body: body,
      );

      // Act
      await tester.pumpApp(projectWindowsScaffold);

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
