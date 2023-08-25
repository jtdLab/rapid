{{#android}}import '../{{project_name}}_ui_android.dart';

final lightExtensions = <ThemeExtension>[
  {{project_name.pascalCase()}}ScaffoldTheme.light,
];

final darkExtensions = <ThemeExtension>[
  {{project_name.pascalCase()}}ScaffoldTheme.dark,
];
{{/android}}{{#ios}}import 'package:flutter/material.dart' show ThemeExtension;
import '../{{project_name}}_ui_ios.dart';

final lightExtensions = <ThemeExtension>[
  {{project_name.pascalCase()}}ScaffoldTheme.light,
];

final darkExtensions = <ThemeExtension>[
  {{project_name.pascalCase()}}ScaffoldTheme.dark,
];
{{/ios}}{{#linux}}import '../{{project_name}}_ui_linux.dart';

final lightExtensions = <ThemeExtension>[
  {{project_name.pascalCase()}}ScaffoldTheme.light,
];

final darkExtensions = <ThemeExtension>[
  {{project_name.pascalCase()}}ScaffoldTheme.dark,
];
{{/linux}}{{#macos}}import 'package:flutter/material.dart' show ThemeExtension;
import '../{{project_name}}_ui_macos.dart';

final lightExtensions = <ThemeExtension>[
  {{project_name.pascalCase()}}ScaffoldTheme.light,
];

final darkExtensions = <ThemeExtension>[
  {{project_name.pascalCase()}}ScaffoldTheme.dark,
];
{{/macos}}{{#web}}import '../{{project_name}}_ui_web.dart';

final lightExtensions = <ThemeExtension>[
  {{project_name.pascalCase()}}ScaffoldTheme.light,
];

final darkExtensions = <ThemeExtension>[
  {{project_name.pascalCase()}}ScaffoldTheme.dark,
];
{{/web}}{{#windows}}import '../{{project_name}}_ui_windows.dart';

final lightExtensions = <ThemeExtension>[
  {{project_name.pascalCase()}}ScaffoldTheme.light,
];

final darkExtensions = <ThemeExtension>[
  {{project_name.pascalCase()}}ScaffoldTheme.dark,
];
{{/windows}}{{#mobile}}import '../{{project_name}}_ui_mobile.dart';

final lightExtensions = <ThemeExtension>[
  {{project_name.pascalCase()}}ScaffoldTheme.light,
];

final darkExtensions = <ThemeExtension>[
  {{project_name.pascalCase()}}ScaffoldTheme.dark,
];
{{/mobile}}