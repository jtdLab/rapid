import 'dart:io';

import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/environment.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/app_package/app_package.dart';
import 'package:rapid_cli/src/project/app_package/app_package_impl.dart';
import 'package:rapid_cli/src/project/app_package/platform_native_directory/platform_native_directory.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../common.dart';
import '../../mocks.dart';

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

AppPackage _getAppPackage({
  Project? project,
  PubspecFile? pubspecFile,
  PlatformNativeDirectoryBuilder? platformNativeDirectoryBuilder,
  Set<MainFile>? mainFiles,
  GeneratorBuilder? generator,
}) {
  return AppPackage(
    project: project ?? getProject(),
    pubspecFile: pubspecFile ?? getPubspecFile(),
    platformNativeDirectory: platformNativeDirectoryBuilder,
    mainFiles: mainFiles ?? {},
    generator: generator ?? (_) async => getMasonGenerator(),
  );
}

MainFile _getMainFile(
  Environment environment, {
  required AppPackage appPackage,
}) {
  return MainFile(
    environment,
    appPackage: appPackage,
  );
}

void main() {
  group('AppPackage', () {
    setUpAll(() {
      registerFallbackValue(FakeLogger());
      registerFallbackValue(FakeDirectoryGeneratorTarget());
      registerFallbackValue(Platform.android);
      registerFallbackValue(FakePlatformCustomFeaturePackage());
    });

    test('.path', () {
      // Arrange
      final project = getProject();
      when(() => project.path).thenReturn('project/path');
      when(() => project.name()).thenReturn('my_project');
      final appPackage = _getAppPackage(project: project);

      // Assert
      expect(
        appPackage.path,
        'project/path/packages/my_project/my_project',
      );
    });

    test('.platformNativeDirectory', () {
      // Arrange
      final appPackage = _getAppPackage();

      // Assert
      expect(
        appPackage.platformNativeDirectory,
        isA<PlatformNativeDirectoryBuilder>().having(
          (platformNativeDirectory) => platformNativeDirectory(
            platform: Platform.android,
          ),
          'returns',
          isA<PlatformNativeDirectory>().having(
            (platformNativeDirectory) => platformNativeDirectory.platform,
            'platform',
            Platform.android,
          ),
        ),
      );
    });

    group('.create()', () {
      test(
        'completes successfully with correct output',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.path).thenReturn('project/path');
          when(() => project.name()).thenReturn('my_project');
          final platformNativeDirectory = getPlatformNativeDirectory();
          final platformNativeDirectoryBuilder =
              getPlatfromNativeDirectoryBuilder();
          when(
            () => platformNativeDirectoryBuilder(
              platform: any(named: 'platform'),
            ),
          ).thenReturn(platformNativeDirectory);
          final generator = getMasonGenerator();
          final appPackage = _getAppPackage(
            project: project,
            platformNativeDirectoryBuilder: platformNativeDirectoryBuilder,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await appPackage.create(
            description: 'some desc',
            orgName: 'my.org',
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
                  'project/path/packages/my_project/my_project',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'description': 'some desc',
                'android': true,
                'ios': true,
                'linux': true,
                'macos': false,
                'web': false,
                'windows': false,
                'none': false,
              },
              logger: logger,
            ),
          ).called(1);
          verify(
            () => platformNativeDirectoryBuilder(platform: Platform.android),
          ).called(1);
          verify(() => platformNativeDirectoryBuilder(platform: Platform.ios))
              .called(1);
          verify(() => platformNativeDirectoryBuilder(platform: Platform.linux))
              .called(1);
          verifyNever(
              () => platformNativeDirectoryBuilder(platform: Platform.macos));
          verifyNever(
              () => platformNativeDirectoryBuilder(platform: Platform.web));
          verifyNever(
              () => platformNativeDirectoryBuilder(platform: Platform.windows));
          verify(
            () => platformNativeDirectory.create(
              description: 'some desc',
              orgName: 'my.org',
              logger: logger,
            ),
          ).called(3);
          verifyNever(
            () => platformNativeDirectory.create(
              description: 'some desc',
              orgName: 'my.org',
              logger: logger,
            ),
          );
        }),
      );

      test(
        'completes successfully with correct output (2)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.path).thenReturn('project/path');
          when(() => project.name()).thenReturn('my_project');
          final platformNativeDirectory = getPlatformNativeDirectory();
          final platformNativeDirectoryBuilder =
              getPlatfromNativeDirectoryBuilder();
          when(
            () => platformNativeDirectoryBuilder(
              platform: any(named: 'platform'),
            ),
          ).thenReturn(platformNativeDirectory);
          final generator = getMasonGenerator();
          final appPackage = _getAppPackage(
            project: project,
            platformNativeDirectoryBuilder: platformNativeDirectoryBuilder,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await appPackage.create(
            description: 'some desc',
            orgName: 'my.org',
            android: false,
            ios: false,
            linux: false,
            macos: true,
            web: true,
            windows: true,
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'project/path/packages/my_project/my_project',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'description': 'some desc',
                'android': false,
                'ios': false,
                'linux': false,
                'macos': true,
                'web': true,
                'windows': true,
                'none': false,
              },
              logger: logger,
            ),
          ).called(1);
          verify(
            () => platformNativeDirectoryBuilder(platform: Platform.macos),
          ).called(1);
          verify(
            () => platformNativeDirectoryBuilder(platform: Platform.web),
          ).called(1);
          verify(
            () => platformNativeDirectoryBuilder(platform: Platform.windows),
          ).called(1);
          verifyNever(
            () => platformNativeDirectoryBuilder(platform: Platform.android),
          );
          verifyNever(
            () => platformNativeDirectoryBuilder(platform: Platform.ios),
          );
          verifyNever(
            () => platformNativeDirectoryBuilder(platform: Platform.linux),
          );
          verify(
            () => platformNativeDirectory.create(
              description: 'some desc',
              orgName: 'my.org',
              logger: logger,
            ),
          ).called(3);
          verifyNever(
            () => platformNativeDirectory.create(
              description: 'some desc',
              orgName: 'my.org',
              logger: logger,
            ),
          );
        }),
      );
    });

    group('.addPlatform()', () {
      test('completes successfully with correct output', () async {
        // Arrange
        final appFeaturePackage = getPlatformAppFeaturePackage();
        when(() => appFeaturePackage.packageName()).thenReturn('app_feature');
        final platformDirectory = getPlatformDirectory();
        when(() => platformDirectory.appFeaturePackage)
            .thenReturn(appFeaturePackage);
        final platformDirectoryBuilder = getPlatfromDirectoryBuilder();
        when(() => platformDirectoryBuilder(platform: any(named: 'platform')))
            .thenReturn(platformDirectory);
        final project = getProject();
        when(() => project.platformDirectory)
            .thenReturn(platformDirectoryBuilder);
        final pubspecFile = getPubspecFile();
        final platformNativeDirectory = getPlatformNativeDirectory();
        final platformNativeDirectoryBuilder =
            getPlatfromNativeDirectoryBuilder();
        when(
          () => platformNativeDirectoryBuilder(
            platform: any(named: 'platform'),
          ),
        ).thenReturn(platformNativeDirectory);
        final mainFile1 = getMainFile();
        final mainFile2 = getMainFile();
        final generator = getMasonGenerator();
        final appPackage = _getAppPackage(
          project: project,
          pubspecFile: pubspecFile,
          platformNativeDirectoryBuilder: platformNativeDirectoryBuilder,
          mainFiles: {mainFile1, mainFile2},
          generator: (_) async => generator,
        );

        // Act
        final logger = FakeLogger();
        await appPackage.addPlatform(
          Platform.android,
          description: 'some desc',
          orgName: 'my.org',
          logger: logger,
        );

        // Assert
        verify(() => project.platformDirectory(platform: Platform.android))
            .called(1);
        verify(() => pubspecFile.setDependency('app_feature')).called(1);
        verify(() => platformNativeDirectoryBuilder(platform: Platform.android))
            .called(1);
        verify(
          () => platformNativeDirectory.create(
            description: 'some desc',
            orgName: 'my.org',
            logger: logger,
          ),
        ).called(1);
        verify(() => mainFile1.addSetupForPlatform(Platform.android)).called(1);
        verify(() => mainFile2.addSetupForPlatform(Platform.android)).called(1);
        // TODO assert logging
      });
    });

    group('.removePlatform()', () {
      test('completes successfully with correct output', () async {
        // Arrange
        final appFeaturePackage = getPlatformAppFeaturePackage();
        when(() => appFeaturePackage.packageName()).thenReturn('app_feature');
        final platformDirectory = getPlatformDirectory();
        when(() => platformDirectory.appFeaturePackage)
            .thenReturn(appFeaturePackage);
        final platformDirectoryBuilder = getPlatfromDirectoryBuilder();
        when(() => platformDirectoryBuilder(platform: any(named: 'platform')))
            .thenReturn(platformDirectory);
        final project = getProject();
        when(() => project.platformDirectory)
            .thenReturn(platformDirectoryBuilder);
        final pubspecFile = getPubspecFile();
        final platformNativeDirectory = getPlatformNativeDirectory();
        final platformNativeDirectoryBuilder =
            getPlatfromNativeDirectoryBuilder();
        when(
          () => platformNativeDirectoryBuilder(
            platform: any(named: 'platform'),
          ),
        ).thenReturn(platformNativeDirectory);
        final mainFile1 = getMainFile();
        final mainFile2 = getMainFile();
        final generator = getMasonGenerator();
        final appPackage = _getAppPackage(
          project: project,
          pubspecFile: pubspecFile,
          platformNativeDirectoryBuilder: platformNativeDirectoryBuilder,
          mainFiles: {mainFile1, mainFile2},
          generator: (_) async => generator,
        );

        // Act
        final logger = FakeLogger();
        await appPackage.removePlatform(
          Platform.android,
          logger: logger,
        );

        // Assert
        verify(() => project.platformDirectory(platform: Platform.android))
            .called(1);
        verify(() => pubspecFile.removeDependency('app_feature')).called(1);
        verify(() => platformNativeDirectoryBuilder(platform: Platform.android))
            .called(1);
        verify(() => platformNativeDirectory.delete(logger: logger)).called(1);
        verify(() => mainFile1.removeSetupForPlatform(Platform.android))
            .called(1);
        verify(() => mainFile2.removeSetupForPlatform(Platform.android))
            .called(1);
        // TODO assert logging
      });
    });
  });

  group('MainFile', () {
    group('.path', () {
      test('(development)', () {
        // Arrange
        final appPackage = getAppPackage();
        when(() => appPackage.path).thenReturn('app_package/path');
        final mainFile = _getMainFile(
          Environment.development,
          appPackage: appPackage,
        );

        // Assert
        expect(mainFile.path, 'app_package/path/lib/main_development.dart');
      });

      test('(test)', () {
        // Arrange
        final appPackage = getAppPackage();
        when(() => appPackage.path).thenReturn('app_package/path');
        final mainFile = _getMainFile(
          Environment.test,
          appPackage: appPackage,
        );

        // Assert
        expect(mainFile.path, 'app_package/path/lib/main_test.dart');
      });

      test('(production)', () {
        // Arrange
        final appPackage = getAppPackage();
        when(() => appPackage.path).thenReturn('app_package/path');
        final mainFile = _getMainFile(
          Environment.production,
          appPackage: appPackage,
        );

        // Assert
        expect(mainFile.path, 'app_package/path/lib/main_production.dart');
      });
    });

    group('.addSetupForPlatform()', () {
      group('add platform setup correctly when no other platform setups exist',
          () {
        void performTest(Environment environment) {
          // Arrange
          final project = getProject();
          when(() => project.name()).thenReturn('ab_cd');
          final appPackage = getAppPackage();
          when(() => appPackage.project).thenReturn(project);
          final mainFile = _getMainFile(
            environment,
            appPackage: appPackage,
          );
          final file = File(mainFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(mainFileNoSetup);

          // Act
          mainFile.addSetupForPlatform(Platform.android);

          // Assert
          final contents = file.readAsStringSync();
          expect(contents, mainFileWithAndroidSetup(environment));
        }

        test(
          '(development)',
          withTempDir(() => performTest(Environment.development)),
        );

        test(
          '(test)',
          withTempDir(() => performTest(Environment.test)),
        );

        test(
          '(production)',
          withTempDir(() => performTest(Environment.production)),
        );
      });

      group(
          'add platform setup correctly when no other platform setups exist (web)',
          () {
        void performTest(Environment environment) {
          // Arrange
          final project = getProject();
          when(() => project.name()).thenReturn('ab_cd');
          final appPackage = getAppPackage();
          when(() => appPackage.project).thenReturn(project);
          final mainFile = _getMainFile(
            environment,
            appPackage: appPackage,
          );
          final file = File(mainFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(mainFileNoSetup);

          // Act
          mainFile.addSetupForPlatform(Platform.web);

          // Assert
          final contents = file.readAsStringSync();
          expect(contents, mainFileWithWebSetup(environment));
        }

        test(
          '(development)',
          withTempDir(() => performTest(Environment.development)),
        );

        test(
          '(test)',
          withTempDir(() => performTest(Environment.test)),
        );

        test(
          '(production)',
          withTempDir(() => performTest(Environment.production)),
        );
      });

      group('add platform setup correctly when other platform setups exist',
          () {
        void performTest(Environment environment) {
          // Arrange
          final project = getProject();
          when(() => project.name()).thenReturn('ab_cd');
          final appPackage = getAppPackage();
          when(() => appPackage.project).thenReturn(project);
          final mainFile = _getMainFile(
            environment,
            appPackage: appPackage,
          );
          final file = File(mainFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(
              mainFileWithWebSetup(environment),
            );

          // Act
          mainFile.addSetupForPlatform(Platform.android);

          // Assert
          final contents = file.readAsStringSync();
          expect(
            contents,
            mainFileWithWebAndAndroidSetup(environment),
          );
        }

        test(
          '(development)',
          withTempDir(() => performTest(Environment.development)),
        );

        test(
          '(test)',
          withTempDir(() => performTest(Environment.test)),
        );

        test(
          '(production)',
          withTempDir(() => performTest(Environment.production)),
        );
      });

      group('does nothing when setup for platform already exists', () {
        void performTest(Environment environment) {
          // Arrange
          final project = getProject();
          when(() => project.name()).thenReturn('ab_cd');
          final appPackage = getAppPackage();
          when(() => appPackage.project).thenReturn(project);
          final mainFile = _getMainFile(
            environment,
            appPackage: appPackage,
          );
          final file = File(mainFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(
              mainFileWithAndroidSetup(environment),
            );

          // Act
          mainFile.addSetupForPlatform(Platform.android);

          // Assert
          final contents = file.readAsStringSync();
          expect(contents, mainFileWithAndroidSetup(environment));
        }

        test(
          '(development)',
          withTempDir(() => performTest(Environment.development)),
        );

        test(
          '(test)',
          withTempDir(() => performTest(Environment.test)),
        );

        test(
          '(production)',
          withTempDir(() => performTest(Environment.production)),
        );
      });
    });

    group('.removeSetupForPlatform()', () {
      group('does nothing when no other platform setups exist', () {
        void performTest(Environment environment) {
          // Arrange
          final project = getProject();
          when(() => project.name()).thenReturn('ab_cd');
          final appPackage = getAppPackage();
          when(() => appPackage.project).thenReturn(project);
          final mainFile = _getMainFile(
            environment,
            appPackage: appPackage,
          );
          final file = File(mainFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(mainFileNoSetup);

          // Act
          mainFile.removeSetupForPlatform(Platform.android);

          // Assert
          expect(file.readAsStringSync(), mainFileNoSetup);
        }

        test(
          '(development)',
          withTempDir(() => performTest(Environment.development)),
        );

        test(
          '(test)',
          withTempDir(() => performTest(Environment.test)),
        );

        test(
          '(production)',
          withTempDir(() => performTest(Environment.production)),
        );
      });

      group('remove platform setup correctly when platform exists', () {
        void performTest(Environment environment) {
          // Arrange
          final project = getProject();
          when(() => project.name()).thenReturn('ab_cd');
          final appPackage = getAppPackage();
          when(() => appPackage.project).thenReturn(project);
          final mainFile = _getMainFile(
            environment,
            appPackage: appPackage,
          );
          final file = File(mainFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(
              mainFileWithAndroidSetup(environment),
            );

          // Act
          mainFile.removeSetupForPlatform(Platform.android);

          // Assert
          final contents = file.readAsStringSync();
          expect(contents, mainFileNoSetup);
        }

        test(
          '(development)',
          withTempDir(() => performTest(Environment.development)),
        );

        test(
          '(test)',
          withTempDir(() => performTest(Environment.test)),
        );

        test(
          '(production)',
          withTempDir(() => performTest(Environment.production)),
        );
      });

      group('remove platform setup correctly when platform exists (web)', () {
        void performTest(Environment environment) {
          // Arrange
          final project = getProject();
          when(() => project.name()).thenReturn('ab_cd');
          final appPackage = getAppPackage();
          when(() => appPackage.project).thenReturn(project);
          final mainFile = _getMainFile(
            environment,
            appPackage: appPackage,
          );
          final file = File(mainFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(
              mainFileWithWebSetup(environment),
            );

          // Act
          mainFile.removeSetupForPlatform(Platform.web);

          // Assert
          final contents = file.readAsStringSync();
          expect(contents, mainFileNoSetup);
        }

        test(
          '(development)',
          withTempDir(() => performTest(Environment.development)),
        );

        test(
          '(test)',
          withTempDir(() => performTest(Environment.test)),
        );

        test(
          '(production)',
          withTempDir(() => performTest(Environment.production)),
        );
      });

      group('remove platform setup correctly when other platform setups exist',
          () {
        void performTest(Environment environment) {
          // Arrange
          final project = getProject();
          when(() => project.name()).thenReturn('ab_cd');
          final appPackage = getAppPackage();
          when(() => appPackage.project).thenReturn(project);
          final mainFile = _getMainFile(
            environment,
            appPackage: appPackage,
          );
          final file = File(mainFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(
              mainFileWithWebAndAndroidSetup(environment),
            );

          // Act
          mainFile.removeSetupForPlatform(Platform.android);

          // Assert
          final contents = file.readAsStringSync();
          expect(contents, mainFileWithWebSetup(environment));
        }

        test(
          '(development)',
          withTempDir(() => performTest(Environment.development)),
        );

        test(
          '(test)',
          withTempDir(() => performTest(Environment.test)),
        );

        test(
          '(production)',
          withTempDir(() => performTest(Environment.production)),
        );
      });
    });
  });
}
