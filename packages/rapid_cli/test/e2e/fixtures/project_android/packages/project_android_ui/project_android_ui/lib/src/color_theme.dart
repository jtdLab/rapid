import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show ThemeExtension;
import 'package:flutter/widgets.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'color_theme.tailor.dart';

@Tailor(themeGetter: ThemeGetter.none)
class _$ProjectAndroidColorTheme {
  static List<Color> primary = [
    const Color(0xFFFFFFFF),
    const Color(0xFF222222)
  ];

  static List<Color> secondary = [
    const Color(0xFF3277B4),
    const Color(0xFF284D72)
  ];
}
