{{#android}}import 'package:flutter/widgets.dart';
import 'package:{{project_name}}_android_app/{{project_name}}_android_app.dart';
import 'package:{{project_name}}_android_home_page/{{project_name}}_android_home_page.dart';

const localizationsDelegates = <LocalizationsDelegate>[
  AppLocalizations.delegate,
  HomePageLocalizations.delegate,
];

final supportedLocales = <Locale>[
  const Locale('en'),
];
{{/android}}{{#ios}}import 'package:flutter/widgets.dart';
import 'package:{{project_name}}_ios_app/{{project_name}}_ios_app.dart';
import 'package:{{project_name}}_ios_home_page/{{project_name}}_ios_home_page.dart';

const localizationsDelegates = <LocalizationsDelegate>[
  AppLocalizations.delegate,
  HomePageLocalizations.delegate,
];

final supportedLocales = <Locale>[
  const Locale('en'),
];
{{/ios}}{{#linux}}import 'package:flutter/widgets.dart';
import 'package:{{project_name}}_linux_app/{{project_name}}_linux_app.dart';
import 'package:{{project_name}}_linux_home_page/{{project_name}}_linux_home_page.dart';

const localizationsDelegates = <LocalizationsDelegate>[
  AppLocalizations.delegate,
  HomePageLocalizations.delegate,
];

final supportedLocales = <Locale>[
  const Locale('en'),
];
{{/linux}}{{#macos}}import 'package:flutter/widgets.dart';
import 'package:{{project_name}}_macos_app/{{project_name}}_macos_app.dart';
import 'package:{{project_name}}_macos_home_page/{{project_name}}_macos_home_page.dart';

const localizationsDelegates = <LocalizationsDelegate>[
  AppLocalizations.delegate,
  HomePageLocalizations.delegate,
];

final supportedLocales = <Locale>[
  const Locale('en'),
];
{{/macos}}{{#web}}import 'package:flutter/widgets.dart';
import 'package:{{project_name}}_web_app/{{project_name}}_web_app.dart';
import 'package:{{project_name}}_web_home_page/{{project_name}}_web_home_page.dart';

const localizationsDelegates = <LocalizationsDelegate>[
  AppLocalizations.delegate,
  HomePageLocalizations.delegate,
];

final supportedLocales = <Locale>[
  const Locale('en'),
];
{{/web}}{{#windows}}import 'package:flutter/widgets.dart';
import 'package:{{project_name}}_windows_app/{{project_name}}_windows_app.dart';
import 'package:{{project_name}}_windows_home_page/{{project_name}}_windows_home_page.dart';

const localizationsDelegates = <LocalizationsDelegate>[
  AppLocalizations.delegate,
  HomePageLocalizations.delegate,
];

final supportedLocales = <Locale>[
  const Locale('en'),
];
{{/windows}}{{#mobile}}import 'package:flutter/widgets.dart';
import 'package:{{project_name}}_mobile_app/{{project_name}}_mobile_app.dart';
import 'package:{{project_name}}_mobile_home_page/{{project_name}}_mobile_home_page.dart';

const localizationsDelegates = <LocalizationsDelegate>[
  AppLocalizations.delegate,
  HomePageLocalizations.delegate,
];

final supportedLocales = <Locale>[
  const Locale('en'),
];
{{/mobile}}