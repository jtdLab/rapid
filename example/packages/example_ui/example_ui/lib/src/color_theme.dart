import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show ThemeExtension;
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'color_theme.tailor.dart';

@Tailor(themeGetter: ThemeGetter.none)
class _$ExampleColorTheme {
  static List<Color> primary = [
    const Color(0xFF151839),
    const Color(0xFFFFFFFF),
  ];

  static List<Color> secondary = [
    const Color(0xFFFFFFFF),
    const Color(0xFF151839),
  ];

  static List<Color> tertiary = [
    const Color(0xFF1C97D4),
    const Color(0xFF1C97D4),
  ];

  static List<Color> grey = [
    CupertinoColors.systemGrey,
    const Color(0xFFE4E4E4),
  ];

  static List<Color> error = [
    const Color(0xFFCC281C),
    const Color(0xFFCC281C),
  ];
}
