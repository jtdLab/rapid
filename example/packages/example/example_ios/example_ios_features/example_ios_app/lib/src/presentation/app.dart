import 'package:auto_route/auto_route.dart';
import 'package:example_ui_ios/example_ui_ios.dart';

abstract class App extends StatelessWidget {
  const App._({
    super.key,
    required this.localizationsDelegates,
    this.router,
  });

  const factory App({
    Key? key,
    required List<Locale> supportedLocales,
    required List<LocalizationsDelegate> localizationsDelegates,
    required RootStackRouter router,
    List<NavigatorObserver> Function()? routerObserverBuilder,
  }) = _App;

  @visibleForTesting
  const factory App.test({
    Key? key,
    Locale locale,
    required List<LocalizationsDelegate> localizationsDelegates,
    required RootStackRouter router,
    List<PageRouteInfo<dynamic>>? initialRoutes,
    NavigatorObserver? routerObserver,
    Brightness? brightness,
  }) = _AppTest;

  @visibleForTesting
  const factory App.testWidget({
    Key? key,
    required Widget widget,
    Locale locale,
    required List<LocalizationsDelegate> localizationsDelegates,
    Brightness? brightness,
  }) = _AppTestWidget;

  final List<LocalizationsDelegate> localizationsDelegates;
  final RootStackRouter? router;
}

class _App extends App {
  const _App({
    super.key,
    required this.supportedLocales,
    required super.localizationsDelegates,
    required RootStackRouter super.router,
    this.routerObserverBuilder,
  }) : super._();

  final List<NavigatorObserver> Function()? routerObserverBuilder;

  final List<Locale> supportedLocales;

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
    required super.localizationsDelegates,
    required RootStackRouter super.router,
    this.initialRoutes,
    this.routerObserver,
    this.brightness,
  }) : super._();

  final Locale locale;
  final List<PageRouteInfo<dynamic>>? initialRoutes;
  final NavigatorObserver? routerObserver;
  final Brightness? brightness;

  List<Locale> get supportedLocales => [locale];

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
    required super.localizationsDelegates,
    this.brightness,
  }) : super._();

  final Locale locale;
  final Widget widget;
  final Brightness? brightness;

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
