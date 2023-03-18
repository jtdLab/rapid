{{#android}}import 'package:auto_route/auto_route.dart';
import 'package:{{project_name}}_ui_android/{{project_name}}_ui_android.dart';

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
    ThemeMode? themeMode,
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
    return {{project_name.pascalCase()}}App(
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
    this.locale = const Locale('en'),
    required this.localizationsDelegate,
    required super.router,
    this.initialRoutes,
    this.routerObserver,
    this.themeMode,
  }) : super._();

  final Locale locale;
  final LocalizationsDelegate localizationsDelegate;
  final List<PageRouteInfo<dynamic>>? initialRoutes;
  final AutoRouterObserver? routerObserver;
  final ThemeMode? themeMode;

  @override
  List<Locale> get supportedLocales => [locale];
  @override
  List<LocalizationsDelegate> get localizationsDelegates =>
      [localizationsDelegate];

  @override
  Widget build(BuildContext context) {
    return {{project_name.pascalCase()}}App(
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
{{/android}}{{#ios}}import 'package:auto_route/auto_route.dart';
import 'package:{{project_name}}_ui_ios/{{project_name}}_ui_ios.dart';

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
    return {{project_name.pascalCase()}}App(
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
    return {{project_name.pascalCase()}}App(
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
      brightness: brightness,
    );
  }
}
{{/ios}}{{#linux}}import 'package:auto_route/auto_route.dart';
import 'package:{{project_name}}_ui_linux/{{project_name}}_ui_linux.dart';

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
    ThemeMode? themeMode,
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
    return {{project_name.pascalCase()}}App(
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
    this.locale = const Locale('en'),
    required this.localizationsDelegate,
    required super.router,
    this.initialRoutes,
    this.routerObserver,
    this.themeMode,
  }) : super._();

  final Locale locale;
  final LocalizationsDelegate localizationsDelegate;
  final List<PageRouteInfo<dynamic>>? initialRoutes;
  final AutoRouterObserver? routerObserver;
  final ThemeMode? themeMode;

  @override
  List<Locale> get supportedLocales => [locale];
  @override
  List<LocalizationsDelegate> get localizationsDelegates =>
      [localizationsDelegate];

  @override
  Widget build(BuildContext context) {
    return {{project_name.pascalCase()}}App(
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
{{/linux}}{{#macos}}import 'package:auto_route/auto_route.dart';
import 'package:{{project_name}}_ui_macos/{{project_name}}_ui_macos.dart';

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
    return {{project_name.pascalCase()}}App(
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
    return {{project_name.pascalCase()}}App(
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
      brightness: brightness,
    );
  }
}
{{/macos}}{{#web}}import 'package:auto_route/auto_route.dart';
import 'package:{{project_name}}_ui_web/{{project_name}}_ui_web.dart';

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
    ThemeMode? themeMode,
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
    return {{project_name.pascalCase()}}App(
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
    this.locale = const Locale('en'),
    required this.localizationsDelegate,
    required super.router,
    this.initialRoutes,
    this.routerObserver,
    this.themeMode,
  }) : super._();

  final Locale locale;
  final LocalizationsDelegate localizationsDelegate;
  final List<PageRouteInfo<dynamic>>? initialRoutes;
  final AutoRouterObserver? routerObserver;
  final ThemeMode? themeMode;

  @override
  List<Locale> get supportedLocales => [locale];
  @override
  List<LocalizationsDelegate> get localizationsDelegates =>
      [localizationsDelegate];

  @override
  Widget build(BuildContext context) {
    return {{project_name.pascalCase()}}App(
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
{{/web}}{{#windows}}import 'package:auto_route/auto_route.dart';
import 'package:{{project_name}}_ui_windows/{{project_name}}_ui_windows.dart';

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
    ThemeMode? themeMode,
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
    return {{project_name.pascalCase()}}App(
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
    this.locale = const Locale('en'),
    required this.localizationsDelegate,
    required super.router,
    this.initialRoutes,
    this.routerObserver,
    this.themeMode,
  }) : super._();

  final Locale locale;
  final LocalizationsDelegate localizationsDelegate;
  final List<PageRouteInfo<dynamic>>? initialRoutes;
  final AutoRouterObserver? routerObserver;
  final ThemeMode? themeMode;

  @override
  List<Locale> get supportedLocales => [locale];
  @override
  List<LocalizationsDelegate> get localizationsDelegates =>
      [localizationsDelegate];

  @override
  Widget build(BuildContext context) {
    return {{project_name.pascalCase()}}App(
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
{{/windows}}