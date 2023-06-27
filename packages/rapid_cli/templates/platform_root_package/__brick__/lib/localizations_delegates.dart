{{#android}}import 'package:flutter/widgets.dart';
import 'package:{{project_name}}_android_home_page/{{project_name}}_android_home_page.dart';

const localizationsDelegates = <LocalizationsDelegate>[
  HomePageLocalizations.delegate,
];

final supportedLocales = <Locale>[
  {{#languages}}const Locale.fromSubtags(languageCode: '{{language_code}}'{{#has_script_code}}, scriptCode: '{{script_code}}'{{/has_script_code}}{{#has_country_code}}, countryCode: '{{country_code}}'{{/has_country_code}},),{{/languages}}
];
{{/android}}{{#ios}}import 'package:flutter/widgets.dart';
import 'package:{{project_name}}_ios_home_page/{{project_name}}_ios_home_page.dart';

const localizationsDelegates = <LocalizationsDelegate>[
  HomePageLocalizations.delegate,
];

final supportedLocales = <Locale>[
  {{#languages}}const Locale.fromSubtags(languageCode: '{{language_code}}'{{#has_script_code}}, scriptCode: '{{script_code}}'{{/has_script_code}}{{#has_country_code}}, countryCode: '{{country_code}}'{{/has_country_code}},),{{/languages}}
];
{{/ios}}{{#linux}}import 'package:flutter/widgets.dart';
import 'package:{{project_name}}_linux_home_page/{{project_name}}_linux_home_page.dart';

const localizationsDelegates = <LocalizationsDelegate>[
  HomePageLocalizations.delegate,
];

final supportedLocales = <Locale>[
  {{#languages}}const Locale.fromSubtags(languageCode: '{{language_code}}'{{#has_script_code}}, scriptCode: '{{script_code}}'{{/has_script_code}}{{#has_country_code}}, countryCode: '{{country_code}}'{{/has_country_code}},),{{/languages}}
];
{{/linux}}{{#macos}}import 'package:flutter/widgets.dart';
import 'package:{{project_name}}_macos_home_page/{{project_name}}_macos_home_page.dart';

const localizationsDelegates = <LocalizationsDelegate>[
  HomePageLocalizations.delegate,
];

final supportedLocales = <Locale>[
  {{#languages}}const Locale.fromSubtags(languageCode: '{{language_code}}'{{#has_script_code}}, scriptCode: '{{script_code}}'{{/has_script_code}}{{#has_country_code}}, countryCode: '{{country_code}}'{{/has_country_code}},),{{/languages}}
];
{{/macos}}{{#web}}import 'package:flutter/widgets.dart';
import 'package:{{project_name}}_web_home_page/{{project_name}}_web_home_page.dart';

const localizationsDelegates = <LocalizationsDelegate>[
  HomePageLocalizations.delegate,
];

final supportedLocales = <Locale>[
  {{#languages}}const Locale.fromSubtags(languageCode: '{{language_code}}'{{#has_script_code}}, scriptCode: '{{script_code}}'{{/has_script_code}}{{#has_country_code}}, countryCode: '{{country_code}}'{{/has_country_code}},),{{/languages}}
];
{{/web}}{{#windows}}import 'package:flutter/widgets.dart';
import 'package:{{project_name}}_windows_home_page/{{project_name}}_windows_home_page.dart';

const localizationsDelegates = <LocalizationsDelegate>[
  HomePageLocalizations.delegate,
];

final supportedLocales = <Locale>[
  {{#languages}}const Locale.fromSubtags(languageCode: '{{language_code}}'{{#has_script_code}}, scriptCode: '{{script_code}}'{{/has_script_code}}{{#has_country_code}}, countryCode: '{{country_code}}'{{/has_country_code}},),{{/languages}}
];
{{/windows}}{{#mobile}}import 'package:flutter/widgets.dart';
import 'package:{{project_name}}_mobile_home_page/{{project_name}}_mobile_home_page.dart';

const localizationsDelegates = <LocalizationsDelegate>[
  HomePageLocalizations.delegate,
];

final supportedLocales = <Locale>[
  {{#languages}}const Locale.fromSubtags(languageCode: '{{language_code}}'{{#has_script_code}}, scriptCode: '{{script_code}}'{{/has_script_code}}{{#has_country_code}}, countryCode: '{{country_code}}'{{/has_country_code}},),{{/languages}}
];
{{/mobile}}