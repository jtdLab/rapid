{{#android}}import 'package:flutter/material.dart';

import 'scaffold_theme.dart';

class {{project_name.pascalCase()}}Scaffold extends StatelessWidget {
  const {{project_name.pascalCase()}}Scaffold({
    super.key,
    this.theme,
    required this.body,
  });

  final {{project_name.pascalCase()}}ScaffoldTheme? theme;

  final Widget body;

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

import 'scaffold_theme.dart';

class {{project_name.pascalCase()}}Scaffold extends StatelessWidget {
  const {{project_name.pascalCase()}}Scaffold({
    super.key,
    this.theme,
    required this.body,
  });

  final {{project_name.pascalCase()}}ScaffoldTheme? theme;

  final Widget body;

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

import 'scaffold_theme.dart';

class {{project_name.pascalCase()}}Scaffold extends StatelessWidget {
  const {{project_name.pascalCase()}}Scaffold({
    super.key,
    this.theme,
    required this.body,
  });

  final {{project_name.pascalCase()}}ScaffoldTheme? theme;

  final Widget body;

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
import 'package:macos_ui/macos_ui.dart';

import 'scaffold_theme.dart';

class {{project_name.pascalCase()}}Scaffold extends StatelessWidget {
  const {{project_name.pascalCase()}}Scaffold({
    super.key,
    this.theme,
    required this.children,
  });

  final {{project_name.pascalCase()}}ScaffoldTheme? theme;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? context.{{project_name.camelCase()}}ScaffoldTheme;
    final backgroundColor = theme.backgroundColor;

    // TODO: https://github.com/macosui/macos_ui/issues/428
    return MacosOverlayFilter(
      borderRadius: BorderRadius.zero,
      color: backgroundColor,
      child: MacosScaffold(
        backgroundColor: backgroundColor,
        children: children,
      ),
    );
  }
}
{{/macos}}{{#web}}
import 'package:flutter/material.dart';

import 'scaffold_theme.dart';

class {{project_name.pascalCase()}}Scaffold extends StatelessWidget {
  const {{project_name.pascalCase()}}Scaffold({
    super.key,
    this.theme,
    required this.body,
  });

  final {{project_name.pascalCase()}}ScaffoldTheme? theme;

  final Widget body;

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

import 'scaffold_theme.dart';

class {{project_name.pascalCase()}}Scaffold extends StatelessWidget {
  const {{project_name.pascalCase()}}Scaffold({
    super.key,
    this.theme,
   required this.body,
  });

  final {{project_name.pascalCase()}}ScaffoldTheme? theme;

  final Widget body;

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? context.{{project_name.camelCase()}}ScaffoldTheme;
    final backgroundColor = theme.backgroundColor;

    return NavigationView(
      content: ColoredBox(
        color: backgroundColor,
        child: body,
      ),
    );
  }
}
{{/windows}}{{#mobile}}import 'package:flutter/material.dart';

import 'scaffold_theme.dart';

class {{project_name.pascalCase()}}Scaffold extends StatelessWidget {
  const {{project_name.pascalCase()}}Scaffold({
    super.key,
    this.theme,
    required this.body,
  });

  final {{project_name.pascalCase()}}ScaffoldTheme? theme;

  final Widget body;

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
{{/mobile}}