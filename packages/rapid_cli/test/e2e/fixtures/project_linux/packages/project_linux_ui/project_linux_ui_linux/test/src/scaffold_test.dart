import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:project_linux_ui_linux/src/scaffold.dart';
import 'package:project_linux_ui_linux/src/scaffold_theme.dart';

import 'helpers/pump_app.dart';

ProjectLinuxScaffold _getProjectLinuxScaffold({
  ProjectLinuxScaffoldTheme? theme,
  required Widget body,
}) {
  return ProjectLinuxScaffold(
    theme: theme,
    body: body,
  );
}

void main() {
  group('ProjectLinuxScaffold', () {
    testWidgets('renders Scaffold correctly', (tester) async {
      // Arrange
      const theme =
          ProjectLinuxScaffoldTheme(backgroundColor: Color(0xFF12FF12));
      final body = Container();
      final projectLinuxScaffold = _getProjectLinuxScaffold(
        theme: theme,
        body: body,
      );

      // Act
      await tester.pumpApp(projectLinuxScaffold);

      // Assert
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, const Color(0xFF12FF12));
      expect(scaffold.body, body);
    });

    testWidgets('renders Scaffold correctly when no theme is provided',
        (tester) async {
      // Arrange
      final body = Container();
      final projectLinuxScaffold = _getProjectLinuxScaffold(
        body: body,
      );

      // Act
      await tester.pumpApp(projectLinuxScaffold);

      // Assert
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(
        scaffold.backgroundColor,
        ProjectLinuxScaffoldTheme.light.backgroundColor,
      );
      expect(scaffold.body, body);
    });
  });
}
