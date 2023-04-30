import 'package:flutter/material.dart' show ThemeExtension;
import 'package:{{project_name}}_ui/{{project_name}}_ui.dart';

final lightExtensions = <ThemeExtension>[
  {{project_name.pascalCase()}}ColorTheme.light,
];

final darkExtensions = <ThemeExtension>[
  {{project_name.pascalCase()}}ColorTheme.dark,
];
