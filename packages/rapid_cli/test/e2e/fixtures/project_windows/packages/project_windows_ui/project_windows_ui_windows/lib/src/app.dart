import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:project_windows_ui_windows/src/theme_extensions.dart';

abstract class ProjectWindowsApp extends StatelessWidget {
  const ProjectWindowsApp._({
    super.key,
    this.locale,
    Iterable<Locale>? supportedLocales,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    this.routerConfig,
    this.themeMode,
    this.home,
  })  : _localizationsDelegates = localizationsDelegates,
        _supportedLocales = supportedLocales;

  const factory ProjectWindowsApp({
    Key? key,
    Locale? locale,
    required Iterable<Locale> supportedLocales,
    required Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
    required RouterConfig<Object> routerConfig,
    ThemeMode? themeMode,
  }) = _ProjectWindowsApp;

  @visibleForTesting
  const factory ProjectWindowsApp.test({
    Key? key,
    Locale? locale,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    ThemeMode? themeMode,
    required Widget home,
  }) = _ProjectWindowsAppTest;

  final Locale? locale;
  final Iterable<Locale>? _supportedLocales;
  Iterable<Locale> get supportedLocales =>
      _supportedLocales ?? [locale ?? const Locale('en')];
  final Iterable<LocalizationsDelegate<dynamic>>? _localizationsDelegates;
  Iterable<LocalizationsDelegate<dynamic>> get localizationsDelegates =>
      [...GlobalMaterialLocalizations.delegates, ...?_localizationsDelegates];
  final RouterConfig<Object>? routerConfig;
  FluentThemeData get lightTheme =>
      FluentThemeData(extensions: lightExtensions);
  FluentThemeData get darkTheme => FluentThemeData(extensions: darkExtensions);
  final ThemeMode? themeMode;
  final Widget? home;
}

class _ProjectWindowsApp extends ProjectWindowsApp {
  const _ProjectWindowsApp({
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
    return FluentApp.router(
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      // TODO: https://github.com/bdlukaa/fluent_ui/pull/803
      routeInformationParser: routerConfig?.routeInformationParser,
      routeInformationProvider: routerConfig?.routeInformationProvider,
      routerDelegate: routerConfig?.routerDelegate,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
    );
  }
}

class _ProjectWindowsAppTest extends ProjectWindowsApp {
  const _ProjectWindowsAppTest({
    super.key,
    super.locale,
    super.localizationsDelegates,
    super.themeMode,
    required super.home,
  }) : super._();

  @override
  Widget build(BuildContext context) {
    return FluentApp(
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
