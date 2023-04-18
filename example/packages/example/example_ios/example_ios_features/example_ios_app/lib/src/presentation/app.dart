import 'package:auto_route/auto_route.dart';
import 'package:example_ui_ios/example_ui_ios.dart';

abstract class App extends StatelessWidget {
  const App._({
    super.key,
    this.router,
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

  @visibleForTesting
  const factory App.testWidget({
    Key? key,
    required Widget widget,
    Locale locale,
    required LocalizationsDelegate localizationsDelegate,
    Brightness? brightness,
  }) = _AppTestWidget;

  List<LocalizationsDelegate> get localizationsDelegates;
  final RootStackRouter? router;
}

class _App extends App {
  const _App({
    super.key,
    required this.supportedLocales,
    required this.localizationsDelegates,
    required RootStackRouter super.router,
    this.routerObserverBuilder,
  }) : super._();

  final List<AutoRouterObserver> Function()? routerObserverBuilder;

  final List<Locale> supportedLocales;
  @override
  final List<LocalizationsDelegate> localizationsDelegates;

  @override
  Widget build(BuildContext context) {
    return ExampleApp(
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      routerConfig: router!.config(
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
    required RootStackRouter super.router,
    this.initialRoutes,
    this.routerObserver,
    this.brightness,
  }) : super._();

  final Locale locale;
  final LocalizationsDelegate localizationsDelegate;
  final List<PageRouteInfo<dynamic>>? initialRoutes;
  final AutoRouterObserver? routerObserver;
  final Brightness? brightness;

  List<Locale> get supportedLocales => [locale];
  @override
  List<LocalizationsDelegate> get localizationsDelegates =>
      [localizationsDelegate];

  @override
  Widget build(BuildContext context) {
    return ExampleApp(
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      routerConfig: router!.config(
        initialRoutes: initialRoutes,
        navigatorObservers: routerObserver != null
            ? () => [routerObserver!]
            : AutoRouterDelegate.defaultNavigatorObserversBuilder,
      ),
      brightness: brightness,
    );
  }
}

class _AppTestWidget extends App {
  const _AppTestWidget({
    super.key,
    required this.widget,
    this.locale = const Locale('en'),
    required this.localizationsDelegate,
    this.brightness,
  }) : super._();

  final Locale locale;
  final LocalizationsDelegate localizationsDelegate;
  final Widget widget;
  final Brightness? brightness;

  @override
  List<LocalizationsDelegate> get localizationsDelegates =>
      [localizationsDelegate];

  @override
  Widget build(BuildContext context) {
    // ignore: invalid_use_of_visible_for_testing_member
    return ExampleApp.test(
      locale: locale,
      localizationsDelegates: localizationsDelegates,
      home: widget,
      brightness: brightness,
    );
  }
}
