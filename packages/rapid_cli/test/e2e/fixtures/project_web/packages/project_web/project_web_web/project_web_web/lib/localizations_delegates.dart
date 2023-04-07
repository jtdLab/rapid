import 'package:flutter/widgets.dart';
import 'package:project_web_web_app/project_web_web_app.dart';
import 'package:project_web_web_home_page/project_web_web_home_page.dart';

const localizationsDelegates = <LocalizationsDelegate>[
  ProjectWebWebAppLocalizations.delegate,
  ProjectWebWebHomePageLocalizations.delegate,
];

final supportedLocales = <Locale>[
  const Locale('en'),
];
