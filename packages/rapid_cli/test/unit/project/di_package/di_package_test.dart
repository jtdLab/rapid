import 'dart:io';

import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/project/di_package/di_package.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../common.dart';
import '../../mocks.dart';

const injectionFileWithInitialPackages = '''
import 'package:injectable/injectable.dart';
import 'package:kuk_abc_infrastructure/kuk_abc_infrastructure.dart';
import 'package:kuk_abc_logging/kuk_abc_logging.dart';

import 'di_container.dart';
import 'injection.config.dart';

/// Setup injectable package which generates dependency injection code.
///
/// For more info see: https://pub.dev/packages/injectable
@InjectableInit(
  externalPackageModules: [
    KukAbcLoggingPackageModule,
    KukAbcInfrastructurePackageModule,
  ],
)
void configureDependencies(String environment, String platform) => getIt.init(
      environmentFilter: NoEnvOrContainsAny({environment, platform}),
    );
''';

const injectionFileWithPackages = '''
import 'package:injectable/injectable.dart';
import 'package:kuk_abc_android_home_page/kuk_abc_android_home_page.dart';
import 'package:kuk_abc_infrastructure/kuk_abc_infrastructure.dart';
import 'package:kuk_abc_logging/kuk_abc_logging.dart';

import 'di_container.dart';
import 'injection.config.dart';

/// Setup injectable package which generates dependency injection code.
///
/// For more info see: https://pub.dev/packages/injectable
@InjectableInit(
  externalPackageModules: [
    KukAbcLoggingPackageModule,
    KukAbcInfrastructurePackageModule,
    KukAbcAndroidHomePagePackageModule,
  ],
)
void configureDependencies(String environment, String platform) => getIt.init(
      environmentFilter: NoEnvOrContainsAny({environment, platform}),
    );
''';

DiPackage _getDiPackage({
  Project? project,
  PubspecFile? pubspecFile,
  InjectionFile? injectionFile,
  GeneratorBuilder? generator,
}) {
  return DiPackage(
    pubspecFile: pubspecFile ?? getPubspecFile(),
    injectionFile: injectionFile ?? getInjectionFile(),
    project: project ?? getProject(),
    generator: generator ?? (_) async => getMasonGenerator(),
  );
}

InjectionFile _getInjectionFile({
  required DiPackage diPackage,
}) {
  return InjectionFile(
    diPackage: diPackage,
  );
}

void main() {
  group('DiPackage', () {
    setUpAll(() {
      registerFallbackValue(FakeDirectoryGeneratorTarget());
    });

    test('.path', () {
      // Arrange
      final project = getProject();
      when(() => project.path).thenReturn('project/path');
      when(() => project.name()).thenReturn('my_project');
      final diPackage = _getDiPackage(project: project);

      // Act + Assert
      expect(diPackage.path, 'project/path/packages/my_project/my_project_di');
    });

    group('.create()', () {
      test('completes successfully with correct output', () async {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final generator = getMasonGenerator();
        final diPackage = _getDiPackage(
          project: project,
          generator: (_) async => generator,
        );

        // Act
        final logger = FakeLogger();
        await diPackage.create(
          android: true,
          ios: true,
          linux: true,
          macos: false,
          web: false,
          windows: false,
          logger: logger,
        );

        // Assert
        verify(
          () => generator.generate(
            any(
              that: isA<DirectoryGeneratorTarget>().having(
                (g) => g.dir.path,
                'dir',
                'project/path/packages/my_project/my_project_di',
              ),
            ),
            vars: <String, dynamic>{
              'project_name': 'my_project',
              'android': true,
              'ios': true,
              'linux': true,
              'macos': false,
              'web': false,
              'windows': false,
            },
            logger: logger,
          ),
        ).called(1);
      });
    });

    group('.registerCustomFeaturePackage()', () {
      test('completes successfully with correct output', () async {
        // Arrange
        final pubspecFile = getPubspecFile();
        final injectionFile = getInjectionFile();
        final diPackage = _getDiPackage(
          pubspecFile: pubspecFile,
          injectionFile: injectionFile,
        );

        // Act
        final customFeaturePackage = getPlatformCustomFeaturePackage();
        when(() => customFeaturePackage.packageName()).thenReturn('my_feature');
        final logger = FakeLogger();
        await diPackage.registerCustomFeaturePackage(
          customFeaturePackage,
          logger: logger,
        );

        // Assert
        verify(() => pubspecFile.setDependency('my_feature'));
        verify(
          () => injectionFile.addCustomFeaturePackage(customFeaturePackage),
        );
      });
    });

    group('.unregisterCustomFeaturePackage()', () {
      test('completes successfully with correct output', () async {
        // Arrange
        final pubspecFile = getPubspecFile();
        final injectionFile = getInjectionFile();
        final diPackage = _getDiPackage(
          pubspecFile: pubspecFile,
          injectionFile: injectionFile,
        );

        // Act
        final customFeaturePackage1 = getPlatformCustomFeaturePackage();
        when(() => customFeaturePackage1.packageName())
            .thenReturn('my_feature_one');
        final customFeaturePackage2 = getPlatformCustomFeaturePackage();
        when(() => customFeaturePackage2.packageName())
            .thenReturn('my_feature_two');
        final logger = FakeLogger();
        await diPackage.unregisterCustomFeaturePackages(
          [customFeaturePackage1, customFeaturePackage2],
          logger: logger,
        );

        // Assert
        verify(() => pubspecFile.removeDependency('my_feature_one'));
        verify(
          () => injectionFile.removeCustomFeaturePackage(customFeaturePackage1),
        );
        verify(() => pubspecFile.removeDependency('my_feature_two'));
        verify(
          () => injectionFile.removeCustomFeaturePackage(customFeaturePackage2),
        );
      });
    });
  });

  group('InjectionFile', () {
    test('.path', () {
      // Arrange
      final diPackage = getDiPackage();
      when(() => diPackage.path).thenReturn('di_package/path');
      final injectionFile = _getInjectionFile(diPackage: diPackage);

      // Act + Assert
      expect(
        injectionFile.path,
        'di_package/path/lib/src/injection.dart',
      );
    });

    group('.addCustomFeaturePackage()', () {
      test('add import and external package module correctly', () {
        // Arrange
        final diPackage = getDiPackage();
        when(() => diPackage.path).thenReturn(getTempDir().path);
        final injectionFile = _getInjectionFile(diPackage: diPackage);
        final file = File(injectionFile.path)
          ..createSync(recursive: true)
          ..writeAsStringSync(injectionFileWithInitialPackages);

        // Act
        final customFeaturePackage = getPlatformCustomFeaturePackage();
        when(() => customFeaturePackage.packageName())
            .thenReturn('kuk_abc_android_home_page');
        injectionFile.addCustomFeaturePackage(customFeaturePackage);

        // Assert
        expect(file.readAsStringSync(), injectionFileWithPackages);
      });

      test('do nothing when package already exists', () {
        // Arrange
        final diPackage = getDiPackage();
        when(() => diPackage.path).thenReturn(getTempDir().path);
        final injectionFile = _getInjectionFile(diPackage: diPackage);
        final file = File(injectionFile.path)
          ..createSync(recursive: true)
          ..writeAsStringSync(injectionFileWithPackages);

        // Act
        final customFeaturePackage = getPlatformCustomFeaturePackage();
        when(() => customFeaturePackage.packageName())
            .thenReturn('kuk_abc_android_home_page');
        injectionFile.addCustomFeaturePackage(customFeaturePackage);

        // Assert
        expect(file.readAsStringSync(), injectionFileWithPackages);
      });
    });

    group('.removeCustomFeaturePackage()', () {
      test('remove import and external package module correctly', () {
        // Arrange
        final diPackage = getDiPackage();
        when(() => diPackage.path).thenReturn(getTempDir().path);
        final injectionFile = _getInjectionFile(diPackage: diPackage);
        final file = File(injectionFile.path)
          ..createSync(recursive: true)
          ..writeAsStringSync(injectionFileWithPackages);

        // Act
        final customFeaturePackage = getPlatformCustomFeaturePackage();
        when(() => customFeaturePackage.packageName())
            .thenReturn('kuk_abc_android_home_page');
        injectionFile.removeCustomFeaturePackage(customFeaturePackage);

        // Assert
        expect(file.readAsStringSync(), injectionFileWithInitialPackages);
      });

      test('do nothing when package does not exist', () {
        // Arrange
        final diPackage = getDiPackage();
        when(() => diPackage.path).thenReturn(getTempDir().path);
        final injectionFile = _getInjectionFile(diPackage: diPackage);
        final file = File(injectionFile.path)
          ..createSync(recursive: true)
          ..writeAsStringSync(injectionFileWithInitialPackages);

        // Act
        final customFeaturePackage = getPlatformCustomFeaturePackage();
        when(() => customFeaturePackage.packageName())
            .thenReturn('kuk_abc_android_home_page');
        injectionFile.removeCustomFeaturePackage(customFeaturePackage);

        // Assert
        expect(file.readAsStringSync(), injectionFileWithInitialPackages);
      });
    });
  });
}
