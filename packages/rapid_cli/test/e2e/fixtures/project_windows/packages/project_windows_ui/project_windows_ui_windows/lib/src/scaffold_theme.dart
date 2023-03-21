import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Theme, ThemeExtension;
import 'package:flutter/widgets.dart';
import 'package:project_windows_ui/project_windows_ui.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'scaffold_theme.tailor.dart';

@Tailor(themeGetter: ThemeGetter.onBuildContext)
class _$ProjectWindowsScaffoldTheme {
  static List<Color> backgroundColor = [
    ProjectWindowsColorTheme.light.primary,
    ProjectWindowsColorTheme.dark.primary
  ];
}
