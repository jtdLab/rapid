import 'package:flutter_test/flutter_test.dart';
{{#android}}import 'package:flutter/material.dart';{{/android}}{{#ios}}import 'package:flutter/cupertino.dart';{{/ios}}{{#linux}}import 'package:flutter/material.dart';{{/linux}}{{#macos}}import 'package:flutter/widgets.dart';import 'package:macos_ui/macos_ui.dart';{{/macos}}{{#web}}import 'package:flutter/material.dart';{{/web}}{{#windows}}import 'package:fluent_ui/fluent_ui.dart';{{/windows}}{{#mobile}}import 'package:flutter/material.dart';{{/mobile}}
{{#android}}import 'package:{{project_name}}_ui_android/src/scaffold.dart';import 'package:{{project_name}}_ui_android/src/scaffold_theme.dart';{{/android}}{{#ios}}import 'package:{{project_name}}_ui_ios/src/scaffold.dart';import 'package:{{project_name}}_ui_ios/src/scaffold_theme.dart';{{/ios}}{{#linux}}import 'package:{{project_name}}_ui_linux/src/scaffold.dart';import 'package:{{project_name}}_ui_linux/src/scaffold_theme.dart';{{/linux}}{{#macos}}import 'package:{{project_name}}_ui_macos/src/scaffold.dart';import 'package:{{project_name}}_ui_macos/src/scaffold_theme.dart';{{/macos}}{{#web}}import 'package:{{project_name}}_ui_web/src/scaffold.dart';import 'package:{{project_name}}_ui_web/src/scaffold_theme.dart';{{/web}}{{#windows}}import 'package:{{project_name}}_ui_windows/src/scaffold.dart';import 'package:{{project_name}}_ui_windows/src/scaffold_theme.dart';{{/windows}}{{#mobile}}import 'package:{{project_name}}_ui_mobile/src/scaffold.dart';import 'package:{{project_name}}_ui_mobile/src/scaffold_theme.dart';{{/mobile}}

import 'helpers/pump_app.dart';

{{^macos}}{{project_name.pascalCase()}}Scaffold _get{{project_name.pascalCase()}}Scaffold({
  {{project_name.pascalCase()}}ScaffoldTheme? theme,
  required Widget body,
}) {
  return {{project_name.pascalCase()}}Scaffold(
    theme: theme,
    body: body,
  );
}{{/macos}}{{#macos}}{{project_name.pascalCase()}}Scaffold _get{{project_name.pascalCase()}}Scaffold({
  {{project_name.pascalCase()}}ScaffoldTheme? theme,
  required List<Widget> children,
}) {
  return {{project_name.pascalCase()}}Scaffold(
    theme: theme,
    children: children,
  );
}
{{/macos}}

{{#android}}void main() {
  group('{{project_name.pascalCase()}}Scaffold', () {
    testWidgets('renders Scaffold correctly', (tester) async {
      // Arrange
      const theme = {{project_name.pascalCase()}}ScaffoldTheme(backgroundColor: Color(0xFF12FF12));
      final body = Container();
      final {{project_name.camelCase()}}Scaffold = _get{{project_name.pascalCase()}}Scaffold(
        theme: theme,
        body: body,
      );

      // Act
      await tester.pumpApp({{project_name.camelCase()}}Scaffold);

      // Assert
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, const Color(0xFF12FF12));
      expect(scaffold.body, body);
    });

    testWidgets('renders Scaffold correctly when no theme is provided',
        (tester) async {
      // Arrange
      final body = Container();
      final {{project_name.camelCase()}}Scaffold = _get{{project_name.pascalCase()}}Scaffold(
        body: body,
      );

      // Act
      await tester.pumpApp({{project_name.camelCase()}}Scaffold);

      // Assert
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(
        scaffold.backgroundColor,
        {{project_name.pascalCase()}}ScaffoldTheme.light.backgroundColor,
      );
      expect(scaffold.body, body);
    });
  });
}
{{/android}}{{#ios}}void main() {
  group('{{project_name.pascalCase()}}Scaffold', () {
    testWidgets('renders CupertinoPageScaffold correctly', (tester) async {
      // Arrange
      const theme = {{project_name.pascalCase()}}ScaffoldTheme(backgroundColor: Color(0xFF12FF12));
      final body = Container();
      final {{project_name.camelCase()}}Scaffold = _get{{project_name.pascalCase()}}Scaffold(
        theme: theme,
        body: body,
      );

      // Act
      await tester.pumpApp({{project_name.camelCase()}}Scaffold);

      // Assert
      final pageScaffold = tester.widget<CupertinoPageScaffold>(find.byType(CupertinoPageScaffold));
      expect(pageScaffold.backgroundColor, const Color(0xFF12FF12));
      expect(pageScaffold.child, body);
    });

    testWidgets('renders CupertinoPageScaffold correctly when no theme is provided',
        (tester) async {
      // Arrange
      final body = Container();
      final {{project_name.camelCase()}}Scaffold = _get{{project_name.pascalCase()}}Scaffold(
        body: body,
      );

      // Act
      await tester.pumpApp({{project_name.camelCase()}}Scaffold);

      // Assert
      final pageScaffold = tester.widget<CupertinoPageScaffold>(find.byType(CupertinoPageScaffold));
      expect(
        pageScaffold.backgroundColor,
        {{project_name.pascalCase()}}ScaffoldTheme.light.backgroundColor,
      );
      expect(pageScaffold.child, body);
    });
  });
}
{{/ios}}{{#linux}}void main() {
  group('{{project_name.pascalCase()}}Scaffold', () {
    testWidgets('renders Scaffold correctly', (tester) async {
      // Arrange
      const theme = {{project_name.pascalCase()}}ScaffoldTheme(backgroundColor: Color(0xFF12FF12));
      final body = Container();
      final {{project_name.camelCase()}}Scaffold = _get{{project_name.pascalCase()}}Scaffold(
        theme: theme,
        body: body,
      );

      // Act
      await tester.pumpApp({{project_name.camelCase()}}Scaffold);

      // Assert
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, const Color(0xFF12FF12));
      expect(scaffold.body, body);
    });

    testWidgets('renders Scaffold correctly when no theme is provided',
        (tester) async {
      // Arrange
      final body = Container();
      final {{project_name.camelCase()}}Scaffold = _get{{project_name.pascalCase()}}Scaffold(
        body: body,
      );

      // Act
      await tester.pumpApp({{project_name.camelCase()}}Scaffold);

      // Assert
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(
        scaffold.backgroundColor,
        {{project_name.pascalCase()}}ScaffoldTheme.light.backgroundColor,
      );
      expect(scaffold.body, body);
    });
  });
}
{{/linux}}{{#macos}}void main() {
  group('{{project_name.pascalCase()}}Scaffold', () {
    testWidgets('renders PlatformMenuBar with MacosWindow and MacosScaffold correctly', (tester) async {
      // Arrange
      const theme = {{project_name.pascalCase()}}ScaffoldTheme(backgroundColor: Color(0xFF12FF12));
      final children = [ContentArea(builder: (_, __) => Container())];
      final {{project_name.camelCase()}}ScaffoldTheme = _get{{project_name.pascalCase()}}Scaffold(
        theme: theme,
        children: children,
      );

      // Act
      await tester.pumpApp({{project_name.camelCase()}}ScaffoldTheme);
      await tester.pumpAndSettle();

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

    testWidgets('renders  PlatformMenuBar with MacosWindow and MacosScaffold correctly when no theme is provided',
        (tester) async {
      // Arrange
      final children = [ContentArea(builder: (_, __) => Container())];
      final {{project_name.camelCase()}}ScaffoldTheme = _get{{project_name.pascalCase()}}Scaffold(
        children: children,
      );

      // Act
      await tester.pumpApp({{project_name.camelCase()}}ScaffoldTheme);
      await tester.pumpAndSettle();

      // Assert
      final platformMenuBar =
          tester.widget<PlatformMenuBar>(find.byType(PlatformMenuBar));
      final macosWindow = tester.widget<MacosWindow>(find.byType(MacosWindow));
      expect(platformMenuBar.child, macosWindow);
      final macosScaffold =
          tester.widget<MacosScaffold>(find.byType(MacosScaffold));
      expect(
        macosWindow.backgroundColor,
        {{project_name.pascalCase()}}ScaffoldTheme.light.backgroundColor,
      );
      expect(macosWindow.child, macosScaffold);
      expect(
        macosScaffold.backgroundColor,
        {{project_name.pascalCase()}}ScaffoldTheme.light.backgroundColor,
      );
      expect(macosScaffold.children, children);
    });
  });
}
{{/macos}}{{#web}}void main() {
  group('{{project_name.pascalCase()}}Scaffold', () {
    testWidgets('renders Scaffold correctly', (tester) async {
      // Arrange
      const theme = {{project_name.pascalCase()}}ScaffoldTheme(backgroundColor: Color(0xFF12FF12));
      final body = Container();
      final {{project_name.camelCase()}}ScaffoldTheme = _get{{project_name.pascalCase()}}Scaffold(
        theme: theme,
        body: body,
      );

      // Act
      await tester.pumpApp({{project_name.camelCase()}}ScaffoldTheme);

      // Assert
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, const Color(0xFF12FF12));
      expect(scaffold.body, body);
    });

    testWidgets('renders Scaffold correctly when no theme is provided',
        (tester) async {
      // Arrange
      final body = Container();
      final {{project_name.camelCase()}}Scaffold = _get{{project_name.pascalCase()}}Scaffold(
        body: body,
      );

      // Act
      await tester.pumpApp({{project_name.camelCase()}}Scaffold);

      // Assert
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(
        scaffold.backgroundColor,
        {{project_name.pascalCase()}}ScaffoldTheme.light.backgroundColor,
      );
      expect(scaffold.body, body);
    });
  });
}
{{/web}}{{#windows}}void main() {
  group('{{project_name.pascalCase()}}Scaffold', () {
    testWidgets('renders NavigationView correctly', (tester) async {
      // Arrange
      const theme = {{project_name.pascalCase()}}ScaffoldTheme(backgroundColor: Color(0xFF12FF12));
      final body = Container();
      final {{project_name.camelCase()}}Scaffold = _get{{project_name.pascalCase()}}Scaffold(
        theme: theme,
        body: body,
      );

      // Act
      await tester.pumpApp({{project_name.camelCase()}}Scaffold);

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
      final {{project_name.camelCase()}}Scaffold = _get{{project_name.pascalCase()}}Scaffold(
        body: body,
      );

      // Act
      await tester.pumpApp({{project_name.camelCase()}}Scaffold);

      // Assert
      final navigationView =
          tester.widget<NavigationView>(find.byType(NavigationView));
      final content = navigationView.content;
      expect(content, isA<Container>());
      expect(
        (content as Container).color,
        {{project_name.pascalCase()}}ScaffoldTheme.light.backgroundColor,
      );
    });
  });
}
{{/windows}}{{#mobile}}void main() {
  group('{{project_name.pascalCase()}}Scaffold', () {
    testWidgets('renders Scaffold correctly', (tester) async {
      // Arrange
      const theme = {{project_name.pascalCase()}}ScaffoldTheme(backgroundColor: Color(0xFF12FF12));
      final body = Container();
      final {{project_name.camelCase()}}Scaffold = _get{{project_name.pascalCase()}}Scaffold(
        theme: theme,
        body: body,
      );

      // Act
      await tester.pumpApp({{project_name.camelCase()}}Scaffold);

      // Assert
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, const Color(0xFF12FF12));
      expect(scaffold.body, body);
    });

    testWidgets('renders Scaffold correctly when no theme is provided',
        (tester) async {
      // Arrange
      final body = Container();
      final {{project_name.camelCase()}}Scaffold = _get{{project_name.pascalCase()}}Scaffold(
        body: body,
      );

      // Act
      await tester.pumpApp({{project_name.camelCase()}}Scaffold);

      // Assert
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(
        scaffold.backgroundColor,
        {{project_name.pascalCase()}}ScaffoldTheme.light.backgroundColor,
      );
      expect(scaffold.body, body);
    });
  });
}
{{/mobile}}