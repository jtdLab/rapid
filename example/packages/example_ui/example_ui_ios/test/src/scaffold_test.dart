import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:example_ui_ios/src/scaffold.dart';
import 'package:example_ui_ios/src/scaffold_theme.dart';

import 'helpers/pump_app.dart';

ExampleScaffold _getExampleScaffold({
  ExampleScaffoldTheme? theme,
  required Widget body,
}) {
  return ExampleScaffold(
    theme: theme,
    child: body,
  );
}

void main() {
  group('ExampleScaffold', () {
    testWidgets('renders CupertinoPageScaffold correctly', (tester) async {
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
      final exampleScaffold = _getExampleScaffold(
        body: body,
      );

      // Act
      await tester.pumpApp(exampleScaffold);

      // Assert
      final pageScaffold = tester
          .widget<CupertinoPageScaffold>(find.byType(CupertinoPageScaffold));
      expect(
        pageScaffold.backgroundColor,
        ExampleScaffoldTheme.light.backgroundColor,
      );
      expect(pageScaffold.child, body);
    });
  });
}
