import 'package:flutter/widgets.dart';
import 'package:example_windows_app/example_windows_app.dart';
import 'package:example_windows_home_page/example_windows_home_page.dart';

const localizationsDelegates = <LocalizationsDelegate>[
  ExampleWindowsAppLocalizations.delegate,
  ExampleWindowsHomePageLocalizations.delegate,
];

final supportedLocales = <Locale>[
  const Locale('en'),
];
