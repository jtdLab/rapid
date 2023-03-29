{{#android}}import 'package:flutter/material.dart';
import 'package:{{project_name}}_ui_android/src/scaffold_theme.dart';

class {{project_name.pascalCase()}}Scaffold extends StatelessWidget {
  final {{project_name.pascalCase()}}ScaffoldTheme? theme;
  final Widget body;

  const {{project_name.pascalCase()}}Scaffold({
    super.key,
    this.theme,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? context.{{project_name.camelCase()}}ScaffoldTheme;
    final backgroundColor = theme.backgroundColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: body,
    );
  }
}
{{/android}}{{#ios}}
import 'package:flutter/cupertino.dart';
import 'package:{{project_name}}_ui_ios/src/scaffold_theme.dart';

class {{project_name.pascalCase()}}Scaffold extends StatelessWidget {
  final {{project_name.pascalCase()}}ScaffoldTheme? theme;
  final Widget body;

  const {{project_name.pascalCase()}}Scaffold({
    super.key,
    this.theme,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? context.{{project_name.camelCase()}}ScaffoldTheme;
    final backgroundColor = theme.backgroundColor;

    return CupertinoPageScaffold(
      backgroundColor: backgroundColor,
      child: body,
    );
  }
}
{{/ios}}{{#linux}}
import 'package:flutter/material.dart';
import 'package:{{project_name}}_ui_linux/src/scaffold_theme.dart';

class {{project_name.pascalCase()}}Scaffold extends StatelessWidget {
  final {{project_name.pascalCase()}}ScaffoldTheme? theme;
  final Widget body;

  const {{project_name.pascalCase()}}Scaffold({
    super.key,
    this.theme,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? context.{{project_name.camelCase()}}ScaffoldTheme;
    final backgroundColor = theme.backgroundColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: body,
    );
  }
}
{{/linux}}{{#macos}}
import 'package:flutter/cupertino.dart';
import 'package:{{project_name}}_ui_macos/src/scaffold_theme.dart';
import 'package:macos_ui/macos_ui.dart';

class {{project_name.pascalCase()}}Scaffold extends StatelessWidget {
  final {{project_name.pascalCase()}}ScaffoldTheme? theme;
  final List<Widget> children;

  const {{project_name.pascalCase()}}Scaffold({
    super.key,
    this.theme,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? context.{{project_name.camelCase()}}ScaffoldTheme;
    final backgroundColor = theme.backgroundColor;

    return PlatformMenuBar(
      menus: const [],
      child: MacosWindow(
        backgroundColor: backgroundColor,
        child: MacosScaffold(
          backgroundColor: backgroundColor,
          children: children,
        ),
      ),
    );
  }
}
{{/macos}}{{#web}}
import 'package:flutter/material.dart';
import 'package:{{project_name}}_ui_web/src/scaffold_theme.dart';

class {{project_name.pascalCase()}}Scaffold extends StatelessWidget {
  final {{project_name.pascalCase()}}ScaffoldTheme? theme;
  final Widget body;

  const {{project_name.pascalCase()}}Scaffold({
    super.key,
    this.theme,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? context.{{project_name.camelCase()}}ScaffoldTheme;
    final backgroundColor = theme.backgroundColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: body,
    );
  }
}
{{/web}}{{#windows}}
import 'package:fluent_ui/fluent_ui.dart';
import 'package:{{project_name}}_ui_windows/src/scaffold_theme.dart';

class {{project_name.pascalCase()}}Scaffold extends StatelessWidget {
  final {{project_name.pascalCase()}}ScaffoldTheme? theme;
  final Widget body;

  const {{project_name.pascalCase()}}Scaffold({
    super.key,
    this.theme,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? context.{{project_name.camelCase()}}ScaffoldTheme;
    final backgroundColor = theme.backgroundColor;

    return NavigationView(
      content: Container(
        color: backgroundColor,
        child: body,
      ),
    );
  }
}
{{/windows}}