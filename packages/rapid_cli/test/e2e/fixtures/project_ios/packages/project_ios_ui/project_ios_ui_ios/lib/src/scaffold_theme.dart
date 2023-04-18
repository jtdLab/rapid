import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Theme, ThemeExtension;
import 'package:flutter/widgets.dart';
import 'package:project_ios_ui/project_ios_ui.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'scaffold_theme.tailor.dart';

@Tailor(themeGetter: ThemeGetter.onBuildContext)
class _$ProjectIosScaffoldTheme {
  static List<Color> backgroundColor = [
    ProjectIosColorTheme.light.primary,
    ProjectIosColorTheme.dark.primary
  ];
}
