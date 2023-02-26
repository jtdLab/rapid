import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_web/router_observer.dart';
import 'package:project_web_logging/project_web_logging.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks.dart';

ProjectWebRouterObserver _getProjectWebRouterObserver(ProjectWebLogger logger) {
  return ProjectWebRouterObserver(logger);
}

void main() {
  group('ProjectWebRouterObserver', () {
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
      final logger = MockProjectWebLogger();

      // Act
      final projectWebRouterObserver = _getProjectWebRouterObserver(logger);

      // Act
      expect(projectWebRouterObserver.logger, logger);
    });

    test('.didPush()', () {
      // Arrange
      final logger = MockProjectWebLogger();
      final projectWebRouterObserver = _getProjectWebRouterObserver(logger);

      // Act
      projectWebRouterObserver.didPush(makeRoute('MyRoute'), null);

      // Assert
      verify(() => logger.debug('New route pushed: MyRoute'));
    });

    test('.didPop()', () {
      // Arrange
      final logger = MockProjectWebLogger();
      final projectWebRouterObserver = _getProjectWebRouterObserver(logger);

      // Act
      projectWebRouterObserver.didPop(makeRoute('MyRoute'), null);

      // Assert
      verify(() => logger.debug('Route popped: MyRoute'));
    });

    test('.didRemove()', () {
      // Arrange
      final logger = MockProjectWebLogger();
      final projectWebRouterObserver = _getProjectWebRouterObserver(logger);

      // Act
      projectWebRouterObserver.didRemove(makeRoute('MyRoute'), null);

      // Assert
      verify(() => logger.debug('Route removed: MyRoute'));
    });

    test('.didInitTabRoute()', () {
      // Arrange
      final logger = MockProjectWebLogger();
      final projectWebRouterObserver = _getProjectWebRouterObserver(logger);

      // Act
      projectWebRouterObserver.didInitTabRoute(
          makeTabPageRoute('MyRoute'), null);

      // Assert
      verify(() => logger.debug('Tab route visited: MyRoute'));
    });

    test('.didChangeTabRoute()', () {
      // Arrange
      final logger = MockProjectWebLogger();
      final projectWebRouterObserver = _getProjectWebRouterObserver(logger);

      // Act
      projectWebRouterObserver.didChangeTabRoute(
        makeTabPageRoute('MyRoute'),
        makeTabPageRoute('MyPrevRoute'),
      );

      // Assert
      verify(() => logger.debug('Tab route re-visited: MyRoute'));
    });
  });
}
