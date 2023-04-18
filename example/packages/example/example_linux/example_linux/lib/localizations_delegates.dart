import 'package:flutter/widgets.dart';
import 'package:example_linux_app/example_linux_app.dart';
import 'package:example_linux_home_page/example_linux_home_page.dart';

const localizationsDelegates = <LocalizationsDelegate>[
  ExampleLinuxAppLocalizations.delegate,
  ExampleLinuxHomePageLocalizations.delegate,
];

final supportedLocales = <Locale>[
  const Locale('en'),
];
