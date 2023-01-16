import 'package:flutter_test/flutter_test.dart';
import 'package:project_ios_ui_ios/project_ios_ui_ios.dart';

import '../helpers/pump_app.dart';

void main() {
  group('ProjectIosScaffold', () {
    late ProjectIosScaffoldTheme? theme;
    const backgroundColor = Color(0xFF12FF12);

    late Widget body;

    setUp(() {
      theme = const ProjectIosScaffoldTheme(backgroundColor: backgroundColor);
      body = Container();
    });

    ProjectIosScaffold getScaffold() => ProjectIosScaffold(
          theme: theme,
          body: body,
        );

    testWidgets('renders Scaffold correctly', (tester) async {
      // Act
      await tester.pumpApp(getScaffold());

      // Assert
      final pageScaffold = tester
          .widget<CupertinoPageScaffold>(find.byType(CupertinoPageScaffold));
      expect(pageScaffold.backgroundColor, backgroundColor);
      expect(pageScaffold.child, body);
    });

    testWidgets('renders Scaffold correctly when no theme is provided',
        (tester) async {
      // Arrange
      theme = null;

      // Act
      await tester.pumpApp(getScaffold());

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
