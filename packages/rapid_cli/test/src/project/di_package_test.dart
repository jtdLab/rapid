import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/di_package.dart';
import 'package:rapid_cli/src/project/melos_file.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

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

class _MockMelosFile extends Mock implements MelosFile {}

class _MockProject extends Mock implements Project {}

class _MockDiPackage extends Mock implements DiPackage {}

void main() {
  group('DiPackage', () {
    final cwd = Directory.current;

    const projectName = 'foo_bar';
    late MelosFile melosFile;
    late Project project;
    late DiPackage diPackage;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      melosFile = _MockMelosFile();
      when(() => melosFile.name()).thenReturn(projectName);
      project = _MockProject();
      when(() => project.melosFile).thenReturn(melosFile);
      diPackage = DiPackage(project: project);
      Directory(diPackage.path).createSync(recursive: true);
    });

    tearDown(() {
      Directory.current = cwd;
    });

    group('injectionFile', () {
      test('returns correct injection file', () {
        // Act
        final injectionFile = diPackage.injectionFile;

        // Assert
        expect(injectionFile.path,
            'packages/$projectName/${projectName}_di/lib/src/injection.dart');
      });
    });

    group('path', () {
      test('is correct', () {
        // Assert
        expect(diPackage.path, 'packages/$projectName/${projectName}_di');
      });
    });

    group('pubspecFile', () {
      test('returns correct pubspec file', () {
        // Act
        final pubspecFile = diPackage.pubspecFile;

        // Assert
        expect(pubspecFile.path,
            'packages/$projectName/${projectName}_di/pubspec.yaml');
      });
    });
  });

  group('InjectionFile', () {
    final cwd = Directory.current;

    const projectName = 'kuk_abc';
    late MelosFile melosFile;
    late Project project;
    const diPackagePath = 'foo/bar/baz';
    late DiPackage diPackage;
    late InjectionFile injectionFile;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      melosFile = _MockMelosFile();
      when(() => melosFile.name()).thenReturn(projectName);
      project = _MockProject();
      when(() => project.melosFile).thenReturn(melosFile);
      diPackage = _MockDiPackage();
      when(() => diPackage.path).thenReturn(diPackagePath);
      when(() => diPackage.project).thenReturn(project);
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

    group('addPackage', () {
      test('add import and external package module correctly', () {
        // Arrange
        final file = File(injectionFile.path);
        file.writeAsStringSync(injectionFileWithInitialPackages);

        // Act
        injectionFile.addPackage('android_home_page');

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, injectionFileWithPackages);
      });

      test(
          'add import and external package module correctly when packages exist',
          () {
        // Arrange
        final file = File(injectionFile.path);
        file.writeAsStringSync(injectionFileWithPackages);

        // Act
        injectionFile.addPackage('web_my_page');

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, injectionFileWithMorePackages);
      });

      test('does nothing when package already exists', () {
        // Arrange
        final file = File(injectionFile.path);
        file.writeAsStringSync(injectionFileWithMorePackages);

        // Act
        injectionFile.addPackage('web_my_page');

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, injectionFileWithMorePackages);
      });
    });

    group('removePackagesByPlatform', () {
      test('remove import and external package module correctly', () {
        // Arrange
        final file = File(injectionFile.path);
        file.writeAsStringSync(injectionFileWithPackages);

        // Act
        injectionFile.removePackagesByPlatform(Platform.android);

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, injectionFileWithInitialPackages);
      });

      test(
          'remove import and external package module correctly when packages exist',
          () {
        // Arrange
        final file = File(injectionFile.path);
        file.writeAsStringSync(injectionFileWithMorePackages);

        // Act
        injectionFile.removePackagesByPlatform(Platform.web);

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, injectionFileWithPackages);
      });

      test('does nothing when package already exists', () {
        // Arrange
        final file = File(injectionFile.path);
        file.writeAsStringSync(injectionFileWithInitialPackages);

        // Act
        injectionFile.removePackagesByPlatform(Platform.web);

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, injectionFileWithInitialPackages);
      });
    });
  });
}
