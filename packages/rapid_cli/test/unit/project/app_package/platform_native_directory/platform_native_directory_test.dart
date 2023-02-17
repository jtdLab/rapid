import 'dart:io';

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

const infoPlistWithoutLocalizations = '''
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict></dict>
</plist>''';

const infoPlistWithLocalizations = '''
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>CFBundleLocalizations</key>
    <array>
      <string>en</string>
    </array>
  </dict>
</plist>''';

const infoPlistWithMoreLocalizations = '''
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>CFBundleLocalizations</key>
    <array>
      <string>en</string>
      <string>de</string>
    </array>
  </dict>
</plist>''';

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

IosNativeDirectory _getIosNativeDirectory({
  AppPackage? appPackage,
  GeneratorBuilder? generator,
}) {
  return IosNativeDirectory(
    appPackage: appPackage ?? getAppPackage(),
    generator: generator ?? (_) async => getMasonGenerator(),
  );
}

InfoPlistFile _getInfoPlistFile({
  IosNativeDirectory? iosNativeDirectory,
}) {
  return InfoPlistFile(
    iosNativeDirectory: iosNativeDirectory ?? getIosNativeDirectory(),
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

  group('IosNativeDirectory', () {
    setUpAll(() {
      registerFallbackValue(FakeDirectoryGeneratorTarget());
      registerFallbackValue(FakeLogger());
      registerFallbackValue(Platform.ios);
      registerFallbackValue(FakeMasonBundle());
    });

    test('.path', () {
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
          final iosNativeDirectory = _getIosNativeDirectory(
            appPackage: appPackage,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await iosNativeDirectory.create(
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
                  'app_package/path/ios',
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
          final iosNativeDirectory = _getIosNativeDirectory(
            appPackage: appPackage,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await iosNativeDirectory.create(
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
                  'app_package/path/ios',
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

      test(
        'completes successfully with correct output when language is not null',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.name()).thenReturn('my_project');
          final appPackage = getAppPackage();
          when(() => appPackage.path).thenReturn('app_package/path');
          when(() => appPackage.project).thenReturn(project);
          final generator = getMasonGenerator();
          final iosNativeDirectory = _getIosNativeDirectory(
            appPackage: appPackage,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await iosNativeDirectory.create(
            orgName: 'my.org',
            logger: logger,
            language: 'de',
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'app_package/path/ios',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'org_name': 'my.org',
                'language': 'de',
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );

      test(
        'uses correct bundle',
        withTempDir(() async {
          // Arrange
          final generator = getGeneratorBuilder();
          final iosNativeDirectory = _getIosNativeDirectory(
            generator: generator,
          );

          // Act
          await iosNativeDirectory.create(
            logger: FakeLogger(),
          );

          // Assert
          verify(() => generator(iosNativeDirectoryBundle)).called(1);
        }),
      );
    });

    test('.infoPlistFile', () {
      // Arrange
      final iosNativeDirectory = _getIosNativeDirectory();

      // Assert
      expect(
        iosNativeDirectory.infoPlistFile,
        isA<InfoPlistFile>().having(
          (infoPlistFile) => infoPlistFile.iosNativeDirectory,
          'iosNativeDirectory',
          iosNativeDirectory,
        ),
      );
    });
  });

  group('InfoPlistFile', () {
    setUpAll(() {
      registerFallbackValue(FakeLogger());
    });

    test('.path', () {
      // Arrange
      final iosNativeDirectory = getIosNativeDirectory();
      when(() => iosNativeDirectory.path)
          .thenReturn('ios_native_directory/path');
      final infoPlistFile = _getInfoPlistFile(
        iosNativeDirectory: iosNativeDirectory,
      );

      // Act + Assert
      expect(infoPlistFile.path, 'ios_native_directory/path/Runner/Info.plist');
    });

    group('.addLanguage()', () {
      test(
        'adds the corresponding language dict entry',
        withTempDir(() {
          // Arrange
          final infoPlistFile = _getInfoPlistFile();
          final file = File(infoPlistFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(infoPlistWithLocalizations);

          // Act
          infoPlistFile.addLanguage(language: 'de');

          // Assert
          expect(file.readAsStringSync(), infoPlistWithMoreLocalizations);
        }),
      );

      test(
        'adds the corresponding language no entries are present',
        withTempDir(() {
          // Arrange
          final infoPlistFile = _getInfoPlistFile();
          final file = File(infoPlistFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(infoPlistWithoutLocalizations);

          // Act
          infoPlistFile.addLanguage(language: 'en');

          // Assert
          expect(file.readAsStringSync(), infoPlistWithLocalizations);
        }),
      );

      test(
        'does nothing when the corresponding entry is already present',
        withTempDir(() {
          // Arrange
          final infoPlistFile = _getInfoPlistFile();
          final file = File(infoPlistFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(infoPlistWithoutLocalizations);

          // Act
          infoPlistFile.addLanguage(language: 'en');

          // Assert
          expect(file.readAsStringSync(), infoPlistWithLocalizations);
        }),
      );
    });

    group('.removeLanguage()', () {
      test(
        'removes the corresponding language dict entry',
        withTempDir(() {
          // Arrange
          final infoPlistFile = _getInfoPlistFile();
          final file = File(infoPlistFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(infoPlistWithMoreLocalizations);

          // Act
          infoPlistFile.removeLanguage(language: 'de');

          // Assert
          expect(file.readAsStringSync(), infoPlistWithLocalizations);
        }),
      );

      test(
        'does nothing when no entries are present',
        withTempDir(() {
          // Arrange
          final infoPlistFile = _getInfoPlistFile();
          final file = File(infoPlistFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(infoPlistWithoutLocalizations);

          // Act
          infoPlistFile.removeLanguage(language: 'en');

          // Assert
          expect(file.readAsStringSync(), infoPlistWithoutLocalizations);
        }),
      );

      test(
        'does nothing when no ',
        withTempDir(() {
          // Arrange
          final infoPlistFile = _getInfoPlistFile();
          final file = File(infoPlistFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(infoPlistWithoutLocalizations);

          // Act
          infoPlistFile.removeLanguage(language: 'en');

          // Assert
          expect(file.readAsStringSync(), infoPlistWithoutLocalizations);
        }),
      );
    });
  });
}
