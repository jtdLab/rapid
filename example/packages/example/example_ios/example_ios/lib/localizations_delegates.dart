import 'package:example_ios_app/example_ios_app.dart';
import 'package:example_ios_home_page/example_ios_home_page.dart';
import 'package:example_ios_login_page/example_ios_login_page.dart';
import 'package:example_ios_protected_router/example_ios_protected_router.dart';
import 'package:example_ios_public_router/example_ios_public_router.dart';
import 'package:example_ios_sign_up_page/example_ios_sign_up_page.dart';
import 'package:flutter/widgets.dart';

const localizationsDelegates = <LocalizationsDelegate>[
  ExampleIosAppLocalizations.delegate,
  ExampleIosHomePageLocalizations.delegate,
  ExampleIosLoginPageLocalizations.delegate,
  ExampleIosProtectedRouterLocalizations.delegate,
  ExampleIosPublicRouterLocalizations.delegate,
  ExampleIosSignUpPageLocalizations.delegate,
];

final supportedLocales = <Locale>[
  const Locale('en'),
];
