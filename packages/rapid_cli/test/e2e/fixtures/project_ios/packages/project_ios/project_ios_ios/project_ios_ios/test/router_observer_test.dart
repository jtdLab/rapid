import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_ios_ios/router_observer.dart';
import 'package:project_ios_logging/project_ios_logging.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks.dart';

ProjectIosRouterObserver _getProjectIosRouterObserver(ProjectIosLogger logger) {
  return ProjectIosRouterObserver(logger);
}

void main() {
  group('ProjectIosRouterObserver', () {
    Route makeRoute(String name) {
      final settings = MockRouteSettings();
      when(() => settings.name).thenReturn(name);
      final route = MockRoute();
      when(() => route.settings).thenReturn(settings);
      return route;
    }

    MockTabPageRoute makeTabPageRoute(String name) {
      final tabRoute = MockTabPageRoute();
      when(() => tabRoute.name).thenReturn(name);
      return tabRoute;
    }

    test('.()', () {
      // Arrange
      final logger = MockProjectIosLogger();

      // Act
      final projectIosRouterObserver = _getProjectIosRouterObserver(logger);

      // Act
      expect(projectIosRouterObserver.logger, logger);
    });

    test('.didPush()', () {
      // Arrange
      final logger = MockProjectIosLogger();
      final projectIosRouterObserver = _getProjectIosRouterObserver(logger);

      // Act
      projectIosRouterObserver.didPush(makeRoute('MyRoute'), null);

      // Assert
      verify(() => logger.debug('New route pushed: MyRoute'));
    });

    test('.didPop()', () {
      // Arrange
      final logger = MockProjectIosLogger();
      final projectIosRouterObserver = _getProjectIosRouterObserver(logger);

      // Act
      projectIosRouterObserver.didPop(makeRoute('MyRoute'), null);

      // Assert
      verify(() => logger.debug('Route popped: MyRoute'));
    });

    test('.didRemove()', () {
      // Arrange
      final logger = MockProjectIosLogger();
      final projectIosRouterObserver = _getProjectIosRouterObserver(logger);

      // Act
      projectIosRouterObserver.didRemove(makeRoute('MyRoute'), null);

      // Assert
      verify(() => logger.debug('Route removed: MyRoute'));
    });

    test('.didInitTabRoute()', () {
      // Arrange
      final logger = MockProjectIosLogger();
      final projectIosRouterObserver = _getProjectIosRouterObserver(logger);

      // Act
      projectIosRouterObserver.didInitTabRoute(
          makeTabPageRoute('MyRoute'), null);

      // Assert
      verify(() => logger.debug('Tab route visited: MyRoute'));
    });

    test('.didChangeTabRoute()', () {
      // Arrange
      final logger = MockProjectIosLogger();
      final projectIosRouterObserver = _getProjectIosRouterObserver(logger);

      // Act
      projectIosRouterObserver.didChangeTabRoute(
        makeTabPageRoute('MyRoute'),
        makeTabPageRoute('MyPrevRoute'),
      );

      // Assert
      verify(() => logger.debug('Tab route re-visited: MyRoute'));
    });
  });
}
