import 'package:flutter_test/flutter_test.dart';
import 'package:project_linux_ui_linux/project_linux_ui_linux.dart';

import '../helpers/pump_app.dart';

void main() {
  group('ProjectLinuxScaffold', () {
    late ProjectLinuxScaffoldTheme? theme;
    const backgroundColor = Color(0xFF12FF12);

    late Widget body;

    setUp(() {
      theme = const ProjectLinuxScaffoldTheme(backgroundColor: backgroundColor);
      body = Container();
    });

    ProjectLinuxScaffold projectLinuxScaffold() => ProjectLinuxScaffold(
          theme: theme,
          body: body,
        );

    testWidgets('renders Scaffold correctly', (tester) async {
      // Act
      await tester.pumpApp(projectLinuxScaffold());

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
      await tester.pumpApp(projectLinuxScaffold());

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
