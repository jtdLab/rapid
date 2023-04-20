import 'package:flutter_test/flutter_test.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:example_ui_windows/src/scaffold.dart';
import 'package:example_ui_windows/src/scaffold_theme.dart';

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
    testWidgets('renders NavigationView correctly', (tester) async {
      // Arrange
      const theme = ExampleScaffoldTheme(backgroundColor: Color(0xFF12FF12));
      final body = Container();
      final exampleScaffold = _getExampleScaffold(
        theme: theme,
        body: body,
      );

      // Act
      await tester.pumpApp(exampleScaffold);

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
      final exampleScaffold = _getExampleScaffold(
        body: body,
      );

      // Act
      await tester.pumpApp(exampleScaffold);

      // Assert
      final navigationView =
          tester.widget<NavigationView>(find.byType(NavigationView));
      final content = navigationView.content;
      expect(content, isA<Container>());
      expect(
        (content as Container).color,
        ExampleScaffoldTheme.light.backgroundColor,
      );
    });
  });
}
