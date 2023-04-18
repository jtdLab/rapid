import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:project_ios_ui_ios/src/scaffold.dart';
import 'package:project_ios_ui_ios/src/scaffold_theme.dart';

import 'helpers/pump_app.dart';

ProjectIosScaffold _getProjectIosScaffold({
  ProjectIosScaffoldTheme? theme,
  required Widget body,
}) {
  return ProjectIosScaffold(
    theme: theme,
    body: body,
  );
}

void main() {
  group('ProjectIosScaffold', () {
    testWidgets('renders CupertinoPageScaffold correctly', (tester) async {
      // Arrange
      const theme = ProjectIosScaffoldTheme(backgroundColor: Color(0xFF12FF12));
      final body = Container();
      final projectIosScaffold = _getProjectIosScaffold(
        theme: theme,
        body: body,
      );

      // Act
      await tester.pumpApp(projectIosScaffold);

      // Assert
      final pageScaffold = tester
          .widget<CupertinoPageScaffold>(find.byType(CupertinoPageScaffold));
      expect(pageScaffold.backgroundColor, const Color(0xFF12FF12));
      expect(pageScaffold.child, body);
    });

    testWidgets(
        'renders CupertinoPageScaffold correctly when no theme is provided',
        (tester) async {
      // Arrange
      final body = Container();
      final projectIosScaffold = _getProjectIosScaffold(
        body: body,
      );

      // Act
      await tester.pumpApp(projectIosScaffold);

      // Assert
      final pageScaffold = tester
          .widget<CupertinoPageScaffold>(find.byType(CupertinoPageScaffold));
      expect(
        pageScaffold.backgroundColor,
        ProjectIosScaffoldTheme.light.backgroundColor,
      );
      expect(pageScaffold.child, body);
    });
  });
}
