void main() {
  // TODO: impl tests
}

/* import 'package:mocktail/mocktail.dart';
import 'package:test/scaffolding.dart';

import '../../../common.dart';

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

InjectionFile _getInjectionFile({
  required DiPackage diPackage,
}) {
  return InjectionFile(
    diPackage: diPackage,
  );
}

void main() {
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

  group('PlatformRootPackage', () {});

  group('LocalizationsDelegatesFile', () {});

  group('InjectionFile', () {
    setUpAll(() {
      registerFallbackValue(FakeLogger());
      registerFallbackValue(FakePlatformCustomFeaturePackage());
    });

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
      test(
        'add import and external package module correctly',
        withTempDir(() {
          // Arrange
          final diPackage = getDiPackage();
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
        }),
      );

      test(
        'do nothing when package already exists',
        withTempDir(() {
          // Arrange
          final diPackage = getDiPackage();
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
        }),
      );
    });

    group('.removeCustomFeaturePackage()', () {
      test(
        'remove import and external package module correctly',
        withTempDir(() {
          // Arrange
          final diPackage = getDiPackage();
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
        }),
      );

      test(
        'do nothing when package does not exist',
        withTempDir(() {
          // Arrange
          final diPackage = getDiPackage();
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
        }),
      );
    });
  });
}
 */
