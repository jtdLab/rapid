import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Theme, ThemeData;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:project_macos_ui_macos/src/theme_extensions.dart';
import 'package:macos_ui/macos_ui.dart';

class ProjectMacosApp extends StatelessWidget {
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Iterable<Locale> supportedLocales;
  final RouteInformationParser<Object>? routeInformationParser;
  final RouterDelegate<Object>? routerDelegate;
  final Locale? locale;
  final Brightness? brightness;
  final Widget? home;

  const ProjectMacosApp({
    super.key,
    this.localizationsDelegates,
    this.supportedLocales = const [Locale('en')],
    this.routeInformationParser,
    this.routerDelegate,
    this.locale,
    this.brightness,
    this.home,
  });

  @override
  Widget build(BuildContext context) {
    if (home != null) {
      return MacosApp(
        locale: locale,
        localizationsDelegates: [
          ...GlobalCupertinoLocalizations.delegates,
          ...GlobalMaterialLocalizations.delegates,
          GlobalWidgetsLocalizations.delegate,
          ...?localizationsDelegates,
        ],
        supportedLocales: supportedLocales,
        builder: _builder,
        home: home,
      );
    }

    return MacosApp.router(
      localizationsDelegates: [
        ...GlobalCupertinoLocalizations.delegates,
        ...GlobalMaterialLocalizations.delegates,
        GlobalWidgetsLocalizations.delegate,
        ...?localizationsDelegates,
      ],
      builder: _builder,
      supportedLocales: supportedLocales,
      routeInformationParser: routeInformationParser!,
      routerDelegate: routerDelegate!,
    );
  }

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
