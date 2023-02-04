import 'package:project_windows_windows_routing/project_windows_windows_routing.dart';
import 'package:project_windows_ui_windows/project_windows_ui_windows.dart';

import 'localizations.dart';

class App extends StatelessWidget {
  final List<AutoRouterObserver> Function()? routerObserverBuilder;
  final Locale? locale;
  final ThemeMode? themeMode;
  final Router? router;
  final Widget? home;

  const App({
    super.key,
    this.routerObserverBuilder,
    this.locale,
    this.themeMode,
    this.router,
    this.home,
  });

  @override
  Widget build(BuildContext context) {
    final router = this.router ?? Router();

    if (home != null) {
      return ProjectWindowsApp(
          localizationsDelegates: localizationsDelegates,
          supportedLocales: supportedLocales,
          locale: locale,
          themeMode: themeMode,
          home: home);
    }

    return ProjectWindowsApp(
      localizationsDelegates: localizationsDelegates,
      supportedLocales: supportedLocales,
      routeInformationParser: router.defaultRouteParser(),
      routerDelegate: router.delegate(
        navigatorObservers: routerObserverBuilder ??
            AutoRouterDelegate.defaultNavigatorObserversBuilder,
      ),
      locale: locale,
      themeMode: themeMode,
    );
  }
}
