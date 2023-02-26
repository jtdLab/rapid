import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_none/router_observer.dart';
import 'package:project_none_logging/project_none_logging.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks.dart';

ProjectNoneRouterObserver _getProjectNoneRouterObserver(
    ProjectNoneLogger logger) {
  return ProjectNoneRouterObserver(logger);
}

void main() {
  group('ProjectNoneRouterObserver', () {
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
      final logger = MockProjectNoneLogger();

      // Act
      final projectNoneRouterObserver = _getProjectNoneRouterObserver(logger);

      // Act
      expect(projectNoneRouterObserver.logger, logger);
    });

    test('.didPush()', () {
      // Arrange
      final logger = MockProjectNoneLogger();
      final projectNoneRouterObserver = _getProjectNoneRouterObserver(logger);

      // Act
      projectNoneRouterObserver.didPush(makeRoute('MyRoute'), null);

      // Assert
      verify(() => logger.debug('New route pushed: MyRoute'));
    });

    test('.didPop()', () {
      // Arrange
      final logger = MockProjectNoneLogger();
      final projectNoneRouterObserver = _getProjectNoneRouterObserver(logger);

      // Act
      projectNoneRouterObserver.didPop(makeRoute('MyRoute'), null);

      // Assert
      verify(() => logger.debug('Route popped: MyRoute'));
    });

    test('.didRemove()', () {
      // Arrange
      final logger = MockProjectNoneLogger();
      final projectNoneRouterObserver = _getProjectNoneRouterObserver(logger);

      // Act
      projectNoneRouterObserver.didRemove(makeRoute('MyRoute'), null);

      // Assert
      verify(() => logger.debug('Route removed: MyRoute'));
    });

    test('.didInitTabRoute()', () {
      // Arrange
      final logger = MockProjectNoneLogger();
      final projectNoneRouterObserver = _getProjectNoneRouterObserver(logger);

      // Act
      projectNoneRouterObserver.didInitTabRoute(
          makeTabPageRoute('MyRoute'), null);

      // Assert
      verify(() => logger.debug('Tab route visited: MyRoute'));
    });

    test('.didChangeTabRoute()', () {
      // Arrange
      final logger = MockProjectNoneLogger();
      final projectNoneRouterObserver = _getProjectNoneRouterObserver(logger);

      // Act
      projectNoneRouterObserver.didChangeTabRoute(
        makeTabPageRoute('MyRoute'),
        makeTabPageRoute('MyPrevRoute'),
      );

      // Assert
      verify(() => logger.debug('Tab route re-visited: MyRoute'));
    });
  });
}
