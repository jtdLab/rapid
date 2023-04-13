import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:project_macos_ui_macos/src/scaffold.dart';
import 'package:project_macos_ui_macos/src/scaffold_theme.dart';

import 'helpers/pump_app.dart';

ProjectMacosScaffold _getProjectMacosScaffold({
  ProjectMacosScaffoldTheme? theme,
  required List<Widget> children,
}) {
  return ProjectMacosScaffold(
    theme: theme,
    children: children,
  );
}

void main() {
  group('ProjectMacosScaffold', () {
    testWidgets(
        'renders PlatformMenuBar with MacosWindow and MacosScaffold correctly',
        (tester) async {
      // Arrange
      const theme =
          ProjectMacosScaffoldTheme(backgroundColor: Color(0xFF12FF12));
      final children = [ContentArea(builder: (_, __) => Container())];
      final projectMacosScaffoldTheme = _getProjectMacosScaffold(
        theme: theme,
        children: children,
      );

      // Act
      await tester.pumpApp(projectMacosScaffoldTheme);

      // Assert
      final platformMenuBar =
          tester.widget<PlatformMenuBar>(find.byType(PlatformMenuBar));
      final macosWindow = tester.widget<MacosWindow>(find.byType(MacosWindow));
      expect(platformMenuBar.child, macosWindow);
      final macosScaffold =
          tester.widget<MacosScaffold>(find.byType(MacosScaffold));
      expect(macosWindow.backgroundColor, const Color(0xFF12FF12));
      expect(macosWindow.child, macosScaffold);
      expect(macosScaffold.backgroundColor, const Color(0xFF12FF12));
      expect(macosScaffold.children, children);
    });

    testWidgets(
        'renders  PlatformMenuBar with MacosWindow and MacosScaffold correctly when no theme is provided',
        (tester) async {
      // Arrange
      final children = [ContentArea(builder: (_, __) => Container())];
      final projectMacosScaffoldTheme = _getProjectMacosScaffold(
        children: children,
      );

      // Act
      await tester.pumpApp(projectMacosScaffoldTheme);

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
