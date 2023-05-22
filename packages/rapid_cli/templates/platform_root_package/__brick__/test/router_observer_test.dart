import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name}}_{{#android}}android{{/android}}{{#ios}}ios{{/ios}}{{#linux}}linux{{/linux}}{{#macos}}macos{{/macos}}{{#web}}web{{/web}}{{#windows}}windows{{/windows}}{{#mobile}}mobile{{/mobile}}/router_observer.dart';
import 'package:{{project_name}}_logging/{{project_name}}_logging.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks.dart';

{{project_name.pascalCase()}}RouterObserver _get{{project_name.pascalCase()}}RouterObserver({{project_name.pascalCase()}}Logger logger) {
  return {{project_name.pascalCase()}}RouterObserver(logger);
}

void main() {
  group('{{project_name.pascalCase()}}RouterObserver', () {
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
      final logger = Mock{{project_name.pascalCase()}}Logger();

      // Act
      final {{project_name.camelCase()}}RouterObserver = _get{{project_name.pascalCase()}}RouterObserver(logger);

      // Act
      expect({{project_name.camelCase()}}RouterObserver.logger, logger);
    });

    test('.didPush()', () {
      // Arrange
      final logger = Mock{{project_name.pascalCase()}}Logger();
      final {{project_name.camelCase()}}RouterObserver = _get{{project_name.pascalCase()}}RouterObserver(logger);

      // Act
      {{project_name.camelCase()}}RouterObserver.didPush(makeRoute('MyRoute'), null);

      // Assert
      verify(() => logger.debug('New route pushed: MyRoute'));
    });

    test('.didPop()', () {
      // Arrange
      final logger = Mock{{project_name.pascalCase()}}Logger();
      final {{project_name.camelCase()}}RouterObserver = _get{{project_name.pascalCase()}}RouterObserver(logger);

      // Act
      {{project_name.camelCase()}}RouterObserver.didPop(makeRoute('MyRoute'), null);

      // Assert
      verify(() => logger.debug('Route popped: MyRoute'));
    });

    test('.didRemove()', () {
      // Arrange
      final logger = Mock{{project_name.pascalCase()}}Logger();
      final {{project_name.camelCase()}}RouterObserver = _get{{project_name.pascalCase()}}RouterObserver(logger);

      // Act
      {{project_name.camelCase()}}RouterObserver.didRemove(makeRoute('MyRoute'), null);

      // Assert
      verify(() => logger.debug('Route removed: MyRoute'));
    });

    test('.didInitTabRoute()', () {
      // Arrange
      final logger = Mock{{project_name.pascalCase()}}Logger();
      final {{project_name.camelCase()}}RouterObserver = _get{{project_name.pascalCase()}}RouterObserver(logger);

      // Act
      {{project_name.camelCase()}}RouterObserver.didInitTabRoute(makeTabPageRoute('MyRoute'), null);

      // Assert
      verify(() => logger.debug('Tab route visited: MyRoute'));
    });

    test('.didChangeTabRoute()', () {
      // Arrange
      final logger = Mock{{project_name.pascalCase()}}Logger();
      final {{project_name.camelCase()}}RouterObserver = _get{{project_name.pascalCase()}}RouterObserver(logger);

      // Act
      {{project_name.camelCase()}}RouterObserver.didChangeTabRoute(
        makeTabPageRoute('MyRoute'),
        makeTabPageRoute('MyPrevRoute'),
      );

      // Assert
      verify(() => logger.debug('Tab route re-visited: MyRoute'));
    });
  });
}
