{{^android}}{{^ios}}{{^linux}}{{^macos}}{{^web}}{{^windows}}{{^mobile}}import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Theme, ThemeExtension;
import 'package:flutter/widgets.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part '{{name.snakeCase()}}_theme.tailor.dart';

@Tailor(themeGetter: ThemeGetter.onBuildContext)
class _${{project_name.pascalCase()}}{{name.pascalCase()}}Theme {
  static List<Color> backgroundColor = [
    const Color(0xFFFFFFFF),
    const Color(0xFF000000),
  ];
}{{/mobile}}{{/windows}}{{/web}}{{/macos}}{{/linux}}{{/ios}}{{/android}}{{#android}}import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Theme, ThemeExtension;
import 'package:flutter/widgets.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part '{{name.snakeCase()}}_theme.tailor.dart';

@Tailor(themeGetter: ThemeGetter.onBuildContext)
class _${{project_name.pascalCase()}}{{name.pascalCase()}}Theme {
  static List<Color> backgroundColor = [
    const Color(0xFFFFFFFF),
    const Color(0xFF000000),
  ];
}
{{/android}}{{#ios}}import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Theme, ThemeExtension;
import 'package:flutter/widgets.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part '{{name.snakeCase()}}_theme.tailor.dart';

@Tailor(themeGetter: ThemeGetter.onBuildContext)
class _${{project_name.pascalCase()}}{{name.pascalCase()}}Theme {
  static List<Color> backgroundColor = [
    const Color(0xFFFFFFFF),
    const Color(0xFF000000),
  ];
}
{{/ios}}{{#linux}}import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Theme, ThemeExtension;
import 'package:flutter/widgets.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part '{{name.snakeCase()}}_theme.tailor.dart';

@Tailor(themeGetter: ThemeGetter.onBuildContext)
class _${{project_name.pascalCase()}}{{name.pascalCase()}}Theme {
  static List<Color> backgroundColor = [
    const Color(0xFFFFFFFF),
    const Color(0xFF000000),
  ];
}
{{/linux}}{{#macos}}import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Theme, ThemeExtension;
import 'package:flutter/widgets.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part '{{name.snakeCase()}}_theme.tailor.dart';

@Tailor(themeGetter: ThemeGetter.onBuildContext)
class _${{project_name.pascalCase()}}{{name.pascalCase()}}Theme {
  static List<Color> backgroundColor = [
    const Color(0xFFFFFFFF),
    const Color(0xFF000000),
  ];
}
{{/macos}}{{#web}}import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Theme, ThemeExtension;
import 'package:flutter/widgets.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part '{{name.snakeCase()}}_theme.tailor.dart';

@Tailor(themeGetter: ThemeGetter.onBuildContext)
class _${{project_name.pascalCase()}}{{name.pascalCase()}}Theme {
  static List<Color> backgroundColor = [
    const Color(0xFFFFFFFF),
    const Color(0xFF000000),
  ];
}
{{/web}}{{#windows}}import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part '{{name.snakeCase()}}_theme.tailor.dart';

@Tailor(themeGetter: ThemeGetter.onBuildContext)
class _${{project_name.pascalCase()}}{{name.pascalCase()}}Theme {
  static List<Color> backgroundColor = [
    const Color(0xFFFFFFFF),
    const Color(0xFF000000),
  ];
}

// TODO: https://github.com/Iteo/theme_tailor/issues/83
extension {{project_name.pascalCase()}}{{name.pascalCase()}}ThemeBuildContext on BuildContext {
  {{project_name.pascalCase()}}{{name.pascalCase()}}Theme get {{project_name.camelCase()}}{{name.pascalCase()}}Theme =>
      FluentTheme.of(this).extension<{{project_name.pascalCase()}}{{name.pascalCase()}}Theme>()!;
}{{/windows}}{{#mobile}}import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Theme, ThemeExtension;
import 'package:flutter/widgets.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part '{{name.snakeCase()}}_theme.tailor.dart';

@Tailor(themeGetter: ThemeGetter.onBuildContext)
class _${{project_name.pascalCase()}}{{name.pascalCase()}}Theme {
  static List<Color> backgroundColor = [
    const Color(0xFFFFFFFF),
    const Color(0xFF000000),
  ];
}
{{/mobile}}
