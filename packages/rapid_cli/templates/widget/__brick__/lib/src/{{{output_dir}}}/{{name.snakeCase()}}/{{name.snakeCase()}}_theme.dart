{{#android}}import 'package:flutter/material.dart';{{/android}}{{#ios}}import 'package:flutter/cupertino.dart';import 'package:flutter/material.dart' show Theme, ThemeExtension;{{/ios}}{{#linux}}import 'package:flutter/material.dart';{{/linux}}{{#macos}}import 'package:flutter/cupertino.dart';import 'package:flutter/material.dart' show Theme, ThemeExtension;{{/macos}}{{#web}}import 'package:flutter/material.dart';{{/web}}{{#windows}}import 'package:flutter/material.dart';{{/windows}}import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part '{{name.snakeCase()}}_theme.tailor.dart';

@tailor
class _${{project_name.pascalCase()}}{{name.pascalCase()}}Theme {
  static List<Color> backgroundColor = [
{{#android}}
    Colors.black,
    Colors.white,
{{/android}}
{{#ios}}
    CupertinoColors.black,
    CupertinoColors.white,
{{/ios}}
{{#linux}}
    Colors.black,
    Colors.white,
{{/linux}}
{{#macos}}
    CupertinoColors.black,
    CupertinoColors.white,
{{/macos}}
{{#web}}
    Colors.black,
    Colors.white,
{{/web}}
{{#windows}}
    Colors.black,
    Colors.white,
{{/windows}}
  ];
}
