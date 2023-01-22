import 'package:flutter/material.dart';
import 'package:project_ios_ui/project_ios_ui.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'scaffold_theme.tailor.dart';

@tailorComponent
class _$ProjectIosScaffoldTheme {
  static List<Color> backgroundColor = [
    ProjectIosColorTheme.light.primary,
    ProjectIosColorTheme.dark.primary
  ];
}
