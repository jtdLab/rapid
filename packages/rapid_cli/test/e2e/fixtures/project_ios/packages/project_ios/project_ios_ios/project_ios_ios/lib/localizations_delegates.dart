import 'package:flutter/widgets.dart';
import 'package:project_ios_ios_app/project_ios_ios_app.dart';
import 'package:project_ios_ios_home_page/project_ios_ios_home_page.dart';

const localizationsDelegates = <LocalizationsDelegate>[
  ProjectIosIosAppLocalizations.delegate,
  ProjectIosIosHomePageLocalizations.delegate,
];

final supportedLocales = <Locale>[
  const Locale('en'),
];
