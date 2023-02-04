import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:project_linux_ui_linux/src/theme_extensions.dart';

class ProjectLinuxApp extends StatelessWidget {
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Iterable<Locale> supportedLocales;
  final RouteInformationParser<Object>? routeInformationParser;
  final RouterDelegate<Object>? routerDelegate;
  final Locale? locale;
  final ThemeMode? themeMode;
  final Widget? home;

  const ProjectLinuxApp({
    super.key,
    this.localizationsDelegates,
    this.supportedLocales = const [Locale('en')],
    this.routeInformationParser,
    this.routerDelegate,
    this.locale,
    this.themeMode,
    this.home,
  });

  @override
  Widget build(BuildContext context) {
    final lightTheme = ThemeData(extensions: lightExtensions);
    final darkTheme = ThemeData(extensions: darkExtensions);

    if (home != null) {
      return MaterialApp(
        locale: locale,
        localizationsDelegates: [
          ...GlobalMaterialLocalizations.delegates,
          ...?localizationsDelegates,
        ],
        supportedLocales: supportedLocales,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeMode,
        home: home,
      );
    }

    return MaterialApp.router(
      localizationsDelegates: [
        ...GlobalMaterialLocalizations.delegates,
        ...?localizationsDelegates,
      ],
      supportedLocales: supportedLocales,
      theme: lightTheme,
      darkTheme: darkTheme,
      routeInformationParser: routeInformationParser,
      routerDelegate: routerDelegate,
    );
  }
}
