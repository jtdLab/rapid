import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/core/app_package.dart';
import 'package:rapid_cli/src/core/melos_file.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/core/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

// TODO update when app templates  is updated -remove empty lines etc
const emptyMainFile = '''
import 'package:foo_bar/router_observer.dart';

import 'package:foo_bar_di/foo_bar_di.dart';


import 'package:foo_bar_logging/foo_bar_logging.dart';



import 'package:flutter/widgets.dart';
import 'package:rapid/rapid.dart';

import 'bootstrap.dart';

void main() => runOnPlatform(
      
      
      
      
      
      
    );











''';

const mainFileWithIos = '''
import 'package:flutter/widgets.dart';
import 'package:foo_bar/router_observer.dart';
import 'package:foo_bar_di/foo_bar_di.dart';
import 'package:foo_bar_ios_app/foo_bar_ios_app.dart' as ios;
import 'package:foo_bar_logging/foo_bar_logging.dart';
import 'package:rapid/rapid.dart';

import 'bootstrap.dart';

void main() => runOnPlatform(
      ios: runIosApp,
    );

Future<void> runIosApp() async {
  configureDependencies(Environment.dev, Platform.ios);
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: add more ios development setup here

  final logger = getIt<FooBarLogger>();
  final app = ios.App(
    navigatorObserverBuilder: () => [
      FooBarRouterObserver(logger),
    ],
  );
  await bootstrap(app, logger);
}
''';

const mainFileWithIosTest = '''
import 'package:flutter/widgets.dart';
import 'package:foo_bar/router_observer.dart';
import 'package:foo_bar_di/foo_bar_di.dart';
import 'package:foo_bar_ios_app/foo_bar_ios_app.dart' as ios;
import 'package:foo_bar_logging/foo_bar_logging.dart';
import 'package:rapid/rapid.dart';

import 'bootstrap.dart';

void main() => runOnPlatform(
      ios: runIosApp,
    );

Future<void> runIosApp() async {
  configureDependencies(Environment.test, Platform.ios);
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: add more ios test setup here

  final logger = getIt<FooBarLogger>();
  final app = ios.App(
    navigatorObserverBuilder: () => [
      FooBarRouterObserver(logger),
    ],
  );
  await bootstrap(app, logger);
}
''';

const mainFileWithIosAndWeb = '''
import 'package:flutter/widgets.dart';
import 'package:foo_bar/router_observer.dart';
import 'package:foo_bar_di/foo_bar_di.dart';
import 'package:foo_bar_ios_app/foo_bar_ios_app.dart' as ios;
import 'package:foo_bar_logging/foo_bar_logging.dart';
import 'package:foo_bar_web_app/foo_bar_web_app.dart' as web;
import 'package:rapid/rapid.dart';
import 'package:url_strategy/url_strategy.dart';

import 'bootstrap.dart';

void main() => runOnPlatform(
      ios: runIosApp,
      web: runWebApp,
    );

Future<void> runIosApp() async {
  configureDependencies(Environment.dev, Platform.ios);
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: add more ios development setup here

  final logger = getIt<FooBarLogger>();
  final app = ios.App(
    navigatorObserverBuilder: () => [
      FooBarRouterObserver(logger),
    ],
  );
  await bootstrap(app, logger);
}

Future<void> runWebApp() async {
  configureDependencies(Environment.dev, Platform.web);
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: add more web development setup here

  final logger = getIt<FooBarLogger>();
  final app = web.App(
    navigatorObserverBuilder: () => [
      FooBarRouterObserver(logger),
    ],
  );
  await bootstrap(app, logger);
}
''';

class MockMelosFile extends Mock implements MelosFile {}

class MockProject extends Mock implements Project {}

class MockAppPackage extends Mock implements AppPackage {}

void main() {
  group('AppPackage', () {
    const projectName = 'test_app';

    late MelosFile melosFile;
    late Project project;
    late AppPackage appPackage;

    setUp(() {
      melosFile = MockMelosFile();
      when(() => melosFile.name).thenReturn(projectName);
      project = MockProject();
      when(() => project.melosFile).thenReturn(melosFile);
      appPackage = AppPackage(project: project);
    });

    group('path', () {
      test('is "packages/<PROJECT-NAME>/<PROJECT-NAME>"', () {
        // Assert
        expect(appPackage.path, 'packages/$projectName/$projectName');
      });
    });

    group('directory', () {
      test('is "packages/<PROJECT-NAME>/<PROJECT-NAME>"', () {
        // Assert
        expect(appPackage.directory.path, 'packages/$projectName/$projectName');
      });
    });

    group('mainFiles', () {
      test(
          'Returns a set of main files one main file per environment all having a reference to the app package',
          () {
        // Assert
        final mainFiles = appPackage.mainFiles;
        expect(mainFiles, hasLength(3));
        expect(
          mainFiles.elementAt(0),
          isA<MainFile>()
              .having(
                (mainFile) => mainFile.appPackage,
                '',
                appPackage,
              )
              .having(
                (mainFile) => mainFile.environment,
                '',
                Environment.development,
              ),
        );
        expect(
          mainFiles.elementAt(1),
          isA<MainFile>()
              .having(
                (mainFile) => mainFile.appPackage,
                '',
                appPackage,
              )
              .having(
                (mainFile) => mainFile.environment,
                '',
                Environment.test,
              ),
        );
        expect(
          mainFiles.elementAt(2),
          isA<MainFile>()
              .having(
                (mainFile) => mainFile.appPackage,
                '',
                appPackage,
              )
              .having(
                (mainFile) => mainFile.environment,
                '',
                Environment.production,
              ),
        );
      });
    });
  });

  group('MainFile', () {
    final cwd = Directory.current;

    const projectName = 'foo_bar';
    late Environment environment;
    late MelosFile melosFile;
    late Project project;
    late AppPackage appPackage;
    late MainFile mainFile;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      environment = Environment.development;
      melosFile = MockMelosFile();
      when(() => melosFile.name).thenReturn(projectName);
      project = MockProject();
      when(() => project.melosFile).thenReturn(melosFile);
      appPackage = MockAppPackage();
      when(() => appPackage.path).thenReturn('app/package/path');
      when(() => appPackage.project).thenReturn(project);
      mainFile = MainFile(
        environment,
        appPackage: appPackage,
      );
    });

    tearDown(() {
      Directory.current = cwd;
    });

    group('path', () {
      test('is "<APP-PACKAGE-PATH>lib/main_<ENVIRONMENT>.dart"', () {
        // Assert
        expect(
          mainFile.path,
          '${appPackage.path}/lib/main_${environment.name}.dart',
        );
      });
    });

    group('file', () {
      test('is "<APP-PACKAGE-PATH>/lib/main_<ENVIRONMENT>.dart"', () {
        // Assert
        expect(
          mainFile.file.path,
          '${appPackage.path}/lib/main_${environment.name}.dart',
        );
      });
    });

    group('addPlatform', () {
      test(
          'adds import to app, call to platform method in main and implementation of platform method correctly when no platforms present',
          () {
        // Arrange
        final file = File(mainFile.path);
        file.createSync(recursive: true);
        file.writeAsStringSync(emptyMainFile);

        // Act
        mainFile.addPlatform(Platform.ios);

        // Assert
        expect(file.readAsStringSync(), mainFileWithIos);
      });

      test(
          'adds import to app, call to platform method in main and implementation of platform method correctly when no platforms present (test env)',
          () {
        // Arrange
        environment = Environment.test;
        mainFile = MainFile(environment, appPackage: appPackage);
        final file = File(mainFile.path);
        file.createSync(recursive: true);
        file.writeAsStringSync(emptyMainFile);

        // Act
        mainFile.addPlatform(Platform.ios);

        // Assert
        expect(file.readAsStringSync(), mainFileWithIosTest);
      });

      test(
          'adds import to app, call to platform method in main and implementation of platform method correctly when platforms present',
          () {
        // Arrange
        final file = File(mainFile.path);
        file.createSync(recursive: true);
        file.writeAsStringSync(mainFileWithIos);

        // Act
        mainFile.addPlatform(Platform.web);

        // Assert
        expect(file.readAsStringSync(), mainFileWithIosAndWeb);
      });
    });

    group('removePlatform', () {
      // TODO: impl
    });
  });
}
