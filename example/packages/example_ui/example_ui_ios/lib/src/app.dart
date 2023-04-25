import 'package:example_ui/example_ui.dart';
import 'package:example_ui_ios/src/theme_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Theme, ThemeData;
import 'package:flutter_localizations/flutter_localizations.dart';

abstract class ExampleApp extends StatelessWidget {
  const ExampleApp._({
    super.key,
    this.locale,
    Iterable<Locale>? supportedLocales,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    this.routerConfig,
    this.brightness,
    this.home,
  })  : _localizationsDelegates = localizationsDelegates,
        _supportedLocales = supportedLocales;

  const factory ExampleApp({
    Key? key,
    Locale? locale,
    required Iterable<Locale> supportedLocales,
    required Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
    required RouterConfig<Object> routerConfig,
    Brightness? brightness,
  }) = _ExampleApp;

  @visibleForTesting
  const factory ExampleApp.test({
    Key? key,
    Locale? locale,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    Brightness? brightness,
    required Widget home,
  }) = _ExampleAppTest;

  final Locale? locale;
  final Iterable<Locale>? _supportedLocales;
  Iterable<Locale> get supportedLocales =>
      _supportedLocales ?? [locale ?? const Locale('en')];
  final Iterable<LocalizationsDelegate<dynamic>>? _localizationsDelegates;
  Iterable<LocalizationsDelegate<dynamic>> get localizationsDelegates =>
      [...GlobalMaterialLocalizations.delegates, ...?_localizationsDelegates];
  final RouterConfig<Object>? routerConfig;
  final Brightness? brightness;
  final Widget? home;

  Widget _builder(BuildContext context, Widget? child) {
    final brightness =
        this.brightness ?? MediaQuery.of(context).platformBrightness;
    final textColor = brightness == Brightness.light
        ? ExampleColorTheme.light.primary
        : ExampleColorTheme.dark.primary;

    late final Widget theme;
    if (brightness == Brightness.light) {
      theme = DefaultTextStyle(
        style: TextStyle(color: textColor),
        child: Theme(
          data: ThemeData(extensions: lightExtensions),
          child: child!,
        ),
      );
    } else {
      theme = DefaultTextStyle(
        style: TextStyle(color: textColor),
        child: Theme(
          data: ThemeData(extensions: darkExtensions),
          child: child!,
        ),
      );
    }

    return theme;
    // TODO: this does not trigger rebuilt of subtree on theme changes
    // But the toast gets displayed even without this
    // return exampleToastBuilder(context, theme);
  }
}

class _ExampleApp extends ExampleApp {
  const _ExampleApp({
    super.key,
    super.locale,
    required Iterable<Locale> super.supportedLocales,
    required Iterable<LocalizationsDelegate<dynamic>>
        super.localizationsDelegates,
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

class _ExampleAppTest extends ExampleApp {
  const _ExampleAppTest({
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
