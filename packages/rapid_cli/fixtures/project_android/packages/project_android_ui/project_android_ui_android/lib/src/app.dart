import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class ProjectAndroidApp extends StatelessWidget {
  final Locale? locale;
  final Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;
  final Iterable<Locale> supportedLocales;
  final RouteInformationParser<Object> routeInformationParser;
  final RouterDelegate<Object> routerDelegate;

  const ProjectAndroidApp({
    super.key,
    this.locale,
    required this.localizationsDelegates,
    required this.supportedLocales,
    required this.routeInformationParser,
    required this.routerDelegate,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      locale: locale,
      localizationsDelegates: [
        ...GlobalMaterialLocalizations.delegates,
        ...localizationsDelegates,
      ],
      supportedLocales: supportedLocales,
      routeInformationParser: routeInformationParser,
      routerDelegate: routerDelegate,
    );
  }
}
