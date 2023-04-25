import 'package:example_ui/example_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Theme, ThemeExtension;
import 'package:flutter/widgets.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'primary_button_theme.tailor.dart';

@Tailor(themeGetter: ThemeGetter.onBuildContext)
class _$ExamplePrimaryButtonTheme {
  static List<Color> backgroundColor = [
    ExampleColorTheme.light.primary,
    ExampleColorTheme.dark.primary,
  ];

  static List<BorderRadius> borderRadius = [
    BorderRadius.circular(12),
    BorderRadius.circular(12),
  ];

  static List<TextStyle> textStyle = [
    const TextStyle(color: Color(0xFFFFFFFF)),
    const TextStyle(color: Color(0xFF000000)),
  ];
}
