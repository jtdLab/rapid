{{#android}}import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:{{project_name}}_ui/{{project_name}}_ui.dart' as ui;
import 'package:{{project_name}}_ui_android/src/theme_extensions.dart';

abstract class {{project_name.pascalCase()}}App extends StatelessWidget {
  const {{project_name.pascalCase()}}App._({
    super.key,
    this.locale,
    Iterable<Locale>? supportedLocales,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    this.routerConfig,
    this.themeMode,
    this.home,
  }) : _localizationsDelegates = localizationsDelegates,
        _supportedLocales = supportedLocales;

  const factory {{project_name.pascalCase()}}App({
    Key? key,
    Locale? locale,
    required Iterable<Locale> supportedLocales,
    required Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
    required RouterConfig<Object> routerConfig,
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
  final RouterConfig<Object>? routerConfig;
  ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        extensions: [...lightExtensions, ...ui.lightExtensions],
        // TODO: override material light themes here.
      );
  ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        extensions: [...darkExtensions, ...ui.darkExtensions],
        // TODO: override material light themes here.
      );
  final ThemeMode? themeMode;
  final Widget? home;
}

class _{{project_name.pascalCase()}}App extends {{project_name.pascalCase()}}App {
  const _{{project_name.pascalCase()}}App({
    super.key,
    super.locale,
    required Iterable<Locale> super.supportedLocales,
    required Iterable<LocalizationsDelegate<dynamic>> super.localizationsDelegates,
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
import 'package:{{project_name}}_ui/{{project_name}}_ui.dart' as ui;
import 'package:{{project_name}}_ui_ios/src/theme_extensions.dart';

abstract class {{project_name.pascalCase()}}App extends StatelessWidget {
  const {{project_name.pascalCase()}}App._({
    super.key,
    this.locale,
    Iterable<Locale>? supportedLocales,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    this.routerConfig,
    this.brightness,
    this.home,
  }) : _localizationsDelegates = localizationsDelegates,
        _supportedLocales = supportedLocales;

  const factory {{project_name.pascalCase()}}App({
    Key? key,
    Locale? locale,
    required Iterable<Locale> supportedLocales,
    required Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
    required RouterConfig<Object> routerConfig,
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
  final RouterConfig<Object>? routerConfig;
  CupertinoThemeData get theme => CupertinoThemeData(
        brightness: brightness,
        // TODO: override cupertino themes here.
        // Hint: Use CupertinoDynamicColor.withBrightness
      );
  final Brightness? brightness;
  final Widget? home;

  Widget _builder(BuildContext context, Widget? child) {
    final brightness =
        this.brightness ?? MediaQuery.of(context).platformBrightness;

    late final ThemeData data;
    switch (brightness) {
      case Brightness.light:
        data = ThemeData(
          brightness: brightness,
          extensions: [...lightExtensions, ...ui.lightExtensions],
          cupertinoOverrideTheme: theme,
        );
      case Brightness.dark:
        data = ThemeData(
          brightness: brightness,
          extensions: [...darkExtensions, ...ui.darkExtensions],
          cupertinoOverrideTheme: theme,
        );
    }

    return Theme(
      data: data,
      child: child!,
    );
  }
}

class _{{project_name.pascalCase()}}App extends {{project_name.pascalCase()}}App {
  const _{{project_name.pascalCase()}}App({
    super.key,
    super.locale,
    required Iterable<Locale> super.supportedLocales,
    required Iterable<LocalizationsDelegate<dynamic>> super.localizationsDelegates,
    required RouterConfig<Object> super.routerConfig,
    super.brightness,
  }) : super._();

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      routerConfig: routerConfig,
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
import 'package:{{project_name}}_ui/{{project_name}}_ui.dart' as ui;
import 'package:{{project_name}}_ui_linux/src/theme_extensions.dart';

abstract class {{project_name.pascalCase()}}App extends StatelessWidget {
  const {{project_name.pascalCase()}}App._({
    super.key,
    this.locale,
    Iterable<Locale>? supportedLocales,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    this.routerConfig,
    this.themeMode,
    this.home,
  }) : _localizationsDelegates = localizationsDelegates,
        _supportedLocales = supportedLocales;

  const factory {{project_name.pascalCase()}}App({
    Key? key,
    Locale? locale,
    required Iterable<Locale> supportedLocales,
    required Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
    required RouterConfig<Object> routerConfig,
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
  final RouterConfig<Object>? routerConfig;
  ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        extensions: [...lightExtensions, ...ui.lightExtensions],
        // TODO: override material light themes here.
      );
  ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        extensions: [...darkExtensions, ...ui.darkExtensions],
        // TODO: override material dark themes here.
      );
  final ThemeMode? themeMode;
  final Widget? home;
}

class _{{project_name.pascalCase()}}App extends {{project_name.pascalCase()}}App {
  const _{{project_name.pascalCase()}}App({
    super.key,
    super.locale,
    required Iterable<Locale> super.supportedLocales,
    required Iterable<LocalizationsDelegate<dynamic>> super.localizationsDelegates,
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
import 'package:flutter/material.dart' show Theme, ThemeData, ThemeMode;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:{{project_name}}_ui/{{project_name}}_ui.dart' as ui;
import 'package:{{project_name}}_ui_macos/src/theme_extensions.dart';
import 'package:macos_ui/macos_ui.dart';

abstract class {{project_name.pascalCase()}}App extends StatelessWidget {
  const {{project_name.pascalCase()}}App._({
    super.key,
    this.locale,
    Iterable<Locale>? supportedLocales,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    this.routerConfig,
    this.themeMode,
    this.home,
  }) : _localizationsDelegates = localizationsDelegates,
        _supportedLocales = supportedLocales;

  const factory {{project_name.pascalCase()}}App({
    Key? key,
    Locale? locale,
    required Iterable<Locale> supportedLocales,
    required Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
    required RouterConfig<Object> routerConfig,
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
  final RouterConfig<Object>? routerConfig;
  MacosThemeData get lightTheme => MacosThemeData(
        brightness: Brightness.light,
        // TODO: override macos_ui light themes here.
      );
  MacosThemeData get darkTheme => MacosThemeData(
        brightness: Brightness.dark,
        // TODO: override macos_ui dark themes here.
      );
  final ThemeMode? themeMode;
  final Widget? home;

  Widget _builder(BuildContext context, Widget? child) {
    final themeMode = this.themeMode ?? ThemeMode.system;

    late final Brightness brightness;
    switch (themeMode) {
      case ThemeMode.light:
        brightness = Brightness.light;
      case ThemeMode.dark:
        brightness = Brightness.dark;
      case ThemeMode.system:
        brightness = MediaQuery.of(context).platformBrightness;
    }

    late final ThemeData data;
    switch (brightness) {
      case Brightness.light:
        data = ThemeData(
          brightness: brightness,
          extensions: [...lightExtensions, ...ui.lightExtensions],
        );
      case Brightness.dark:
        data = ThemeData(
          brightness: brightness,
          extensions: [...darkExtensions, ...ui.darkExtensions],
        );
    }

    return Theme(
      data: data,
      child: child!,
    );
  }
}

class _{{project_name.pascalCase()}}App extends {{project_name.pascalCase()}}App {
  const _{{project_name.pascalCase()}}App({
    super.key,
    super.locale,
    required Iterable<Locale> super.supportedLocales,
    required Iterable<LocalizationsDelegate<dynamic>> super.localizationsDelegates,
    required RouterConfig<Object> super.routerConfig,
    super.themeMode,
  }) : super._();

  @override
  Widget build(BuildContext context) {
    return MacosApp.router(
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      routerConfig: routerConfig,
      builder: _builder,
      themeMode: themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
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
    return MacosApp(
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      builder: _builder,
      themeMode: themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: home,
    );
  }
}
{{/macos}}{{#web}}
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:{{project_name}}_ui/{{project_name}}_ui.dart' as ui;
import 'package:{{project_name}}_ui_web/src/theme_extensions.dart';

abstract class {{project_name.pascalCase()}}App extends StatelessWidget {
  const {{project_name.pascalCase()}}App._({
    super.key,
    this.locale,
    Iterable<Locale>? supportedLocales,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    this.routerConfig,
    this.themeMode,
    this.home,
  }) : _localizationsDelegates = localizationsDelegates,
        _supportedLocales = supportedLocales;

  const factory {{project_name.pascalCase()}}App({
    Key? key,
    Locale? locale,
    required Iterable<Locale> supportedLocales,
    required Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
    required RouterConfig<Object> routerConfig,
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
  final RouterConfig<Object>? routerConfig;
  ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        extensions: [...lightExtensions, ...ui.lightExtensions],
        // TODO: override material light themes here.
      );
  ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        extensions: [...darkExtensions, ...ui.darkExtensions],
        // TODO: override material light themes here.
      );
  final ThemeMode? themeMode;
  final Widget? home;
}

class _{{project_name.pascalCase()}}App extends {{project_name.pascalCase()}}App {
  const _{{project_name.pascalCase()}}App({
    super.key,
    super.locale,
    required Iterable<Locale> super.supportedLocales,
    required Iterable<LocalizationsDelegate<dynamic>> super.localizationsDelegates,
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
import 'package:{{project_name}}_ui/{{project_name}}_ui.dart' as ui;
import 'package:{{project_name}}_ui_windows/src/theme_extensions.dart';

abstract class {{project_name.pascalCase()}}App extends StatelessWidget {
  const {{project_name.pascalCase()}}App._({
    super.key,
    this.locale,
    Iterable<Locale>? supportedLocales,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    this.routerConfig,
    this.themeMode,
    this.home,
  }) : _localizationsDelegates = localizationsDelegates,
        _supportedLocales = supportedLocales;

  const factory {{project_name.pascalCase()}}App({
    Key? key,
    Locale? locale,
    required Iterable<Locale> supportedLocales,
    required Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
    required RouterConfig<Object> routerConfig,
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
  final RouterConfig<Object>? routerConfig;
  FluentThemeData get lightTheme => FluentThemeData(
        brightness: Brightness.light,
        extensions: [...lightExtensions, ...ui.lightExtensions],
        // TODO: override fluent_ui light themes here.
      );
  FluentThemeData get darkTheme => FluentThemeData(
        brightness: Brightness.dark,
        extensions: [...darkExtensions, ...ui.darkExtensions],
        // TODO: override fluent_ui light themes here.
      );
  final ThemeMode? themeMode;
  final Widget? home;
}

class _{{project_name.pascalCase()}}App extends {{project_name.pascalCase()}}App {
  const _{{project_name.pascalCase()}}App({
    super.key,
    super.locale,
    required Iterable<Locale> super.supportedLocales,
    required Iterable<LocalizationsDelegate<dynamic>> super.localizationsDelegates,
    required RouterConfig<Object> super.routerConfig,
    super.themeMode,
  }) : super._();

  @override
  Widget build(BuildContext context) {
    return FluentApp.router(
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
{{/windows}}{{#mobile}}import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:{{project_name}}_ui/{{project_name}}_ui.dart' as ui;
import 'package:{{project_name}}_ui_mobile/src/theme_extensions.dart';

abstract class {{project_name.pascalCase()}}App extends StatelessWidget {
  const {{project_name.pascalCase()}}App._({
    super.key,
    this.locale,
    Iterable<Locale>? supportedLocales,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    this.routerConfig,
    this.themeMode,
    this.home,
  }) : _localizationsDelegates = localizationsDelegates,
        _supportedLocales = supportedLocales;

  const factory {{project_name.pascalCase()}}App({
    Key? key,
    Locale? locale,
    required Iterable<Locale> supportedLocales,
    required Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
    required RouterConfig<Object> routerConfig,
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
  final RouterConfig<Object>? routerConfig;
  ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        extensions: [...lightExtensions, ...ui.lightExtensions],
        // TODO: override material light themes here.
      );
  ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        extensions: [...darkExtensions, ...ui.darkExtensions],
        // TODO: override material light themes here.
      );
  final ThemeMode? themeMode;
  final Widget? home;
}

class _{{project_name.pascalCase()}}App extends {{project_name.pascalCase()}}App {
  const _{{project_name.pascalCase()}}App({
    super.key,
    super.locale,
    required Iterable<Locale> super.supportedLocales,
    required Iterable<LocalizationsDelegate<dynamic>> super.localizationsDelegates,
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
{{/mobile}}