{{#android}}import 'package:auto_route/auto_route.dart';
import 'package:{{project_name}}_android_localization/{{project_name}}_android_localization.dart';
import 'package:{{project_name}}_ui_android/{{project_name}}_ui_android.dart';

abstract class App extends StatelessWidget {
  const factory App({
    Key? key,
    required RootStackRouter router,
    List<NavigatorObserver> Function()? navigatorObserverBuilder,
  }) = _App;

  @visibleForTesting
  const factory App.test({
    Key? key,
    Locale? locale,
    required RootStackRouter router,
    List<PageRouteInfo<dynamic>>? initialRoutes,
    NavigatorObserver? navigatorObserver,
    ThemeMode? themeMode,
  }) = _AppTest;

  @visibleForTesting
  const factory App.testWidget({
    Key? key,
    required Widget widget,
    Locale? locale,
    ThemeMode? themeMode,
  }) = _AppTestWidget;

  const App._({
    super.key,
    this.router,
  })  : supportedLocales = {{project_name.pascalCase()}}Localizations.supportedLocales,
        localizationsDelegates = const [
          {{project_name.pascalCase()}}Localizations.delegate
        ];

  final List<Locale> supportedLocales;

  final List<LocalizationsDelegate<dynamic>> localizationsDelegates;

  final RootStackRouter? router;
}

class _App extends App {
  const _App({
    super.key,
    required RootStackRouter super.router,
    this.navigatorObserverBuilder,
  }) : super._();

  final List<NavigatorObserver> Function()? navigatorObserverBuilder;

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
    this.locale,
    required RootStackRouter super.router,
    this.initialRoutes,
    this.navigatorObserver,
    this.themeMode,
  }) : super._();

  final Locale? locale;

  final List<PageRouteInfo<dynamic>>? initialRoutes;

  final NavigatorObserver? navigatorObserver;

  final ThemeMode? themeMode;

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
    this.locale,
    this.themeMode,
  }) : super._();

  final Locale? locale;

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
import 'package:{{project_name}}_ios_localization/{{project_name}}_ios_localization.dart';

abstract class App extends StatelessWidget {
  const factory App({
    Key? key,
    required RootStackRouter router,
    List<NavigatorObserver> Function()? navigatorObserverBuilder,
  }) = _App;

  @visibleForTesting
  const factory App.test({
    Key? key,
    Locale? locale,
    required RootStackRouter router,
    List<PageRouteInfo<dynamic>>? initialRoutes,
    NavigatorObserver? navigatorObserver,
    Brightness? brightness,
  }) = _AppTest;

  @visibleForTesting
  const factory App.testWidget({
    Key? key,
    required Widget widget,
    Locale? locale,
    Brightness? brightness,
  }) = _AppTestWidget;

  const App._({
    super.key,
    this.router,
  })  : supportedLocales = {{project_name.pascalCase()}}Localizations.supportedLocales,
        localizationsDelegates = const [
          {{project_name.pascalCase()}}Localizations.delegate
        ];

  final List<Locale> supportedLocales;

  final List<LocalizationsDelegate<dynamic>> localizationsDelegates;

  final RootStackRouter? router;
}

class _App extends App {
  const _App({
    super.key,
    required RootStackRouter super.router,
    this.navigatorObserverBuilder,
  }) : super._();

  final List<NavigatorObserver> Function()? navigatorObserverBuilder;

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
    this.locale,
    required RootStackRouter super.router,
    this.initialRoutes,
    this.navigatorObserver,
    this.brightness,
  }) : super._();

  final Locale? locale;

  final List<PageRouteInfo<dynamic>>? initialRoutes;

  final NavigatorObserver? navigatorObserver;

  final Brightness? brightness;

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
    this.locale,
    this.brightness,
  }) : super._();

  final Locale? locale;

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
import 'package:{{project_name}}_linux_localization/{{project_name}}_linux_localization.dart';

abstract class App extends StatelessWidget {
  const factory App({
    Key? key,
    required RootStackRouter router,
    List<NavigatorObserver> Function()? navigatorObserverBuilder,
  }) = _App;

  @visibleForTesting
  const factory App.test({
    Key? key,
    Locale? locale,
    required RootStackRouter router,
    List<PageRouteInfo<dynamic>>? initialRoutes,
    NavigatorObserver? navigatorObserver,
    ThemeMode? themeMode,
  }) = _AppTest;

  @visibleForTesting
  const factory App.testWidget({
    Key? key,
    required Widget widget,
    Locale? locale,
    ThemeMode? themeMode,
  }) = _AppTestWidget;

  const App._({
    super.key,
    this.router,
  })  : supportedLocales = {{project_name.pascalCase()}}Localizations.supportedLocales,
        localizationsDelegates = const [
          {{project_name.pascalCase()}}Localizations.delegate
        ];

  final List<Locale> supportedLocales;

  final List<LocalizationsDelegate<dynamic>> localizationsDelegates;

  final RootStackRouter? router;
}

class _App extends App {
  const _App({
    super.key,
    required RootStackRouter super.router,
    this.navigatorObserverBuilder,
  }) : super._();

  final List<NavigatorObserver> Function()? navigatorObserverBuilder;

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
    this.locale,
    required RootStackRouter super.router,
    this.initialRoutes,
    this.navigatorObserver,
    this.themeMode,
  }) : super._();

  final Locale? locale;

  final List<PageRouteInfo<dynamic>>? initialRoutes;

  final NavigatorObserver? navigatorObserver;

  final ThemeMode? themeMode;

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
    this.locale,
    this.themeMode,
  }) : super._();

  final Locale? locale;

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
import 'package:{{project_name}}_macos_localization/{{project_name}}_macos_localization.dart';

abstract class App extends StatelessWidget {
  const factory App({
    Key? key,
    required RootStackRouter router,
    List<NavigatorObserver> Function()? navigatorObserverBuilder,
  }) = _App;

  @visibleForTesting
  const factory App.test({
    Key? key,
    Locale? locale,
    required RootStackRouter router,
    List<PageRouteInfo<dynamic>>? initialRoutes,
    NavigatorObserver? navigatorObserver,
    ThemeMode? themeMode,
  }) = _AppTest;

  @visibleForTesting
  const factory App.testWidget({
    Key? key,
    required Widget widget,
    Locale? locale,
    ThemeMode? themeMode,
  }) = _AppTestWidget;

  const App._({
    super.key,
    this.router,
  })  : supportedLocales = {{project_name.pascalCase()}}Localizations.supportedLocales,
        localizationsDelegates = const [
          {{project_name.pascalCase()}}Localizations.delegate
        ];

  final List<Locale> supportedLocales;

  final List<LocalizationsDelegate<dynamic>> localizationsDelegates;

  final RootStackRouter? router;
}

class _App extends App {
  const _App({
    super.key,
    required RootStackRouter super.router,
    this.navigatorObserverBuilder,
  }) : super._();

  final List<NavigatorObserver> Function()? navigatorObserverBuilder;

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
    this.locale,
    required RootStackRouter super.router,
    this.initialRoutes,
    this.navigatorObserver,
    this.themeMode,
  }) : super._();

  final Locale? locale;

  final List<PageRouteInfo<dynamic>>? initialRoutes;

  final NavigatorObserver? navigatorObserver;

  final ThemeMode? themeMode;

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
    this.locale,
    this.themeMode,
  }) : super._();

  final Locale? locale;

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
{{/macos}}{{#web}}import 'package:auto_route/auto_route.dart';
import 'package:{{project_name}}_ui_web/{{project_name}}_ui_web.dart';
import 'package:{{project_name}}_web_localization/{{project_name}}_web_localization.dart';

abstract class App extends StatelessWidget {
  const factory App({
    Key? key,
    required RootStackRouter router,
    List<NavigatorObserver> Function()? navigatorObserverBuilder,
  }) = _App;

  @visibleForTesting
  const factory App.test({
    Key? key,
    Locale? locale,
    required RootStackRouter router,
    List<PageRouteInfo<dynamic>>? initialRoutes,
    NavigatorObserver? navigatorObserver,
    ThemeMode? themeMode,
  }) = _AppTest;

  @visibleForTesting
  const factory App.testWidget({
    Key? key,
    required Widget widget,
    Locale? locale,
    ThemeMode? themeMode,
  }) = _AppTestWidget;

  const App._({
    super.key,
    this.router,
  })  : supportedLocales = {{project_name.pascalCase()}}Localizations.supportedLocales,
        localizationsDelegates = const [
          {{project_name.pascalCase()}}Localizations.delegate
        ];

  final List<Locale> supportedLocales;

  final List<LocalizationsDelegate<dynamic>> localizationsDelegates;

  final RootStackRouter? router;
}

class _App extends App {
  const _App({
    super.key,
    required RootStackRouter super.router,
    this.navigatorObserverBuilder,
  }) : super._();

  final List<NavigatorObserver> Function()? navigatorObserverBuilder;

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
    this.locale,
    required RootStackRouter super.router,
    this.initialRoutes,
    this.navigatorObserver,
    this.themeMode,
  }) : super._();

  final Locale? locale;

  final List<PageRouteInfo<dynamic>>? initialRoutes;

  final NavigatorObserver? navigatorObserver;

  final ThemeMode? themeMode;

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
    this.locale,
    this.themeMode,
  }) : super._();

  final Locale? locale;

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
import 'package:{{project_name}}_windows_localization/{{project_name}}_windows_localization.dart';

abstract class App extends StatelessWidget {
  const factory App({
    Key? key,
    required RootStackRouter router,
    List<NavigatorObserver> Function()? navigatorObserverBuilder,
  }) = _App;

  @visibleForTesting
  const factory App.test({
    Key? key,
    Locale? locale,
    required RootStackRouter router,
    List<PageRouteInfo<dynamic>>? initialRoutes,
    NavigatorObserver? navigatorObserver,
    ThemeMode? themeMode,
  }) = _AppTest;

  @visibleForTesting
  const factory App.testWidget({
    Key? key,
    required Widget widget,
    Locale? locale,
    ThemeMode? themeMode,
  }) = _AppTestWidget;

  const App._({
    super.key,
    this.router,
  })  : supportedLocales = {{project_name.pascalCase()}}Localizations.supportedLocales,
        localizationsDelegates = const [
          {{project_name.pascalCase()}}Localizations.delegate
        ];

  final List<Locale> supportedLocales;

  final List<LocalizationsDelegate<dynamic>> localizationsDelegates;

  final RootStackRouter? router;
}

class _App extends App {
  const _App({
    super.key,
    required RootStackRouter super.router,
    this.navigatorObserverBuilder,
  }) : super._();

  final List<NavigatorObserver> Function()? navigatorObserverBuilder;

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
    this.locale,
    required RootStackRouter super.router,
    this.initialRoutes,
    this.navigatorObserver,
    this.themeMode,
  }) : super._();

  final Locale? locale;

  final List<PageRouteInfo<dynamic>>? initialRoutes;

  final NavigatorObserver? navigatorObserver;

  final ThemeMode? themeMode;

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
    this.locale,
    this.themeMode,
  }) : super._();

  final Locale? locale;

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
import 'package:{{project_name}}_mobile_localization/{{project_name}}_mobile_localization.dart';

abstract class App extends StatelessWidget {
  const factory App({
    Key? key,
    required RootStackRouter router,
    List<NavigatorObserver> Function()? navigatorObserverBuilder,
  }) = _App;

  @visibleForTesting
  const factory App.test({
    Key? key,
    Locale? locale,
    required RootStackRouter router,
    List<PageRouteInfo<dynamic>>? initialRoutes,
    NavigatorObserver? navigatorObserver,
    ThemeMode? themeMode,
  }) = _AppTest;

  @visibleForTesting
  const factory App.testWidget({
    Key? key,
    required Widget widget,
    Locale? locale,
    ThemeMode? themeMode,
  }) = _AppTestWidget;

  const App._({
    super.key,
    this.router,
  })  : supportedLocales = {{project_name.pascalCase()}}Localizations.supportedLocales,
        localizationsDelegates = const [
          {{project_name.pascalCase()}}Localizations.delegate
        ];

  final List<Locale> supportedLocales;

  final List<LocalizationsDelegate<dynamic>> localizationsDelegates;

  final RootStackRouter? router;
}

class _App extends App {
  const _App({
    super.key,
    required RootStackRouter super.router,
    this.navigatorObserverBuilder,
  }) : super._();

  final List<NavigatorObserver> Function()? navigatorObserverBuilder;

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
    this.locale,
    required RootStackRouter super.router,
    this.initialRoutes,
    this.navigatorObserver,
    this.themeMode,
  }) : super._();

  final Locale? locale;

  final List<PageRouteInfo<dynamic>>? initialRoutes;

  final NavigatorObserver? navigatorObserver;

  final ThemeMode? themeMode;

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
    this.locale,
    this.themeMode,
  }) : super._();

  final Locale? locale;

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