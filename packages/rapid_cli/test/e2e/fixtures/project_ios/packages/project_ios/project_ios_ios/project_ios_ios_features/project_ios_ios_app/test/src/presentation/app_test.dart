import 'package:auto_route/auto_route.dart';
import 'package:project_ios_ios_app/src/presentation/app.dart';
import 'package:project_ios_ui_ios/project_ios_ui_ios.dart';
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
  Brightness? brightness,
}) {
  return App.test(
    locale: locale,
    localizationsDelegate: localizationsDelegate,
    router: router,
    initialRoutes: initialRoutes,
    routerObserver: routerObserver,
    brightness: brightness,
  );
}

void main() {
  group('App', () {
    testWidgets('renders ProjectIosApp correctly', (tester) async {
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
      final projectIosApp = tester.widget<ProjectIosApp>(
        find.byWidgetPredicate((widget) => widget is ProjectIosApp),
      );
      expect(
        projectIosApp.localizationsDelegates,
        contains(GlobalWidgetsLocalizations.delegate),
      );
      expect(projectIosApp.supportedLocales, const [Locale('en')]);
      expect(projectIosApp.routeInformationParser, isA<DefaultRouteParser>());
      expect(
        projectIosApp.routerDelegate,
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
    testWidgets('renders ProjectIosApp correctly', (tester) async {
      // Arrange
      final router = FakeRouter();
      final routerObserver = MockAutoRouterObserver();
      final app = _getAppTest(
        locale: const Locale('fr'),
        localizationsDelegate: GlobalWidgetsLocalizations.delegate,
        router: router,
        initialRoutes: const [FakePageRouteInfo()],
        routerObserver: routerObserver,
        brightness: Brightness.dark,
      );

      // Act
      await tester.pumpWidget(app);

      // Assert
      final projectIosApp = tester.widget<ProjectIosApp>(
        find.byWidgetPredicate((widget) => widget is ProjectIosApp),
      );
      expect(projectIosApp.locale, const Locale('fr'));
      expect(projectIosApp.supportedLocales, const [Locale('fr')]);
      expect(
        projectIosApp.localizationsDelegates,
        contains(GlobalWidgetsLocalizations.delegate),
      );
      expect(projectIosApp.routeInformationParser, isA<DefaultRouteParser>());
      expect(
        projectIosApp.routerDelegate,
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
      expect(projectIosApp.brightness, Brightness.dark);
    });
  });
}
