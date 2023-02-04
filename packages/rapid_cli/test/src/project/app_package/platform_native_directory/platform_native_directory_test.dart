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
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

abstract class _GeneratorBuilder {
  Future<MasonGenerator> call(MasonBundle bundle);
}

class _MockAppPackage extends Mock implements AppPackage {}

class _MockProject extends Mock implements Project {}

class _MockGeneratorBuilder extends Mock implements _GeneratorBuilder {}

class _MockMasonGenerator extends Mock implements MasonGenerator {}

class _MockLogger extends Mock implements Logger {}

class _FakeDirectoryGeneratorTarget extends Fake
    implements DirectoryGeneratorTarget {}

class _FakeMasonBundle extends Fake implements MasonBundle {}

void main() {
  group('PlatformNativeDirectory', () {
    late Platform platform;

    late AppPackage appPackage;
    const appPackagePath = 'app/pack';
    late Project project;
    const projectName = 'foo_bar';

    late GeneratorBuilder generatorBuilder;
    late MasonGenerator generator;
    final generatedFiles = List.filled(
      23,
      const GeneratedFile.created(path: ''),
    );

    late PlatformNativeDirectory underTest;

    PlatformNativeDirectory platformNativeDirectory() =>
        PlatformNativeDirectory(
          platform,
          appPackage: appPackage,
          generator: generatorBuilder,
        );

    setUpAll(() {
      registerFallbackValue(_FakeDirectoryGeneratorTarget());
      registerFallbackValue(_FakeMasonBundle());
    });

    setUp(() {
      platform = Platform.android;

      appPackage = _MockAppPackage();
      project = _MockProject();
      when(() => project.name()).thenReturn(projectName);
      when(() => appPackage.path).thenReturn(appPackagePath);
      when(() => appPackage.project).thenReturn(project);

      generatorBuilder = _MockGeneratorBuilder();
      generator = _MockMasonGenerator();
      when(() => generator.id).thenReturn('generator_id');
      when(() => generator.description).thenReturn('generator description');
      when(
        () => generator.generate(
          any(),
          vars: any(named: 'vars'),
          logger: any(named: 'logger'),
        ),
      ).thenAnswer((_) async => generatedFiles);
      when(() => generatorBuilder(any())).thenAnswer((_) async => generator);

      underTest = platformNativeDirectory();
    });

    group('path', () {
      test('is correct', () {
        // Assert
        expect(
          underTest.path,
          '$appPackagePath/${platform.name}',
        );
      });
    });

    group('platform', () {
      test('is correct', () {
        // Assert
        expect(underTest.platform, platform);
      });
    });

    group('create', () {
      late String? description;
      late String? orgName;
      late Logger logger;

      setUp(() {
        description = null;
        orgName = null;
        logger = _MockLogger();
      });

      test(
          'completes successfully with correct output when description is not null',
          () async {
        // Arrange
        description = 'some desc';

        // Act
        await underTest.create(
          description: description,
          orgName: orgName,
          logger: logger,
        );

        // Assert
        verify(
          () => generator.generate(
            any(
              that: isA<DirectoryGeneratorTarget>().having(
                (g) => g.dir.path,
                'dir',
                '$appPackagePath/${platform.name}',
              ),
            ),
            vars: <String, dynamic>{
              'project_name': projectName,
              'description': description,
            },
            logger: logger,
          ),
        ).called(1);
      });

      test(
          'completes successfully with correct output when orgName is not null',
          () async {
        // Arrange
        orgName = 'some org name';

        // Act
        await underTest.create(
          description: description,
          orgName: orgName,
          logger: logger,
        );

        // Assert
        verify(
          () => generator.generate(
            any(
              that: isA<DirectoryGeneratorTarget>().having(
                (g) => g.dir.path,
                'dir',
                '$appPackagePath/${platform.name}',
              ),
            ),
            vars: <String, dynamic>{
              'project_name': projectName,
              'org_name': orgName,
            },
            logger: logger,
          ),
        ).called(1);
      });

      test('uses correct bundle (android)', () async {
        // Act
        await underTest.create(
          description: description,
          orgName: orgName,
          logger: logger,
        );

        // Assert
        verify(() => generatorBuilder(androidNativeDirectoryBundle)).called(1);
      });

      test('uses correct bundle (ios)', () async {
        // Arrange
        platform = Platform.ios;
        underTest = platformNativeDirectory();

        // Act
        await underTest.create(
          description: description,
          orgName: orgName,
          logger: logger,
        );

        // Assert
        verify(() => generatorBuilder(iosNativeDirectoryBundle)).called(1);
      });

      test('uses correct bundle (linux)', () async {
        // Arrange
        platform = Platform.linux;
        underTest = platformNativeDirectory();

        // Act
        await underTest.create(
          description: description,
          orgName: orgName,
          logger: logger,
        );

        // Assert
        verify(() => generatorBuilder(linuxNativeDirectoryBundle)).called(1);
      });

      test('uses correct bundle (macos)', () async {
        // Arrange
        platform = Platform.macos;
        underTest = platformNativeDirectory();

        // Act
        await underTest.create(
          description: description,
          orgName: orgName,
          logger: logger,
        );

        // Assert
        verify(() => generatorBuilder(macosNativeDirectoryBundle)).called(1);
      });

      test('uses correct bundle (web)', () async {
        // Arrange
        platform = Platform.web;
        underTest = platformNativeDirectory();

        // Act
        await underTest.create(
          description: description,
          orgName: orgName,
          logger: logger,
        );

        // Assert
        verify(() => generatorBuilder(webNativeDirectoryBundle)).called(1);
      });

      test('uses correct bundle (windows)', () async {
        // Arrange
        platform = Platform.windows;
        underTest = platformNativeDirectory();

        // Act
        await underTest.create(
          description: description,
          orgName: orgName,
          logger: logger,
        );

        // Assert
        verify(() => generatorBuilder(windowsNativeDirectoryBundle)).called(1);
      });
    });
  });
}
