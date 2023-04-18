import 'package:flutter/widgets.dart';
import 'package:example_ios_app/example_ios_app.dart';
import 'package:example_ios_home_page/example_ios_home_page.dart';

const localizationsDelegates = <LocalizationsDelegate>[
  ExampleIosAppLocalizations.delegate,
  ExampleIosHomePageLocalizations.delegate,
];

final supportedLocales = <Locale>[
  const Locale('en'),
];
