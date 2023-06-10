{{#android}}import 'package:auto_route/auto_route.dart';
import 'package:{{project_name}}_ui_android/{{project_name}}_ui_android.dart';

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
    List<NavigatorObserver> Function()? navigatorObserverBuilder,
  }) = _App;

  @visibleForTesting
  const factory App.test({
    Key? key,
    Locale locale,
    required List<LocalizationsDelegate> localizationsDelegates,
    required RootStackRouter router,
    List<PageRouteInfo<dynamic>>? initialRoutes,
    NavigatorObserver? navigatorObserver,
    ThemeMode? themeMode,
  }) = _AppTest;

  @visibleForTesting
  const factory App.testWidget({
    Key? key,
    required Widget widget,
    Locale locale,
    required List<LocalizationsDelegate> localizationsDelegates,
    ThemeMode? themeMode,
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
    this.navigatorObserverBuilder,
  }) : super._();

  final List<NavigatorObserver> Function()? navigatorObserverBuilder;
  final List<Locale> supportedLocales;

  @override
  Widget build(BuildContext context) {
    return {{project_name.pascalCase()}}App(
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      routerConfig: router!.config(
        navigatorObservers: navigatorObserverBuilder ??
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
    this.navigatorObserver,
    this.themeMode,
  }) : super._();

  final Locale locale;
  final List<PageRouteInfo<dynamic>>? initialRoutes;
  final NavigatorObserver? navigatorObserver;
  final ThemeMode? themeMode;

  List<Locale> get supportedLocales => [locale];

  @override
  Widget build(BuildContext context) {
    return {{project_name.pascalCase()}}App(
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      routerConfig: router!.config(
        deepLinkBuilder:
            initialRoutes != null ? (_) => DeepLink(initialRoutes!) : null,
        navigatorObservers: navigatorObserver!= null
            ? () => [navigatorObserver!]
            : AutoRouterDelegate.defaultNavigatorObserversBuilder,
      ),
      themeMode: themeMode,
    );
  }
}

class _AppTestWidget extends App {
  const _AppTestWidget({
    super.key,
    required this.widget,
    this.locale = const Locale('en'),
    required super.localizationsDelegates,
    this.themeMode,
  }) : super._();

  final Locale locale;
  final Widget widget;
  final ThemeMode? themeMode;

  @override
  Widget build(BuildContext context) {
    // ignore: invalid_use_of_visible_for_testing_member
    return {{project_name.pascalCase()}}App.test(
      locale: locale,
      localizationsDelegates: localizationsDelegates,
      home: widget,
      themeMode: themeMode,
    );
  }
}
{{/android}}{{#ios}}import 'package:auto_route/auto_route.dart';
import 'package:{{project_name}}_ui_ios/{{project_name}}_ui_ios.dart';

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
    List<NavigatorObserver> Function()? navigatorObserverBuilder,
  }) = _App;

  @visibleForTesting
  const factory App.test({
    Key? key,
    Locale locale,
    required List<LocalizationsDelegate> localizationsDelegates,
    required RootStackRouter router,
    List<PageRouteInfo<dynamic>>? initialRoutes,
    NavigatorObserver? navigatorObserver,
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
    this.navigatorObserverBuilder,
  }) : super._();

  final List<NavigatorObserver> Function()? navigatorObserverBuilder;
  final List<Locale> supportedLocales;

  @override
  Widget build(BuildContext context) {
    return {{project_name.pascalCase()}}App(
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      routerConfig: router!.config(
        navigatorObservers: navigatorObserverBuilder ??
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
    this.navigatorObserver,
    this.brightness,
  }) : super._();

  final Locale locale;
  final List<PageRouteInfo<dynamic>>? initialRoutes;
  final NavigatorObserver? navigatorObserver;
  final Brightness? brightness;

  List<Locale> get supportedLocales => [locale];

  @override
  Widget build(BuildContext context) {
    return {{project_name.pascalCase()}}App(
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      routerConfig: router!.config(
        deepLinkBuilder:
            initialRoutes != null ? (_) => DeepLink(initialRoutes!) : null,
        navigatorObservers: navigatorObserver!= null
            ? () => [navigatorObserver!]
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
    return {{project_name.pascalCase()}}App.test(
      locale: locale,
      localizationsDelegates: localizationsDelegates,
      home: widget,
      brightness: brightness,
    );
  }
}
{{/ios}}{{#linux}}import 'package:auto_route/auto_route.dart';
import 'package:{{project_name}}_ui_linux/{{project_name}}_ui_linux.dart';

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
    List<NavigatorObserver> Function()? navigatorObserverBuilder,
  }) = _App;

  @visibleForTesting
  const factory App.test({
    Key? key,
    Locale locale,
    required List<LocalizationsDelegate> localizationsDelegates,
    required RootStackRouter router,
    List<PageRouteInfo<dynamic>>? initialRoutes,
    NavigatorObserver? navigatorObserver,
    ThemeMode? themeMode,
  }) = _AppTest;

  @visibleForTesting
  const factory App.testWidget({
    Key? key,
    required Widget widget,
    Locale locale,
    required List<LocalizationsDelegate> localizationsDelegates,
    ThemeMode? themeMode,
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
    this.navigatorObserverBuilder,
  }) : super._();

  final List<NavigatorObserver> Function()? navigatorObserverBuilder;
  final List<Locale> supportedLocales;

  @override
  Widget build(BuildContext context) {
    return {{project_name.pascalCase()}}App(
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      routerConfig: router!.config(
        navigatorObservers: navigatorObserverBuilder ??
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
    this.navigatorObserver,
    this.themeMode,
  }) : super._();

  final Locale locale;
  final List<PageRouteInfo<dynamic>>? initialRoutes;
  final NavigatorObserver? navigatorObserver;
  final ThemeMode? themeMode;

  List<Locale> get supportedLocales => [locale];

  @override
  Widget build(BuildContext context) {
    return {{project_name.pascalCase()}}App(
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      routerConfig: router!.config(
        deepLinkBuilder:
            initialRoutes != null ? (_) => DeepLink(initialRoutes!) : null,
        navigatorObservers: navigatorObserver!= null
            ? () => [navigatorObserver!]
            : AutoRouterDelegate.defaultNavigatorObserversBuilder,
      ),
      themeMode: themeMode,
    );
  }
}

class _AppTestWidget extends App {
  const _AppTestWidget({
    super.key,
    required this.widget,
    this.locale = const Locale('en'),
    required super.localizationsDelegates,
    this.themeMode,
  }) : super._();

  final Locale locale;
  final Widget widget;
  final ThemeMode? themeMode;

  @override
  Widget build(BuildContext context) {
    // ignore: invalid_use_of_visible_for_testing_member
    return {{project_name.pascalCase()}}App.test(
      locale: locale,
      localizationsDelegates: localizationsDelegates,
      home: widget,
      themeMode: themeMode,
    );
  }
}
{{/linux}}{{#macos}}import 'package:auto_route/auto_route.dart';
import 'package:{{project_name}}_ui_macos/{{project_name}}_ui_macos.dart';

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
    List<NavigatorObserver> Function()? navigatorObserverBuilder,
  }) = _App;

  @visibleForTesting
  const factory App.test({
    Key? key,
    Locale locale,
    required List<LocalizationsDelegate> localizationsDelegates,
    required RootStackRouter router,
    List<PageRouteInfo<dynamic>>? initialRoutes,
    NavigatorObserver? navigatorObserver,
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
    this.navigatorObserverBuilder,
  }) : super._();

  final List<NavigatorObserver> Function()? navigatorObserverBuilder;
  final List<Locale> supportedLocales;

  @override
  Widget build(BuildContext context) {
    return {{project_name.pascalCase()}}App(
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      routerConfig: router!.config(
        navigatorObservers: navigatorObserverBuilder ??
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
    this.navigatorObserver,
    this.brightness,
  }) : super._();

  final Locale locale;
  final List<PageRouteInfo<dynamic>>? initialRoutes;
  final NavigatorObserver? navigatorObserver;
  final Brightness? brightness;

  List<Locale> get supportedLocales => [locale];

  @override
  Widget build(BuildContext context) {
    return {{project_name.pascalCase()}}App(
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      routerConfig: router!.config(
        deepLinkBuilder:
            initialRoutes != null ? (_) => DeepLink(initialRoutes!) : null,
        navigatorObservers: navigatorObserver!= null
            ? () => [navigatorObserver!]
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
    this.brightness
  }) : super._();

  final Locale locale;
  final Widget widget;
  final Brightness? brightness;

  @override
  Widget build(BuildContext context) {
    // ignore: invalid_use_of_visible_for_testing_member
    return {{project_name.pascalCase()}}App.test(
      locale: locale,
      localizationsDelegates: localizationsDelegates,
      home: widget,
      brightness: brightness,
    );
  }
}
{{/macos}}{{#web}}import 'package:auto_route/auto_route.dart';
import 'package:{{project_name}}_ui_web/{{project_name}}_ui_web.dart';

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
    List<NavigatorObserver> Function()? navigatorObserverBuilder,
  }) = _App;

  @visibleForTesting
  const factory App.test({
    Key? key,
    Locale locale,
    required List<LocalizationsDelegate> localizationsDelegates,
    required RootStackRouter router,
    List<PageRouteInfo<dynamic>>? initialRoutes,
    NavigatorObserver? navigatorObserver,
    ThemeMode? themeMode,
  }) = _AppTest;

  @visibleForTesting
  const factory App.testWidget({
    Key? key,
    required Widget widget,
    Locale locale,
    required List<LocalizationsDelegate> localizationsDelegates,
    ThemeMode? themeMode,
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
    this.navigatorObserverBuilder,
  }) : super._();

  final List<NavigatorObserver> Function()? navigatorObserverBuilder;
  final List<Locale> supportedLocales;

  @override
  Widget build(BuildContext context) {
    return {{project_name.pascalCase()}}App(
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      routerConfig: router!.config(
        navigatorObservers: navigatorObserverBuilder ??
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
    this.navigatorObserver,
    this.themeMode,
  }) : super._();

  final Locale locale;
  final List<PageRouteInfo<dynamic>>? initialRoutes;
  final NavigatorObserver? navigatorObserver;
  final ThemeMode? themeMode;

  List<Locale> get supportedLocales => [locale];

  @override
  Widget build(BuildContext context) {
    return {{project_name.pascalCase()}}App(
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      routerConfig: router!.config(
        deepLinkBuilder:
            initialRoutes != null ? (_) => DeepLink(initialRoutes!) : null,
        navigatorObservers: navigatorObserver!= null
            ? () => [navigatorObserver!]
            : AutoRouterDelegate.defaultNavigatorObserversBuilder,
      ),
      themeMode: themeMode,
    );
  }
}

class _AppTestWidget extends App {
  const _AppTestWidget({
    super.key,
    required this.widget,
    this.locale = const Locale('en'),
    required super.localizationsDelegates,
    this.themeMode,
  }) : super._();

  final Locale locale;
  final Widget widget;
  final ThemeMode? themeMode;

  @override
  Widget build(BuildContext context) {
    // ignore: invalid_use_of_visible_for_testing_member
    return {{project_name.pascalCase()}}App.test(
      locale: locale,
      localizationsDelegates: localizationsDelegates,
      home: widget,
      themeMode: themeMode,
    );
  }
}
{{/web}}{{#windows}}import 'package:auto_route/auto_route.dart';
import 'package:{{project_name}}_ui_windows/{{project_name}}_ui_windows.dart';

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
    List<NavigatorObserver> Function()? navigatorObserverBuilder,
  }) = _App;

  @visibleForTesting
  const factory App.test({
    Key? key,
    Locale locale,
    required List<LocalizationsDelegate> localizationsDelegates,
    required RootStackRouter router,
    List<PageRouteInfo<dynamic>>? initialRoutes,
    NavigatorObserver? navigatorObserver,
    ThemeMode? themeMode,
  }) = _AppTest;

  @visibleForTesting
  const factory App.testWidget({
    Key? key,
    required Widget widget,
    Locale locale,
    required List<LocalizationsDelegate> localizationsDelegates,
    ThemeMode? themeMode,
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
    this.navigatorObserverBuilder,
  }) : super._();

  final List<NavigatorObserver> Function()? navigatorObserverBuilder;
  final List<Locale> supportedLocales;

  @override
  Widget build(BuildContext context) {
    return {{project_name.pascalCase()}}App(
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      routerConfig: router!.config(
        navigatorObservers: navigatorObserverBuilder ??
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
    this.navigatorObserver,
    this.themeMode,
  }) : super._();

  final Locale locale;
  final List<PageRouteInfo<dynamic>>? initialRoutes;
  final NavigatorObserver? navigatorObserver;
  final ThemeMode? themeMode;

  List<Locale> get supportedLocales => [locale];

  @override
  Widget build(BuildContext context) {
    return {{project_name.pascalCase()}}App(
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      routerConfig: router!.config(
        deepLinkBuilder:
            initialRoutes != null ? (_) => DeepLink(initialRoutes!) : null,
        navigatorObservers: navigatorObserver!= null
            ? () => [navigatorObserver!]
            : AutoRouterDelegate.defaultNavigatorObserversBuilder,
      ),
      themeMode: themeMode,
    );
  }
}

class _AppTestWidget extends App {
  const _AppTestWidget({
    super.key,
    required this.widget,
    this.locale = const Locale('en'),
    required super.localizationsDelegates,
    this.themeMode,
  }) : super._();

  final Locale locale;
  final Widget widget;
  final ThemeMode? themeMode;

  @override
  Widget build(BuildContext context) {
    // ignore: invalid_use_of_visible_for_testing_member
    return {{project_name.pascalCase()}}App.test(
      locale: locale,
      localizationsDelegates: localizationsDelegates,
      home: widget,
      themeMode: themeMode,
    );
  }
}
{{/windows}}{{#mobile}}import 'package:auto_route/auto_route.dart';
import 'package:{{project_name}}_ui_mobile/{{project_name}}_ui_mobile.dart';

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
    List<NavigatorObserver> Function()? navigatorObserverBuilder,
  }) = _App;

  @visibleForTesting
  const factory App.test({
    Key? key,
    Locale locale,
    required List<LocalizationsDelegate> localizationsDelegates,
    required RootStackRouter router,
    List<PageRouteInfo<dynamic>>? initialRoutes,
    NavigatorObserver? navigatorObserver,
    ThemeMode? themeMode,
  }) = _AppTest;

  @visibleForTesting
  const factory App.testWidget({
    Key? key,
    required Widget widget,
    Locale locale,
    required List<LocalizationsDelegate> localizationsDelegates,
    ThemeMode? themeMode,
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
    this.navigatorObserverBuilder,
  }) : super._();

  final List<NavigatorObserver> Function()? navigatorObserverBuilder;
  final List<Locale> supportedLocales;

  @override
  Widget build(BuildContext context) {
    return {{project_name.pascalCase()}}App(
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      routerConfig: router!.config(
        navigatorObservers: navigatorObserverBuilder ??
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
    this.navigatorObserver,
    this.themeMode,
  }) : super._();

  final Locale locale;
  final List<PageRouteInfo<dynamic>>? initialRoutes;
  final NavigatorObserver? navigatorObserver;
  final ThemeMode? themeMode;

  List<Locale> get supportedLocales => [locale];

  @override
  Widget build(BuildContext context) {
    return {{project_name.pascalCase()}}App(
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      routerConfig: router!.config(
        deepLinkBuilder:
            initialRoutes != null ? (_) => DeepLink(initialRoutes!) : null,
        navigatorObservers: navigatorObserver!= null
            ? () => [navigatorObserver!]
            : AutoRouterDelegate.defaultNavigatorObserversBuilder,
      ),
      themeMode: themeMode,
    );
  }
}

class _AppTestWidget extends App {
  const _AppTestWidget({
    super.key,
    required this.widget,
    this.locale = const Locale('en'),
    required super.localizationsDelegates,
    this.themeMode,
  }) : super._();

  final Locale locale;
  final Widget widget;
  final ThemeMode? themeMode;

  @override
  Widget build(BuildContext context) {
    // ignore: invalid_use_of_visible_for_testing_member
    return {{project_name.pascalCase()}}App.test(
      locale: locale,
      localizationsDelegates: localizationsDelegates,
      home: widget,
      themeMode: themeMode,
    );
  }
}
{{/mobile}}