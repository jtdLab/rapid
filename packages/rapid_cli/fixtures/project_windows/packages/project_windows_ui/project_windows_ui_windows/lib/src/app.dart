import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:project_windows_ui/project_windows_ui.dart';
import 'package:project_windows_ui_windows/src/theme_extensions.dart';

class ProjectWindowsApp extends StatelessWidget {
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Iterable<Locale> supportedLocales;
  final RouteInformationParser<Object>? routeInformationParser;
  final RouterDelegate<Object>? routerDelegate;
  final Locale? locale;
  final ThemeMode? themeMode;
  final Widget? home;

  const ProjectWindowsApp({
    super.key,
    this.localizationsDelegates,
    this.supportedLocales = const [Locale('en')],
    this.routeInformationParser,
    this.routerDelegate,
    this.locale,
    this.themeMode,
    this.home,
  });

  @override
  Widget build(BuildContext context) {
    final lightTheme = ThemeData(extensions: lightExtensions);
    final darkTheme = ThemeData(extensions: darkExtensions);

    if (home != null) {
      return FluentApp(
        locale: locale,
        localizationsDelegates: [
          ...GlobalMaterialLocalizations.delegates,
          ...?localizationsDelegates,
        ],
        supportedLocales: supportedLocales,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeMode,
        home: home,
      );
    }

    return FluentApp.router(
      localizationsDelegates: [
        ...GlobalMaterialLocalizations.delegates,
        ...?localizationsDelegates,
      ],
      supportedLocales: supportedLocales,
      theme: lightTheme,
      darkTheme: darkTheme,
      color: ProjectWindowsColorTheme.light.secondary,
      routeInformationParser: routeInformationParser,
      routerDelegate: routerDelegate,
    );
  }
}
