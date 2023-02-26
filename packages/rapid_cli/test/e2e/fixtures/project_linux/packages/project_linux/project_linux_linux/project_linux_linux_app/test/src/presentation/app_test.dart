import 'package:project_linux_linux_app/src/presentation/app.dart';
import 'package:project_linux_linux_app/src/presentation/l10n/l10n.dart';
import 'package:project_linux_linux_app/src/presentation/localizations_delegates.dart';
import 'package:project_linux_linux_routing/project_linux_linux_routing.dart';
import 'package:project_linux_ui_linux/project_linux_ui_linux.dart';
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
    testWidgets('renders ProjectLinuxApp correctly', (tester) async {
      // Arrange
      routerObserverBuilder() => <AutoRouterObserver>[];
      final app = _getApp(routerObserverBuilder: routerObserverBuilder);

      // Act
      await tester.pumpWidget(app);

      // Assert
      final projectLinuxApp = tester.widget<ProjectLinuxApp>(
        find.byWidgetPredicate((widget) => widget is ProjectLinuxApp),
      );
      expect(
        projectLinuxApp.localizationsDelegates,
        containsAll(localizationsDelegates),
      );
      expect(
        projectLinuxApp.supportedLocales,
        ProjectLinuxLinuxAppLocalizations.supportedLocales,
      );
      expect(projectLinuxApp.routeInformationParser, isA<DefaultRouteParser>());
      expect(
        projectLinuxApp.routerDelegate,
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
      final projectLinuxApp = tester.widget<ProjectLinuxApp>(
        find.byWidgetPredicate((widget) => widget is ProjectLinuxApp),
      );
      expect(projectLinuxApp.locale, const Locale('en'));
      expect(
        projectLinuxApp.supportedLocales,
        ProjectLinuxLinuxAppLocalizations.supportedLocales,
      );
      expect(
        projectLinuxApp.localizationsDelegates,
        containsAll(localizationsDelegates),
      );
      expect(projectLinuxApp.routeInformationParser, isA<DefaultRouteParser>());
      expect(
        projectLinuxApp.routerDelegate,
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
      expect(projectLinuxApp.themeMode, ThemeMode.dark);
    });
  });
}
