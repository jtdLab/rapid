import 'package:project_windows_windows_app/src/presentation/app.dart';
import 'package:project_windows_windows_app/src/presentation/l10n/l10n.dart';
import 'package:project_windows_windows_app/src/presentation/localizations_delegates.dart';
import 'package:project_windows_windows_routing/project_windows_windows_routing.dart';
import 'package:project_windows_ui_windows/project_windows_ui_windows.dart';
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
    testWidgets('renders ProjectWindowsApp correctly', (tester) async {
      // Arrange
      routerObserverBuilder() => <AutoRouterObserver>[];
      final app = _getApp(routerObserverBuilder: routerObserverBuilder);

      // Act
      await tester.pumpWidget(app);

      // Assert
      final projectWindowsApp = tester.widget<ProjectWindowsApp>(
        find.byWidgetPredicate((widget) => widget is ProjectWindowsApp),
      );
      expect(
        projectWindowsApp.localizationsDelegates,
        containsAll(localizationsDelegates),
      );
      expect(
        projectWindowsApp.supportedLocales,
        ProjectWindowsWindowsAppLocalizations.supportedLocales,
      );
      expect(
          projectWindowsApp.routeInformationParser, isA<DefaultRouteParser>());
      expect(
        projectWindowsApp.routerDelegate,
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
      final projectWindowsApp = tester.widget<ProjectWindowsApp>(
        find.byWidgetPredicate((widget) => widget is ProjectWindowsApp),
      );
      expect(projectWindowsApp.locale, const Locale('en'));
      expect(
        projectWindowsApp.supportedLocales,
        ProjectWindowsWindowsAppLocalizations.supportedLocales,
      );
      expect(
        projectWindowsApp.localizationsDelegates,
        containsAll(localizationsDelegates),
      );
      expect(
          projectWindowsApp.routeInformationParser, isA<DefaultRouteParser>());
      expect(
        projectWindowsApp.routerDelegate,
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
      expect(projectWindowsApp.themeMode, ThemeMode.dark);
    });
  });
}
