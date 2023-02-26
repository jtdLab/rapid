import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:project_android_ui_android/src/scaffold.dart';
import 'package:project_android_ui_android/src/scaffold_theme.dart';

import 'helpers/pump_app.dart';

ProjectAndroidScaffold _getProjectAndroidScaffold({
  ProjectAndroidScaffoldTheme? theme,
  required Widget body,
}) {
  return ProjectAndroidScaffold(
    theme: theme,
    body: body,
  );
}

void main() {
  group('ProjectAndroidScaffold', () {
    testWidgets('renders Scaffold correctly', (tester) async {
      // Arrange
      const theme =
          ProjectAndroidScaffoldTheme(backgroundColor: Color(0xFF12FF12));
      final body = Container();
      final projectAndroidScaffold = _getProjectAndroidScaffold(
        theme: theme,
        body: body,
      );

      // Act
      await tester.pumpApp(projectAndroidScaffold);

      // Assert
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, const Color(0xFF12FF12));
      expect(scaffold.body, body);
    });

    testWidgets('renders Scaffold correctly when no theme is provided',
        (tester) async {
      // Arrange
      final body = Container();
      final projectAndroidScaffold = _getProjectAndroidScaffold(
        body: body,
      );

      // Act
      await tester.pumpApp(projectAndroidScaffold);

      // Assert
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(
        scaffold.backgroundColor,
        ProjectAndroidScaffoldTheme.light.backgroundColor,
      );
      expect(scaffold.body, body);
    });
  });
}
