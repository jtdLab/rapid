import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:project_android_ui_android/src/theme_extensions.dart';

abstract class ProjectAndroidApp extends StatelessWidget {
  const ProjectAndroidApp._({
    super.key,
    this.locale,
    Iterable<Locale>? supportedLocales,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    this.routerConfig,
    this.themeMode,
    this.home,
  })  : _localizationsDelegates = localizationsDelegates,
        _supportedLocales = supportedLocales;

  const factory ProjectAndroidApp({
    Key? key,
    Locale? locale,
    required Iterable<Locale> supportedLocales,
    required Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
    required RouterConfig<Object> routerConfig,
    ThemeMode? themeMode,
  }) = _ProjectAndroidApp;

  @visibleForTesting
  const factory ProjectAndroidApp.test({
    Key? key,
    Locale? locale,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    ThemeMode? themeMode,
    required Widget home,
  }) = _ProjectAndroidAppTest;

  final Locale? locale;
  final Iterable<Locale>? _supportedLocales;
  Iterable<Locale> get supportedLocales =>
      _supportedLocales ?? [locale ?? const Locale('en')];
  final Iterable<LocalizationsDelegate<dynamic>>? _localizationsDelegates;
  Iterable<LocalizationsDelegate<dynamic>> get localizationsDelegates =>
      [...GlobalMaterialLocalizations.delegates, ...?_localizationsDelegates];
  final RouterConfig<Object>? routerConfig;
  ThemeData get lightTheme => ThemeData(extensions: lightExtensions);
  ThemeData get darkTheme => ThemeData(extensions: darkExtensions);
  final ThemeMode? themeMode;
  final Widget? home;
}

class _ProjectAndroidApp extends ProjectAndroidApp {
  const _ProjectAndroidApp({
    super.key,
    super.locale,
    required Iterable<Locale> super.supportedLocales,
    required Iterable<LocalizationsDelegate<dynamic>>
        super.localizationsDelegates,
    required RouterConfig<Object> super.routerConfig,
    super.themeMode,
  }) : super._();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      routerConfig: routerConfig,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
    );
  }
}

class _ProjectAndroidAppTest extends ProjectAndroidApp {
  const _ProjectAndroidAppTest({
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
