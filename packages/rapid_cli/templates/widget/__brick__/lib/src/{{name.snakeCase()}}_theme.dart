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
{{/web}}{{#windows}}import 'package:flutter/foundation.dart';
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
{{/windows}}{{#mobile}}import 'package:flutter/foundation.dart';
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
