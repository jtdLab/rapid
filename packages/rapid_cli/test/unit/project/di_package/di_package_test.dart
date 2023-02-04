import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/project/di_package/di_package.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_feature_package/platform_feature_package.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'dart:io';

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

const injectionFileWithMorePackages = '''
import 'package:injectable/injectable.dart';
import 'package:kuk_abc_android_home_page/kuk_abc_android_home_page.dart';
import 'package:kuk_abc_infrastructure/kuk_abc_infrastructure.dart';
import 'package:kuk_abc_logging/kuk_abc_logging.dart';
import 'package:kuk_abc_web_my_page/kuk_abc_web_my_page.dart';

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
    KukAbcWebMyPagePackageModule,
  ],
)
void configureDependencies(String environment, String platform) => getIt.init(
      environmentFilter: NoEnvOrContainsAny({environment, platform}),
    );
''';

void main() {
  group('DiPackage', () {
    late Project project;
    const projectName = 'foo_bar';
    const projectPath = 'foo/bar';

    late PubspecFile pubspecFile;

    late InjectionFile injectionFile;

    late MasonGenerator generator;
    final generatedFiles = List.filled(
      23,
      const GeneratedFile.created(path: ''),
    );

    late DiPackage diPackage;

    setUpAll(() {
      registerFallbackValue(FakeDirectoryGeneratorTarget());
    });

    setUp(() {
      project = MockProject();
      when(() => project.name()).thenReturn(projectName);
      when(() => project.path).thenReturn(projectPath);

      pubspecFile = MockPubspecFile();

      injectionFile = MockInjectionFile();

      generator = MockMasonGenerator();
      when(() => generator.id).thenReturn('generator_id');
      when(() => generator.description).thenReturn('generator description');
      when(
        () => generator.generate(
          any(),
          vars: any(named: 'vars'),
          logger: any(named: 'logger'),
        ),
      ).thenAnswer((_) async => generatedFiles);

      diPackage = DiPackage(
        project: project,
        pubspecFile: pubspecFile,
        injectionFile: injectionFile,
        generator: (_) async => generator,
      );

      Directory(diPackage.path).createSync(recursive: true);
    });

    group('path', () {
      test('is correct', () {
        // Assert
        expect(
          diPackage.path,
          '$projectPath/packages/$projectName/${projectName}_di',
        );
      });
    });

    group('create', () {
      late bool android;
      late bool ios;
      late bool linux;
      late bool macos;
      late bool web;
      late bool windows;
      late Logger logger;

      setUp(() {
        android = true;
        ios = false;
        linux = true;
        macos = false;
        web = false;
        windows = true;
        logger = MockLogger();
      });

      test('completes successfully with correct output', () async {
        // Act
        await diPackage.create(
          android: android,
          ios: ios,
          linux: linux,
          macos: macos,
          web: web,
          windows: windows,
          logger: logger,
        );

        // Assert
        verify(
          () => generator.generate(
            any(
              that: isA<DirectoryGeneratorTarget>().having(
                (g) => g.dir.path,
                'dir',
                '$projectPath/packages/$projectName/${projectName}_di',
              ),
            ),
            vars: <String, dynamic>{
              'project_name': projectName,
              'android': android,
              'ios': ios,
              'linux': linux,
              'macos': macos,
              'web': web,
              'windows': windows,
            },
            logger: logger,
          ),
        ).called(1);
      });
    });

    group('registerCustomFeaturePackage', () {
      late PlatformCustomFeaturePackage customFeaturePackage;
      const customFeaturePackageName = 'my_feature';
      late Logger logger;

      setUp(() {
        customFeaturePackage = MockPlatformCustomFeaturePackage();
        when(() => customFeaturePackage.packageName())
            .thenReturn(customFeaturePackageName);
        logger = MockLogger();
      });

      test('completes successfully with correct output', () async {
        // Act
        await diPackage.registerCustomFeaturePackage(
          customFeaturePackage,
          logger: logger,
        );

        // Assert
        verify(() => pubspecFile.setDependency(customFeaturePackageName));
        verify(
          () => injectionFile.addCustomFeaturePackage(customFeaturePackage),
        );
      });
    });

    group('unregisterCustomFeaturePackage', () {
      late List<PlatformCustomFeaturePackage> customFeaturePackages;
      late PlatformCustomFeaturePackage customFeaturePackage1;
      const customFeaturePackageName1 = 'my_feature1';
      late PlatformCustomFeaturePackage customFeaturePackage2;
      const customFeaturePackageName2 = 'my_feature2';

      late Logger logger;

      setUp(() {
        customFeaturePackage1 = MockPlatformCustomFeaturePackage();
        when(() => customFeaturePackage1.packageName())
            .thenReturn(customFeaturePackageName1);
        customFeaturePackage2 = MockPlatformCustomFeaturePackage();
        when(() => customFeaturePackage2.packageName())
            .thenReturn(customFeaturePackageName2);
        customFeaturePackages = [
          customFeaturePackage1,
          customFeaturePackage2,
        ];

        logger = MockLogger();
      });

      test('completes successfully with correct output', () async {
        // Act
        await diPackage.unregisterCustomFeaturePackages(
          customFeaturePackages,
          logger: logger,
        );

        // Assert
        verify(() => pubspecFile.removeDependency(customFeaturePackageName1));
        verify(
          () => injectionFile.removeCustomFeaturePackage(customFeaturePackage1),
        );
        verify(() => pubspecFile.removeDependency(customFeaturePackageName2));
        verify(
          () => injectionFile.removeCustomFeaturePackage(customFeaturePackage2),
        );
      });
    });
  });

  group('InjectionFile', () {
    final cwd = Directory.current;

    late DiPackage diPackage;
    const diPackagePath = 'foo/bar/baz';

    late InjectionFile injectionFile;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      diPackage = MockDiPackage();
      when(() => diPackage.path).thenReturn(diPackagePath);

      injectionFile = InjectionFile(diPackage: diPackage);

      File(injectionFile.path).createSync(recursive: true);
    });

    tearDown(() {
      Directory.current = cwd;
    });

    group('path', () {
      test('is correct', () {
        // Assert
        expect(
          injectionFile.path,
          '$diPackagePath/lib/src/injection.dart',
        );
      });
    });

    group('addCustomFeaturePackage', () {
      late PlatformCustomFeaturePackage customFeaturePackage;
      late String customFeaturePackageName;

      setUp(() {
        customFeaturePackage = MockPlatformCustomFeaturePackage();
      });

      test('add import and external package module correctly', () {
        // Arrange
        customFeaturePackageName = 'kuk_abc_android_home_page';
        when(() => customFeaturePackage.packageName())
            .thenReturn(customFeaturePackageName);
        final file = File(injectionFile.path);
        file.writeAsStringSync(injectionFileWithInitialPackages);

        // Act
        injectionFile.addCustomFeaturePackage(customFeaturePackage);

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, injectionFileWithPackages);
      });

      test(
          'add import and external package module correctly when package does not exists',
          () {
        // Arrange
        customFeaturePackageName = 'kuk_abc_web_my_page';
        when(() => customFeaturePackage.packageName())
            .thenReturn(customFeaturePackageName);

        final file = File(injectionFile.path);
        file.writeAsStringSync(injectionFileWithPackages);

        // Act
        injectionFile.addCustomFeaturePackage(customFeaturePackage);

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, injectionFileWithMorePackages);
      });

      test('does nothing when package already exists', () {
        // Arrange
        customFeaturePackageName = 'kuk_abc_web_my_page';
        when(() => customFeaturePackage.packageName())
            .thenReturn(customFeaturePackageName);

        final file = File(injectionFile.path);
        file.writeAsStringSync(injectionFileWithMorePackages);

        // Act
        injectionFile.addCustomFeaturePackage(customFeaturePackage);

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, injectionFileWithMorePackages);
      });
    });

    group('removeCustomFeaturePackage', () {
      late PlatformCustomFeaturePackage customFeaturePackage;
      late String customFeaturePackageName;

      setUp(() {
        customFeaturePackage = MockPlatformCustomFeaturePackage();
      });

      test('remove import and external package module correctly', () {
        // Arrange
        customFeaturePackageName = 'kuk_abc_android_home_page';
        when(() => customFeaturePackage.packageName())
            .thenReturn(customFeaturePackageName);

        final file = File(injectionFile.path);
        file.writeAsStringSync(injectionFileWithPackages);

        // Act
        injectionFile.removeCustomFeaturePackage(customFeaturePackage);

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, injectionFileWithInitialPackages);
      });

      test(
          'remove import and external package module correctly when packages exist',
          () {
        // Arrange
        customFeaturePackageName = 'kuk_abc_web_my_page';
        when(() => customFeaturePackage.packageName())
            .thenReturn(customFeaturePackageName);

        final file = File(injectionFile.path);
        file.writeAsStringSync(injectionFileWithMorePackages);

        // Act
        injectionFile.removeCustomFeaturePackage(customFeaturePackage);

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, injectionFileWithPackages);
      });

      test('does nothing when package does not exist', () {
        // Arrange
        customFeaturePackageName = 'kuk_abc_web_my_page';
        when(() => customFeaturePackage.packageName())
            .thenReturn(customFeaturePackageName);

        final file = File(injectionFile.path);
        file.writeAsStringSync(injectionFileWithPackages);

        // Act
        injectionFile.removeCustomFeaturePackage(customFeaturePackage);

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, injectionFileWithPackages);
      });
    });
  });
}
