import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/app_package.dart';
import 'package:rapid_cli/src/project/melos_file.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

const mainFileNoSetups = '''
import 'package:ab_cd/router_observer.dart';
import 'package:ab_cd_di/ab_cd_di.dart';

import 'package:ab_cd_logging/ab_cd_logging.dart';

import 'package:flutter/widgets.dart';
import 'package:rapid/rapid.dart';

import 'bootstrap.dart';

void main() => runOnPlatform();
''';

const mainFileWithAndroidSetup = '''
import 'package:ab_cd/router_observer.dart';
import 'package:ab_cd_android_app/ab_cd_android_app.dart' as android;
import 'package:ab_cd_di/ab_cd_di.dart';
import 'package:ab_cd_logging/ab_cd_logging.dart';
import 'package:flutter/widgets.dart';
import 'package:rapid/rapid.dart';

import 'bootstrap.dart';

void main() => runOnPlatform(
      android: runAndroidApp,
    );

Future<void> runAndroidApp() async {
  configureDependencies(Environment.dev, Platform.android);
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: add more android development setup here

  final logger = getIt<AbCdLogger>();
  final app = android.App(
    navigatorObserverBuilder: () => [
      AbCdRouterObserver(logger),
    ],
  );
  await bootstrap(app, logger);
}
''';

const mainFileWithWebSetup = '''
import 'package:ab_cd/router_observer.dart';
import 'package:ab_cd_di/ab_cd_di.dart';
import 'package:ab_cd_logging/ab_cd_logging.dart';
import 'package:ab_cd_web_app/ab_cd_web_app.dart' as web;
import 'package:flutter/widgets.dart';
import 'package:rapid/rapid.dart';
import 'package:url_strategy/url_strategy.dart';

import 'bootstrap.dart';

void main() => runOnPlatform(
      web: runWebApp,
    );

Future<void> runWebApp() async {
  configureDependencies(Environment.dev, Platform.web);
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: add more web development setup here

  final logger = getIt<AbCdLogger>();
  final app = web.App(
    navigatorObserverBuilder: () => [
      AbCdRouterObserver(logger),
    ],
  );
  await bootstrap(app, logger);
}
''';

const mainFileWithWebAndAndroidSetups = '''
import 'package:ab_cd/router_observer.dart';
import 'package:ab_cd_android_app/ab_cd_android_app.dart' as android;
import 'package:ab_cd_di/ab_cd_di.dart';
import 'package:ab_cd_logging/ab_cd_logging.dart';
import 'package:ab_cd_web_app/ab_cd_web_app.dart' as web;
import 'package:flutter/widgets.dart';
import 'package:rapid/rapid.dart';
import 'package:url_strategy/url_strategy.dart';

import 'bootstrap.dart';

void main() => runOnPlatform(
      web: runWebApp,
      android: runAndroidApp,
    );

Future<void> runWebApp() async {
  configureDependencies(Environment.dev, Platform.web);
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: add more web development setup here

  final logger = getIt<AbCdLogger>();
  final app = web.App(
    navigatorObserverBuilder: () => [
      AbCdRouterObserver(logger),
    ],
  );
  await bootstrap(app, logger);
}

Future<void> runAndroidApp() async {
  configureDependencies(Environment.dev, Platform.android);
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: add more android development setup here

  final logger = getIt<AbCdLogger>();
  final app = android.App(
    navigatorObserverBuilder: () => [
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
  });

  group('MainFile', () {
    final cwd = Directory.current;

    const projectName = 'ab_cd';
    late MelosFile melosFile;
    late Project project;
    const appPackagePath = 'foo/bar/baz';
    late AppPackage appPackage;
    const Environment environment = Environment.development;
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
          '${appPackage.path}/lib/main_${environment.name}.dart',
        );
      });
    });

    group('addSetupForPlatform', () {
      test('add platform setup correctly when no other platform setups exist',
          () {
        // Arrange
        final file = File(mainFile.path);
        file.writeAsStringSync(mainFileNoSetups);

        // Act
        mainFile.addSetupForPlatform(Platform.android);

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, mainFileWithAndroidSetup);
      });

      test(
          'add platform setup correctly when no other platform setups exist (web)',
          () {
        // Arrange
        final file = File(mainFile.path);
        file.writeAsStringSync(mainFileNoSetups);

        // Act
        mainFile.addSetupForPlatform(Platform.web);

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, mainFileWithWebSetup);
      });

      test('add platform setup correctly when other platform setups exist', () {
        // Arrange
        final file = File(mainFile.path);
        file.writeAsStringSync(mainFileWithWebSetup);

        // Act
        mainFile.addSetupForPlatform(Platform.android);

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, mainFileWithWebAndAndroidSetups);
      });

      test('does nothing when setup for platform already exists', () {
        // Arrange
        final file = File(mainFile.path);
        file.writeAsStringSync(mainFileWithAndroidSetup);

        // Act
        mainFile.addSetupForPlatform(Platform.android);

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, mainFileWithAndroidSetup);
      });
    });

    group('removeSetupForPlatform', () {
      // TODO
    });
  });
}
