import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/core/di_package.dart';
import 'package:rapid_cli/src/core/melos_file.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/core/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

const injectionFileWithNoPlatform = '''
import 'dart:async';

import 'package:foo_bar_infrastructure/foo_bar_infrastructure.dart';
import 'package:foo_bar_logging/foo_bar_logging.dart';
import 'package:injectable/injectable.dart';

import 'di_container.dart';
import 'injection.config.dart';

/// Setup injectable package which generates dependency injection code.
///
/// For more info see: https://pub.dev/packages/injectable
@InjectableInit(
  externalPackageModules: [
    FooBarInfrastructurePackageModule,
    FooBarLoggingPackageModule
  ],
)
void configureDependencies(String environment, String platform) => getIt.init(
      environmentFilter: NoEnvOrContainsAny({environment, platform}),
    );
''';

const injectionFileWithAndroid = '''
import 'dart:async';

import 'package:foo_bar_android_home_page/foo_bar_android_home_page.dart';
import 'package:foo_bar_infrastructure/foo_bar_infrastructure.dart';
import 'package:foo_bar_logging/foo_bar_logging.dart';
import 'package:injectable/injectable.dart';

import 'di_container.dart';
import 'injection.config.dart';

/// Setup injectable package which generates dependency injection code.
///
/// For more info see: https://pub.dev/packages/injectable
@InjectableInit(
  externalPackageModules: [
    FooBarAndroidHomePagePackageModule,
    FooBarInfrastructurePackageModule,
    FooBarLoggingPackageModule
  ],
)
void configureDependencies(String environment, String platform) => getIt.init(
      environmentFilter: NoEnvOrContainsAny({environment, platform}),
    );
''';

const injectionFileWithIosWeb = '''
import 'dart:async';

import 'package:foo_bar_infrastructure/foo_bar_infrastructure.dart';
import 'package:foo_bar_ios_home_page/foo_bar_ios_home_page.dart';
import 'package:foo_bar_logging/foo_bar_logging.dart';
import 'package:foo_bar_web_home_page/foo_bar_web_home_page.dart';
import 'package:injectable/injectable.dart';

import 'di_container.dart';
import 'injection.config.dart';

/// Setup injectable package which generates dependency injection code.
///
/// For more info see: https://pub.dev/packages/injectable
@InjectableInit(
  externalPackageModules: [
    FooBarInfrastructurePackageModule,
    FooBarIosHomePagePackageModule,
    FooBarLoggingPackageModule,
    FooBarWebHomePagePackageModule
  ],
)
void configureDependencies(String environment, String platform) => getIt.init(
      environmentFilter: NoEnvOrContainsAny({environment, platform}),
    );
''';

const injectionFileWithAndroidIosWeb = '''
import 'dart:async';

import 'package:foo_bar_android_home_page/foo_bar_android_home_page.dart';
import 'package:foo_bar_infrastructure/foo_bar_infrastructure.dart';
import 'package:foo_bar_ios_home_page/foo_bar_ios_home_page.dart';
import 'package:foo_bar_logging/foo_bar_logging.dart';
import 'package:foo_bar_web_home_page/foo_bar_web_home_page.dart';
import 'package:injectable/injectable.dart';

import 'di_container.dart';
import 'injection.config.dart';

/// Setup injectable package which generates dependency injection code.
///
/// For more info see: https://pub.dev/packages/injectable
@InjectableInit(
  externalPackageModules: [
    FooBarAndroidHomePagePackageModule,
    FooBarInfrastructurePackageModule,
    FooBarIosHomePagePackageModule,
    FooBarLoggingPackageModule,
    FooBarWebHomePagePackageModule
  ],
)
void configureDependencies(String environment, String platform) => getIt.init(
      environmentFilter: NoEnvOrContainsAny({environment, platform}),
    );
''';

class MockMelosFile extends Mock implements MelosFile {}

class MockProject extends Mock implements Project {}

class MockDiPackage extends Mock implements DiPackage {}

void main() {
  group('DiPackage', () {
    const projectName = 'test_app';

    late MelosFile melosFile;
    late Project project;
    late DiPackage diPackage;

    setUp(() {
      melosFile = MockMelosFile();
      when(() => melosFile.name).thenReturn(projectName);
      project = MockProject();
      when(() => project.melosFile).thenReturn(melosFile);
      diPackage = DiPackage(project: project);
    });

    group('path', () {
      test('is "packages/<PROJECT-NAME>/<PROJECT-NAME>_di"', () {
        // Assert
        expect(diPackage.path, 'packages/$projectName/${projectName}_di');
      });
    });

    group('directory', () {
      test('is "packages/<PROJECT-NAME>/<PROJECT-NAME>_di"', () {
        // Assert
        expect(
          diPackage.directory.path,
          'packages/$projectName/${projectName}_di',
        );
      });
    });

    group('injectionFile', () {
      test('returns injection file with reference to this di package', () {
        // Assert
        expect(
          diPackage.injectionFile,
          isA<InjectionFile>().having(
            (injectionFile) => injectionFile.diPackage,
            '',
            diPackage,
          ),
        );
      });
    });
  });

  group('InjectionFile', () {
    final cwd = Directory.current;

    const projectName = 'foo_bar';
    late MelosFile melosFile;
    late Project project;
    const diPackagePath = 'di/package/path';
    late DiPackage diPackage;
    late InjectionFile injectionFile;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      melosFile = MockMelosFile();
      when(() => melosFile.name).thenReturn(projectName);
      project = MockProject();
      when(() => project.melosFile).thenReturn(melosFile);
      diPackage = MockDiPackage();
      when(() => diPackage.project).thenReturn(project);
      when(() => diPackage.path).thenReturn(diPackagePath);
      injectionFile = InjectionFile(
        diPackage: diPackage,
      );
    });

    tearDown(() {
      Directory.current = cwd;
    });

    group('path', () {
      test('is "<DI-PACKAGE-PATH>/lib/src/injection.dart"', () {
        // Assert
        expect(injectionFile.path, '${diPackage.path}/lib/src/injection.dart');
      });
    });

    group('file', () {
      test('is "<DI-PACKAGE-PATH>/lib/src/injection.dart"', () {
        // Assert
        expect(
          injectionFile.file.path,
          '${diPackage.path}/lib/src/injection.dart',
        );
      });
    });

    // TODO case for multiple results
    group('getPackagesByPlatform', () {
      test('Returns list of platforms package names', () {
        final file = File(injectionFile.path);
        file.createSync(recursive: true);
        file.writeAsStringSync(injectionFileWithAndroidIosWeb);

        // Act
        final packages = injectionFile.getPackagesByPlatform(Platform.android);

        // Assert
        expect(packages, ['foo_bar_android_home_page']);
      });

      test('Returns empty list when no package with platform is present', () {
        final file = File(injectionFile.path);
        file.createSync(recursive: true);
        file.writeAsStringSync(injectionFileWithAndroidIosWeb);

        // Act
        final packages = injectionFile.getPackagesByPlatform(Platform.windows);

        // Assert
        expect(packages, isEmpty);
      });
    });

    group('addPackage', () {
      test('does nothing when the package is already present', () {
        // Arrange
        final file = File(injectionFile.path);
        file.createSync(recursive: true);
        file.writeAsStringSync(injectionFileWithAndroid);

        // Act
        injectionFile.addPackage('foo_bar_android_home_page');

        // Assert
        expect(file.readAsStringSync(), injectionFileWithAndroid);
      });

      test('adds import and external package module correctly', () {
        // Arrange
        final file = File(injectionFile.path);
        file.createSync(recursive: true);
        file.writeAsStringSync(injectionFileWithIosWeb);

        // Act
        injectionFile.addPackage('foo_bar_android_home_page');

        // Assert
        expect(file.readAsStringSync(), injectionFileWithAndroidIosWeb);
      });
    });

    group('removePackage', () {
      test('does nothing when package is not present', () {
        // Arrange
        final file = File(injectionFile.path);
        file.createSync(recursive: true);
        file.writeAsStringSync(injectionFileWithNoPlatform);

        // Act
        injectionFile.removePackage('foo_bar_android_home_page');

        // Assert
        expect(file.readAsStringSync(), injectionFileWithNoPlatform);
      });

      test('removes import and external package module correctly', () {
        // Arrange
        final file = File(injectionFile.path);
        file.createSync(recursive: true);
        file.writeAsStringSync(injectionFileWithAndroidIosWeb);

        // Act
        injectionFile.removePackage('foo_bar_android_home_page');

        // Assert
        expect(file.readAsStringSync(), injectionFileWithIosWeb);
      });
    });
  });
}
