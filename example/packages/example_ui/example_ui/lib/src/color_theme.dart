import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show ThemeExtension;
import 'package:flutter/widgets.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'color_theme.tailor.dart';

@Tailor(themeGetter: ThemeGetter.none)
class _$ExampleColorTheme {
  static List<Color> primary = [
    const Color(0xFF000000),
    const Color(0xFF000000),
  ];

  static List<Color> secondary = [
    const Color(0xFF32A44F),
    const Color(0xFF32A44F)
  ];

  static List<Color> tertiary = [
    const Color(0xFF1C97D4),
    const Color(0xFF1C97D4),
  ];

  static List<Color> quaternary = [
    const Color(0xFFF8AD2F),
    const Color(0xFFF8AD2F),
  ];

  static List<Color> grey = [
    const Color(0xFFE4E4E4),
    const Color(0xFFE4E4E4),
  ];

  static List<Color> background = [
    const Color(0xFFFFFFFF),
    const Color(0xFFFFFFFF),
  ];

  static List<Color> error = [
    const Color(0xFFCC281C),
    const Color(0xFFCC281C),
  ];
}
