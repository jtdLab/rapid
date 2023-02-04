import 'package:flutter_test/flutter_test.dart';
import 'package:project_macos_ui_macos/project_macos_ui_macos.dart';

import '../helpers/pump_app.dart';

void main() {
  group('ProjectMacosScaffold', () {
    late ProjectMacosScaffoldTheme? theme;
    const backgroundColor = Color(0xFF12FF12);

    late List<Widget> children;

    setUp(() {
      theme = const ProjectMacosScaffoldTheme(backgroundColor: backgroundColor);
      children = [
        ContentArea(
          builder: (context, scrollController) => Container(),
        )
      ];
    });

    ProjectMacosScaffold projectMacosScaffold() => ProjectMacosScaffold(
          theme: theme,
          children: children,
        );

    testWidgets(
        'renders PlatformMenuBar with MacosWindow and MacosScaffold correctly',
        (tester) async {
      // Act
      await tester.pumpApp(projectMacosScaffold());

      // Assert
      final platformMenuBar =
          tester.widget<PlatformMenuBar>(find.byType(PlatformMenuBar));
      final macosWindow = tester.widget<MacosWindow>(find.byType(MacosWindow));
      expect(platformMenuBar.child, macosWindow);
      final macosScaffold =
          tester.widget<MacosScaffold>(find.byType(MacosScaffold));
      expect(macosWindow.backgroundColor, backgroundColor);
      expect(macosWindow.child, macosScaffold);
      expect(macosScaffold.backgroundColor, backgroundColor);
      expect(macosScaffold.children, children);
    });

    testWidgets(
        'renders  PlatformMenuBar with MacosWindow and MacosScaffold correctly when no theme is provided',
        (tester) async {
      // Arrange
      theme = null;

      // Act
      await tester.pumpApp(projectMacosScaffold());

      // Assert
      final platformMenuBar =
          tester.widget<PlatformMenuBar>(find.byType(PlatformMenuBar));
      final macosWindow = tester.widget<MacosWindow>(find.byType(MacosWindow));
      expect(platformMenuBar.child, macosWindow);
      final macosScaffold =
          tester.widget<MacosScaffold>(find.byType(MacosScaffold));
      expect(
        macosWindow.backgroundColor,
        ProjectMacosScaffoldTheme.light.backgroundColor,
      );
      expect(macosWindow.child, macosScaffold);
      expect(
        macosScaffold.backgroundColor,
        ProjectMacosScaffoldTheme.light.backgroundColor,
      );
      expect(macosScaffold.children, children);
    });
  });
}
