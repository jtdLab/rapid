import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/app_package/app_package.dart';
import 'package:rapid_cli/src/project/melos_file.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

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
  // TODO: add more android ${env.entityName} setup here

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
  // TODO: add more web ${env.entityName} setup here

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
  // TODO: add more web ${env.entityName} setup here

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
  // TODO: add more android ${env.entityName} setup here

  final logger = getIt<AbCdLogger>();
  final app = android.App(
    routerObserverBuilder: () => [
      AbCdRouterObserver(logger),
    ],
  );
  await bootstrap(app, logger);
}
''';

class _MockMelosFile extends Mock implements MelosFile {}

class _MockProject extends Mock implements Project {}

class _MockAppPackage extends Mock implements AppPackage {}

void main() {
  group('AppPackage', () {
    final cwd = Directory.current;

    const projectName = 'foo_bar';
    late MelosFile melosFile;
    late Project project;
    late AppPackage appPackage;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      melosFile = _MockMelosFile();
      when(() => melosFile.name()).thenReturn(projectName);
      project = _MockProject();
      when(() => project.melosFile).thenReturn(melosFile);
      appPackage = AppPackage(project: project);
      Directory(appPackage.path).createSync(recursive: true);
    });

    tearDown(() {
      Directory.current = cwd;
    });

    group('mainFiles', () {
      test(
          'returns correct three main files with env development, test and production',
          () {
        // Act
        final mainFiles = appPackage.mainFiles;

        // Assert
        expect(mainFiles, hasLength(3));
        final mainFileDev = mainFiles.first;
        expect(mainFileDev.env, Environment.development);
        expect(mainFileDev.path,
            'packages/$projectName/$projectName/lib/main_development.dart');
        final mainFileTest = mainFiles.elementAt(1);
        expect(mainFileTest.env, Environment.test);
        expect(mainFileTest.path,
            'packages/$projectName/$projectName/lib/main_test.dart');
        final mainFileProd = mainFiles.last;
        expect(mainFileProd.env, Environment.production);
        expect(mainFileProd.path,
            'packages/$projectName/$projectName/lib/main_production.dart');
      });
    });

    group('path', () {
      test('is correct', () {
        // Assert
        expect(appPackage.path, 'packages/$projectName/$projectName');
      });
    });

    group('platformDirectory', () {
      late Platform platform;

      test('returns directory with correct path (android)', () {
        // Arrange
        platform = Platform.android;

        // Assert
        expect(
          appPackage.platformDirectory(platform).path,
          'packages/$projectName/$projectName/android',
        );
      });

      test('returns directory with correct path (ios)', () {
        // Arrange
        platform = Platform.ios;

        // Assert
        expect(
          appPackage.platformDirectory(platform).path,
          'packages/$projectName/$projectName/ios',
        );
      });

      test('returns directory with correct path (linux)', () {
        // Arrange
        platform = Platform.linux;

        // Assert
        expect(
          appPackage.platformDirectory(platform).path,
          'packages/$projectName/$projectName/linux',
        );
      });

      test('returns directory with correct path (macos)', () {
        // Arrange
        platform = Platform.macos;

        // Assert
        expect(
          appPackage.platformDirectory(platform).path,
          'packages/$projectName/$projectName/macos',
        );
      });

      test('returns directory with correct path (web)', () {
        // Arrange
        platform = Platform.web;

        // Assert
        expect(
          appPackage.platformDirectory(platform).path,
          'packages/$projectName/$projectName/web',
        );
      });

      test('returns directory with correct path (windows)', () {
        // Arrange
        platform = Platform.windows;

        // Assert
        expect(
          appPackage.platformDirectory(platform).path,
          'packages/$projectName/$projectName/windows',
        );
      });
    });

    group('testDriverDirectory', () {
      test('returns directory with correct path', () {
        // Assert
        expect(
          appPackage.testDriverDirectory().path,
          'packages/$projectName/$projectName/test_driver',
        );
      });
    });
  });

  group('MainFile', () {
    final cwd = Directory.current;

    const projectName = 'ab_cd';
    late MelosFile melosFile;
    late Project project;
    const appPackagePath = 'foo/bar/baz';
    late AppPackage appPackage;
    late Environment environment;
    late MainFile mainFile;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      melosFile = _MockMelosFile();
      when(() => melosFile.name()).thenReturn(projectName);
      project = _MockProject();
      when(() => project.melosFile).thenReturn(melosFile);
      appPackage = _MockAppPackage();
      when(() => appPackage.path).thenReturn(appPackagePath);
      when(() => appPackage.project).thenReturn(project);
      environment = Environment.development;
      mainFile = MainFile(environment, appPackage: appPackage);
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
          '$appPackagePath/lib/main_${environment.entityName}.dart',
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
