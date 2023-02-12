import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/app_package/app_package.dart';
import 'package:rapid_cli/src/project/app_package/platform_native_directory/android_native_directory_bundle.dart';
import 'package:rapid_cli/src/project/app_package/platform_native_directory/ios_native_directory_bundle.dart';
import 'package:rapid_cli/src/project/app_package/platform_native_directory/linux_native_directory_bundle.dart';
import 'package:rapid_cli/src/project/app_package/platform_native_directory/macos_native_directory_bundle.dart';
import 'package:rapid_cli/src/project/app_package/platform_native_directory/platform_native_directory.dart';
import 'package:rapid_cli/src/project/app_package/platform_native_directory/web_native_directory_bundle.dart';
import 'package:rapid_cli/src/project/app_package/platform_native_directory/windows_native_directory_bundle.dart';
import 'package:test/test.dart';

import '../../../common.dart';
import '../../../mocks.dart';

PlatformNativeDirectory _getPlatformNativeDirectory(
  Platform platform, {
  AppPackage? appPackage,
  GeneratorBuilder? generator,
}) {
  return PlatformNativeDirectory(
    platform,
    appPackage: appPackage ?? getAppPackage(),
    generator: generator ?? (_) async => getMasonGenerator(),
  );
}

void main() {
  group('PlatformNativeDirectory', () {
    setUpAll(() {
      registerFallbackValue(FakeDirectoryGeneratorTarget());
      registerFallbackValue(FakeMasonBundle());
      registerFallbackValue(FakeLogger());
      registerFallbackValue(Platform.android);
      registerFallbackValue(FakePlatformCustomFeaturePackage());
    });

    group('.path', () {
      test('(android)', () {
        // Arrange
        final appPackage = getAppPackage();
        when(() => appPackage.path).thenReturn('app_package/path');
        final platformNativeDirectory = _getPlatformNativeDirectory(
          Platform.android,
          appPackage: appPackage,
        );

        // Act + Assert
        expect(platformNativeDirectory.path, 'app_package/path/android');
      });

      test('(ios)', () {
        // Arrange
        final appPackage = getAppPackage();
        when(() => appPackage.path).thenReturn('app_package/path');
        final platformNativeDirectory = _getPlatformNativeDirectory(
          Platform.ios,
          appPackage: appPackage,
        );

        // Act + Assert
        expect(platformNativeDirectory.path, 'app_package/path/ios');
      });

      test('(linux)', () {
        // Arrange
        final appPackage = getAppPackage();
        when(() => appPackage.path).thenReturn('app_package/path');
        final platformNativeDirectory = _getPlatformNativeDirectory(
          Platform.linux,
          appPackage: appPackage,
        );

        // Act + Assert
        expect(platformNativeDirectory.path, 'app_package/path/linux');
      });

      test('(macos)', () {
        // Arrange
        final appPackage = getAppPackage();
        when(() => appPackage.path).thenReturn('app_package/path');
        final platformNativeDirectory = _getPlatformNativeDirectory(
          Platform.macos,
          appPackage: appPackage,
        );

        // Act + Assert
        expect(platformNativeDirectory.path, 'app_package/path/macos');
      });

      test('(web)', () {
        // Arrange
        final appPackage = getAppPackage();
        when(() => appPackage.path).thenReturn('app_package/path');
        final platformNativeDirectory = _getPlatformNativeDirectory(
          Platform.web,
          appPackage: appPackage,
        );

        // Act + Assert
        expect(platformNativeDirectory.path, 'app_package/path/web');
      });

      test('(windows)', () {
        // Arrange
        final appPackage = getAppPackage();
        when(() => appPackage.path).thenReturn('app_package/path');
        final platformNativeDirectory = _getPlatformNativeDirectory(
          Platform.windows,
          appPackage: appPackage,
        );

        // Act + Assert
        expect(platformNativeDirectory.path, 'app_package/path/windows');
      });
    });

    group('.create()', () {
      test(
        'completes successfully with correct output when description is not null',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.name()).thenReturn('my_project');
          final appPackage = getAppPackage();
          when(() => appPackage.path).thenReturn('app_package/path');
          when(() => appPackage.project).thenReturn(project);
          final generator = getMasonGenerator();
          final platformNativeDirectory = _getPlatformNativeDirectory(
            Platform.android,
            appPackage: appPackage,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await platformNativeDirectory.create(
            description: 'some desc',
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'app_package/path/android',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'description': 'some desc',
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );

      test(
        'completes successfully with correct output when orgName is not null',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.name()).thenReturn('my_project');
          final appPackage = getAppPackage();
          when(() => appPackage.path).thenReturn('app_package/path');
          when(() => appPackage.project).thenReturn(project);
          final generator = getMasonGenerator();
          final platformNativeDirectory = _getPlatformNativeDirectory(
            Platform.android,
            appPackage: appPackage,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await platformNativeDirectory.create(
            orgName: 'my.org',
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'app_package/path/android',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'org_name': 'my.org',
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );

      group('uses correct bundle', () {
        test(
          '(android)',
          withTempDir(() async {
            // Arrange
            final generator = getGeneratorBuilder();
            final platformNativeDirectory = _getPlatformNativeDirectory(
              Platform.android,
              generator: generator,
            );

            // Act
            await platformNativeDirectory.create(
              logger: FakeLogger(),
            );

            // Assert
            verify(() => generator(androidNativeDirectoryBundle)).called(1);
          }),
        );

        test(
          '(ios)',
          withTempDir(() async {
            // Arrange
            final generator = getGeneratorBuilder();
            final platformNativeDirectory = _getPlatformNativeDirectory(
              Platform.ios,
              generator: generator,
            );

            // Act
            await platformNativeDirectory.create(
              logger: FakeLogger(),
            );

            // Assert
            verify(() => generator(iosNativeDirectoryBundle)).called(1);
          }),
        );

        test(
          '(linux)',
          withTempDir(() async {
            // Arrange
            final generator = getGeneratorBuilder();
            final platformNativeDirectory = _getPlatformNativeDirectory(
              Platform.linux,
              generator: generator,
            );

            // Act
            await platformNativeDirectory.create(
              logger: FakeLogger(),
            );

            // Assert
            verify(() => generator(linuxNativeDirectoryBundle)).called(1);
          }),
        );

        test(
          '(macos)',
          withTempDir(() async {
            // Arrange
            final generator = getGeneratorBuilder();
            final platformNativeDirectory = _getPlatformNativeDirectory(
              Platform.macos,
              generator: generator,
            );

            // Act
            await platformNativeDirectory.create(
              logger: FakeLogger(),
            );

            // Assert
            verify(() => generator(macosNativeDirectoryBundle)).called(1);
          }),
        );

        test(
          '(web)',
          withTempDir(() async {
            // Arrange
            final generator = getGeneratorBuilder();
            final platformNativeDirectory = _getPlatformNativeDirectory(
              Platform.web,
              generator: generator,
            );

            // Act
            await platformNativeDirectory.create(
              logger: FakeLogger(),
            );

            // Assert
            verify(() => generator(webNativeDirectoryBundle)).called(1);
          }),
        );

        test(
          '(windows)',
          withTempDir(() async {
            // Arrange
            final generator = getGeneratorBuilder();
            final platformNativeDirectory = _getPlatformNativeDirectory(
              Platform.windows,
              generator: generator,
            );

            // Act
            await platformNativeDirectory.create(
              logger: FakeLogger(),
            );

            // Assert
            verify(() => generator(windowsNativeDirectoryBundle)).called(1);
          }),
        );
      });
    });
  });
}
