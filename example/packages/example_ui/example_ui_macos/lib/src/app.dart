import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Theme, ThemeData;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:example_ui_macos/src/theme_extensions.dart';
import 'package:macos_ui/macos_ui.dart';

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
    return MacosApp.router(
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      // TODO: migrate to routerConfig https://github.com/macosui/macos_ui/issues/388
      routeInformationProvider: routerConfig?.routeInformationProvider,
      routerDelegate: routerConfig!.routerDelegate,
      routeInformationParser: routerConfig!.routeInformationParser!,
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
    return MacosApp(
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      builder: _builder,
      home: home,
    );
  }
}
