import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_ios/router_observer.dart';
import 'package:project_ios_logging/project_ios_logging.dart';
import 'package:mocktail/mocktail.dart';

class _MockProjectIosLogger extends Mock implements ProjectIosLogger {}

class _MockRoute extends Mock implements Route {}

class _MockTabPageRoute extends Mock implements TabPageRoute {}

class _MockRouteSettings extends Mock implements RouteSettings {}

void main() {
  group('ProjectIosRouterObserver', () {
    late ProjectIosLogger logger;
    late ProjectIosRouterObserver underTest;

    setUp(() {
      logger = _MockProjectIosLogger();
      when(() => logger.debug(any())).thenReturn(null);
      underTest = ProjectIosRouterObserver(logger);
    });

    Route makeRoute([String name = 'TestRoute']) {
      final settings = _MockRouteSettings();
      when(() => settings.name).thenReturn(name);
      final route = _MockRoute();
      when(() => route.settings).thenReturn(settings);
      return route;
    }

    _MockTabPageRoute makeTabPageRoute([String name = 'TestTabRoute']) {
      final tabRoute = _MockTabPageRoute();
      when(() => tabRoute.name).thenReturn(name);
      return tabRoute;
    }

    group('.', () {
      test('assigns all params correctly', () {
        // Assert
        expect(underTest.logger, logger);
      });
    });

    group('didPush', () {
      late String routeName;
      late Route route;
      late Route? previousRoute;

      setUp(() {
        routeName = 'MyRoute';
        route = makeRoute(routeName);
        previousRoute = null;
      });

      test('logs debug message', () {
        // Act
        underTest.didPush(route, previousRoute);

        // Assert
        verify(() => logger.debug('New route pushed: $routeName'));
      });
    });

    group('didPop', () {
      late String routeName;
      late Route route;
      late Route? previousRoute;

      setUp(() {
        routeName = 'MyRoute';
        route = makeRoute(routeName);
        previousRoute = null;
      });

      test('logs debug message', () {
        // Act
        underTest.didPop(route, previousRoute);

        // Assert
        verify(() => logger.debug('Route popped: $routeName'));
      });
    });

    group('didRemove', () {
      late String routeName;
      late Route route;
      late Route? previousRoute;

      setUp(() {
        routeName = 'MyRoute';
        route = makeRoute(routeName);
        previousRoute = null;
      });

      test('logs debug message', () {
        // Act
        underTest.didRemove(route, previousRoute);

        // Assert
        verify(() => logger.debug('Route removed: $routeName'));
      });
    });

    group('didInitTabRoute', () {
      late String routeName;
      late TabPageRoute route;
      late TabPageRoute? previousRoute;

      setUp(() {
        routeName = 'MyRoute';
        route = makeTabPageRoute(routeName);
        previousRoute = null;
      });

      test('logs debug message', () {
        // Act
        underTest.didInitTabRoute(route, previousRoute);

        // Assert
        verify(() => logger.debug('Tab route visited: $routeName'));
      });
    });

    group('didChangeTabRoute', () {
      late String routeName;
      late TabPageRoute route;
      late TabPageRoute previousRoute;

      setUp(() {
        routeName = 'MyRoute';
        route = makeTabPageRoute(routeName);
        previousRoute = makeTabPageRoute(routeName);
      });

      test('logs debug message', () {
        // Act
        underTest.didChangeTabRoute(route, previousRoute);

        // Assert
        verify(() => logger.debug('Tab route re-visited: $routeName'));
      });
    });
  });
}
