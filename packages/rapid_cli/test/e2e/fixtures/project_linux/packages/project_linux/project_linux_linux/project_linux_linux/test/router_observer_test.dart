import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_linux_linux/router_observer.dart';
import 'package:project_linux_logging/project_linux_logging.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks.dart';

ProjectLinuxRouterObserver _getProjectLinuxRouterObserver(
    ProjectLinuxLogger logger) {
  return ProjectLinuxRouterObserver(logger);
}

void main() {
  group('ProjectLinuxRouterObserver', () {
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
      final logger = MockProjectLinuxLogger();

      // Act
      final projectLinuxRouterObserver = _getProjectLinuxRouterObserver(logger);

      // Act
      expect(projectLinuxRouterObserver.logger, logger);
    });

    test('.didPush()', () {
      // Arrange
      final logger = MockProjectLinuxLogger();
      final projectLinuxRouterObserver = _getProjectLinuxRouterObserver(logger);

      // Act
      projectLinuxRouterObserver.didPush(makeRoute('MyRoute'), null);

      // Assert
      verify(() => logger.debug('New route pushed: MyRoute'));
    });

    test('.didPop()', () {
      // Arrange
      final logger = MockProjectLinuxLogger();
      final projectLinuxRouterObserver = _getProjectLinuxRouterObserver(logger);

      // Act
      projectLinuxRouterObserver.didPop(makeRoute('MyRoute'), null);

      // Assert
      verify(() => logger.debug('Route popped: MyRoute'));
    });

    test('.didRemove()', () {
      // Arrange
      final logger = MockProjectLinuxLogger();
      final projectLinuxRouterObserver = _getProjectLinuxRouterObserver(logger);

      // Act
      projectLinuxRouterObserver.didRemove(makeRoute('MyRoute'), null);

      // Assert
      verify(() => logger.debug('Route removed: MyRoute'));
    });

    test('.didInitTabRoute()', () {
      // Arrange
      final logger = MockProjectLinuxLogger();
      final projectLinuxRouterObserver = _getProjectLinuxRouterObserver(logger);

      // Act
      projectLinuxRouterObserver.didInitTabRoute(
          makeTabPageRoute('MyRoute'), null);

      // Assert
      verify(() => logger.debug('Tab route visited: MyRoute'));
    });

    test('.didChangeTabRoute()', () {
      // Arrange
      final logger = MockProjectLinuxLogger();
      final projectLinuxRouterObserver = _getProjectLinuxRouterObserver(logger);

      // Act
      projectLinuxRouterObserver.didChangeTabRoute(
        makeTabPageRoute('MyRoute'),
        makeTabPageRoute('MyPrevRoute'),
      );

      // Assert
      verify(() => logger.debug('Tab route re-visited: MyRoute'));
    });
  });
}
