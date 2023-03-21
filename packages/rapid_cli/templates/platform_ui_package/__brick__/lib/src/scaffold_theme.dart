{{#android}}import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Theme, ThemeExtension;
import 'package:flutter/widgets.dart';
import 'package:{{project_name}}_ui/{{project_name}}_ui.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'scaffold_theme.tailor.dart';

@Tailor(themeGetter: ThemeGetter.onBuildContext)
class _${{project_name.pascalCase()}}ScaffoldTheme {
  static List<Color> backgroundColor = [
    {{project_name.pascalCase()}}ColorTheme.light.primary,
    {{project_name.pascalCase()}}ColorTheme.dark.primary
  ];
}
{{/android}}{{#ios}}import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Theme, ThemeExtension;
import 'package:flutter/widgets.dart';
import 'package:{{project_name}}_ui/{{project_name}}_ui.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'scaffold_theme.tailor.dart';

@Tailor(themeGetter: ThemeGetter.onBuildContext)
class _${{project_name.pascalCase()}}ScaffoldTheme {
  static List<Color> backgroundColor = [
    {{project_name.pascalCase()}}ColorTheme.light.primary,
    {{project_name.pascalCase()}}ColorTheme.dark.primary
  ];
}
{{/ios}}{{#linux}}import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Theme, ThemeExtension;
import 'package:flutter/widgets.dart';
import 'package:{{project_name}}_ui/{{project_name}}_ui.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'scaffold_theme.tailor.dart';

@Tailor(themeGetter: ThemeGetter.onBuildContext)
class _${{project_name.pascalCase()}}ScaffoldTheme {
  static List<Color> backgroundColor = [
    {{project_name.pascalCase()}}ColorTheme.light.primary,
    {{project_name.pascalCase()}}ColorTheme.dark.primary
  ];
}
{{/linux}}{{#macos}}import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Theme, ThemeExtension;
import 'package:flutter/widgets.dart';
import 'package:{{project_name}}_ui/{{project_name}}_ui.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'scaffold_theme.tailor.dart';

@Tailor(themeGetter: ThemeGetter.onBuildContext)
class _${{project_name.pascalCase()}}ScaffoldTheme {
  static List<Color> backgroundColor = [
    {{project_name.pascalCase()}}ColorTheme.light.primary,
    {{project_name.pascalCase()}}ColorTheme.dark.primary
  ];
}
{{/macos}}{{#web}}import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Theme, ThemeExtension;
import 'package:flutter/widgets.dart';
import 'package:{{project_name}}_ui/{{project_name}}_ui.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'scaffold_theme.tailor.dart';

@Tailor(themeGetter: ThemeGetter.onBuildContext)
class _${{project_name.pascalCase()}}ScaffoldTheme {
  static List<Color> backgroundColor = [
    {{project_name.pascalCase()}}ColorTheme.light.primary,
    {{project_name.pascalCase()}}ColorTheme.dark.primary
  ];
}
{{/web}}{{#windows}}import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Theme, ThemeExtension;
import 'package:flutter/widgets.dart';
import 'package:{{project_name}}_ui/{{project_name}}_ui.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'scaffold_theme.tailor.dart';

@Tailor(themeGetter: ThemeGetter.onBuildContext)
class _${{project_name.pascalCase()}}ScaffoldTheme {
  static List<Color> backgroundColor = [
    {{project_name.pascalCase()}}ColorTheme.light.primary,
    {{project_name.pascalCase()}}ColorTheme.dark.primary
  ];
}
{{/windows}}