import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_macos_macos/router_observer.dart';
import 'package:project_macos_logging/project_macos_logging.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks.dart';

ProjectMacosRouterObserver _getProjectMacosRouterObserver(
    ProjectMacosLogger logger) {
  return ProjectMacosRouterObserver(logger);
}

void main() {
  group('ProjectMacosRouterObserver', () {
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
      final logger = MockProjectMacosLogger();

      // Act
      final projectMacosRouterObserver = _getProjectMacosRouterObserver(logger);

      // Act
      expect(projectMacosRouterObserver.logger, logger);
    });

    test('.didPush()', () {
      // Arrange
      final logger = MockProjectMacosLogger();
      final projectMacosRouterObserver = _getProjectMacosRouterObserver(logger);

      // Act
      projectMacosRouterObserver.didPush(makeRoute('MyRoute'), null);

      // Assert
      verify(() => logger.debug('New route pushed: MyRoute'));
    });

    test('.didPop()', () {
      // Arrange
      final logger = MockProjectMacosLogger();
      final projectMacosRouterObserver = _getProjectMacosRouterObserver(logger);

      // Act
      projectMacosRouterObserver.didPop(makeRoute('MyRoute'), null);

      // Assert
      verify(() => logger.debug('Route popped: MyRoute'));
    });

    test('.didRemove()', () {
      // Arrange
      final logger = MockProjectMacosLogger();
      final projectMacosRouterObserver = _getProjectMacosRouterObserver(logger);

      // Act
      projectMacosRouterObserver.didRemove(makeRoute('MyRoute'), null);

      // Assert
      verify(() => logger.debug('Route removed: MyRoute'));
    });

    test('.didInitTabRoute()', () {
      // Arrange
      final logger = MockProjectMacosLogger();
      final projectMacosRouterObserver = _getProjectMacosRouterObserver(logger);

      // Act
      projectMacosRouterObserver.didInitTabRoute(
          makeTabPageRoute('MyRoute'), null);

      // Assert
      verify(() => logger.debug('Tab route visited: MyRoute'));
    });

    test('.didChangeTabRoute()', () {
      // Arrange
      final logger = MockProjectMacosLogger();
      final projectMacosRouterObserver = _getProjectMacosRouterObserver(logger);

      // Act
      projectMacosRouterObserver.didChangeTabRoute(
        makeTabPageRoute('MyRoute'),
        makeTabPageRoute('MyPrevRoute'),
      );

      // Assert
      verify(() => logger.debug('Tab route re-visited: MyRoute'));
    });
  });
}
