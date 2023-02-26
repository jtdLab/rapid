import 'package:project_web_web_app/src/presentation/app.dart';
import 'package:project_web_web_app/src/presentation/l10n/l10n.dart';
import 'package:project_web_web_app/src/presentation/localizations_delegates.dart';
import 'package:project_web_web_routing/project_web_web_routing.dart';
import 'package:project_web_ui_web/project_web_ui_web.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mocks.dart';

App _getApp({
  List<AutoRouterObserver> Function()? routerObserverBuilder,
}) {
  return App(
    routerObserverBuilder: routerObserverBuilder,
  );
}

App _getAppTest({
  Locale? locale,
  required Router router,
  List<PageRouteInfo<dynamic>>? initialRoutes,
  AutoRouterObserver? routerObserver,
  ThemeMode? themeMode,
}) {
  return App.test(
    locale: locale,
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
      routerObserverBuilder() => <AutoRouterObserver>[];
      final app = _getApp(routerObserverBuilder: routerObserverBuilder);

      // Act
      await tester.pumpWidget(app);

      // Assert
      final projectWebApp = tester.widget<ProjectWebApp>(
        find.byWidgetPredicate((widget) => widget is ProjectWebApp),
      );
      expect(
        projectWebApp.localizationsDelegates,
        containsAll(localizationsDelegates),
      );
      expect(
        projectWebApp.supportedLocales,
        ProjectWebWebAppLocalizations.supportedLocales,
      );
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
              isA<Router>(),
            ),
      );
    });
  });

  group('App.test', () {
    testWidgets('renders App correctly', (tester) async {
      // Arrange
      final router = Router();
      final initialRoutes = [const HomePageRoute()];
      final routerObserver = MockAutoRouterObserver();
      final app = _getAppTest(
        locale: const Locale('en'),
        router: router,
        initialRoutes: initialRoutes,
        routerObserver: routerObserver,
        themeMode: ThemeMode.dark,
      );

      // Act
      await tester.pumpWidget(app);

      // Assert
      final projectWebApp = tester.widget<ProjectWebApp>(
        find.byWidgetPredicate((widget) => widget is ProjectWebApp),
      );
      expect(projectWebApp.locale, const Locale('en'));
      expect(
        projectWebApp.supportedLocales,
        ProjectWebWebAppLocalizations.supportedLocales,
      );
      expect(
        projectWebApp.localizationsDelegates,
        containsAll(localizationsDelegates),
      );
      expect(projectWebApp.routeInformationParser, isA<DefaultRouteParser>());
      expect(
        projectWebApp.routerDelegate,
        isA<AutoRouterDelegate>()
            .having(
              (delegate) => delegate.initialRoutes,
              'initialRoutes',
              equals(initialRoutes),
            )
            .having(
              (delegate) => delegate.navigatorObservers(),
              'navigatorObservers',
              equals([routerObserver]),
            )
            .having(
              (delegate) => delegate.controller,
              'controller',
              isA<Router>(),
            ),
      );
      expect(projectWebApp.themeMode, ThemeMode.dark);
    });
  });
}
