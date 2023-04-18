import 'package:example_ui/example_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Theme, ThemeExtension;
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'text_field_theme.tailor.dart';

@Tailor(themeGetter: ThemeGetter.onBuildContext)
class _$ExampleTextFieldTheme {
  static List<Color> color = [
    CupertinoColors.systemGrey,
    CupertinoColors.systemGrey,
  ];

  static List<Color> errorColor = [
    ExampleColorTheme.light.error,
    ExampleColorTheme.dark.error,
  ];

  static List<Color> cursorColor = [
    const Color(0xFF000000),
    const Color(0xFF000000),
  ];
}
