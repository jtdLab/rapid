import 'package:auto_route/auto_route.dart';
import 'package:project_web_web_app/src/presentation/app.dart';
import 'package:project_web_ui_web/project_web_ui_web.dart';
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

void main() {
  group('App', () {
    testWidgets('renders ProjectWebApp correctly', (tester) async {
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
      final projectWebApp = tester.widget<ProjectWebApp>(
        find.byWidgetPredicate((widget) => widget is ProjectWebApp),
      );
      expect(
        projectWebApp.localizationsDelegates,
        contains(GlobalWidgetsLocalizations.delegate),
      );
      expect(projectWebApp.supportedLocales, const [Locale('en')]);
      expect(projectWebApp.routeInformationParser, isA<DefaultRouteParser>());
      expect(
        projectWebApp.routerDelegate,
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
      );
    });
  });

  group('App.test', () {
    testWidgets('renders ProjectWebApp correctly', (tester) async {
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
      final projectWebApp = tester.widget<ProjectWebApp>(
        find.byWidgetPredicate((widget) => widget is ProjectWebApp),
      );
      expect(projectWebApp.locale, const Locale('fr'));
      expect(projectWebApp.supportedLocales, const [Locale('fr')]);
      expect(
        projectWebApp.localizationsDelegates,
        contains(GlobalWidgetsLocalizations.delegate),
      );
      expect(projectWebApp.routeInformationParser, isA<DefaultRouteParser>());
      expect(
        projectWebApp.routerDelegate,
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
      );
      expect(projectWebApp.themeMode, ThemeMode.dark);
    });
  });
}
