import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:project_web_ui_web/src/theme_extensions.dart';

abstract class ProjectWebApp extends StatelessWidget {
  const ProjectWebApp._({
    super.key,
    this.locale,
    Iterable<Locale>? supportedLocales,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    this.routeInformationParser,
    this.routerDelegate,
    this.themeMode,
    this.home,
  })  : _localizationsDelegates = localizationsDelegates,
        _supportedLocales = supportedLocales;

  const factory ProjectWebApp({
    Key? key,
    Locale? locale,
    required Iterable<Locale> supportedLocales,
    required Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
    required RouteInformationParser<Object> routeInformationParser,
    required RouterDelegate<Object> routerDelegate,
    ThemeMode? themeMode,
  }) = _ProjectWebApp;

  @visibleForTesting
  const factory ProjectWebApp.test({
    Key? key,
    Locale? locale,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    ThemeMode? themeMode,
    required Widget home,
  }) = _ProjectWebAppTest;

  final Locale? locale;
  final Iterable<Locale>? _supportedLocales;
  Iterable<Locale> get supportedLocales =>
      _supportedLocales ?? [locale ?? const Locale('en')];
  final Iterable<LocalizationsDelegate<dynamic>>? _localizationsDelegates;
  Iterable<LocalizationsDelegate<dynamic>> get localizationsDelegates =>
      [...GlobalMaterialLocalizations.delegates, ...?_localizationsDelegates];
  final RouteInformationParser<Object>? routeInformationParser;
  final RouterDelegate<Object>? routerDelegate;
  ThemeData get lightTheme => ThemeData(extensions: lightExtensions);
  ThemeData get darkTheme => ThemeData(extensions: darkExtensions);
  final ThemeMode? themeMode;
  final Widget? home;
}

class _ProjectWebApp extends ProjectWebApp {
  const _ProjectWebApp({
    super.key,
    super.locale,
    required Iterable<Locale> super.supportedLocales,
    required super.localizationsDelegates,
    required super.routeInformationParser,
    required super.routerDelegate,
    super.themeMode,
  }) : super._();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      routeInformationParser: routeInformationParser,
      routerDelegate: routerDelegate,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
    );
  }
}

class _ProjectWebAppTest extends ProjectWebApp {
  const _ProjectWebAppTest({
    super.key,
    super.locale,
    super.localizationsDelegates,
    super.themeMode,
    required super.home,
  }) : super._();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      themeMode: themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: home,
    );
  }
}
