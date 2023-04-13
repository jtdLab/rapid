import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:project_web_ui_web/src/scaffold.dart';
import 'package:project_web_ui_web/src/scaffold_theme.dart';

import 'helpers/pump_app.dart';

ProjectWebScaffold _getProjectWebScaffold({
  ProjectWebScaffoldTheme? theme,
  required Widget body,
}) {
  return ProjectWebScaffold(
    theme: theme,
    body: body,
  );
}

void main() {
  group('ProjectWebScaffold', () {
    testWidgets('renders Scaffold correctly', (tester) async {
      // Arrange
      const theme = ProjectWebScaffoldTheme(backgroundColor: Color(0xFF12FF12));
      final body = Container();
      final projectWebScaffoldTheme = _getProjectWebScaffold(
        theme: theme,
        body: body,
      );

      // Act
      await tester.pumpApp(projectWebScaffoldTheme);

      // Assert
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, const Color(0xFF12FF12));
      expect(scaffold.body, body);
    });

    testWidgets('renders Scaffold correctly when no theme is provided',
        (tester) async {
      // Arrange
      final body = Container();
      final projectWebScaffold = _getProjectWebScaffold(
        body: body,
      );

      // Act
      await tester.pumpApp(projectWebScaffold);

      // Assert
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(
        scaffold.backgroundColor,
        ProjectWebScaffoldTheme.light.backgroundColor,
      );
      expect(scaffold.body, body);
    });
  });
}
