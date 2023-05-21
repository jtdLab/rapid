{{^android}}{{^ios}}{{^linux}}{{^macos}}{{^web}}{{^windows}}import 'package:flutter/widgets.dart';
import 'package:{{project_name.snakeCase()}}_ui/src/{{name.snakeCase()}}_theme.dart';

class {{project_name.pascalCase()}}{{name.pascalCase()}} extends StatelessWidget {
  final {{project_name.pascalCase()}}{{name.pascalCase()}}Theme? theme;

  const {{project_name.pascalCase()}}{{name.pascalCase()}}({
    super.key,
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? context.{{project_name.camelCase()}}{{name.pascalCase()}}Theme;
    final backgroundColor = theme.backgroundColor;

    // TODO: implement
    return Container(
      color: backgroundColor,
    );
  }
}{{/windows}}{{/web}}{{/macos}}{{/linux}}{{/ios}}{{/android}}
{{#android}}import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}_ui_android/src/{{name.snakeCase()}}_theme.dart';

class {{project_name.pascalCase()}}{{name.pascalCase()}} extends StatelessWidget {
  final {{project_name.pascalCase()}}{{name.pascalCase()}}Theme? theme;

  const {{project_name.pascalCase()}}{{name.pascalCase()}}({
    super.key,
    this.theme,
  });

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
import 'package:{{project_name.snakeCase()}}_ui_ios/src/{{name.snakeCase()}}_theme.dart';

class {{project_name.pascalCase()}}{{name.pascalCase()}} extends StatelessWidget {
  final {{project_name.pascalCase()}}{{name.pascalCase()}}Theme? theme;

  const {{project_name.pascalCase()}}{{name.pascalCase()}}({
    super.key,
    this.theme,
  });

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
import 'package:{{project_name.snakeCase()}}_ui_linux/src/{{name.snakeCase()}}_theme.dart';

class {{project_name.pascalCase()}}{{name.pascalCase()}} extends StatelessWidget {
  final {{project_name.pascalCase()}}{{name.pascalCase()}}Theme? theme;

  const {{project_name.pascalCase()}}{{name.pascalCase()}}({
    super.key,
    this.theme,
  });

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
import 'package:{{project_name.snakeCase()}}_ui_macos/src/{{name.snakeCase()}}_theme.dart';

class {{project_name.pascalCase()}}{{name.pascalCase()}} extends StatelessWidget {
  final {{project_name.pascalCase()}}{{name.pascalCase()}}Theme? theme;

  const {{project_name.pascalCase()}}{{name.pascalCase()}}({
    super.key,
    this.theme,
  });

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
import 'package:{{project_name.snakeCase()}}_ui_web/src/{{name.snakeCase()}}_theme.dart';

class {{project_name.pascalCase()}}{{name.pascalCase()}} extends StatelessWidget {
  final {{project_name.pascalCase()}}{{name.pascalCase()}}Theme? theme;

  const {{project_name.pascalCase()}}{{name.pascalCase()}}({
    super.key,
    this.theme,
  });

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
import 'package:{{project_name.snakeCase()}}_ui_windows/src/{{name.snakeCase()}}_theme.dart';

class {{project_name.pascalCase()}}{{name.pascalCase()}} extends StatelessWidget {
  final {{project_name.pascalCase()}}{{name.pascalCase()}}Theme? theme;

  const {{project_name.pascalCase()}}{{name.pascalCase()}}({
    super.key,
    this.theme,
  });

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
import 'package:{{project_name.snakeCase()}}_ui_mobile/src/{{name.snakeCase()}}_theme.dart';

class {{project_name.pascalCase()}}{{name.pascalCase()}} extends StatelessWidget {
  final {{project_name.pascalCase()}}{{name.pascalCase()}}Theme? theme;

  const {{project_name.pascalCase()}}{{name.pascalCase()}}({
    super.key,
    this.theme,
  });

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
