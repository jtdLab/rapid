import 'package:auto_route/auto_route.dart';
import 'package:project_macos_ui_macos/project_macos_ui_macos.dart';

abstract class App extends StatelessWidget {
  const App._({
    super.key,
    required this.router,
  });

  const factory App({
    Key? key,
    required List<Locale> supportedLocales,
    required List<LocalizationsDelegate> localizationsDelegates,
    required RootStackRouter router,
    List<AutoRouterObserver> Function()? routerObserverBuilder,
  }) = _App;

  @visibleForTesting
  const factory App.test({
    Key? key,
    Locale locale,
    required LocalizationsDelegate localizationsDelegate,
    required RootStackRouter router,
    List<PageRouteInfo<dynamic>>? initialRoutes,
    AutoRouterObserver? routerObserver,
    Brightness? brightness,
  }) = _AppTest;

  List<Locale> get supportedLocales;
  List<LocalizationsDelegate> get localizationsDelegates;
  final RootStackRouter router;
}

class _App extends App {
  const _App({
    super.key,
    required this.supportedLocales,
    required this.localizationsDelegates,
    required super.router,
    this.routerObserverBuilder,
  }) : super._();

  final List<AutoRouterObserver> Function()? routerObserverBuilder;

  @override
  final List<Locale> supportedLocales;
  @override
  final List<LocalizationsDelegate> localizationsDelegates;

  @override
  Widget build(BuildContext context) {
    return ProjectMacosApp(
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      routerConfig: router.config(
        navigatorObservers: routerObserverBuilder ??
            AutoRouterDelegate.defaultNavigatorObserversBuilder,
      ),
    );
  }
}

class _AppTest extends App {
  const _AppTest({
    super.key,
    this.locale = const Locale('en'),
    required this.localizationsDelegate,
    required super.router,
    this.initialRoutes,
    this.routerObserver,
    this.brightness,
  }) : super._();

  final Locale locale;
  final LocalizationsDelegate localizationsDelegate;
  final List<PageRouteInfo<dynamic>>? initialRoutes;
  final AutoRouterObserver? routerObserver;
  final Brightness? brightness;

  @override
  List<Locale> get supportedLocales => [locale];
  @override
  List<LocalizationsDelegate> get localizationsDelegates =>
      [localizationsDelegate];

  @override
  Widget build(BuildContext context) {
    return ProjectMacosApp(
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      routerConfig: router.config(
        initialRoutes: initialRoutes,
        navigatorObservers: routerObserver != null
            ? () => [routerObserver!]
            : AutoRouterDelegate.defaultNavigatorObserversBuilder,
      ),
      brightness: brightness,
    );
  }
}
