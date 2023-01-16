import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Theme, ThemeData;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:project_ios_ui_ios/src/theme_extensions.dart';

class ProjectIosApp extends StatelessWidget {
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Iterable<Locale> supportedLocales;
  final RouteInformationParser<Object>? routeInformationParser;
  final RouterDelegate<Object>? routerDelegate;
  final Locale? locale;
  final Brightness? brightness;
  final Widget? home;

  const ProjectIosApp({
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
      return CupertinoApp(
        locale: locale,
        localizationsDelegates: [
          ...GlobalMaterialLocalizations.delegates,
          ...?localizationsDelegates,
        ],
        supportedLocales: supportedLocales,
        builder: _builder,
        home: home,
      );
    }

    return CupertinoApp.router(
      localizationsDelegates: [
        ...GlobalMaterialLocalizations.delegates,
        ...?localizationsDelegates,
      ],
      supportedLocales: supportedLocales,
      builder: _builder,
      routeInformationParser: routeInformationParser,
      routerDelegate: routerDelegate,
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
