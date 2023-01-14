import 'package:injectable/injectable.dart' hide test;
import 'package:project_windows_di/src/di_container.dart';
import 'package:project_windows_di/src/injection.dart';
import 'package:project_windows_logging/project_windows_logging.dart';
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
      expect(getIt<ProjectWindowsLogger>(),
          isA<ProjectWindowsLoggerDevelopment>());
      // TODO: add more asserts here
    });

    test('registers test dependencies inside getIt when environment is test',
        () {
      // Arrange
      environment = 'test';

      // Act
      configureDependencies(environment, platform);

      // Assert
      expect(getIt<ProjectWindowsLogger>(), isA<ProjectWindowsLoggerTest>());
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
      expect(
          getIt<ProjectWindowsLogger>(), isA<ProjectWindowsLoggerProduction>());
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
