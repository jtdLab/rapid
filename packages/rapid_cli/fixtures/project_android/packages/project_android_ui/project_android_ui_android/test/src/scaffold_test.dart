import 'package:flutter_test/flutter_test.dart';
import 'package:project_android_ui_android/project_android_ui_android.dart';

import '../helpers/pump_app.dart';

void main() {
  group('ProjectAndroidScaffold', () {
    late ProjectAndroidScaffoldTheme? theme;
    const backgroundColor = Color(0xFF12FF12);

    late Widget body;

    setUp(() {
      theme =
          const ProjectAndroidScaffoldTheme(backgroundColor: backgroundColor);
      body = Container();
    });

    ProjectAndroidScaffold getScaffold() => ProjectAndroidScaffold(
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
        ProjectAndroidScaffoldTheme.light.backgroundColor,
      );
      expect(scaffold.body, body);
    });
  });
}
