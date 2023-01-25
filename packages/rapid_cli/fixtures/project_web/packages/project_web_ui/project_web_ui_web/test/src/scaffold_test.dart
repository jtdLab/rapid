import 'package:flutter_test/flutter_test.dart';
import 'package:project_web_ui_web/project_web_ui_web.dart';

import '../helpers/pump_app.dart';

void main() {
  group('ProjectWebScaffold', () {
    late ProjectWebScaffoldTheme? theme;
    const backgroundColor = Color(0xFF12FF12);

    late Widget body;

    setUp(() {
      theme = const ProjectWebScaffoldTheme(backgroundColor: backgroundColor);
      body = Container();
    });

    ProjectWebScaffold getScaffold() => ProjectWebScaffold(
          theme: theme,
          body: body,
        );

    testWidgets('renders Scaffold correctly', (tester) async {
      // Act
      await tester.pumpApp(getScaffold());

      // Assert
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, backgroundColor);
      expect(scaffold.body, body);
    });

    testWidgets('renders Scaffold correctly when no theme is provided',
        (tester) async {
      // Arrange
      theme = null;

      // Act
      await tester.pumpApp(getScaffold());

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
