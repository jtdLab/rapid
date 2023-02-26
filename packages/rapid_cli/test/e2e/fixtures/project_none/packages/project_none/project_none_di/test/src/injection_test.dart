import 'package:injectable/injectable.dart' show Environment;
import 'package:project_none_di/src/injection.dart';
import 'package:project_none_logging/project_none_logging.dart';
import 'package:rapid_di/rapid_di.dart';
import 'package:test/test.dart';

void main() {
  group('.configureDependencies()', () {
    String randomEnvironment() {
      final environments = [
        Environment.dev,
        Environment.test,
        Environment.prod
      ];
      environments.shuffle();

      return environments.first;
    }

    String randomPlatform() {
      final platforms = [
        Platform.android,
        Platform.ios,
        Platform.web,
        Platform.linux,
        Platform.macos,
        Platform.windows
      ];
      platforms.shuffle();

      return platforms.first;
    }

    tearDown(() async {
      await getIt.reset();
    });

    test('registers the general dependencies', () {
      // Act
      configureDependencies(randomEnvironment(), randomPlatform());

      // Assert
      // TODO: add more asserts here
    });

    test('registers development dependencies when environment is dev', () {
      // Act
      configureDependencies('dev', randomPlatform());

      // Assert
      expect(getIt<ProjectNoneLogger>(), isA<ProjectNoneLoggerDevelopment>());
      // TODO: add more asserts here
    });

    test('registers test dependencies when environment is test', () {
      // Act
      configureDependencies('test', randomPlatform());

      // Assert
      expect(getIt<ProjectNoneLogger>(), isA<ProjectNoneLoggerTest>());
      // TODO: add more asserts here
    });

    test('registers production dependencies when environment is prod', () {
      // Act
      configureDependencies('prod', randomPlatform());

      // Assert
      expect(getIt<ProjectNoneLogger>(), isA<ProjectNoneLoggerProduction>());
      // TODO: add more asserts here
    });

    test('registers Android dependencies when platform is android', () {
      // Act
      configureDependencies(randomEnvironment(), 'android');

      // Assert
      // TODO: add more asserts here
    });

    test('registers iOS dependencies when platform is ios', () {
      // Act
      configureDependencies(randomEnvironment(), 'ios');

      // Assert
      // TODO: add more asserts here
    });

    test('registers Linux dependencies when platform is linux', () {
      // Act
      configureDependencies(randomEnvironment(), 'linux');

      // Assert
      // TODO: add more asserts here
    });

    test('registers macOS dependencies when platform is macos', () {
      // Act
      configureDependencies(randomEnvironment(), 'macos');

      // Assert
      // TODO: add more asserts here
    });

    test('registers Web dependencies when platform is web', () {
      // Act
      configureDependencies(randomEnvironment(), 'web');

      // Assert
      // TODO: add more asserts here
    });

    test('registers Windows dependencies when platform is windows', () {
      // Act
      configureDependencies(randomEnvironment(), 'windows');

      // Assert
      // TODO: add more asserts here
    });
  });
}
