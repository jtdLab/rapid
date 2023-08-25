{{^android}}{{^ios}}{{^linux}}{{^macos}}{{^web}}{{^windows}}{{^mobile}}import 'package:flutter/widgets.dart';

import '{{name.snakeCase()}}_theme.dart';

class {{project_name.pascalCase()}}{{name.pascalCase()}} extends StatelessWidget {
  const {{project_name.pascalCase()}}{{name.pascalCase()}}({
    super.key,
    this.theme,
  });

  final {{project_name.pascalCase()}}{{name.pascalCase()}}Theme? theme;

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? context.{{project_name.camelCase()}}{{name.pascalCase()}}Theme;
    final backgroundColor = theme.backgroundColor;

    // TODO: implement
    return Container(
      color: backgroundColor,
    );
  }
}{{/mobile}}{{/windows}}{{/web}}{{/macos}}{{/linux}}{{/ios}}{{/android}}
{{#android}}import 'package:flutter/material.dart';

import '{{name.snakeCase()}}_theme.dart';

class {{project_name.pascalCase()}}{{name.pascalCase()}} extends StatelessWidget {
  const {{project_name.pascalCase()}}{{name.pascalCase()}}({
    super.key,
    this.theme,
  });

  final {{project_name.pascalCase()}}{{name.pascalCase()}}Theme? theme;

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? context.{{project_name.camelCase()}}{{name.pascalCase()}}Theme;
    final backgroundColor = theme.backgroundColor;

    // TODO: implement
    return Container(
      color: backgroundColor,
    );
  }
}{{/android}}{{#ios}}import 'package:flutter/cupertino.dart';

import '{{name.snakeCase()}}_theme.dart';

class {{project_name.pascalCase()}}{{name.pascalCase()}} extends StatelessWidget {
  const {{project_name.pascalCase()}}{{name.pascalCase()}}({
    super.key,
    this.theme,
  });

  final {{project_name.pascalCase()}}{{name.pascalCase()}}Theme? theme;

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? context.{{project_name.camelCase()}}{{name.pascalCase()}}Theme;
    final backgroundColor = theme.backgroundColor;

    // TODO: implement
    return Container(
      color: backgroundColor,
    );
  }
}{{/ios}}{{#linux}}import 'package:flutter/material.dart';

import '{{name.snakeCase()}}_theme.dart';

class {{project_name.pascalCase()}}{{name.pascalCase()}} extends StatelessWidget {
  const {{project_name.pascalCase()}}{{name.pascalCase()}}({
    super.key,
    this.theme,
  });

  final {{project_name.pascalCase()}}{{name.pascalCase()}}Theme? theme;

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? context.{{project_name.camelCase()}}{{name.pascalCase()}}Theme;
    final backgroundColor = theme.backgroundColor;

    // TODO: implement
    return Container(
      color: backgroundColor,
    );
  }
}{{/linux}}{{#macos}}import 'package:flutter/cupertino.dart';

import '{{name.snakeCase()}}_theme.dart';

class {{project_name.pascalCase()}}{{name.pascalCase()}} extends StatelessWidget {
  const {{project_name.pascalCase()}}{{name.pascalCase()}}({
    super.key,
    this.theme,
  });

  final {{project_name.pascalCase()}}{{name.pascalCase()}}Theme? theme;

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? context.{{project_name.camelCase()}}{{name.pascalCase()}}Theme;
    final backgroundColor = theme.backgroundColor;

    // TODO: implement
    return Container(
      color: backgroundColor,
    );
  }
}{{/macos}}{{#web}}import 'package:flutter/material.dart';

import '{{name.snakeCase()}}_theme.dart';

class {{project_name.pascalCase()}}{{name.pascalCase()}} extends StatelessWidget {
  const {{project_name.pascalCase()}}{{name.pascalCase()}}({
    super.key,
    this.theme,
  });

  final {{project_name.pascalCase()}}{{name.pascalCase()}}Theme? theme;

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? context.{{project_name.camelCase()}}{{name.pascalCase()}}Theme;
    final backgroundColor = theme.backgroundColor;

    // TODO: implement
    return Container(
      color: backgroundColor,
    );
  }
}{{/web}}{{#windows}}import 'package:fluent_ui/fluent_ui.dart';

import '{{name.snakeCase()}}_theme.dart';

class {{project_name.pascalCase()}}{{name.pascalCase()}} extends StatelessWidget {
  const {{project_name.pascalCase()}}{{name.pascalCase()}}({
    super.key,
    this.theme,
  });

  final {{project_name.pascalCase()}}{{name.pascalCase()}}Theme? theme;

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? context.{{project_name.camelCase()}}{{name.pascalCase()}}Theme;
    final backgroundColor = theme.backgroundColor;

    // TODO: implement
    return Container(
      color: backgroundColor,
    );
  }
}{{/windows}}{{#mobile}}import 'package:flutter/material.dart';

import '{{name.snakeCase()}}_theme.dart';

class {{project_name.pascalCase()}}{{name.pascalCase()}} extends StatelessWidget {
  const {{project_name.pascalCase()}}{{name.pascalCase()}}({
    super.key,
    this.theme,
  });

  final {{project_name.pascalCase()}}{{name.pascalCase()}}Theme? theme;

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? context.{{project_name.camelCase()}}{{name.pascalCase()}}Theme;
    final backgroundColor = theme.backgroundColor;

    // TODO: implement
    return Container(
      color: backgroundColor,
    );
  }
}{{/mobile}}
