import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:example_ui_web/src/scaffold.dart';
import 'package:example_ui_web/src/scaffold_theme.dart';

import 'helpers/pump_app.dart';

ExampleScaffold _getExampleScaffold({
  ExampleScaffoldTheme? theme,
  required Widget body,
}) {
  return ExampleScaffold(
    theme: theme,
    body: body,
  );
}

void main() {
  group('ExampleScaffold', () {
    testWidgets('renders Scaffold correctly', (tester) async {
      // Arrange
      const theme = ExampleScaffoldTheme(backgroundColor: Color(0xFF12FF12));
      final body = Container();
      final exampleScaffoldTheme = _getExampleScaffold(
        theme: theme,
        body: body,
      );

      // Act
      await tester.pumpApp(exampleScaffoldTheme);

      // Assert
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, const Color(0xFF12FF12));
      expect(scaffold.body, body);
    });

    testWidgets('renders Scaffold correctly when no theme is provided',
        (tester) async {
      // Arrange
      final body = Container();
      final exampleScaffold = _getExampleScaffold(
        body: body,
      );

      // Act
      await tester.pumpApp(exampleScaffold);

      // Assert
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(
        scaffold.backgroundColor,
        ExampleScaffoldTheme.light.backgroundColor,
      );
      expect(scaffold.body, body);
    });
  });
}
