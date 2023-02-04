import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/environment.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/app_package/app_package.dart';
import 'package:rapid_cli/src/project/app_package/platform_native_directory/platform_native_directory.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_directory.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_feature_package/platform_feature_package.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../mocks.dart';

extension on Environment {
  String get shortName {
    switch (this) {
      case Environment.development:
        return 'dev';
      case Environment.test:
        return 'test';
      case Environment.production:
        return 'prod';
    }
  }
}

const mainFileNoSetup = '''
import 'package:rapid/rapid.dart';

void main() => runOnPlatform();
''';

String mainFileWithAndroidSetup(Environment env) => '''
import 'package:ab_cd_android_app/ab_cd_android_app.dart' as android;
import 'package:ab_cd_di/ab_cd_di.dart';
import 'package:ab_cd_logging/ab_cd_logging.dart';
import 'package:flutter/widgets.dart';
import 'package:rapid/rapid.dart';

import 'bootstrap.dart';
import 'router_observer.dart';

void main() => runOnPlatform(
      android: runAndroidApp,
    );

Future<void> runAndroidApp() async {
  configureDependencies(Environment.${env.shortName}, Platform.android);
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: add more android ${env.name} setup here

  final logger = getIt<AbCdLogger>();
  final app = android.App(
    routerObserverBuilder: () => [
      AbCdRouterObserver(logger),
    ],
  );
  await bootstrap(app, logger);
}
''';

String mainFileWithWebSetup(Environment env) => '''
import 'package:ab_cd_di/ab_cd_di.dart';
import 'package:ab_cd_logging/ab_cd_logging.dart';
import 'package:ab_cd_web_app/ab_cd_web_app.dart' as web;
import 'package:flutter/widgets.dart';
import 'package:rapid/rapid.dart';
import 'package:url_strategy/url_strategy.dart';

import 'bootstrap.dart';
import 'router_observer.dart';

void main() => runOnPlatform(
      web: runWebApp,
    );

Future<void> runWebApp() async {
  configureDependencies(Environment.${env.shortName}, Platform.web);
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: add more web ${env.name} setup here

  final logger = getIt<AbCdLogger>();
  final app = web.App(
    routerObserverBuilder: () => [
      AbCdRouterObserver(logger),
    ],
  );
  await bootstrap(app, logger);
}
''';

String mainFileWithWebAndAndroidSetup(Environment env) => '''
import 'package:ab_cd_android_app/ab_cd_android_app.dart' as android;
import 'package:ab_cd_di/ab_cd_di.dart';
import 'package:ab_cd_logging/ab_cd_logging.dart';
import 'package:ab_cd_web_app/ab_cd_web_app.dart' as web;
import 'package:flutter/widgets.dart';
import 'package:rapid/rapid.dart';
import 'package:url_strategy/url_strategy.dart';

import 'bootstrap.dart';
import 'router_observer.dart';

void main() => runOnPlatform(
      web: runWebApp,
      android: runAndroidApp,
    );

Future<void> runWebApp() async {
  configureDependencies(Environment.${env.shortName}, Platform.web);
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: add more web ${env.name} setup here

  final logger = getIt<AbCdLogger>();
  final app = web.App(
    routerObserverBuilder: () => [
      AbCdRouterObserver(logger),
    ],
  );
  await bootstrap(app, logger);
}

Future<void> runAndroidApp() async {
  configureDependencies(Environment.${env.shortName}, Platform.android);
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: add more android ${env.name} setup here

  final logger = getIt<AbCdLogger>();
  final app = android.App(
    routerObserverBuilder: () => [
      AbCdRouterObserver(logger),
    ],
  );
  await bootstrap(app, logger);
}
''';

void main() {
  group('AppPackage', () {
    final cwd = Directory.current;

    late Project project;
    const projectPath = 'foo/bar';
    const projectName = 'foo_bar';
    late PlatformDirectoryBuilder platformDirectoryBuilder;
    late PlatformDirectory platformDirectory;
    late PlatformAppFeaturePackage appFeaturePackage;
    const appFeaturePackagePackageName = 'my_app_feature';

    late PubspecFile pubspecFile;
    const appPackagePackageName = 'my_app_package';

    late PlatformNativeDirectoryBuilder platformNativeDirectoryBuilder;
    late PlatformNativeDirectory platformNativeDirectory;

    late Set<MainFile> mainFiles;
    late MainFile mainFile1;
    late MainFile mainFile2;

    late MasonGenerator generator;
    final generatedFiles = List.filled(
      23,
      const GeneratedFile.created(path: ''),
    );

    late AppPackage appPackage;

    setUpAll(() {
      registerFallbackValue(FakeLogger());
      registerFallbackValue(FakeDirectoryGeneratorTarget());
      registerFallbackValue(Platform.android);
    });

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      project = MockProject();
      platformDirectoryBuilder = MockPlatformDirectoryBuilder();
      platformDirectory = MockPlatformDirectory();
      appFeaturePackage = MockPlatformAppFeaturePackage();
      when(() => appFeaturePackage.packageName())
          .thenReturn(appFeaturePackagePackageName);
      when(() => platformDirectory.appFeaturePackage)
          .thenReturn(appFeaturePackage);
      when(() => platformDirectoryBuilder(platform: any(named: 'platform')))
          .thenReturn(platformDirectory);

      when(() => project.path).thenReturn(projectPath);
      when(() => project.name()).thenReturn(projectName);
      when(() => project.platformDirectory)
          .thenReturn(platformDirectoryBuilder);

      pubspecFile = MockPubspecFile();
      when(() => pubspecFile.name).thenReturn(appPackagePackageName);

      platformNativeDirectoryBuilder = MockPlatformNativeDirectoryBuilder();
      platformNativeDirectory = MockPlatformNativeDirectory();
      when(
        () => platformNativeDirectory.create(
          description: any(named: 'description'),
          orgName: any(named: 'orgName'),
          logger: any(named: 'logger'),
        ),
      ).thenAnswer((_) async {});
      when(
        () => platformNativeDirectoryBuilder(platform: any(named: 'platform')),
      ).thenReturn(platformNativeDirectory);

      mainFile1 = MockMainFile();
      mainFile2 = MockMainFile();
      mainFiles = {mainFile1, mainFile2};

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

      appPackage = AppPackage(
        project: project,
        pubspecFile: pubspecFile,
        platformNativeDirectory: platformNativeDirectoryBuilder,
        mainFiles: mainFiles,
        generator: (_) async => generator,
      );
    });

    tearDown(() {
      Directory.current = cwd;
    });

    group('path', () {
      test('is correct', () {
        // Assert
        expect(
          appPackage.path,
          '$projectPath/packages/$projectName/$projectName',
        );
      });
    });

    group('create', () {
      late String description;
      late String orgName;
      late bool android;
      late bool ios;
      late bool linux;
      late bool macos;
      late bool web;
      late bool windows;
      late Logger logger;

      setUp(() {
        description = 'some desc';
        orgName = 'com.ex.org';
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
        await appPackage.create(
          description: description,
          orgName: orgName,
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
                '$projectPath/packages/$projectName/$projectName',
              ),
            ),
            vars: <String, dynamic>{
              'project_name': projectName,
              'description': description,
              'android': android,
              'ios': ios,
              'linux': linux,
              'macos': macos,
              'web': web,
              'windows': windows,
              'none': false,
            },
            logger: logger,
          ),
        ).called(1);
        verify(() => platformNativeDirectoryBuilder(platform: Platform.android))
            .called(1);
        verify(() => platformNativeDirectoryBuilder(platform: Platform.linux))
            .called(1);
        verify(() => platformNativeDirectoryBuilder(platform: Platform.windows))
            .called(1);
        verifyNever(
            () => platformNativeDirectoryBuilder(platform: Platform.ios));
        verifyNever(
            () => platformNativeDirectoryBuilder(platform: Platform.macos));
        verifyNever(
            () => platformNativeDirectoryBuilder(platform: Platform.web));
        verify(
          () => platformNativeDirectory.create(
            description: description,
            orgName: orgName,
            logger: logger,
          ),
        ).called(3);
        verifyNever(
          () => platformNativeDirectory.create(
            description: description,
            orgName: orgName,
            logger: logger,
          ),
        );
      });
    });

    group('addPlatform', () {
      late Platform platform;
      late String? description;
      late String? orgName;
      late Logger logger;

      setUp(() {
        platform = Platform.android;
        description = 'some desc';
        orgName = 'com.ex.org';
        logger = MockLogger();
      });

      test('completes successfully with correct output', () async {
        // Act
        await appPackage.addPlatform(
          platform,
          description: description,
          orgName: orgName,
          logger: logger,
        );

        // Assert
        verify(() => project.platformDirectory(platform: platform)).called(1);
        verify(() => pubspecFile.setDependency(appFeaturePackagePackageName))
            .called(1);
        verify(() => platformNativeDirectoryBuilder(platform: platform))
            .called(1);
        verify(
          () => platformNativeDirectory.create(
            description: description,
            orgName: orgName,
            logger: logger,
          ),
        ).called(1);
        verify(() => mainFile1.addSetupForPlatform(platform)).called(1);
        verify(() => mainFile2.addSetupForPlatform(platform)).called(1);
        // TODO assert logging
      });
    });

    group('removePlatform', () {
      late Platform platform;
      late Logger logger;

      setUp(() {
        platform = Platform.android;
        logger = MockLogger();
      });

      test('completes successfully with correct output', () async {
        // Act
        await appPackage.removePlatform(
          platform,
          logger: logger,
        );

        // Assert
        verify(() => project.platformDirectory(platform: platform)).called(1);
        verify(() => pubspecFile.removeDependency(appFeaturePackagePackageName))
            .called(1);
        verify(() => platformNativeDirectoryBuilder(platform: platform))
            .called(1);
        verify(
          () => platformNativeDirectory.delete(
            logger: logger,
          ),
        ).called(1);
        verify(() => mainFile1.removeSetupForPlatform(platform)).called(1);
        verify(() => mainFile2.removeSetupForPlatform(platform)).called(1);
        // TODO assert logging
      });
    });
  });

  group('MainFile', () {
    final cwd = Directory.current;

    late Environment environment;

    late AppPackage appPackage;
    const appPackagePath = 'foo/bar/baz';
    late Project project;
    const projectName = 'ab_cd';

    late MainFile mainFile;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      environment = Environment.development;

      appPackage = MockAppPackage();
      project = MockProject();
      when(() => project.name()).thenReturn(projectName);
      when(() => appPackage.path).thenReturn(appPackagePath);
      when(() => appPackage.project).thenReturn(project);

      mainFile = MainFile(
        environment,
        appPackage: appPackage,
      );

      File(mainFile.path).createSync(recursive: true);
    });

    tearDown(() {
      Directory.current = cwd;
    });

    group('path', () {
      test('is correct', () {
        // Assert
        expect(
          mainFile.path,
          '$appPackagePath/lib/main_${environment.name}.dart',
        );
      });
    });

    group('addSetupForPlatform', () {
      test(
          'add platform setup correctly when no other platform setups exist (dev)',
          () {
        // Arrange
        final file = File(mainFile.path);
        file.writeAsStringSync(mainFileNoSetup);

        // Act
        mainFile.addSetupForPlatform(Platform.android);

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, mainFileWithAndroidSetup(environment));
      });

      test(
          'add platform setup correctly when no other platform setups exist (web) (dev)',
          () {
        // Arrange
        final file = File(mainFile.path);
        file.writeAsStringSync(mainFileNoSetup);

        // Act
        mainFile.addSetupForPlatform(Platform.web);

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, mainFileWithWebSetup(environment));
      });

      test(
          'add platform setup correctly when other platform setups exist (dev)',
          () {
        // Arrange
        final file = File(mainFile.path);
        file.writeAsStringSync(mainFileWithWebSetup(environment));

        // Act
        mainFile.addSetupForPlatform(Platform.android);

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, mainFileWithWebAndAndroidSetup(environment));
      });

      test('does nothing when setup for platform already exists (dev)', () {
        // Arrange
        final file = File(mainFile.path);
        file.writeAsStringSync(mainFileWithAndroidSetup(environment));

        // Act
        mainFile.addSetupForPlatform(Platform.android);

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, mainFileWithAndroidSetup(environment));
      });

      test(
          'add platform setup correctly when no other platform setups exist (test)',
          () {
        // Arrange
        environment = Environment.test;
        mainFile = MainFile(environment, appPackage: appPackage);
        final file = File(mainFile.path);
        file.writeAsStringSync(mainFileNoSetup);

        // Act
        mainFile.addSetupForPlatform(Platform.android);

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, mainFileWithAndroidSetup(environment));
      });

      test(
          'add platform setup correctly when no other platform setups exist (web) (test)',
          () {
        // Arrange
        environment = Environment.test;
        mainFile = MainFile(environment, appPackage: appPackage);
        final file = File(mainFile.path);
        file.writeAsStringSync(mainFileNoSetup);

        // Act
        mainFile.addSetupForPlatform(Platform.web);

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, mainFileWithWebSetup(environment));
      });

      test(
          'add platform setup correctly when other platform setups exist (test)',
          () {
        // Arrange
        environment = Environment.test;
        mainFile = MainFile(environment, appPackage: appPackage);
        final file = File(mainFile.path);
        file.writeAsStringSync(mainFileWithWebSetup(environment));

        // Act
        mainFile.addSetupForPlatform(Platform.android);

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, mainFileWithWebAndAndroidSetup(environment));
      });

      test('does nothing when setup for platform already exists (test)', () {
        // Arrange
        environment = Environment.test;
        final file = File(mainFile.path);
        file.writeAsStringSync(mainFileWithAndroidSetup(environment));

        // Act
        mainFile.addSetupForPlatform(Platform.android);

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, mainFileWithAndroidSetup(environment));
      });

      test(
          'add platform setup correctly when no other platform setups exist (prod)',
          () {
        // Arrange
        environment = Environment.production;
        mainFile = MainFile(environment, appPackage: appPackage);
        final file = File(mainFile.path);
        file.writeAsStringSync(mainFileNoSetup);

        // Act
        mainFile.addSetupForPlatform(Platform.android);

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, mainFileWithAndroidSetup(environment));
      });

      test(
          'add platform setup correctly when no other platform setups exist (web) (prod)',
          () {
        // Arrange
        environment = Environment.production;
        mainFile = MainFile(environment, appPackage: appPackage);
        final file = File(mainFile.path);
        file.writeAsStringSync(mainFileNoSetup);

        // Act
        mainFile.addSetupForPlatform(Platform.web);

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, mainFileWithWebSetup(environment));
      });

      test(
          'add platform setup correctly when other platform setups exist (prod)',
          () {
        // Arrange
        environment = Environment.production;
        mainFile = MainFile(environment, appPackage: appPackage);
        final file = File(mainFile.path);
        file.writeAsStringSync(mainFileWithWebSetup(environment));

        // Act
        mainFile.addSetupForPlatform(Platform.android);

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, mainFileWithWebAndAndroidSetup(environment));
      });

      test('does nothing when setup for platform already exists (prod)', () {
        // Arrange
        environment = Environment.production;
        final file = File(mainFile.path);
        file.writeAsStringSync(mainFileWithAndroidSetup(environment));

        // Act
        mainFile.addSetupForPlatform(Platform.android);

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, mainFileWithAndroidSetup(environment));
      });
    });

    group('removeSetupForPlatform', () {
      test('does nothing when no other platform setups exist', () {
        // Arrange
        final file = File(mainFile.path);
        file.writeAsStringSync(mainFileNoSetup);

        // Act
        mainFile.removeSetupForPlatform(Platform.android);

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, mainFileNoSetup);
      });

      test('remove platform setup correctly when platform exists', () {
        // Arrange
        final file = File(mainFile.path);
        file.writeAsStringSync(mainFileWithAndroidSetup(environment));

        // Act
        mainFile.removeSetupForPlatform(Platform.android);

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, mainFileNoSetup);
      });

      test('remove platform setup correctly when platform exists (web)', () {
        // Arrange
        final file = File(mainFile.path);
        file.writeAsStringSync(mainFileWithWebSetup(environment));

        // Act
        mainFile.removeSetupForPlatform(Platform.web);

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, mainFileNoSetup);
      });

      test('remove platform setup correctly when other platform setups exist',
          () {
        // Arrange
        final file = File(mainFile.path);
        file.writeAsStringSync(mainFileWithWebAndAndroidSetup(environment));

        // Act
        mainFile.removeSetupForPlatform(Platform.android);

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, mainFileWithWebSetup(environment));
      });
    });
  });
}
