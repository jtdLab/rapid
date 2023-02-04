import 'package:injectable/injectable.dart' hide test;
import 'package:project_none_di/src/injection.dart';
import 'package:project_none_logging/project_none_logging.dart';
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
      expect(getIt<ProjectNoneLogger>(), isA<ProjectNoneLoggerDevelopment>());
      // TODO: add more asserts here
    });

    test('registers test dependencies inside getIt when environment is test',
        () {
      // Arrange
      environment = 'test';

      // Act
      configureDependencies(environment, platform);

      // Assert
      expect(getIt<ProjectNoneLogger>(), isA<ProjectNoneLoggerTest>());
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
      expect(getIt<ProjectNoneLogger>(), isA<ProjectNoneLoggerProduction>());
      // TODO: add more asserts here
    });
  });
}
