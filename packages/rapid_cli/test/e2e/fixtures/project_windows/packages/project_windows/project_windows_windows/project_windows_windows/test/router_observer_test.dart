import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_windows_windows/router_observer.dart';
import 'package:project_windows_logging/project_windows_logging.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks.dart';

ProjectWindowsRouterObserver _getProjectWindowsRouterObserver(
    ProjectWindowsLogger logger) {
  return ProjectWindowsRouterObserver(logger);
}

void main() {
  group('ProjectWindowsRouterObserver', () {
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
      final logger = MockProjectWindowsLogger();

      // Act
      final projectWindowsRouterObserver =
          _getProjectWindowsRouterObserver(logger);

      // Act
      expect(projectWindowsRouterObserver.logger, logger);
    });

    test('.didPush()', () {
      // Arrange
      final logger = MockProjectWindowsLogger();
      final projectWindowsRouterObserver =
          _getProjectWindowsRouterObserver(logger);

      // Act
      projectWindowsRouterObserver.didPush(makeRoute('MyRoute'), null);

      // Assert
      verify(() => logger.debug('New route pushed: MyRoute'));
    });

    test('.didPop()', () {
      // Arrange
      final logger = MockProjectWindowsLogger();
      final projectWindowsRouterObserver =
          _getProjectWindowsRouterObserver(logger);

      // Act
      projectWindowsRouterObserver.didPop(makeRoute('MyRoute'), null);

      // Assert
      verify(() => logger.debug('Route popped: MyRoute'));
    });

    test('.didRemove()', () {
      // Arrange
      final logger = MockProjectWindowsLogger();
      final projectWindowsRouterObserver =
          _getProjectWindowsRouterObserver(logger);

      // Act
      projectWindowsRouterObserver.didRemove(makeRoute('MyRoute'), null);

      // Assert
      verify(() => logger.debug('Route removed: MyRoute'));
    });

    test('.didInitTabRoute()', () {
      // Arrange
      final logger = MockProjectWindowsLogger();
      final projectWindowsRouterObserver =
          _getProjectWindowsRouterObserver(logger);

      // Act
      projectWindowsRouterObserver.didInitTabRoute(
          makeTabPageRoute('MyRoute'), null);

      // Assert
      verify(() => logger.debug('Tab route visited: MyRoute'));
    });

    test('.didChangeTabRoute()', () {
      // Arrange
      final logger = MockProjectWindowsLogger();
      final projectWindowsRouterObserver =
          _getProjectWindowsRouterObserver(logger);

      // Act
      projectWindowsRouterObserver.didChangeTabRoute(
        makeTabPageRoute('MyRoute'),
        makeTabPageRoute('MyPrevRoute'),
      );

      // Assert
      verify(() => logger.debug('Tab route re-visited: MyRoute'));
    });
  });
}
