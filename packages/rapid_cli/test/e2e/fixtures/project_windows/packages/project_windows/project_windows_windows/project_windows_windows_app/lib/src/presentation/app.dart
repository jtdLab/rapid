import 'package:project_windows_windows_routing/project_windows_windows_routing.dart';
import 'package:project_windows_ui_windows/project_windows_ui_windows.dart';

import 'l10n/l10n.dart';
import 'localizations_delegates.dart';

abstract class App extends StatelessWidget {
  const App._({super.key})
      : supportedLocales =
            ProjectWindowsWindowsAppLocalizations.supportedLocales;

  const factory App({
    Key? key,
    List<AutoRouterObserver> Function()? routerObserverBuilder,
  }) = _App;

  @visibleForTesting
  const factory App.test({
    Key? key,
    Locale? locale,
    required Router router,
    List<PageRouteInfo<dynamic>>? initialRoutes,
    AutoRouterObserver? routerObserver,
    ThemeMode? themeMode,
  }) = _AppTest;

  final List<Locale> supportedLocales;
}

class _App extends App {
  const _App({
    super.key,
    this.routerObserverBuilder,
  }) : super._();

  final List<AutoRouterObserver> Function()? routerObserverBuilder;

  @override
  Widget build(BuildContext context) {
    final router = Router();

    return ProjectWindowsApp(
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      routeInformationParser: router.defaultRouteParser(),
      routerDelegate: router.delegate(
        navigatorObservers: routerObserverBuilder ??
            AutoRouterDelegate.defaultNavigatorObserversBuilder,
      ),
    );
  }
}

class _AppTest extends App {
  const _AppTest({
    super.key,
    this.locale,
    required this.router,
    this.initialRoutes,
    this.routerObserver,
    this.themeMode,
  }) : super._();

  final Locale? locale;
  final Router router;
  final List<PageRouteInfo<dynamic>>? initialRoutes;
  final AutoRouterObserver? routerObserver;
  final ThemeMode? themeMode;

  @override
  Widget build(BuildContext context) {
    return ProjectWindowsApp(
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      routeInformationParser: router.defaultRouteParser(),
      routerDelegate: router.delegate(
        initialRoutes: initialRoutes,
        navigatorObservers: routerObserver != null
            ? () => [routerObserver!]
            : AutoRouterDelegate.defaultNavigatorObserversBuilder,
      ),
      themeMode: themeMode,
    );
  }
}
