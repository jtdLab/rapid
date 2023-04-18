import 'package:flutter/widgets.dart';
import 'package:example_android_app/example_android_app.dart';
import 'package:example_android_home_page/example_android_home_page.dart';

const localizationsDelegates = <LocalizationsDelegate>[
  ExampleAndroidAppLocalizations.delegate,
  ExampleAndroidHomePageLocalizations.delegate,
];

final supportedLocales = <Locale>[
  const Locale('en'),
];
