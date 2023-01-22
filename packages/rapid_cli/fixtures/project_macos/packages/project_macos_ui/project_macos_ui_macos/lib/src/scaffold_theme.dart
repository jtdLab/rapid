import 'package:flutter/material.dart';
import 'package:project_macos_ui/project_macos_ui.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'scaffold_theme.tailor.dart';

@tailorComponent
class _$ProjectMacosScaffoldTheme {
  static List<Color> backgroundColor = [
    ProjectMacosColorTheme.light.primary,
    ProjectMacosColorTheme.dark.primary
  ];
}
