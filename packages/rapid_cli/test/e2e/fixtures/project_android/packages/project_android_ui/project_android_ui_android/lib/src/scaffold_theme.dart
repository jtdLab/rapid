import 'package:flutter/material.dart';
import 'package:project_android_ui/project_android_ui.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'scaffold_theme.tailor.dart';

@tailorComponent
class _$ProjectAndroidScaffoldTheme {
  static List<Color> backgroundColor = [
    ProjectAndroidColorTheme.light.primary,
    ProjectAndroidColorTheme.dark.primary
  ];
}
