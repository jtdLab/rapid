import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_android/router_observer.dart';
import 'package:project_android_logging/project_android_logging.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks.dart';

ProjectAndroidRouterObserver _getProjectAndroidRouterObserver(
    ProjectAndroidLogger logger) {
  return ProjectAndroidRouterObserver(logger);
}

void main() {
  group('ProjectAndroidRouterObserver', () {
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
      final logger = MockProjectAndroidLogger();

      // Act
      final projectAndroidRouterObserver =
          _getProjectAndroidRouterObserver(logger);

      // Act
      expect(projectAndroidRouterObserver.logger, logger);
    });

    test('.didPush()', () {
      // Arrange
      final logger = MockProjectAndroidLogger();
      final projectAndroidRouterObserver =
          _getProjectAndroidRouterObserver(logger);

      // Act
      projectAndroidRouterObserver.didPush(makeRoute('MyRoute'), null);

      // Assert
      verify(() => logger.debug('New route pushed: MyRoute'));
    });

    test('.didPop()', () {
      // Arrange
      final logger = MockProjectAndroidLogger();
      final projectAndroidRouterObserver =
          _getProjectAndroidRouterObserver(logger);

      // Act
      projectAndroidRouterObserver.didPop(makeRoute('MyRoute'), null);

      // Assert
      verify(() => logger.debug('Route popped: MyRoute'));
    });

    test('.didRemove()', () {
      // Arrange
      final logger = MockProjectAndroidLogger();
      final projectAndroidRouterObserver =
          _getProjectAndroidRouterObserver(logger);

      // Act
      projectAndroidRouterObserver.didRemove(makeRoute('MyRoute'), null);

      // Assert
      verify(() => logger.debug('Route removed: MyRoute'));
    });

    test('.didInitTabRoute()', () {
      // Arrange
      final logger = MockProjectAndroidLogger();
      final projectAndroidRouterObserver =
          _getProjectAndroidRouterObserver(logger);

      // Act
      projectAndroidRouterObserver.didInitTabRoute(
          makeTabPageRoute('MyRoute'), null);

      // Assert
      verify(() => logger.debug('Tab route visited: MyRoute'));
    });

    test('.didChangeTabRoute()', () {
      // Arrange
      final logger = MockProjectAndroidLogger();
      final projectAndroidRouterObserver =
          _getProjectAndroidRouterObserver(logger);

      // Act
      projectAndroidRouterObserver.didChangeTabRoute(
        makeTabPageRoute('MyRoute'),
        makeTabPageRoute('MyPrevRoute'),
      );

      // Assert
      verify(() => logger.debug('Tab route re-visited: MyRoute'));
    });
  });
}
