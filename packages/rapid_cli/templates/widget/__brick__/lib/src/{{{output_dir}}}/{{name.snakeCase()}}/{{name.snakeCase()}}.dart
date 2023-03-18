{{#android}}import 'package:flutter/material.dart';{{/android}}{{#ios}}import 'package:flutter/cupertino.dart';{{/ios}}{{#linux}}import 'package:flutter/material.dart';{{/linux}}{{#macos}}import 'package:flutter/cupertino.dart';{{/macos}}{{#web}}import 'package:flutter/material.dart';{{/web}}{{#windows}}import 'package:fluent_ui/fluent_ui.dart';{{/windows}}import 'package:{{project_name.snakeCase()}}_ui_{{#android}}android{{/android}}{{#ios}}ios{{/ios}}{{#linux}}linux{{/linux}}{{#macos}}macos{{/macos}}{{#web}}web{{/web}}{{#windows}}windows{{/windows}}/src/{{name.snakeCase()}}/{{name.snakeCase()}}_theme.dart';

class {{project_name.pascalCase()}}{{name.pascalCase()}} extends StatelessWidget {
  final {{project_name.pascalCase()}}{{name.pascalCase()}}Theme? theme;

  const {{project_name.pascalCase()}}{{name.pascalCase()}}({
    super.key,
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = theme?.backgroundColor ?? context.backgroundColor;

    // TODO: implement
    return Container(
      color: backgroundColor,
    );
  }
}
