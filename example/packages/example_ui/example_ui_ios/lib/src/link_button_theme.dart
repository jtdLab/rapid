import 'package:example_ui_ios/example_ui_ios.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Theme, ThemeExtension;
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'link_button_theme.tailor.dart';

@Tailor(themeGetter: ThemeGetter.onBuildContext)
class _$ExampleLinkButtonTheme {
  static List<TextStyle> textStyle = [
    TextStyle(color: ExampleColorTheme.light.tertiary, fontSize: 14),
    TextStyle(color: ExampleColorTheme.dark.tertiary, fontSize: 14),
  ];
}
