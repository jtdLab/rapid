{{#android}}import 'package:auto_route/auto_route.dart';
import 'package:{{project_name}}_android_app/src/presentation/app.dart';
import 'package:{{project_name}}_ui_android/{{project_name}}_ui_android.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks.dart';

App _getApp({
  required List<Locale> supportedLocales,
  required List<LocalizationsDelegate<dynamic>> localizationsDelegates,
  required RootStackRouter router,
  List<AutoRouterObserver> Function()? navigatorObserverBuilder,
}) {
  return App(
    supportedLocales: supportedLocales,
    localizationsDelegates: localizationsDelegates,
    router: router,
    navigatorObserverBuilder: navigatorObserverBuilder,
  );
}

App _getAppTest({
  required Locale locale,
  required List<LocalizationsDelegate<dynamic>> localizationsDelegates,
  required RootStackRouter router,
  List<PageRouteInfo<dynamic>>? initialRoutes,
  AutoRouterObserver? navigatorObserver,
  ThemeMode? themeMode,
}) {
  return App.test(
    locale: locale,
    localizationsDelegates: localizationsDelegates,
    router: router,
    initialRoutes: initialRoutes,
    navigatorObserver: navigatorObserver,
    themeMode: themeMode,
  );
}

App _getAppTestWidget({
  required Widget widget,
  required Locale locale,
  required List<LocalizationsDelegate<dynamic>> localizationsDelegates,
  ThemeMode? themeMode,
}) {
  return App.testWidget(
    widget: widget,
    locale: locale,
    localizationsDelegates: localizationsDelegates,
    themeMode: themeMode,
  );
}

void main() {
  group('App', () {
    testWidgets('renders {{project_name.pascalCase()}}App correctly', (tester) async {
      // Arrange
      final router = FakeRouter();
      navigatorObserverBuilder() => <AutoRouterObserver>[];
      final app = _getApp(
        supportedLocales: const [Locale('en')],
        localizationsDelegates: [GlobalWidgetsLocalizations.delegate],
        router: router,
        navigatorObserverBuilder: navigatorObserverBuilder,
      );

      // Act
      await tester.pumpWidget(app);

      // Assert
      final {{project_name.camelCase()}}App = tester.widget<{{project_name.pascalCase()}}App>(
        find.byWidgetPredicate((widget) => widget is {{project_name.pascalCase()}}App),
      );
      expect(
        {{project_name.camelCase()}}App.localizationsDelegates,
        contains(GlobalWidgetsLocalizations.delegate),
      );
      expect({{project_name.camelCase()}}App.supportedLocales, const [Locale('en')]);
      expect(
        {{project_name.camelCase()}}App.routerConfig,
        isA<RouterConfig<UrlState>>()
            .having(
              (routerConfig) => routerConfig.routeInformationParser,
              'routeInformationParser',
              isA<DefaultRouteParser>(),
            )
            .having(
              (routerConfig) => routerConfig.routeInformationProvider,
              'routeInformationProvider',
              isA<AutoRouteInformationProvider>(),
            )
            .having(
              (routerConfig) => routerConfig.routerDelegate,
              'routerDelegate',
              isA<AutoRouterDelegate>()
                  .having(
                    (delegate) => delegate.navigatorObservers,
                    'navigatorObservers',
                    navigatorObserverBuilder,
                  )
                  .having(
                    (delegate) => delegate.controller,
                    'controller',
                    router,
                  ),
            ),
      );
    });
  });

  group('App.test', () {
    testWidgets('renders {{project_name.pascalCase()}}App correctly', (tester) async {
      // Arrange
      final router = FakeRouter();
      final navigatorObserver= MockAutoRouterObserver();
      final app = _getAppTest(
        locale: const Locale('fr'),
        localizationsDelegates: [GlobalWidgetsLocalizations.delegate],
        router: router,
        initialRoutes: const [FakePageRouteInfo()],
        navigatorObserver: navigatorObserver,
        themeMode: ThemeMode.dark,
      );

      // Act
      await tester.pumpWidget(app);

      // Assert
      final {{project_name.camelCase()}}App = tester.widget<{{project_name.pascalCase()}}App>(
        find.byWidgetPredicate((widget) => widget is {{project_name.pascalCase()}}App),
      );
      expect({{project_name.camelCase()}}App.locale, const Locale('fr'));
      expect({{project_name.camelCase()}}App.supportedLocales, const [Locale('fr')]);
      expect(
        {{project_name.camelCase()}}App.localizationsDelegates,
        contains(GlobalWidgetsLocalizations.delegate),
      );
      expect(
        {{project_name.camelCase()}}App.routerConfig,
        isA<RouterConfig<UrlState>>()
            .having(
              (routerConfig) => routerConfig.routeInformationParser,
              'routeInformationParser',
              isA<DefaultRouteParser>(),
            )
            .having(
              (routerConfig) => routerConfig.routeInformationProvider,
              'routeInformationProvider',
              isA<AutoRouteInformationProvider>(),
            )
            .having(
              (routerConfig) => routerConfig.routerDelegate,
              'routerDelegate',
              isA<AutoRouterDelegate>()
                 .having(
                    (delegate) => delegate.deepLinkBuilder,
                    'deepLinkBuilder',
                    isNotNull,
                  )
                  .having(
                    (delegate) => delegate.navigatorObservers(),
                    'navigatorObservers',
                    equals([navigatorObserver]),
                  )
                  .having(
                    (delegate) => delegate.controller,
                    'controller',
                    router,
                  ),
            ),
      );
      expect({{project_name.camelCase()}}App.themeMode, ThemeMode.dark);
    });
  });

  group('App.testWidget', () {
    testWidgets('renders {{project_name.pascalCase()}}App correctly', (tester) async {
      // Arrange
      final widget = Container();
      final app = _getAppTestWidget(
        widget: widget,
        locale: const Locale('fr'),
        localizationsDelegates: [GlobalWidgetsLocalizations.delegate],
        themeMode: ThemeMode.dark,
      );

      // Act
      await tester.pumpWidget(app);

      // Assert
      final {{project_name.camelCase()}}App = tester.widget<{{project_name.pascalCase()}}App>(
        find.byWidgetPredicate((widget) => widget is {{project_name.pascalCase()}}App),
      );
      expect({{project_name.camelCase()}}App.home, widget);
      expect({{project_name.camelCase()}}App.locale, const Locale('fr'));
      expect({{project_name.camelCase()}}App.supportedLocales, const [Locale('fr')]);
      expect(
        {{project_name.camelCase()}}App.localizationsDelegates,
        contains(GlobalWidgetsLocalizations.delegate),
      );
      expect({{project_name.camelCase()}}App.routerConfig, null);
      expect({{project_name.camelCase()}}App.themeMode, ThemeMode.dark);
    });
  });
}
{{/android}}{{#ios}}import 'package:auto_route/auto_route.dart';
import 'package:{{project_name}}_ios_app/src/presentation/app.dart';
import 'package:{{project_name}}_ui_ios/{{project_name}}_ui_ios.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks.dart';

App _getApp({
  required List<Locale> supportedLocales,
  required List<LocalizationsDelegate<dynamic>> localizationsDelegates,
  required RootStackRouter router,
  List<AutoRouterObserver> Function()? navigatorObserverBuilder,
}) {
  return App(
    supportedLocales: supportedLocales,
    localizationsDelegates: localizationsDelegates,
    router: router,
    navigatorObserverBuilder: navigatorObserverBuilder,
  );
}

App _getAppTest({
  required Locale locale,
  required List<LocalizationsDelegate<dynamic>> localizationsDelegates,
  required RootStackRouter router,
  List<PageRouteInfo<dynamic>>? initialRoutes,
  AutoRouterObserver? navigatorObserver,
  Brightness? brightness,
}) {
  return App.test(
    locale: locale,
    localizationsDelegates: localizationsDelegates,
    router: router,
    initialRoutes: initialRoutes,
    navigatorObserver: navigatorObserver,
    brightness: brightness,
  );
}

App _getAppTestWidget({
  required Widget widget,
  required Locale locale,
  required List<LocalizationsDelegate<dynamic>> localizationsDelegates,
  Brightness? brightness,
}) {
  return App.testWidget(
    widget: widget,
    locale: locale,
    localizationsDelegates: localizationsDelegates,
    brightness: brightness,
  );
}

void main() {
  group('App', () {
    testWidgets('renders {{project_name.pascalCase()}}App correctly', (tester) async {
      // Arrange
      final router = FakeRouter();
      navigatorObserverBuilder() => <AutoRouterObserver>[];
      final app = _getApp(
        supportedLocales: const [Locale('en')],
        localizationsDelegates: [GlobalWidgetsLocalizations.delegate],
        router: router,
        navigatorObserverBuilder: navigatorObserverBuilder,
      );

      // Act
      await tester.pumpWidget(app);

      // Assert
      final {{project_name.camelCase()}}App = tester.widget<{{project_name.pascalCase()}}App>(
        find.byWidgetPredicate((widget) => widget is {{project_name.pascalCase()}}App),
      );
      expect(
        {{project_name.camelCase()}}App.localizationsDelegates,
        contains(GlobalWidgetsLocalizations.delegate),
      );
      expect({{project_name.camelCase()}}App.supportedLocales, const [Locale('en')]);
      expect(
        {{project_name.camelCase()}}App.routerConfig,
        isA<RouterConfig<UrlState>>()
            .having(
              (routerConfig) => routerConfig.routeInformationParser,
              'routeInformationParser',
              isA<DefaultRouteParser>(),
            )
            .having(
              (routerConfig) => routerConfig.routeInformationProvider,
              'routeInformationProvider',
              isA<AutoRouteInformationProvider>(),
            )
            .having(
              (routerConfig) => routerConfig.routerDelegate,
              'routerDelegate',
              isA<AutoRouterDelegate>()
                  .having(
                    (delegate) => delegate.navigatorObservers,
                    'navigatorObservers',
                    navigatorObserverBuilder,
                  )
                  .having(
                    (delegate) => delegate.controller,
                    'controller',
                    router,
                  ),
            ),
      );
    });
  });

  group('App.test', () {
    testWidgets('renders {{project_name.pascalCase()}}App correctly', (tester) async {
      // Arrange
      final router = FakeRouter();
      final navigatorObserver= MockAutoRouterObserver();
      final app = _getAppTest(
        locale: const Locale('fr'),
        localizationsDelegates: [GlobalWidgetsLocalizations.delegate],
        router: router,
        initialRoutes: const [FakePageRouteInfo()],
        navigatorObserver: navigatorObserver,
        brightness: Brightness.dark,
      );

      // Act
      await tester.pumpWidget(app);

      // Assert
      final {{project_name.camelCase()}}App = tester.widget<{{project_name.pascalCase()}}App>(
        find.byWidgetPredicate((widget) => widget is {{project_name.pascalCase()}}App),
      );
      expect({{project_name.camelCase()}}App.locale, const Locale('fr'));
      expect({{project_name.camelCase()}}App.supportedLocales, const [Locale('fr')]);
      expect(
        {{project_name.camelCase()}}App.localizationsDelegates,
        contains(GlobalWidgetsLocalizations.delegate),
      );
      expect(
        {{project_name.camelCase()}}App.routerConfig,
        isA<RouterConfig<UrlState>>()
            .having(
              (routerConfig) => routerConfig.routeInformationParser,
              'routeInformationParser',
              isA<DefaultRouteParser>(),
            )
            .having(
              (routerConfig) => routerConfig.routeInformationProvider,
              'routeInformationProvider',
              isA<AutoRouteInformationProvider>(),
            )
            .having(
              (routerConfig) => routerConfig.routerDelegate,
              'routerDelegate',
              isA<AutoRouterDelegate>()
                  .having(
                    (delegate) => delegate.deepLinkBuilder,
                    'deepLinkBuilder',
                    isNotNull,
                  )
                  .having(
                    (delegate) => delegate.navigatorObservers(),
                    'navigatorObservers',
                    equals([navigatorObserver]),
                  )
                  .having(
                    (delegate) => delegate.controller,
                    'controller',
                    router,
                  ),
            ),
      );
      expect({{project_name.camelCase()}}App.brightness, Brightness.dark);
    });
  });

  group('App.testWidget', () {
    testWidgets('renders {{project_name.pascalCase()}}App correctly', (tester) async {
      // Arrange
      final widget = Container();
      final app = _getAppTestWidget(
        widget: widget,
        locale: const Locale('fr'),
        localizationsDelegates: [GlobalWidgetsLocalizations.delegate],
        brightness: Brightness.dark,
      );

      // Act
      await tester.pumpWidget(app);

      // Assert
      final {{project_name.camelCase()}}App = tester.widget<{{project_name.pascalCase()}}App>(
        find.byWidgetPredicate((widget) => widget is {{project_name.pascalCase()}}App),
      );
      expect({{project_name.camelCase()}}App.home, widget);
      expect({{project_name.camelCase()}}App.locale, const Locale('fr'));
      expect({{project_name.camelCase()}}App.supportedLocales, const [Locale('fr')]);
      expect(
        {{project_name.camelCase()}}App.localizationsDelegates,
        contains(GlobalWidgetsLocalizations.delegate),
      );
      expect({{project_name.camelCase()}}App.routerConfig, null);
      expect({{project_name.camelCase()}}App.brightness, Brightness.dark);
    });
  });
}
{{/ios}}{{#linux}}import 'package:auto_route/auto_route.dart';
import 'package:{{project_name}}_linux_app/src/presentation/app.dart';
import 'package:{{project_name}}_ui_linux/{{project_name}}_ui_linux.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks.dart';

App _getApp({
  required List<Locale> supportedLocales,
  required List<LocalizationsDelegate<dynamic>> localizationsDelegates,
  required RootStackRouter router,
  List<AutoRouterObserver> Function()? navigatorObserverBuilder,
}) {
  return App(
    supportedLocales: supportedLocales,
    localizationsDelegates: localizationsDelegates,
    router: router,
    navigatorObserverBuilder: navigatorObserverBuilder,
  );
}

App _getAppTest({
  required Locale locale,
  required List<LocalizationsDelegate<dynamic>> localizationsDelegates,
  required RootStackRouter router,
  List<PageRouteInfo<dynamic>>? initialRoutes,
  AutoRouterObserver? navigatorObserver,
  ThemeMode? themeMode,
}) {
  return App.test(
    locale: locale,
    localizationsDelegates: localizationsDelegates,
    router: router,
    initialRoutes: initialRoutes,
    navigatorObserver: navigatorObserver,
    themeMode: themeMode,
  );
}

App _getAppTestWidget({
  required Widget widget,
  required Locale locale,
  required List<LocalizationsDelegate<dynamic>> localizationsDelegates,
  ThemeMode? themeMode,
}) {
  return App.testWidget(
    widget: widget,
    locale: locale,
    localizationsDelegates: localizationsDelegates,
    themeMode: themeMode,
  );
}

void main() {
  group('App', () {
    testWidgets('renders {{project_name.pascalCase()}}App correctly', (tester) async {
      // Arrange
      final router = FakeRouter();
      navigatorObserverBuilder() => <AutoRouterObserver>[];
      final app = _getApp(
        supportedLocales: const [Locale('en')],
        localizationsDelegates: [GlobalWidgetsLocalizations.delegate],
        router: router,
        navigatorObserverBuilder: navigatorObserverBuilder,
      );

      // Act
      await tester.pumpWidget(app);

      // Assert
      final {{project_name.camelCase()}}App = tester.widget<{{project_name.pascalCase()}}App>(
        find.byWidgetPredicate((widget) => widget is {{project_name.pascalCase()}}App),
      );
      expect(
        {{project_name.camelCase()}}App.localizationsDelegates,
        contains(GlobalWidgetsLocalizations.delegate),
      );
      expect({{project_name.camelCase()}}App.supportedLocales, const [Locale('en')]);
      expect(
        {{project_name.camelCase()}}App.routerConfig,
        isA<RouterConfig<UrlState>>()
            .having(
              (routerConfig) => routerConfig.routeInformationParser,
              'routeInformationParser',
              isA<DefaultRouteParser>(),
            )
            .having(
              (routerConfig) => routerConfig.routeInformationProvider,
              'routeInformationProvider',
              isA<AutoRouteInformationProvider>(),
            )
            .having(
              (routerConfig) => routerConfig.routerDelegate,
              'routerDelegate',
              isA<AutoRouterDelegate>()
                  .having(
                    (delegate) => delegate.navigatorObservers,
                    'navigatorObservers',
                    navigatorObserverBuilder,
                  )
                  .having(
                    (delegate) => delegate.controller,
                    'controller',
                    router,
                  ),
            ),
      );
    });
  });

  group('App.test', () {
    testWidgets('renders {{project_name.pascalCase()}}App correctly', (tester) async {
      // Arrange
      final router = FakeRouter();
      final navigatorObserver= MockAutoRouterObserver();
      final app = _getAppTest(
        locale: const Locale('fr'),
        localizationsDelegates: [GlobalWidgetsLocalizations.delegate],
        router: router,
        initialRoutes: const [FakePageRouteInfo()],
        navigatorObserver: navigatorObserver,
        themeMode: ThemeMode.dark,
      );

      // Act
      await tester.pumpWidget(app);

      // Assert
      final {{project_name.camelCase()}}App = tester.widget<{{project_name.pascalCase()}}App>(
        find.byWidgetPredicate((widget) => widget is {{project_name.pascalCase()}}App),
      );
      expect({{project_name.camelCase()}}App.locale, const Locale('fr'));
      expect({{project_name.camelCase()}}App.supportedLocales, const [Locale('fr')]);
      expect(
        {{project_name.camelCase()}}App.localizationsDelegates,
        contains(GlobalWidgetsLocalizations.delegate),
      );
      expect(
        {{project_name.camelCase()}}App.routerConfig,
        isA<RouterConfig<UrlState>>()
            .having(
              (routerConfig) => routerConfig.routeInformationParser,
              'routeInformationParser',
              isA<DefaultRouteParser>(),
            )
            .having(
              (routerConfig) => routerConfig.routeInformationProvider,
              'routeInformationProvider',
              isA<AutoRouteInformationProvider>(),
            )
            .having(
              (routerConfig) => routerConfig.routerDelegate,
              'routerDelegate',
              isA<AutoRouterDelegate>()
                  .having(
                    (delegate) => delegate.deepLinkBuilder,
                    'deepLinkBuilder',
                    isNotNull,
                  )
                  .having(
                    (delegate) => delegate.navigatorObservers(),
                    'navigatorObservers',
                    equals([navigatorObserver]),
                  )
                  .having(
                    (delegate) => delegate.controller,
                    'controller',
                    router,
                  ),
            ),
      );
      expect({{project_name.camelCase()}}App.themeMode, ThemeMode.dark);
    });
  });

  group('App.testWidget', () {
    testWidgets('renders {{project_name.pascalCase()}}App correctly', (tester) async {
      // Arrange
      final widget = Container();
      final app = _getAppTestWidget(
        widget: widget,
        locale: const Locale('fr'),
        localizationsDelegates: [GlobalWidgetsLocalizations.delegate],
        themeMode: ThemeMode.dark,
      );

      // Act
      await tester.pumpWidget(app);

      // Assert
      final {{project_name.camelCase()}}App = tester.widget<{{project_name.pascalCase()}}App>(
        find.byWidgetPredicate((widget) => widget is {{project_name.pascalCase()}}App),
      );
      expect({{project_name.camelCase()}}App.home, widget);
      expect({{project_name.camelCase()}}App.locale, const Locale('fr'));
      expect({{project_name.camelCase()}}App.supportedLocales, const [Locale('fr')]);
      expect(
        {{project_name.camelCase()}}App.localizationsDelegates,
        contains(GlobalWidgetsLocalizations.delegate),
      );
      expect({{project_name.camelCase()}}App.routerConfig, null);
      expect({{project_name.camelCase()}}App.themeMode, ThemeMode.dark);
    });
  });
}
{{/linux}}{{#macos}}import 'package:auto_route/auto_route.dart';
import 'package:{{project_name}}_macos_app/src/presentation/app.dart';
import 'package:{{project_name}}_ui_macos/{{project_name}}_ui_macos.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks.dart';

App _getApp({
  required List<Locale> supportedLocales,
  required List<LocalizationsDelegate<dynamic>> localizationsDelegates,
  required RootStackRouter router,
  List<AutoRouterObserver> Function()? navigatorObserverBuilder,
}) {
  return App(
    supportedLocales: supportedLocales,
    localizationsDelegates: localizationsDelegates,
    router: router,
    navigatorObserverBuilder: navigatorObserverBuilder,
  );
}

App _getAppTest({
  required Locale locale,
  required List<LocalizationsDelegate<dynamic>> localizationsDelegates,
  required RootStackRouter router,
  List<PageRouteInfo<dynamic>>? initialRoutes,
  AutoRouterObserver? navigatorObserver,
  ThemeMode? themeMode,
}) {
  return App.test(
    locale: locale,
    localizationsDelegates: localizationsDelegates,
    router: router,
    initialRoutes: initialRoutes,
    navigatorObserver: navigatorObserver,
    themeMode: themeMode,
  );
}

App _getAppTestWidget({
  required Widget widget,
  required Locale locale,
  required List<LocalizationsDelegate<dynamic>> localizationsDelegates,
  ThemeMode? themeMode,
}) {
  return App.testWidget(
    widget: widget,
    locale: locale,
    localizationsDelegates: localizationsDelegates,
    themeMode: themeMode,
  );
}

void main() {
  group('App', () {
    testWidgets('renders {{project_name.pascalCase()}}App correctly', (tester) async {
      // Arrange
      final router = FakeRouter();
      navigatorObserverBuilder() => <AutoRouterObserver>[];
      final app = _getApp(
        supportedLocales: const [Locale('en')],
        localizationsDelegates: [GlobalWidgetsLocalizations.delegate],
        router: router,
        navigatorObserverBuilder: navigatorObserverBuilder,
      );

      // Act
      await tester.pumpWidget(app);

      // Assert
      final {{project_name.camelCase()}}App = tester.widget<{{project_name.pascalCase()}}App>(
        find.byWidgetPredicate((widget) => widget is {{project_name.pascalCase()}}App),
      );
      expect(
        {{project_name.camelCase()}}App.localizationsDelegates,
        contains(GlobalWidgetsLocalizations.delegate),
      );
      expect({{project_name.camelCase()}}App.supportedLocales, const [Locale('en')]);
      expect(
        {{project_name.camelCase()}}App.routerConfig,
        isA<RouterConfig<UrlState>>()
            .having(
              (routerConfig) => routerConfig.routeInformationParser,
              'routeInformationParser',
              isA<DefaultRouteParser>(),
            )
            .having(
              (routerConfig) => routerConfig.routeInformationProvider,
              'routeInformationProvider',
              isA<AutoRouteInformationProvider>(),
            )
            .having(
              (routerConfig) => routerConfig.routerDelegate,
              'routerDelegate',
              isA<AutoRouterDelegate>()
                  .having(
                    (delegate) => delegate.navigatorObservers,
                    'navigatorObservers',
                    navigatorObserverBuilder,
                  )
                  .having(
                    (delegate) => delegate.controller,
                    'controller',
                    router,
                  ),
            ),
      );
    });
  });

  group('App.test', () {
    testWidgets('renders {{project_name.pascalCase()}}App correctly', (tester) async {
      // Arrange
      final router = FakeRouter();
      final navigatorObserver= MockAutoRouterObserver();
      final app = _getAppTest(
        locale: const Locale('fr'),
        localizationsDelegates: [GlobalWidgetsLocalizations.delegate],
        router: router,
        initialRoutes: const [FakePageRouteInfo()],
        navigatorObserver: navigatorObserver,
        themeMode: ThemeMode.dark,
      );

      // Act
      await tester.pumpWidget(app);

      // Assert
      final {{project_name.camelCase()}}App = tester.widget<{{project_name.pascalCase()}}App>(
        find.byWidgetPredicate((widget) => widget is {{project_name.pascalCase()}}App),
      );
      expect({{project_name.camelCase()}}App.locale, const Locale('fr'));
      expect({{project_name.camelCase()}}App.supportedLocales, const [Locale('fr')]);
      expect(
        {{project_name.camelCase()}}App.localizationsDelegates,
        contains(GlobalWidgetsLocalizations.delegate),
      );
      expect(
        {{project_name.camelCase()}}App.routerConfig,
        isA<RouterConfig<UrlState>>()
            .having(
              (routerConfig) => routerConfig.routeInformationParser,
              'routeInformationParser',
              isA<DefaultRouteParser>(),
            )
            .having(
              (routerConfig) => routerConfig.routeInformationProvider,
              'routeInformationProvider',
              isA<AutoRouteInformationProvider>(),
            )
            .having(
              (routerConfig) => routerConfig.routerDelegate,
              'routerDelegate',
              isA<AutoRouterDelegate>()
                  .having(
                    (delegate) => delegate.deepLinkBuilder,
                    'deepLinkBuilder',
                    isNotNull,
                  )
                  .having(
                    (delegate) => delegate.navigatorObservers(),
                    'navigatorObservers',
                    equals([navigatorObserver]),
                  )
                  .having(
                    (delegate) => delegate.controller,
                    'controller',
                    router,
                  ),
            ),
      );
      expect({{project_name.camelCase()}}App.themeMode, ThemeMode.dark);
    });
  });

  group('App.testWidget', () {
    testWidgets('renders {{project_name.pascalCase()}}App correctly', (tester) async {
      // Arrange
      final widget = Container();
      final app = _getAppTestWidget(
        widget: widget,
        locale: const Locale('fr'),
        localizationsDelegates: [GlobalWidgetsLocalizations.delegate],
        themeMode: ThemeMode.dark,
      );

      // Act
      await tester.pumpWidget(app);

      // Assert
      final {{project_name.camelCase()}}App = tester.widget<{{project_name.pascalCase()}}App>(
        find.byWidgetPredicate((widget) => widget is {{project_name.pascalCase()}}App),
      );
      expect({{project_name.camelCase()}}App.home, widget);
      expect({{project_name.camelCase()}}App.locale, const Locale('fr'));
      expect({{project_name.camelCase()}}App.supportedLocales, const [Locale('fr')]);
      expect(
        {{project_name.camelCase()}}App.localizationsDelegates,
        contains(GlobalWidgetsLocalizations.delegate),
      );
      expect({{project_name.camelCase()}}App.routerConfig, null);
      expect({{project_name.camelCase()}}App.themeMode, ThemeMode.dark);
    });
  });
}
{{/macos}}{{#web}}import 'package:auto_route/auto_route.dart';
import 'package:{{project_name}}_web_app/src/presentation/app.dart';
import 'package:{{project_name}}_ui_web/{{project_name}}_ui_web.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks.dart';

App _getApp({
  required List<Locale> supportedLocales,
  required List<LocalizationsDelegate<dynamic>> localizationsDelegates,
  required RootStackRouter router,
  List<AutoRouterObserver> Function()? navigatorObserverBuilder,
}) {
  return App(
    supportedLocales: supportedLocales,
    localizationsDelegates: localizationsDelegates,
    router: router,
    navigatorObserverBuilder: navigatorObserverBuilder,
  );
}

App _getAppTest({
  required Locale locale,
  required List<LocalizationsDelegate<dynamic>> localizationsDelegates,
  required RootStackRouter router,
  List<PageRouteInfo<dynamic>>? initialRoutes,
  AutoRouterObserver? navigatorObserver,
  ThemeMode? themeMode,
}) {
  return App.test(
    locale: locale,
    localizationsDelegates: localizationsDelegates,
    router: router,
    initialRoutes: initialRoutes,
    navigatorObserver: navigatorObserver,
    themeMode: themeMode,
  );
}

App _getAppTestWidget({
  required Widget widget,
  required Locale locale,
  required List<LocalizationsDelegate<dynamic>> localizationsDelegates,
  ThemeMode? themeMode,
}) {
  return App.testWidget(
    widget: widget,
    locale: locale,
    localizationsDelegates: localizationsDelegates,
    themeMode: themeMode,
  );
}

void main() {
  group('App', () {
    testWidgets('renders {{project_name.pascalCase()}}App correctly', (tester) async {
      // Arrange
      final router = FakeRouter();
      navigatorObserverBuilder() => <AutoRouterObserver>[];
      final app = _getApp(
        supportedLocales: const [Locale('en')],
        localizationsDelegates: [GlobalWidgetsLocalizations.delegate],
        router: router,
        navigatorObserverBuilder: navigatorObserverBuilder,
      );

      // Act
      await tester.pumpWidget(app);

      // Assert
      final {{project_name.camelCase()}}App = tester.widget<{{project_name.pascalCase()}}App>(
        find.byWidgetPredicate((widget) => widget is {{project_name.pascalCase()}}App),
      );
      expect(
        {{project_name.camelCase()}}App.localizationsDelegates,
        contains(GlobalWidgetsLocalizations.delegate),
      );
      expect({{project_name.camelCase()}}App.supportedLocales, const [Locale('en')]);
      expect(
        {{project_name.camelCase()}}App.routerConfig,
        isA<RouterConfig<UrlState>>()
            .having(
              (routerConfig) => routerConfig.routeInformationParser,
              'routeInformationParser',
              isA<DefaultRouteParser>(),
            )
            .having(
              (routerConfig) => routerConfig.routeInformationProvider,
              'routeInformationProvider',
              isA<AutoRouteInformationProvider>(),
            )
            .having(
              (routerConfig) => routerConfig.routerDelegate,
              'routerDelegate',
              isA<AutoRouterDelegate>()
                  .having(
                    (delegate) => delegate.navigatorObservers,
                    'navigatorObservers',
                    navigatorObserverBuilder,
                  )
                  .having(
                    (delegate) => delegate.controller,
                    'controller',
                    router,
                  ),
            ),
      );
    });
  });

  group('App.test', () {
    testWidgets('renders {{project_name.pascalCase()}}App correctly', (tester) async {
      // Arrange
      final router = FakeRouter();
      final navigatorObserver= MockAutoRouterObserver();
      final app = _getAppTest(
        locale: const Locale('fr'),
        localizationsDelegates: [GlobalWidgetsLocalizations.delegate],
        router: router,
        initialRoutes: const [FakePageRouteInfo()],
        navigatorObserver: navigatorObserver,
        themeMode: ThemeMode.dark,
      );

      // Act
      await tester.pumpWidget(app);

      // Assert
      final {{project_name.camelCase()}}App = tester.widget<{{project_name.pascalCase()}}App>(
        find.byWidgetPredicate((widget) => widget is {{project_name.pascalCase()}}App),
      );
      expect({{project_name.camelCase()}}App.locale, const Locale('fr'));
      expect({{project_name.camelCase()}}App.supportedLocales, const [Locale('fr')]);
      expect(
        {{project_name.camelCase()}}App.localizationsDelegates,
        contains(GlobalWidgetsLocalizations.delegate),
      );
      expect(
        {{project_name.camelCase()}}App.routerConfig,
        isA<RouterConfig<UrlState>>()
            .having(
              (routerConfig) => routerConfig.routeInformationParser,
              'routeInformationParser',
              isA<DefaultRouteParser>(),
            )
            .having(
              (routerConfig) => routerConfig.routeInformationProvider,
              'routeInformationProvider',
              isA<AutoRouteInformationProvider>(),
            )
            .having(
              (routerConfig) => routerConfig.routerDelegate,
              'routerDelegate',
              isA<AutoRouterDelegate>()
                  .having(
                    (delegate) => delegate.deepLinkBuilder,
                    'deepLinkBuilder',
                    isNotNull,
                  )
                  .having(
                    (delegate) => delegate.navigatorObservers(),
                    'navigatorObservers',
                    equals([navigatorObserver]),
                  )
                  .having(
                    (delegate) => delegate.controller,
                    'controller',
                    router,
                  ),
            ),
      );
      expect({{project_name.camelCase()}}App.themeMode, ThemeMode.dark);
    });
  });

  group('App.testWidget', () {
    testWidgets('renders {{project_name.pascalCase()}}App correctly', (tester) async {
      // Arrange
      final widget = Container();
      final app = _getAppTestWidget(
        widget: widget,
        locale: const Locale('fr'),
        localizationsDelegates: [GlobalWidgetsLocalizations.delegate],
        themeMode: ThemeMode.dark,
      );

      // Act
      await tester.pumpWidget(app);

      // Assert
      final {{project_name.camelCase()}}App = tester.widget<{{project_name.pascalCase()}}App>(
        find.byWidgetPredicate((widget) => widget is {{project_name.pascalCase()}}App),
      );
      expect({{project_name.camelCase()}}App.home, widget);
      expect({{project_name.camelCase()}}App.locale, const Locale('fr'));
      expect({{project_name.camelCase()}}App.supportedLocales, const [Locale('fr')]);
      expect(
        {{project_name.camelCase()}}App.localizationsDelegates,
        contains(GlobalWidgetsLocalizations.delegate),
      );
      expect({{project_name.camelCase()}}App.routerConfig, null);
      expect({{project_name.camelCase()}}App.themeMode, ThemeMode.dark);
    });
  });
}
{{/web}}{{#windows}}import 'package:auto_route/auto_route.dart';
import 'package:{{project_name}}_windows_app/src/presentation/app.dart';
import 'package:{{project_name}}_ui_windows/{{project_name}}_ui_windows.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks.dart';

App _getApp({
  required List<Locale> supportedLocales,
  required List<LocalizationsDelegate<dynamic>> localizationsDelegates,
  required RootStackRouter router,
  List<AutoRouterObserver> Function()? navigatorObserverBuilder,
}) {
  return App(
    supportedLocales: supportedLocales,
    localizationsDelegates: localizationsDelegates,
    router: router,
    navigatorObserverBuilder: navigatorObserverBuilder,
  );
}

App _getAppTest({
  required Locale locale,
  required List<LocalizationsDelegate<dynamic>> localizationsDelegates,
  required RootStackRouter router,
  List<PageRouteInfo<dynamic>>? initialRoutes,
  AutoRouterObserver? navigatorObserver,
  ThemeMode? themeMode,
}) {
  return App.test(
    locale: locale,
    localizationsDelegates: localizationsDelegates,
    router: router,
    initialRoutes: initialRoutes,
    navigatorObserver: navigatorObserver,
    themeMode: themeMode,
  );
}

App _getAppTestWidget({
  required Widget widget,
  required Locale locale,
  required List<LocalizationsDelegate<dynamic>> localizationsDelegates,
  ThemeMode? themeMode,
}) {
  return App.testWidget(
    widget: widget,
    locale: locale,
    localizationsDelegates: localizationsDelegates,
    themeMode: themeMode,
  );
}

void main() {
  group('App', () {
    testWidgets('renders {{project_name.pascalCase()}}App correctly', (tester) async {
      // Arrange
      final router = FakeRouter();
      navigatorObserverBuilder() => <AutoRouterObserver>[];
      final app = _getApp(
        supportedLocales: const [Locale('en')],
        localizationsDelegates: [GlobalWidgetsLocalizations.delegate],
        router: router,
        navigatorObserverBuilder: navigatorObserverBuilder,
      );

      // Act
      await tester.pumpWidget(app);

      // Assert
      final {{project_name.camelCase()}}App = tester.widget<{{project_name.pascalCase()}}App>(
        find.byWidgetPredicate((widget) => widget is {{project_name.pascalCase()}}App),
      );
      expect(
        {{project_name.camelCase()}}App.localizationsDelegates,
        contains(GlobalWidgetsLocalizations.delegate),
      );
      expect({{project_name.camelCase()}}App.supportedLocales, const [Locale('en')]);
      expect(
        {{project_name.camelCase()}}App.routerConfig,
        isA<RouterConfig<UrlState>>()
            .having(
              (routerConfig) => routerConfig.routeInformationParser,
              'routeInformationParser',
              isA<DefaultRouteParser>(),
            )
            .having(
              (routerConfig) => routerConfig.routeInformationProvider,
              'routeInformationProvider',
              isA<AutoRouteInformationProvider>(),
            )
            .having(
              (routerConfig) => routerConfig.routerDelegate,
              'routerDelegate',
              isA<AutoRouterDelegate>()
                  .having(
                    (delegate) => delegate.navigatorObservers,
                    'navigatorObservers',
                    navigatorObserverBuilder,
                  )
                  .having(
                    (delegate) => delegate.controller,
                    'controller',
                    router,
                  ),
            ),
      );
    });
  });

  group('App.test', () {
    testWidgets('renders {{project_name.pascalCase()}}App correctly', (tester) async {
      // Arrange
      final router = FakeRouter();
      final navigatorObserver= MockAutoRouterObserver();
      final app = _getAppTest(
        locale: const Locale('fr'),
        localizationsDelegates: [GlobalWidgetsLocalizations.delegate],
        router: router,
        initialRoutes: const [FakePageRouteInfo()],
        navigatorObserver: navigatorObserver,
        themeMode: ThemeMode.dark,
      );

      // Act
      await tester.pumpWidget(app);

      // Assert
      final {{project_name.camelCase()}}App = tester.widget<{{project_name.pascalCase()}}App>(
        find.byWidgetPredicate((widget) => widget is {{project_name.pascalCase()}}App),
      );
      expect({{project_name.camelCase()}}App.locale, const Locale('fr'));
      expect({{project_name.camelCase()}}App.supportedLocales, const [Locale('fr')]);
      expect(
        {{project_name.camelCase()}}App.localizationsDelegates,
        contains(GlobalWidgetsLocalizations.delegate),
      );
      expect(
        {{project_name.camelCase()}}App.routerConfig,
        isA<RouterConfig<UrlState>>()
            .having(
              (routerConfig) => routerConfig.routeInformationParser,
              'routeInformationParser',
              isA<DefaultRouteParser>(),
            )
            .having(
              (routerConfig) => routerConfig.routeInformationProvider,
              'routeInformationProvider',
              isA<AutoRouteInformationProvider>(),
            )
            .having(
              (routerConfig) => routerConfig.routerDelegate,
              'routerDelegate',
              isA<AutoRouterDelegate>()
                  .having(
                    (delegate) => delegate.deepLinkBuilder,
                    'deepLinkBuilder',
                    isNotNull,
                  )
                  .having(
                    (delegate) => delegate.navigatorObservers(),
                    'navigatorObservers',
                    equals([navigatorObserver]),
                  )
                  .having(
                    (delegate) => delegate.controller,
                    'controller',
                    router,
                  ),
            ),
      );
      expect({{project_name.camelCase()}}App.themeMode, ThemeMode.dark);
    });
  });

  group('App.testWidget', () {
    testWidgets('renders {{project_name.pascalCase()}}App correctly', (tester) async {
      // Arrange
      final widget = Container();
      final app = _getAppTestWidget(
        widget: widget,
        locale: const Locale('fr'),
        localizationsDelegates: [GlobalWidgetsLocalizations.delegate],
        themeMode: ThemeMode.dark,
      );

      // Act
      await tester.pumpWidget(app);

      // Assert
      final {{project_name.camelCase()}}App = tester.widget<{{project_name.pascalCase()}}App>(
        find.byWidgetPredicate((widget) => widget is {{project_name.pascalCase()}}App),
      );
      expect({{project_name.camelCase()}}App.home, widget);
      expect({{project_name.camelCase()}}App.locale, const Locale('fr'));
      expect({{project_name.camelCase()}}App.supportedLocales, const [Locale('fr')]);
      expect(
        {{project_name.camelCase()}}App.localizationsDelegates,
        contains(GlobalWidgetsLocalizations.delegate),
      );
      expect({{project_name.camelCase()}}App.routerConfig, null);
      expect({{project_name.camelCase()}}App.themeMode, ThemeMode.dark);
    });
  });
}
{{/windows}}{{#mobile}}import 'package:auto_route/auto_route.dart';
import 'package:{{project_name}}_mobile_app/src/presentation/app.dart';
import 'package:{{project_name}}_ui_mobile/{{project_name}}_ui_mobile.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks.dart';

App _getApp({
  required List<Locale> supportedLocales,
  required List<LocalizationsDelegate<dynamic>> localizationsDelegates,
  required RootStackRouter router,
  List<AutoRouterObserver> Function()? navigatorObserverBuilder,
}) {
  return App(
    supportedLocales: supportedLocales,
    localizationsDelegates: localizationsDelegates,
    router: router,
    navigatorObserverBuilder: navigatorObserverBuilder,
  );
}

App _getAppTest({
  required Locale locale,
  required List<LocalizationsDelegate<dynamic>> localizationsDelegates,
  required RootStackRouter router,
  List<PageRouteInfo<dynamic>>? initialRoutes,
  AutoRouterObserver? navigatorObserver,
  ThemeMode? themeMode,
}) {
  return App.test(
    locale: locale,
    localizationsDelegates: localizationsDelegates,
    router: router,
    initialRoutes: initialRoutes,
    navigatorObserver: navigatorObserver,
    themeMode: themeMode,
  );
}

App _getAppTestWidget({
  required Widget widget,
  required Locale locale,
  required List<LocalizationsDelegate<dynamic>> localizationsDelegates,
  ThemeMode? themeMode,
}) {
  return App.testWidget(
    widget: widget,
    locale: locale,
    localizationsDelegates: localizationsDelegates,
    themeMode: themeMode,
  );
}

void main() {
  group('App', () {
    testWidgets('renders {{project_name.pascalCase()}}App correctly', (tester) async {
      // Arrange
      final router = FakeRouter();
      navigatorObserverBuilder() => <AutoRouterObserver>[];
      final app = _getApp(
        supportedLocales: const [Locale('en')],
        localizationsDelegates: [GlobalWidgetsLocalizations.delegate],
        router: router,
        navigatorObserverBuilder: navigatorObserverBuilder,
      );

      // Act
      await tester.pumpWidget(app);

      // Assert
      final {{project_name.camelCase()}}App = tester.widget<{{project_name.pascalCase()}}App>(
        find.byWidgetPredicate((widget) => widget is {{project_name.pascalCase()}}App),
      );
      expect(
        {{project_name.camelCase()}}App.localizationsDelegates,
        contains(GlobalWidgetsLocalizations.delegate),
      );
      expect({{project_name.camelCase()}}App.supportedLocales, const [Locale('en')]);
      expect(
        {{project_name.camelCase()}}App.routerConfig,
        isA<RouterConfig<UrlState>>()
            .having(
              (routerConfig) => routerConfig.routeInformationParser,
              'routeInformationParser',
              isA<DefaultRouteParser>(),
            )
            .having(
              (routerConfig) => routerConfig.routeInformationProvider,
              'routeInformationProvider',
              isA<AutoRouteInformationProvider>(),
            )
            .having(
              (routerConfig) => routerConfig.routerDelegate,
              'routerDelegate',
              isA<AutoRouterDelegate>()
                  .having(
                    (delegate) => delegate.navigatorObservers,
                    'navigatorObservers',
                    navigatorObserverBuilder,
                  )
                  .having(
                    (delegate) => delegate.controller,
                    'controller',
                    router,
                  ),
            ),
      );
    });
  });

  group('App.test', () {
    testWidgets('renders {{project_name.pascalCase()}}App correctly', (tester) async {
      // Arrange
      final router = FakeRouter();
      final navigatorObserver= MockAutoRouterObserver();
      final app = _getAppTest(
        locale: const Locale('fr'),
        localizationsDelegates: [GlobalWidgetsLocalizations.delegate],
        router: router,
        initialRoutes: const [FakePageRouteInfo()],
        navigatorObserver: navigatorObserver,
        themeMode: ThemeMode.dark,
      );

      // Act
      await tester.pumpWidget(app);

      // Assert
      final {{project_name.camelCase()}}App = tester.widget<{{project_name.pascalCase()}}App>(
        find.byWidgetPredicate((widget) => widget is {{project_name.pascalCase()}}App),
      );
      expect({{project_name.camelCase()}}App.locale, const Locale('fr'));
      expect({{project_name.camelCase()}}App.supportedLocales, const [Locale('fr')]);
      expect(
        {{project_name.camelCase()}}App.localizationsDelegates,
        contains(GlobalWidgetsLocalizations.delegate),
      );
      expect(
        {{project_name.camelCase()}}App.routerConfig,
        isA<RouterConfig<UrlState>>()
            .having(
              (routerConfig) => routerConfig.routeInformationParser,
              'routeInformationParser',
              isA<DefaultRouteParser>(),
            )
            .having(
              (routerConfig) => routerConfig.routeInformationProvider,
              'routeInformationProvider',
              isA<AutoRouteInformationProvider>(),
            )
            .having(
              (routerConfig) => routerConfig.routerDelegate,
              'routerDelegate',
              isA<AutoRouterDelegate>()
                 .having(
                    (delegate) => delegate.deepLinkBuilder,
                    'deepLinkBuilder',
                    isNotNull,
                  )
                  .having(
                    (delegate) => delegate.navigatorObservers(),
                    'navigatorObservers',
                    equals([navigatorObserver]),
                  )
                  .having(
                    (delegate) => delegate.controller,
                    'controller',
                    router,
                  ),
            ),
      );
      expect({{project_name.camelCase()}}App.themeMode, ThemeMode.dark);
    });
  });

  group('App.testWidget', () {
    testWidgets('renders {{project_name.pascalCase()}}App correctly', (tester) async {
      // Arrange
      final widget = Container();
      final app = _getAppTestWidget(
        widget: widget,
        locale: const Locale('fr'),
        localizationsDelegates: [GlobalWidgetsLocalizations.delegate],
        themeMode: ThemeMode.dark,
      );

      // Act
      await tester.pumpWidget(app);

      // Assert
      final {{project_name.camelCase()}}App = tester.widget<{{project_name.pascalCase()}}App>(
        find.byWidgetPredicate((widget) => widget is {{project_name.pascalCase()}}App),
      );
      expect({{project_name.camelCase()}}App.home, widget);
      expect({{project_name.camelCase()}}App.locale, const Locale('fr'));
      expect({{project_name.camelCase()}}App.supportedLocales, const [Locale('fr')]);
      expect(
        {{project_name.camelCase()}}App.localizationsDelegates,
        contains(GlobalWidgetsLocalizations.delegate),
      );
      expect({{project_name.camelCase()}}App.routerConfig, null);
      expect({{project_name.camelCase()}}App.themeMode, ThemeMode.dark);
    });
  });
}
{{/mobile}}