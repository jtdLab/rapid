import 'package:flutter/widgets.dart';
import 'package:example_macos_app/example_macos_app.dart';
import 'package:example_macos_home_page/example_macos_home_page.dart';

const localizationsDelegates = <LocalizationsDelegate>[
  ExampleMacosAppLocalizations.delegate,
  ExampleMacosHomePageLocalizations.delegate,
];

final supportedLocales = <Locale>[
  const Locale('en'),
];
