import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class ProjectAllApp extends StatelessWidget {
  final Locale? locale;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Iterable<Locale> supportedLocales;
  final RouteInformationParser<Object>? routeInformationParser;
  final RouterDelegate<Object>? routerDelegate;

  const ProjectAllApp({
    super.key,
    this.locale,
    this.localizationsDelegates,
    required this.supportedLocales,
    this.routeInformationParser,
    this.routerDelegate,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      locale: locale,
      localizationsDelegates: [
        ...GlobalCupertinoLocalizations.delegates,
        ...?localizationsDelegates,
      ],
      supportedLocales: supportedLocales,
      routeInformationParser: routeInformationParser,
      routerDelegate: routerDelegate,
    );
  }
}
