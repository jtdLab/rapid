import 'package:project_macos_macos_app/src/presentation/app.dart';
import 'package:project_macos_macos_app/src/presentation/l10n/l10n.dart';
import 'package:project_macos_macos_app/src/presentation/localizations_delegates.dart';
import 'package:project_macos_macos_routing/project_macos_macos_routing.dart';
import 'package:project_macos_ui_macos/project_macos_ui_macos.dart';
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
  Brightness? brightness,
}) {
  return App.test(
    locale: locale,
    router: router,
    initialRoutes: initialRoutes,
    routerObserver: routerObserver,
    brightness: brightness,
  );
}

void main() {
  group('App', () {
    testWidgets('renders ProjectMacosApp correctly', (tester) async {
      // Arrange
      routerObserverBuilder() => <AutoRouterObserver>[];
      final app = _getApp(routerObserverBuilder: routerObserverBuilder);

      // Act
      await tester.pumpWidget(app);

      // Assert
      final projectMacosApp = tester.widget<ProjectMacosApp>(
        find.byWidgetPredicate((widget) => widget is ProjectMacosApp),
      );
      expect(
        projectMacosApp.localizationsDelegates,
        containsAll(localizationsDelegates),
      );
      expect(
        projectMacosApp.supportedLocales,
        ProjectMacosMacosAppLocalizations.supportedLocales,
      );
      expect(projectMacosApp.routeInformationParser, isA<DefaultRouteParser>());
      expect(
        projectMacosApp.routerDelegate,
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
        brightness: Brightness.light,
      );

      // Act
      await tester.pumpWidget(app);

      // Assert
      final projectMacosApp = tester.widget<ProjectMacosApp>(
        find.byWidgetPredicate((widget) => widget is ProjectMacosApp),
      );
      expect(projectMacosApp.locale, const Locale('en'));
      expect(
        projectMacosApp.supportedLocales,
        ProjectMacosMacosAppLocalizations.supportedLocales,
      );
      expect(
        projectMacosApp.localizationsDelegates,
        containsAll(localizationsDelegates),
      );
      expect(projectMacosApp.routeInformationParser, isA<DefaultRouteParser>());
      expect(
        projectMacosApp.routerDelegate,
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
      expect(projectMacosApp.brightness, Brightness.light);
    });
  });
}
