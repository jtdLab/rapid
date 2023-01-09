import 'package:injectable/injectable.dart' hide test;
import 'package:test_app_di/src/di_container.dart';
import 'package:test_app_di/src/injection.dart';
import 'package:test_app_logging/test_app_logging.dart';
import 'package:rapid_di/rapid_di.dart';
import 'package:test/test.dart';

extension _ListX<T> on List<T> {
  T random() => (toList()..shuffle()).first;
}

final _environments = [Environment.dev, Environment.test, Environment.prod];
final _platforms = [
  Platform.android,
  Platform.ios,
  Platform.web,
  Platform.linux,
  Platform.macos,
  Platform.windows
];

void main() {
  group('configureDependencies', () {
    late String environment;
    late String platform;

    setUp(() {
      environment = _environments.random();
      platform = _platforms.random();
    });

    tearDown(() async {
      await getIt.reset();
    });

    test('registers the general dependencies inside getIt', () {
      // Act
      configureDependencies(environment, platform);

      // Assert
      // TODO: add more asserts here
    });

    test(
        'registers development dependencies inside getIt when environment is dev',
        () {
      // Arrange
      environment = 'dev';

      // Act
      configureDependencies(environment, platform);

      // Assert
      expect(getIt<TestAppLogger>(), isA<TestAppLoggerDevelopment>());
      // TODO: add more asserts here
    });

    test('registers test dependencies inside getIt when environment is test',
        () {
      // Arrange
      environment = 'test';

      // Act
      configureDependencies(environment, platform);

      // Assert
      expect(getIt<TestAppLogger>(), isA<TestAppLoggerTest>());
      // TODO: add more asserts here
    });

    test(
        'registers production dependencies inside getIt when environment is prod',
        () {
      // Arrange
      environment = 'prod';

      // Act
      configureDependencies(environment, platform);

      // Assert
      expect(getIt<TestAppLogger>(), isA<TestAppLoggerProduction>());
      // TODO: add more asserts here
    });

    test('registers Android dependencies inside getIt when platform is android',
        () {
      // Arrange
      platform = 'android';

      // Act
      configureDependencies(environment, platform);

      // Assert
      // TODO: add more asserts here
    });

    test('registers iOS dependencies inside getIt when platform is ios', () {
      // Arrange
      platform = 'ios';

      // Act
      configureDependencies(environment, platform);

      // Assert
      // TODO: add more asserts here
    });

    test('registers Linux dependencies inside getIt when platform is linux',
        () {
      // Arrange
      platform = 'linux';

      // Act
      configureDependencies(environment, platform);

      // Assert
      // TODO: add more asserts here
    });

    test('registers macOS dependencies inside getIt when platform is macos',
        () {
      // Arrange
      platform = 'macos';

      // Act
      configureDependencies(environment, platform);

      // Assert
      // TODO: add more asserts here
    });

    test('registers Web dependencies inside getIt when platform is web', () {
      // Arrange
      platform = 'web';

      // Act
      configureDependencies(environment, platform);

      // Assert
      // TODO: add more asserts here
    });

    test('registers Windows dependencies inside getIt when platform is windows',
        () {
      // Arrange
      platform = 'windows';

      // Act
      configureDependencies(environment, platform);

      // Assert
      // TODO: add more asserts here
    });
  });
}
