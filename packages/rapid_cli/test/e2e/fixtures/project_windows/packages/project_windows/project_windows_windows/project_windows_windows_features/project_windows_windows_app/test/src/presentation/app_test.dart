import 'package:auto_route/auto_route.dart';
import 'package:project_windows_windows_app/src/presentation/app.dart';
import 'package:project_windows_ui_windows/project_windows_ui_windows.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mocks.dart';

App _getApp({
  required List<Locale> supportedLocales,
  required List<LocalizationsDelegate<dynamic>> localizationsDelegates,
  required RootStackRouter router,
  List<AutoRouterObserver> Function()? routerObserverBuilder,
}) {
  return App(
    supportedLocales: supportedLocales,
    localizationsDelegates: localizationsDelegates,
    router: router,
    routerObserverBuilder: routerObserverBuilder,
  );
}

App _getAppTest({
  required Locale locale,
  required LocalizationsDelegate<dynamic> localizationsDelegate,
  required RootStackRouter router,
  List<PageRouteInfo<dynamic>>? initialRoutes,
  AutoRouterObserver? routerObserver,
  ThemeMode? themeMode,
}) {
  return App.test(
    locale: locale,
    localizationsDelegate: localizationsDelegate,
    router: router,
    initialRoutes: initialRoutes,
    routerObserver: routerObserver,
    themeMode: themeMode,
  );
}

App _getAppTestWidget({
  required Widget widget,
  required Locale locale,
  required LocalizationsDelegate<dynamic> localizationsDelegate,
  ThemeMode? themeMode,
}) {
  return App.testWidget(
    widget: widget,
    locale: locale,
    localizationsDelegate: localizationsDelegate,
    themeMode: themeMode,
  );
}

void main() {
  group('App', () {
    testWidgets('renders ProjectWindowsApp correctly', (tester) async {
      // Arrange
      final router = FakeRouter();
      routerObserverBuilder() => <AutoRouterObserver>[];
      final app = _getApp(
        supportedLocales: const [Locale('en')],
        localizationsDelegates: [GlobalWidgetsLocalizations.delegate],
        router: router,
        routerObserverBuilder: routerObserverBuilder,
      );

      // Act
      await tester.pumpWidget(app);

      // Assert
      final projectWindowsApp = tester.widget<ProjectWindowsApp>(
        find.byWidgetPredicate((widget) => widget is ProjectWindowsApp),
      );
      expect(
        projectWindowsApp.localizationsDelegates,
        contains(GlobalWidgetsLocalizations.delegate),
      );
      expect(projectWindowsApp.supportedLocales, const [Locale('en')]);
      expect(
        projectWindowsApp.routerConfig,
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
                    routerObserverBuilder,
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
    testWidgets('renders ProjectWindowsApp correctly', (tester) async {
      // Arrange
      final router = FakeRouter();
      final routerObserver = MockAutoRouterObserver();
      final app = _getAppTest(
        locale: const Locale('fr'),
        localizationsDelegate: GlobalWidgetsLocalizations.delegate,
        router: router,
        initialRoutes: const [FakePageRouteInfo()],
        routerObserver: routerObserver,
        themeMode: ThemeMode.dark,
      );

      // Act
      await tester.pumpWidget(app);

      // Assert
      final projectWindowsApp = tester.widget<ProjectWindowsApp>(
        find.byWidgetPredicate((widget) => widget is ProjectWindowsApp),
      );
      expect(projectWindowsApp.locale, const Locale('fr'));
      expect(projectWindowsApp.supportedLocales, const [Locale('fr')]);
      expect(
        projectWindowsApp.localizationsDelegates,
        contains(GlobalWidgetsLocalizations.delegate),
      );
      expect(
        projectWindowsApp.routerConfig,
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
                    (delegate) => delegate.initialRoutes,
                    'initialRoutes',
                    equals(const [FakePageRouteInfo()]),
                  )
                  .having(
                    (delegate) => delegate.navigatorObservers(),
                    'navigatorObservers',
                    equals([routerObserver]),
                  )
                  .having(
                    (delegate) => delegate.controller,
                    'controller',
                    router,
                  ),
            ),
      );
      expect(projectWindowsApp.themeMode, ThemeMode.dark);
    });
  });

  group('App.testWidget', () {
    testWidgets('renders ProjectWindowsApp correctly', (tester) async {
      // Arrange
      final widget = Container();
      final app = _getAppTestWidget(
        widget: widget,
        locale: const Locale('fr'),
        localizationsDelegate: GlobalWidgetsLocalizations.delegate,
        themeMode: ThemeMode.dark,
      );

      // Act
      await tester.pumpWidget(app);

      // Assert
      final projectWindowsApp = tester.widget<ProjectWindowsApp>(
        find.byWidgetPredicate((widget) => widget is ProjectWindowsApp),
      );
      expect(projectWindowsApp.home, widget);
      expect(projectWindowsApp.locale, const Locale('fr'));
      expect(projectWindowsApp.supportedLocales, const [Locale('fr')]);
      expect(
        projectWindowsApp.localizationsDelegates,
        contains(GlobalWidgetsLocalizations.delegate),
      );
      expect(projectWindowsApp.routerConfig, null);
      expect(projectWindowsApp.themeMode, ThemeMode.dark);
    });
  });
}
