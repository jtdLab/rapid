import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:macos_ui/macos_ui.dart';

class ProjectMacosApp extends StatelessWidget {
  final Locale? locale;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Iterable<Locale> supportedLocales;
  final RouteInformationParser<Object> routeInformationParser;
  final RouterDelegate<Object> routerDelegate;

  const ProjectMacosApp({
    super.key,
    this.locale,
    this.localizationsDelegates,
    required this.supportedLocales,
    required this.routeInformationParser,
    required this.routerDelegate,
  });

  @override
  Widget build(BuildContext context) {
    return MacosApp.router(
      locale: locale,
      localizationsDelegates: [
        // TODO all ?
        ...GlobalCupertinoLocalizations.delegates,
        ...GlobalMaterialLocalizations.delegates,
        GlobalWidgetsLocalizations.delegate,
        ...?localizationsDelegates,
      ],
      supportedLocales: supportedLocales,
      routeInformationParser: routeInformationParser,
      routerDelegate: routerDelegate,
    );
  }
}
