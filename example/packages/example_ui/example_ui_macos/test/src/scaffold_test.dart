import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:example_ui_macos/src/scaffold.dart';
import 'package:example_ui_macos/src/scaffold_theme.dart';

import 'helpers/pump_app.dart';

ExampleScaffold _getExampleScaffold({
  ExampleScaffoldTheme? theme,
  required List<Widget> children,
}) {
  return ExampleScaffold(
    theme: theme,
    children: children,
  );
}

void main() {
  group('ExampleScaffold', () {
    testWidgets(
        'renders PlatformMenuBar with MacosWindow and MacosScaffold correctly',
        (tester) async {
      // Arrange
      const theme = ExampleScaffoldTheme(backgroundColor: Color(0xFF12FF12));
      final children = [ContentArea(builder: (_, __) => Container())];
      final exampleScaffoldTheme = _getExampleScaffold(
        theme: theme,
        children: children,
      );

      // Act
      await tester.pumpApp(exampleScaffoldTheme);

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
      final exampleScaffoldTheme = _getExampleScaffold(
        children: children,
      );

      // Act
      await tester.pumpApp(exampleScaffoldTheme);

      // Assert
      final platformMenuBar =
          tester.widget<PlatformMenuBar>(find.byType(PlatformMenuBar));
      final macosWindow = tester.widget<MacosWindow>(find.byType(MacosWindow));
      expect(platformMenuBar.child, macosWindow);
      final macosScaffold =
          tester.widget<MacosScaffold>(find.byType(MacosScaffold));
      expect(
        macosWindow.backgroundColor,
        ExampleScaffoldTheme.light.backgroundColor,
      );
      expect(macosWindow.child, macosScaffold);
      expect(
        macosScaffold.backgroundColor,
        ExampleScaffoldTheme.light.backgroundColor,
      );
      expect(macosScaffold.children, children);
    });
  });
}
