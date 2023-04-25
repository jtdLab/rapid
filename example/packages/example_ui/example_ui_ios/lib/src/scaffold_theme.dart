import 'package:example_ui/example_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Theme, ThemeExtension;
import 'package:flutter/widgets.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'scaffold_theme.tailor.dart';

@Tailor(themeGetter: ThemeGetter.onBuildContext)
class _$ExampleScaffoldTheme {
  static List<Color> backgroundColor = [
    ExampleColorTheme.light.secondary,
    ExampleColorTheme.dark.secondary
  ];

  static List<EdgeInsets> padding = [
    const EdgeInsets.fromLTRB(10, 0, 10, 5),
    const EdgeInsets.fromLTRB(10, 0, 10, 5),
  ];
}
