import 'package:flutter/widgets.dart';
import 'package:project_macos_macos_app/project_macos_macos_app.dart';
import 'package:project_macos_macos_home_page/project_macos_macos_home_page.dart';

const localizationsDelegates = <LocalizationsDelegate>[
  ProjectMacosMacosAppLocalizations.delegate,
  ProjectMacosMacosHomePageLocalizations.delegate,
];

final supportedLocales = <Locale>[
  const Locale('en'),
];
