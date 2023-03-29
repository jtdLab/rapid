{{#android}}import 'package:flutter/widgets.dart';
import 'package:{{project_name}}_android_app/{{project_name}}_android_app.dart';
import 'package:{{project_name}}_android_home_page/{{project_name}}_android_home_page.dart';

const localizationsDelegates = <LocalizationsDelegate>[
  {{project_name.pascalCase()}}AndroidAppLocalizations.delegate,
  {{project_name.pascalCase()}}AndroidHomePageLocalizations.delegate,
];

final supportedLocales = <Locale>[
  const Locale('en'),
];
{{/android}}{{#ios}}import 'package:flutter/widgets.dart';
import 'package:{{project_name}}_ios_app/{{project_name}}_ios_app.dart';
import 'package:{{project_name}}_ios_home_page/{{project_name}}_ios_home_page.dart';

const localizationsDelegates = <LocalizationsDelegate>[
  {{project_name.pascalCase()}}IosAppLocalizations.delegate,
  {{project_name.pascalCase()}}IosHomePageLocalizations.delegate,
];

final supportedLocales = <Locale>[
  const Locale('en'),
];
{{/ios}}{{#linux}}import 'package:flutter/widgets.dart';
import 'package:{{project_name}}_linux_app/{{project_name}}_linux_app.dart';
import 'package:{{project_name}}_linux_home_page/{{project_name}}_linux_home_page.dart';

const localizationsDelegates = <LocalizationsDelegate>[
  {{project_name.pascalCase()}}LinuxAppLocalizations.delegate,
  {{project_name.pascalCase()}}LinuxHomePageLocalizations.delegate,
];

final supportedLocales = <Locale>[
  const Locale('en'),
];
{{/linux}}{{#macos}}import 'package:flutter/widgets.dart';
import 'package:{{project_name}}_macos_app/{{project_name}}_macos_app.dart';
import 'package:{{project_name}}_macos_home_page/{{project_name}}_macos_home_page.dart';

const localizationsDelegates = <LocalizationsDelegate>[
  {{project_name.pascalCase()}}MacosAppLocalizations.delegate,
  {{project_name.pascalCase()}}MacosHomePageLocalizations.delegate,
];

final supportedLocales = <Locale>[
  const Locale('en'),
];
{{/macos}}{{#web}}import 'package:flutter/widgets.dart';
import 'package:{{project_name}}_web_app/{{project_name}}_web_app.dart';
import 'package:{{project_name}}_web_home_page/{{project_name}}_web_home_page.dart';

const localizationsDelegates = <LocalizationsDelegate>[
  {{project_name.pascalCase()}}WebAppLocalizations.delegate,
  {{project_name.pascalCase()}}WebHomePageLocalizations.delegate,
];

final supportedLocales = <Locale>[
  const Locale('en'),
];
{{/web}}{{#windows}}import 'package:flutter/widgets.dart';
import 'package:{{project_name}}_windows_app/{{project_name}}_windows_app.dart';
import 'package:{{project_name}}_windows_home_page/{{project_name}}_windows_home_page.dart';

const localizationsDelegates = <LocalizationsDelegate>[
  {{project_name.pascalCase()}}WindowsAppLocalizations.delegate,
  {{project_name.pascalCase()}}WindowsHomePageLocalizations.delegate,
];

final supportedLocales = <Locale>[
  const Locale('en'),
];
{{/windows}}