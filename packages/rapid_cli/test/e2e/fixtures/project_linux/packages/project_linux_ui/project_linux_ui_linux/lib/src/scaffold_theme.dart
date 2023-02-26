import 'package:flutter/material.dart';
import 'package:project_linux_ui/project_linux_ui.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'scaffold_theme.tailor.dart';

@tailorComponent
class _$ProjectLinuxScaffoldTheme {
  static List<Color> backgroundColor = [
    ProjectLinuxColorTheme.light.primary,
    ProjectLinuxColorTheme.dark.primary
  ];
}
