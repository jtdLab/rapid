import 'package:flutter/material.dart';
import 'package:project_web_ui/project_web_ui.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'scaffold_theme.tailor.dart';

@tailorComponent
class _$ProjectWebScaffoldTheme {
  static List<Color> backgroundColor = [
    ProjectWebColorTheme.light.primary,
    ProjectWebColorTheme.dark.primary
  ];
}
