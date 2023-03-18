{{#android}}import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:{{project_name}}_ui_android/src/theme_extensions.dart';

abstract class {{project_name.pascalCase()}}App extends StatelessWidget {
  const {{project_name.pascalCase()}}App._({
    super.key,
    this.locale,
    Iterable<Locale>? supportedLocales,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    this.routeInformationParser,
    this.routerDelegate,
    this.themeMode,
    this.home,
  }) : _localizationsDelegates = localizationsDelegates,
        _supportedLocales = supportedLocales;

  const factory {{project_name.pascalCase()}}App({
    Key? key,
    Locale? locale,
    required Iterable<Locale> supportedLocales,
    required Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
    required RouteInformationParser<Object> routeInformationParser,
    required RouterDelegate<Object> routerDelegate,
    ThemeMode? themeMode,
  }) = _{{project_name.pascalCase()}}App;

  @visibleForTesting
  const factory {{project_name.pascalCase()}}App.test({
    Key? key,
    Locale? locale,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    ThemeMode? themeMode,
    required Widget home,
  }) = _{{project_name.pascalCase()}}AppTest;

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

class _{{project_name.pascalCase()}}App extends {{project_name.pascalCase()}}App {
  const _{{project_name.pascalCase()}}App({
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

class _{{project_name.pascalCase()}}AppTest extends {{project_name.pascalCase()}}App {
  const _{{project_name.pascalCase()}}AppTest({
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
{{/android}}{{#ios}}import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Theme, ThemeData;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:{{project_name}}_ui_ios/src/theme_extensions.dart';

abstract class {{project_name.pascalCase()}}App extends StatelessWidget {
  const {{project_name.pascalCase()}}App._({
    super.key,
    this.locale,
    Iterable<Locale>? supportedLocales,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    this.routeInformationParser,
    this.routerDelegate,
    this.brightness,
    this.home,
  }) : _localizationsDelegates = localizationsDelegates,
        _supportedLocales = supportedLocales;

  const factory {{project_name.pascalCase()}}App({
    Key? key,
    Locale? locale,
    required Iterable<Locale> supportedLocales,
    required Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
    required RouteInformationParser<Object> routeInformationParser,
    required RouterDelegate<Object> routerDelegate,
    Brightness? brightness,
  }) = _{{project_name.pascalCase()}}App;

  @visibleForTesting
  const factory {{project_name.pascalCase()}}App.test({
    Key? key,
    Locale? locale,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    Brightness? brightness,
    required Widget home,
  }) = _{{project_name.pascalCase()}}AppTest;

  final Locale? locale;
  final Iterable<Locale>? _supportedLocales;
  Iterable<Locale> get supportedLocales =>
      _supportedLocales ?? [locale ?? const Locale('en')];
  final Iterable<LocalizationsDelegate<dynamic>>? _localizationsDelegates;
  Iterable<LocalizationsDelegate<dynamic>> get localizationsDelegates =>
      [...GlobalMaterialLocalizations.delegates, ...?_localizationsDelegates];
  final RouteInformationParser<Object>? routeInformationParser;
  final RouterDelegate<Object>? routerDelegate;
  final Brightness? brightness;
  final Widget? home;

  Widget _builder(BuildContext context, Widget? child) {
    final brightness =
        this.brightness ?? MediaQuery.of(context).platformBrightness;

    if (brightness == Brightness.light) {
      return Theme(
        data: ThemeData(extensions: lightExtensions),
        child: child!,
      );
    } else {
      return Theme(
        data: ThemeData(extensions: darkExtensions),
        child: child!,
      );
    }
  }
}

class _{{project_name.pascalCase()}}App extends {{project_name.pascalCase()}}App {
  const _{{project_name.pascalCase()}}App({
    super.key,
    super.locale,
    required Iterable<Locale> super.supportedLocales,
    required super.localizationsDelegates,
    required super.routeInformationParser,
    required super.routerDelegate,
    super.brightness,
  }) : super._();

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      routeInformationParser: routeInformationParser,
      routerDelegate: routerDelegate,
      builder: _builder,
    );
  }
}

class _{{project_name.pascalCase()}}AppTest extends {{project_name.pascalCase()}}App {
  const _{{project_name.pascalCase()}}AppTest({
    super.key,
    super.locale,
    super.localizationsDelegates,
    super.brightness,
    required super.home,
  }) : super._();

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      builder: _builder,
      home: home,
    );
  }
}
{{/ios}}{{#linux}}import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:{{project_name}}_ui_linux/src/theme_extensions.dart';

abstract class {{project_name.pascalCase()}}App extends StatelessWidget {
  const {{project_name.pascalCase()}}App._({
    super.key,
    this.locale,
    Iterable<Locale>? supportedLocales,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    this.routeInformationParser,
    this.routerDelegate,
    this.themeMode,
    this.home,
  }) : _localizationsDelegates = localizationsDelegates,
        _supportedLocales = supportedLocales;

  const factory {{project_name.pascalCase()}}App({
    Key? key,
    Locale? locale,
    required Iterable<Locale> supportedLocales,
    required Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
    required RouteInformationParser<Object> routeInformationParser,
    required RouterDelegate<Object> routerDelegate,
    ThemeMode? themeMode,
  }) = _{{project_name.pascalCase()}}App;

  @visibleForTesting
  const factory {{project_name.pascalCase()}}App.test({
    Key? key,
    Locale? locale,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    ThemeMode? themeMode,
    required Widget home,
  }) = _{{project_name.pascalCase()}}AppTest;

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

class _{{project_name.pascalCase()}}App extends {{project_name.pascalCase()}}App {
  const _{{project_name.pascalCase()}}App({
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

class _{{project_name.pascalCase()}}AppTest extends {{project_name.pascalCase()}}App {
  const _{{project_name.pascalCase()}}AppTest({
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
{{/linux}}{{#macos}}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Theme, ThemeData;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:{{project_name}}_ui_macos/src/theme_extensions.dart';
import 'package:macos_ui/macos_ui.dart';

abstract class {{project_name.pascalCase()}}App extends StatelessWidget {
  const {{project_name.pascalCase()}}App._({
    super.key,
    this.locale,
    Iterable<Locale>? supportedLocales,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    this.routeInformationParser,
    this.routerDelegate,
    this.brightness,
    this.home,
  }) : _localizationsDelegates = localizationsDelegates,
        _supportedLocales = supportedLocales;

  const factory {{project_name.pascalCase()}}App({
    Key? key,
    Locale? locale,
    required Iterable<Locale> supportedLocales,
    required Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
    required RouteInformationParser<Object> routeInformationParser,
    required RouterDelegate<Object> routerDelegate,
    Brightness? brightness,
  }) = _{{project_name.pascalCase()}}App;

  @visibleForTesting
  const factory {{project_name.pascalCase()}}App.test({
    Key? key,
    Locale? locale,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    Brightness? brightness,
    required Widget home,
  }) = _{{project_name.pascalCase()}}AppTest;

  final Locale? locale;
  final Iterable<Locale>? _supportedLocales;
  Iterable<Locale> get supportedLocales =>
      _supportedLocales ?? [locale ?? const Locale('en')];
  final Iterable<LocalizationsDelegate<dynamic>>? _localizationsDelegates;
  Iterable<LocalizationsDelegate<dynamic>> get localizationsDelegates =>
      [...GlobalMaterialLocalizations.delegates, ...?_localizationsDelegates];
  final RouteInformationParser<Object>? routeInformationParser;
  final RouterDelegate<Object>? routerDelegate;
  final Brightness? brightness;
  final Widget? home;

  Widget _builder(BuildContext context, Widget? child) {
    final brightness =
        this.brightness ?? MediaQuery.of(context).platformBrightness;

    if (brightness == Brightness.light) {
      return Theme(
        data: ThemeData(extensions: lightExtensions),
        child: child!,
      );
    } else {
      return Theme(
        data: ThemeData(extensions: darkExtensions),
        child: child!,
      );
    }
  }
}

class _{{project_name.pascalCase()}}App extends {{project_name.pascalCase()}}App {
  const _{{project_name.pascalCase()}}App({
    super.key,
    super.locale,
    required Iterable<Locale> super.supportedLocales,
    required super.localizationsDelegates,
    required super.routeInformationParser,
    required super.routerDelegate,
    super.brightness,
  }) : super._();

  @override
  Widget build(BuildContext context) {
    return MacosApp.router(
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      routeInformationParser: routeInformationParser!,
      routerDelegate: routerDelegate!,
      builder: _builder,
    );
  }
}

class _{{project_name.pascalCase()}}AppTest extends {{project_name.pascalCase()}}App {
  const _{{project_name.pascalCase()}}AppTest({
    super.key,
    super.locale,
    super.localizationsDelegates,
    super.brightness,
    required super.home,
  }) : super._();

  @override
  Widget build(BuildContext context) {
    return MacosApp(
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      builder: _builder,
      home: home,
    );
  }
}
{{/macos}}{{#web}}
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:{{project_name}}_ui_web/src/theme_extensions.dart';

abstract class {{project_name.pascalCase()}}App extends StatelessWidget {
  const {{project_name.pascalCase()}}App._({
    super.key,
    this.locale,
    Iterable<Locale>? supportedLocales,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    this.routeInformationParser,
    this.routerDelegate,
    this.themeMode,
    this.home,
  }) : _localizationsDelegates = localizationsDelegates,
        _supportedLocales = supportedLocales;

  const factory {{project_name.pascalCase()}}App({
    Key? key,
    Locale? locale,
    required Iterable<Locale> supportedLocales,
    required Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
    required RouteInformationParser<Object> routeInformationParser,
    required RouterDelegate<Object> routerDelegate,
    ThemeMode? themeMode,
  }) = _{{project_name.pascalCase()}}App;

  @visibleForTesting
  const factory {{project_name.pascalCase()}}App.test({
    Key? key,
    Locale? locale,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    ThemeMode? themeMode,
    required Widget home,
  }) = _{{project_name.pascalCase()}}AppTest;

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

class _{{project_name.pascalCase()}}App extends {{project_name.pascalCase()}}App {
  const _{{project_name.pascalCase()}}App({
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

class _{{project_name.pascalCase()}}AppTest extends {{project_name.pascalCase()}}App {
  const _{{project_name.pascalCase()}}AppTest({
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
{{/web}}{{#windows}}
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:{{project_name}}_ui/{{project_name}}_ui.dart';
import 'package:{{project_name}}_ui_windows/src/theme_extensions.dart';

abstract class {{project_name.pascalCase()}}App extends StatelessWidget {
  const {{project_name.pascalCase()}}App._({
    super.key,
    this.locale,
    Iterable<Locale>? supportedLocales,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    this.routeInformationParser,
    this.routerDelegate,
    this.themeMode,
    this.home,
  }) : _localizationsDelegates = localizationsDelegates,
        _supportedLocales = supportedLocales;

  const factory {{project_name.pascalCase()}}App({
    Key? key,
    Locale? locale,
    required Iterable<Locale> supportedLocales,
    required Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
    required RouteInformationParser<Object> routeInformationParser,
    required RouterDelegate<Object> routerDelegate,
    ThemeMode? themeMode,
  }) = _{{project_name.pascalCase()}}App;

  @visibleForTesting
  const factory {{project_name.pascalCase()}}App.test({
    Key? key,
    Locale? locale,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    ThemeMode? themeMode,
    required Widget home,
  }) = _{{project_name.pascalCase()}}AppTest;

  final Locale? locale;
  final Iterable<Locale>? _supportedLocales;
  Iterable<Locale> get supportedLocales =>
      _supportedLocales ?? [locale ?? const Locale('en')];
  final Iterable<LocalizationsDelegate<dynamic>>? _localizationsDelegates;
  Iterable<LocalizationsDelegate<dynamic>> get localizationsDelegates =>
      [...GlobalMaterialLocalizations.delegates, ...?_localizationsDelegates];
  final RouteInformationParser<Object>? routeInformationParser;
  final RouterDelegate<Object>? routerDelegate;
  FluentThemeData get lightTheme => FluentThemeData(extensions: lightExtensions);
  FluentThemeData get darkTheme => FluentThemeData(extensions: darkExtensions);
  final ThemeMode? themeMode;
  final Widget? home;
}

class _{{project_name.pascalCase()}}App extends {{project_name.pascalCase()}}App {
  const _{{project_name.pascalCase()}}App({
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
    return FluentApp.router(
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      routeInformationParser: routeInformationParser,
      routerDelegate: routerDelegate,
      color: {{project_name.pascalCase()}}ColorTheme.light.secondary,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
    );
  }
}

class _{{project_name.pascalCase()}}AppTest extends {{project_name.pascalCase()}}App {
  const _{{project_name.pascalCase()}}AppTest({
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
{{/windows}}