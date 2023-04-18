import 'package:flutter/widgets.dart';
import 'package:example_web_app/example_web_app.dart';
import 'package:example_web_home_page/example_web_home_page.dart';

const localizationsDelegates = <LocalizationsDelegate>[
  ExampleWebAppLocalizations.delegate,
  ExampleWebHomePageLocalizations.delegate,
];

final supportedLocales = <Locale>[
  const Locale('en'),
];
