import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example_windows/router_observer.dart';
import 'package:example_logging/example_logging.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks.dart';

ExampleRouterObserver _getExampleRouterObserver(ExampleLogger logger) {
  return ExampleRouterObserver(logger);
}

void main() {
  group('ExampleRouterObserver', () {
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
      final logger = MockExampleLogger();

      // Act
      final exampleRouterObserver = _getExampleRouterObserver(logger);

      // Act
      expect(exampleRouterObserver.logger, logger);
    });

    test('.didPush()', () {
      // Arrange
      final logger = MockExampleLogger();
      final exampleRouterObserver = _getExampleRouterObserver(logger);

      // Act
      exampleRouterObserver.didPush(makeRoute('MyRoute'), null);

      // Assert
      verify(() => logger.debug('New route pushed: MyRoute'));
    });

    test('.didPop()', () {
      // Arrange
      final logger = MockExampleLogger();
      final exampleRouterObserver = _getExampleRouterObserver(logger);

      // Act
      exampleRouterObserver.didPop(makeRoute('MyRoute'), null);

      // Assert
      verify(() => logger.debug('Route popped: MyRoute'));
    });

    test('.didRemove()', () {
      // Arrange
      final logger = MockExampleLogger();
      final exampleRouterObserver = _getExampleRouterObserver(logger);

      // Act
      exampleRouterObserver.didRemove(makeRoute('MyRoute'), null);

      // Assert
      verify(() => logger.debug('Route removed: MyRoute'));
    });

    test('.didInitTabRoute()', () {
      // Arrange
      final logger = MockExampleLogger();
      final exampleRouterObserver = _getExampleRouterObserver(logger);

      // Act
      exampleRouterObserver.didInitTabRoute(makeTabPageRoute('MyRoute'), null);

      // Assert
      verify(() => logger.debug('Tab route visited: MyRoute'));
    });

    test('.didChangeTabRoute()', () {
      // Arrange
      final logger = MockExampleLogger();
      final exampleRouterObserver = _getExampleRouterObserver(logger);

      // Act
      exampleRouterObserver.didChangeTabRoute(
        makeTabPageRoute('MyRoute'),
        makeTabPageRoute('MyPrevRoute'),
      );

      // Assert
      verify(() => logger.debug('Tab route re-visited: MyRoute'));
    });
  });
}
