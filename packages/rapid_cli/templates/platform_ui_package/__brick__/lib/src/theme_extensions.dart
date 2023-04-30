{{#android}}import 'package:{{project_name}}_ui_android/{{project_name}}_ui_android.dart';

final lightExtensions = <ThemeExtension>[
  {{project_name.pascalCase()}}ScaffoldTheme.light,
];

final darkExtensions = <ThemeExtension>[
  {{project_name.pascalCase()}}ScaffoldTheme.dark,
];
{{/android}}{{#ios}}import 'package:flutter/material.dart' show ThemeExtension;
import 'package:{{project_name}}_ui_ios/{{project_name}}_ui_ios.dart';

final lightExtensions = <ThemeExtension>[
  {{project_name.pascalCase()}}ScaffoldTheme.light,
];

final darkExtensions = <ThemeExtension>[
  {{project_name.pascalCase()}}ScaffoldTheme.dark,
];
{{/ios}}{{#linux}}import 'package:{{project_name}}_ui_linux/{{project_name}}_ui_linux.dart';

final lightExtensions = <ThemeExtension>[
  {{project_name.pascalCase()}}ScaffoldTheme.light,
];

final darkExtensions = <ThemeExtension>[
  {{project_name.pascalCase()}}ScaffoldTheme.dark,
];
{{/linux}}{{#macos}}import 'package:flutter/material.dart' show ThemeExtension;
import 'package:{{project_name}}_ui_macos/{{project_name}}_ui_macos.dart';

final lightExtensions = <ThemeExtension>[
  {{project_name.pascalCase()}}ScaffoldTheme.light,
];

final darkExtensions = <ThemeExtension>[
  {{project_name.pascalCase()}}ScaffoldTheme.dark,
];
{{/macos}}{{#web}}import 'package:{{project_name}}_ui_web/{{project_name}}_ui_web.dart';

final lightExtensions = <ThemeExtension>[
  {{project_name.pascalCase()}}ScaffoldTheme.light,
];

final darkExtensions = <ThemeExtension>[
  {{project_name.pascalCase()}}ScaffoldTheme.dark,
];
{{/web}}{{#windows}}import 'package:{{project_name}}_ui_windows/{{project_name}}_ui_windows.dart';

final lightExtensions = <ThemeExtension>[
  {{project_name.pascalCase()}}ScaffoldTheme.light,
];

final darkExtensions = <ThemeExtension>[
  {{project_name.pascalCase()}}ScaffoldTheme.dark,
];
{{/windows}}