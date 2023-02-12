import 'dart:io';

import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_feature_package/platform_feature_package.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../../common.dart';
import '../../../mocks.dart';

const localizationsFileEmpty = '''
import 'package:ab_cd_ui_android/ab_cd_ui_android.dart';

const localizationsDelegates = <LocalizationsDelegate>[];

const supportedLocales = [
  Locale('en'),
];
''';

const localizationsFileWithPackages = '''
import 'package:ab_cd_android_home_page/ab_cd_android_home_page.dart';
import 'package:ab_cd_ui_android/ab_cd_ui_android.dart';

const localizationsDelegates = <LocalizationsDelegate>[
  AbCdAndroidHomePageLocalizations.delegate,
];

const supportedLocales = [
  Locale('en'),
];
''';

const localizationsFileWithMorePackages = '''
import 'package:ab_cd_android_home_page/ab_cd_android_home_page.dart';
import 'package:ab_cd_android_sign_in_page/ab_cd_android_sign_in_page.dart';
import 'package:ab_cd_ui_android/ab_cd_ui_android.dart';

const localizationsDelegates = <LocalizationsDelegate>[
  AbCdAndroidHomePageLocalizations.delegate,
  AbCdAndroidSignInPageLocalizations.delegate,
];

const supportedLocales = [
  Locale('en'),
];
''';

const localizationsFileWithLanguage = '''
import 'package:ab_cd_ui_android/ab_cd_ui_android.dart';

const localizationsDelegates = <LocalizationsDelegate>[];

const supportedLocales = [
  Locale('en'),
];
''';

const localizationsFileWithMoreLanguages = '''
import 'package:ab_cd_ui_android/ab_cd_ui_android.dart';

const localizationsDelegates = <LocalizationsDelegate>[];

const supportedLocales = [
  Locale('en'),
  Locale('fr'),
];
''';

PlatformAppFeaturePackage _getPlatformAppFeaturePackage(
  Platform platform, {
  Project? project,
  PubspecFile? pubspecFile,
  LocalizationsFile? localizationsFile,
  GeneratorBuilder? generator,
}) {
  return PlatformAppFeaturePackage(
    platform,
    project: project ?? getProject(),
    pubspecFile: pubspecFile ?? getPubspecFile(),
    localizationsFile: localizationsFile,
    generator: generator ?? (_) async => getMasonGenerator(),
  );
}

LocalizationsFile _getLocalizationsFile({
  PlatformAppFeaturePackage? platformAppFeaturePackage,
}) {
  return LocalizationsFile(
    platformAppFeaturePackage:
        platformAppFeaturePackage ?? getPlatformAppFeaturePackage(),
  );
}

PlatformRoutingFeaturePackage _getPlatformRoutingFeaturePackage(
  Platform platform, {
  Project? project,
  PubspecFile? pubspecFile,
  GeneratorBuilder? generator,
}) {
  return PlatformRoutingFeaturePackage(
    platform,
    project: project ?? getProject(),
    pubspecFile: pubspecFile ?? getPubspecFile(),
    generator: generator ?? (_) async => getMasonGenerator(),
  );
}

PlatformCustomFeaturePackage _getPlatformCustomFeaturePackage(
  String name,
  Platform platform, {
  Project? project,
  PubspecFile? pubspecFile,
  L10nFile? l10nFile,
  ArbDirectory? arbDirectory,
  LanguageLocalizationsFileBuilder? languageLocalizationsFile,
  FlutterGenl10nCommand? flutterGenl10n,
  GeneratorBuilder? generator,
}) {
  return PlatformCustomFeaturePackage(
    name,
    platform,
    project: project ?? getProject(),
    pubspecFile: pubspecFile ?? getPubspecFile(),
    l10nFile: l10nFile ?? getL10nFile(),
    arbDirectory: arbDirectory ?? getArbDirectory(),
    languageLocalizationsFile: languageLocalizationsFile,
    flutterGenl10n: flutterGenl10n ?? getFlutterGenl10n().call,
    generator: generator ?? (_) async => getMasonGenerator(),
  );
}

L10nFile _getL10nFile({
  PlatformFeaturePackage? platformFeaturePackage,
}) {
  return L10nFile(
    platformFeaturePackage:
        platformFeaturePackage ?? getPlatformCustomFeaturePackage(),
  );
}

LanguageLocalizationsFile _getLanguageLocalizationsFile(
  String language, {
  PlatformFeaturePackage? platformFeaturePackage,
}) {
  return LanguageLocalizationsFile(
    language,
    platformFeaturePackage:
        platformFeaturePackage ?? getPlatformCustomFeaturePackage(),
  );
}

ArbDirectory _getArbDirectory({
  PlatformFeaturePackage? platformFeaturePackage,
}) {
  return ArbDirectory(
    platformFeaturePackage:
        platformFeaturePackage ?? getPlatformCustomFeaturePackage(),
  );
}

ArbFile _getArbFile({
  required String language,
  ArbDirectory? arbDirectory,
  GeneratorBuilder? generator,
}) {
  return ArbFile(
    language: language,
    arbDirectory: arbDirectory ?? getArbDirectory(),
    generator: generator ?? (_) async => getMasonGenerator(),
  );
}

Bloc _getBloc({
  required String name,
  PlatformFeaturePackage? platformFeaturePackage,
  GeneratorBuilder? generator,
}) {
  return Bloc(
    name: name,
    platformFeaturePackage:
        platformFeaturePackage ?? getPlatformCustomFeaturePackage(),
    generator: generator ?? (_) async => getMasonGenerator(),
  );
}

Cubit _getCubit({
  required String name,
  PlatformFeaturePackage? platformFeaturePackage,
  GeneratorBuilder? generator,
}) {
  return Cubit(
    name: name,
    platformFeaturePackage:
        platformFeaturePackage ?? getPlatformCustomFeaturePackage(),
    generator: generator ?? (_) async => getMasonGenerator(),
  );
}

void main() {
  group('PlatformAppFeaturePackage', () {
    setUpAll(() {
      registerFallbackValue(FakeLogger());
      registerFallbackValue(FakeDirectoryGeneratorTarget());
    });

    group('.path', () {
      test('(android)', () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final platformAppFeaturePackage = _getPlatformAppFeaturePackage(
          Platform.android,
          project: project,
        );

        // Act + Assert
        expect(
          platformAppFeaturePackage.path,
          'project/path/packages/my_project/my_project_android/my_project_android_app',
        );
      });

      test('(ios)', () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final platformAppFeaturePackage = _getPlatformAppFeaturePackage(
          Platform.ios,
          project: project,
        );

        // Act + Assert
        expect(
          platformAppFeaturePackage.path,
          'project/path/packages/my_project/my_project_ios/my_project_ios_app',
        );
      });

      test('(linux)', () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final platformAppFeaturePackage = _getPlatformAppFeaturePackage(
          Platform.linux,
          project: project,
        );

        // Act + Assert
        expect(
          platformAppFeaturePackage.path,
          'project/path/packages/my_project/my_project_linux/my_project_linux_app',
        );
      });

      test('(macos)', () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final platformAppFeaturePackage = _getPlatformAppFeaturePackage(
          Platform.macos,
          project: project,
        );

        // Act + Assert
        expect(
          platformAppFeaturePackage.path,
          'project/path/packages/my_project/my_project_macos/my_project_macos_app',
        );
      });

      test('(web)', () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final platformAppFeaturePackage = _getPlatformAppFeaturePackage(
          Platform.web,
          project: project,
        );

        // Act + Assert
        expect(
          platformAppFeaturePackage.path,
          'project/path/packages/my_project/my_project_web/my_project_web_app',
        );
      });

      test('(windows)', () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final platformAppFeaturePackage = _getPlatformAppFeaturePackage(
          Platform.windows,
          project: project,
        );

        // Act + Assert
        expect(
          platformAppFeaturePackage.path,
          'project/path/packages/my_project/my_project_windows/my_project_windows_app',
        );
      });
    });

    test('.localizationsFile', () {
      final platformAppFeaturePackage = _getPlatformAppFeaturePackage(
        Platform.android,
      );

      // Act + Assert
      expect(
        platformAppFeaturePackage.localizationsFile,
        isA<LocalizationsFile>().having(
          (lf) => lf.platformAppFeaturePackage,
          'platformAppFeaturePackage',
          platformAppFeaturePackage,
        ),
      );
    });

    group('.create()', () {
      test(
        'completes successfully with correct output (android)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.path).thenReturn('project/path');
          when(() => project.name()).thenReturn('my_project');
          final generator = getMasonGenerator();
          final platformAppFeaturePackage = _getPlatformAppFeaturePackage(
            Platform.android,
            project: project,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await platformAppFeaturePackage.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'project/path/packages/my_project/my_project_android/my_project_android_app',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'android': true,
                'ios': false,
                'linux': false,
                'macos': false,
                'web': false,
                'windows': false,
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );

      test(
        'completes successfully with correct output (ios)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.path).thenReturn('project/path');
          when(() => project.name()).thenReturn('my_project');
          final generator = getMasonGenerator();
          final platformAppFeaturePackage = _getPlatformAppFeaturePackage(
            Platform.ios,
            project: project,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await platformAppFeaturePackage.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'project/path/packages/my_project/my_project_ios/my_project_ios_app',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'android': false,
                'ios': true,
                'linux': false,
                'macos': false,
                'web': false,
                'windows': false,
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );

      test(
        'completes successfully with correct output (linux)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.path).thenReturn('project/path');
          when(() => project.name()).thenReturn('my_project');
          final generator = getMasonGenerator();
          final platformAppFeaturePackage = _getPlatformAppFeaturePackage(
            Platform.linux,
            project: project,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await platformAppFeaturePackage.create(
            logger: logger,
          );
          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'project/path/packages/my_project/my_project_linux/my_project_linux_app',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'android': false,
                'ios': false,
                'linux': true,
                'macos': false,
                'web': false,
                'windows': false,
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );

      test(
        'completes successfully with correct output (macos)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.path).thenReturn('project/path');
          when(() => project.name()).thenReturn('my_project');
          final generator = getMasonGenerator();
          final platformAppFeaturePackage = _getPlatformAppFeaturePackage(
            Platform.macos,
            project: project,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await platformAppFeaturePackage.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'project/path/packages/my_project/my_project_macos/my_project_macos_app',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'android': false,
                'ios': false,
                'linux': false,
                'macos': true,
                'web': false,
                'windows': false,
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );

      test(
        'completes successfully with correct output (web)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.path).thenReturn('project/path');
          when(() => project.name()).thenReturn('my_project');
          final generator = getMasonGenerator();
          final platformAppFeaturePackage = _getPlatformAppFeaturePackage(
            Platform.web,
            project: project,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await platformAppFeaturePackage.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'project/path/packages/my_project/my_project_web/my_project_web_app',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'android': false,
                'ios': false,
                'linux': false,
                'macos': false,
                'web': true,
                'windows': false,
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );

      test(
        'completes successfully with correct output (windows)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.path).thenReturn('project/path');
          when(() => project.name()).thenReturn('my_project');
          final generator = getMasonGenerator();
          final platformAppFeaturePackage = _getPlatformAppFeaturePackage(
            Platform.windows,
            project: project,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await platformAppFeaturePackage.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'project/path/packages/my_project/my_project_windows/my_project_windows_app',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'android': false,
                'ios': false,
                'linux': false,
                'macos': false,
                'web': false,
                'windows': true,
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );
    });

    group('.registerCustomFeaturePackage()', () {
      test('adds package to pubspec and registers its localizations delegate',
          () async {
        // Arrange
        final pubspecFile = getPubspecFile();
        final localizationsFile = getLocalizationsFile();
        final platformAppFeaturePackage = _getPlatformAppFeaturePackage(
          Platform.android,
          pubspecFile: pubspecFile,
          localizationsFile: localizationsFile,
        );

        // Act
        final customFeaturePackage = getPlatformCustomFeaturePackage();
        when(() => customFeaturePackage.packageName())
            .thenReturn('feature_name');
        await platformAppFeaturePackage.registerCustomFeaturePackage(
          customFeaturePackage,
          logger: FakeLogger(),
        );

        // Assert
        verify(() => pubspecFile.setDependency('feature_name'));
        verify(
          () => localizationsFile.addLocalizationsDelegate(
            customFeaturePackage,
          ),
        );
      });
    });

    group('.unregisterCustomFeaturePackage()', () {
      test(
          'removes package from pubspec and unregisters its localizations delegate',
          () async {
        // Arrange
        final pubspecFile = getPubspecFile();
        final localizationsFile = getLocalizationsFile();
        final platformAppFeaturePackage = _getPlatformAppFeaturePackage(
          Platform.android,
          pubspecFile: pubspecFile,
          localizationsFile: localizationsFile,
        );

        // Act
        final customFeaturePackage = getPlatformCustomFeaturePackage();
        when(() => customFeaturePackage.packageName())
            .thenReturn('feature_name');
        await platformAppFeaturePackage.unregisterCustomFeaturePackage(
          customFeaturePackage,
          logger: FakeLogger(),
        );

        // Assert
        verify(() => pubspecFile.removeDependency('feature_name'));
        verify(
          () => localizationsFile.removeLocalizationsDelegate(
            customFeaturePackage,
          ),
        );
      });
    });
  });

  group('LocalizationsFile', () {
    setUpAll(() {
      registerFallbackValue(FakeLogger());
      registerFallbackValue(FakePlatformCustomFeaturePackage());
    });

    test('.path', () {
      // Arrange
      final platformAppFeaturePackage = getPlatformAppFeaturePackage();
      when(() => platformAppFeaturePackage.path)
          .thenReturn('platform_app_feature_package/path');
      final localizationsFile = _getLocalizationsFile(
        platformAppFeaturePackage: platformAppFeaturePackage,
      );

      // Act + Assert
      expect(
        localizationsFile.path,
        'platform_app_feature_package/path/lib/src/presentation/localizations.dart',
      );
    });

    test('.platformAppFeaturePackage', () {
      // Arrange
      final platformAppFeaturePackage = getPlatformAppFeaturePackage();
      final localizationsFile = _getLocalizationsFile(
        platformAppFeaturePackage: platformAppFeaturePackage,
      );

      // Act + Assert
      expect(
        localizationsFile.platformAppFeaturePackage,
        platformAppFeaturePackage,
      );
    });

    group('.addLocalizationsDelegate()', () {
      test(
        'adds import and the localizations delegate correctly',
        withTempDir(() {
          // Arrange
          final localizationsFile = _getLocalizationsFile();
          final file = File(localizationsFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(localizationsFileEmpty);

          // Act
          final customFeaturePackage = getPlatformCustomFeaturePackage();
          when(() => customFeaturePackage.packageName())
              .thenReturn('ab_cd_android_home_page');
          localizationsFile.addLocalizationsDelegate(customFeaturePackage);

          // Assert
          expect(file.readAsStringSync(), localizationsFileWithPackages);
        }),
      );

      test(
        'adds import and the localizations delegate correctly when diffrent packages already present',
        withTempDir(() {
          // Arrange
          final localizationsFile = _getLocalizationsFile();
          final file = File(localizationsFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(localizationsFileWithPackages);

          // Act
          final customFeaturePackage = getPlatformCustomFeaturePackage();
          when(() => customFeaturePackage.packageName())
              .thenReturn('ab_cd_android_sign_in_page');
          localizationsFile.addLocalizationsDelegate(customFeaturePackage);

          // Assert
          expect(file.readAsStringSync(), localizationsFileWithMorePackages);
        }),
      );

      test(
        'does nothing when same package already present',
        withTempDir(() {
          // Arrange
          final localizationsFile = _getLocalizationsFile();
          final file = File(localizationsFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(localizationsFileWithPackages);

          // Act
          final customFeaturePackage = getPlatformCustomFeaturePackage();
          when(() => customFeaturePackage.packageName())
              .thenReturn('ab_cd_android_home_page');
          localizationsFile.addLocalizationsDelegate(customFeaturePackage);

          // Assert
          expect(file.readAsStringSync(), localizationsFileWithPackages);
        }),
      );
    });

    group('.removeLocalizationsDelegate()', () {
      test(
        'removes import and the localizations delegate correctly',
        withTempDir(() {
          // Arrange
          final localizationsFile = _getLocalizationsFile();
          final file = File(localizationsFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(localizationsFileWithPackages);

          // Act
          final customFeaturePackage = getPlatformCustomFeaturePackage();
          when(() => customFeaturePackage.packageName())
              .thenReturn('ab_cd_android_home_page');
          localizationsFile.removeLocalizationsDelegate(customFeaturePackage);

          // Assert
          expect(file.readAsStringSync(), localizationsFileEmpty);
        }),
      );

      test(
        'removes import and the localizations delegate correctly when diffrent packages already present',
        withTempDir(() {
          // Arrange
          final localizationsFile = _getLocalizationsFile();
          final file = File(localizationsFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(localizationsFileWithMorePackages);

          // Act
          final customFeaturePackage = getPlatformCustomFeaturePackage();
          when(() => customFeaturePackage.packageName())
              .thenReturn('ab_cd_android_sign_in_page');
          localizationsFile.removeLocalizationsDelegate(customFeaturePackage);

          // Assert
          expect(file.readAsStringSync(), localizationsFileWithPackages);
        }),
      );

      test(
        'does nothing when no packages are present',
        withTempDir(() {
          // Arrange
          final localizationsFile = _getLocalizationsFile();
          final file = File(localizationsFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(localizationsFileEmpty);

          // Act
          final customFeaturePackage = getPlatformCustomFeaturePackage();
          when(() => customFeaturePackage.packageName())
              .thenReturn('ab_cd_android_home_page');
          localizationsFile.removeLocalizationsDelegate(customFeaturePackage);

          // Assert
          expect(file.readAsStringSync(), localizationsFileEmpty);
        }),
      );
    });

    group('.addSupportedLanguage()', () {
      test(
        'adds the supported language correctly',
        withTempDir(() {
          // Arrange
          final localizationsFile = _getLocalizationsFile();
          final file = File(localizationsFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(localizationsFileWithLanguage);

          // Act
          localizationsFile.addSupportedLanguage('fr');

          // Assert
          expect(file.readAsStringSync(), localizationsFileWithMoreLanguages);
        }),
      );

      test(
        'does nothing when the language already exists',
        withTempDir(() {
          // Arrange
          final localizationsFile = _getLocalizationsFile();
          final file = File(localizationsFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(localizationsFileWithLanguage);

          // Act
          localizationsFile.addSupportedLanguage('en');

          // Assert
          expect(file.readAsStringSync(), localizationsFileWithLanguage);
        }),
      );
    });

    group('.removeSupportedLanguage()', () {
      test(
        'removes the supported language correctly',
        withTempDir(() {
          // Arrange
          final localizationsFile = _getLocalizationsFile();
          final file = File(localizationsFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(localizationsFileWithMoreLanguages);

          // Act
          localizationsFile.removeSupportedLanguage('fr');

          // Assert
          expect(file.readAsStringSync(), localizationsFileWithLanguage);
        }),
      );

      test(
        'does nothing when the language does not exist',
        withTempDir(() {
          // Arrange
          final localizationsFile = _getLocalizationsFile();
          final file = File(localizationsFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(localizationsFileWithLanguage);

          // Act
          localizationsFile.removeSupportedLanguage('fr');

          // Assert
          expect(file.readAsStringSync(), localizationsFileWithLanguage);
        }),
      );
    });
  });

  group('PlatformRoutingFeaturePackage', () {
    setUpAll(() {
      registerFallbackValue(FakeLogger());
      registerFallbackValue(FakeDirectoryGeneratorTarget());
    });

    group('.path', () {
      test('(android)', () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final platformRoutingFeaturePackage = _getPlatformRoutingFeaturePackage(
          Platform.android,
          project: project,
        );

        // Act + Assert
        expect(
          platformRoutingFeaturePackage.path,
          'project/path/packages/my_project/my_project_android/my_project_android_routing',
        );
      });

      test('(ios)', () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final platformRoutingFeaturePackage = _getPlatformRoutingFeaturePackage(
          Platform.ios,
          project: project,
        );

        // Act + Assert
        expect(
          platformRoutingFeaturePackage.path,
          'project/path/packages/my_project/my_project_ios/my_project_ios_routing',
        );
      });

      test('(linux)', () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final platformRoutingFeaturePackage = _getPlatformRoutingFeaturePackage(
          Platform.linux,
          project: project,
        );

        // Act + Assert
        expect(
          platformRoutingFeaturePackage.path,
          'project/path/packages/my_project/my_project_linux/my_project_linux_routing',
        );
      });

      test('(macos)', () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final platformRoutingFeaturePackage = _getPlatformRoutingFeaturePackage(
          Platform.macos,
          project: project,
        );

        // Act + Assert
        expect(
          platformRoutingFeaturePackage.path,
          'project/path/packages/my_project/my_project_macos/my_project_macos_routing',
        );
      });

      test('(web)', () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final platformRoutingFeaturePackage = _getPlatformRoutingFeaturePackage(
          Platform.web,
          project: project,
        );

        // Act + Assert
        expect(
          platformRoutingFeaturePackage.path,
          'project/path/packages/my_project/my_project_web/my_project_web_routing',
        );
      });

      test('(windows)', () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final platformRoutingFeaturePackage = _getPlatformRoutingFeaturePackage(
          Platform.windows,
          project: project,
        );

        // Act + Assert
        expect(
          platformRoutingFeaturePackage.path,
          'project/path/packages/my_project/my_project_windows/my_project_windows_routing',
        );
      });
    });

    group('.create()', () {
      test(
        'completes successfully with correct output (android)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.path).thenReturn('project/path');
          when(() => project.name()).thenReturn('my_project');
          final generator = getMasonGenerator();
          final platformRoutingFeaturePackage =
              _getPlatformRoutingFeaturePackage(
            Platform.android,
            project: project,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await platformRoutingFeaturePackage.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'project/path/packages/my_project/my_project_android/my_project_android_routing',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'android': true,
                'ios': false,
                'linux': false,
                'macos': false,
                'web': false,
                'windows': false,
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );

      test(
        'completes successfully with correct output (ios)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.path).thenReturn('project/path');
          when(() => project.name()).thenReturn('my_project');
          final generator = getMasonGenerator();
          final platformRoutingFeaturePackage =
              _getPlatformRoutingFeaturePackage(
            Platform.ios,
            project: project,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await platformRoutingFeaturePackage.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'project/path/packages/my_project/my_project_ios/my_project_ios_routing',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'android': false,
                'ios': true,
                'linux': false,
                'macos': false,
                'web': false,
                'windows': false,
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );

      test(
        'completes successfully with correct output (linux)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.path).thenReturn('project/path');
          when(() => project.name()).thenReturn('my_project');
          final generator = getMasonGenerator();
          final platformRoutingFeaturePackage =
              _getPlatformRoutingFeaturePackage(
            Platform.linux,
            project: project,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await platformRoutingFeaturePackage.create(
            logger: logger,
          );
          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'project/path/packages/my_project/my_project_linux/my_project_linux_routing',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'android': false,
                'ios': false,
                'linux': true,
                'macos': false,
                'web': false,
                'windows': false,
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );

      test(
        'completes successfully with correct output (macos)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.path).thenReturn('project/path');
          when(() => project.name()).thenReturn('my_project');
          final generator = getMasonGenerator();
          final platformRoutingFeaturePackage =
              _getPlatformRoutingFeaturePackage(
            Platform.macos,
            project: project,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await platformRoutingFeaturePackage.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'project/path/packages/my_project/my_project_macos/my_project_macos_routing',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'android': false,
                'ios': false,
                'linux': false,
                'macos': true,
                'web': false,
                'windows': false,
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );

      test(
        'completes successfully with correct output (web)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.path).thenReturn('project/path');
          when(() => project.name()).thenReturn('my_project');
          final generator = getMasonGenerator();
          final platformRoutingFeaturePackage =
              _getPlatformRoutingFeaturePackage(
            Platform.web,
            project: project,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await platformRoutingFeaturePackage.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'project/path/packages/my_project/my_project_web/my_project_web_routing',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'android': false,
                'ios': false,
                'linux': false,
                'macos': false,
                'web': true,
                'windows': false,
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );

      test(
        'completes successfully with correct output (windows)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.path).thenReturn('project/path');
          when(() => project.name()).thenReturn('my_project');
          final generator = getMasonGenerator();
          final platformRoutingFeaturePackage =
              _getPlatformRoutingFeaturePackage(
            Platform.windows,
            project: project,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await platformRoutingFeaturePackage.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'project/path/packages/my_project/my_project_windows/my_project_windows_routing',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'android': false,
                'ios': false,
                'linux': false,
                'macos': false,
                'web': false,
                'windows': true,
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );
    });

    group('.registerCustomFeaturePackage()', () {
      test('adds package to pubspec', () async {
        // Arrange
        final pubspecFile = getPubspecFile();
        final platformAppFeaturePackage = _getPlatformRoutingFeaturePackage(
          Platform.android,
          pubspecFile: pubspecFile,
        );

        // Act
        final customFeaturePackage = getPlatformCustomFeaturePackage();
        when(() => customFeaturePackage.packageName())
            .thenReturn('feature_name');
        await platformAppFeaturePackage.registerCustomFeaturePackage(
          customFeaturePackage,
          logger: FakeLogger(),
        );

        // Assert
        verify(() => pubspecFile.setDependency('feature_name'));
      });
    });

    group('.unregisterCustomFeaturePackage()', () {
      test('removes package from pubspec', () async {
        // Arrange
        final pubspecFile = getPubspecFile();
        final platformAppFeaturePackage = _getPlatformRoutingFeaturePackage(
          Platform.android,
          pubspecFile: pubspecFile,
        );

        // Act
        final customFeaturePackage = getPlatformCustomFeaturePackage();
        when(() => customFeaturePackage.packageName())
            .thenReturn('feature_name');
        await platformAppFeaturePackage.unregisterCustomFeaturePackage(
          customFeaturePackage,
          logger: FakeLogger(),
        );

        // Assert
        verify(() => pubspecFile.removeDependency('feature_name'));
      });
    });
  });

  group('PlatformCustomFeaturePackage', () {
    setUpAll(() {
      registerFallbackValue(FakeLogger());
      registerFallbackValue(FakeDirectoryGeneratorTarget());
    });

    group('.path', () {
      test('(android)', () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final platformCustomFeaturePackage = _getPlatformCustomFeaturePackage(
          'my_feature',
          Platform.android,
          project: project,
        );

        // Act + Assert
        expect(
          platformCustomFeaturePackage.path,
          'project/path/packages/my_project/my_project_android/my_project_android_my_feature',
        );
      });

      test('(ios)', () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final platformCustomFeaturePackage = _getPlatformCustomFeaturePackage(
          'my_feature',
          Platform.ios,
          project: project,
        );

        // Act + Assert
        expect(
          platformCustomFeaturePackage.path,
          'project/path/packages/my_project/my_project_ios/my_project_ios_my_feature',
        );
      });

      test('(linux)', () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final platformCustomFeaturePackage = _getPlatformCustomFeaturePackage(
          'my_feature',
          Platform.linux,
          project: project,
        );

        // Act + Assert
        expect(
          platformCustomFeaturePackage.path,
          'project/path/packages/my_project/my_project_linux/my_project_linux_my_feature',
        );
      });

      test('(macos)', () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final platformCustomFeaturePackage = _getPlatformCustomFeaturePackage(
          'my_feature',
          Platform.macos,
          project: project,
        );

        // Act + Assert
        expect(
          platformCustomFeaturePackage.path,
          'project/path/packages/my_project/my_project_macos/my_project_macos_my_feature',
        );
      });

      test('(web)', () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final platformCustomFeaturePackage = _getPlatformCustomFeaturePackage(
          'my_feature',
          Platform.web,
          project: project,
        );

        // Act + Assert
        expect(
          platformCustomFeaturePackage.path,
          'project/path/packages/my_project/my_project_web/my_project_web_my_feature',
        );
      });

      test('(windows)', () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final platformCustomFeaturePackage = _getPlatformCustomFeaturePackage(
          'my_feature',
          Platform.windows,
          project: project,
        );

        // Act + Assert
        expect(
          platformCustomFeaturePackage.path,
          'project/path/packages/my_project/my_project_windows/my_project_windows_my_feature',
        );
      });
    });

    test('.platformNativeDirectory', () {
      // Arrange
      final platformCustomFeaturePackage = _getPlatformCustomFeaturePackage(
        'foo',
        Platform.android,
      );

      // Assert
      expect(
        platformCustomFeaturePackage.languageLocalizationsFile,
        isA<LanguageLocalizationsFileBuilder>().having(
          (languageLocalizationsFile) =>
              languageLocalizationsFile(language: 'de'),
          'returns',
          isA<LanguageLocalizationsFile>(),
        ),
      );
    });

    group('.supportedLanguages()', () {
      test('returns correct supported languages', () {
        // Arrange
        final arbDirectory = getArbDirectory();
        final arbFile1 = getArbFile();
        when(() => arbFile1.language).thenReturn('de');
        final arbFile2 = getArbFile();
        when(() => arbFile2.language).thenReturn('fr');
        when(() => arbDirectory.arbFiles()).thenReturn([arbFile1, arbFile2]);
        final platformCustomFeaturePackage = _getPlatformCustomFeaturePackage(
          'my_feature',
          Platform.android,
          arbDirectory: arbDirectory,
        );

        // Act + Assert
        expect(
          platformCustomFeaturePackage.supportedLanguages(),
          equals(['de', 'fr']),
        );
      });
    });

    group('.supportsLanguage()', () {
      test('returns true when language is supported', () {
        // Arrange
        final arbDirectory = getArbDirectory();
        final arbFile1 = getArbFile();
        when(() => arbFile1.language).thenReturn('de');
        when(() => arbDirectory.arbFiles()).thenReturn([arbFile1]);
        final platformCustomFeaturePackage = _getPlatformCustomFeaturePackage(
          'my_feature',
          Platform.android,
          arbDirectory: arbDirectory,
        );

        // Act + Assert
        expect(platformCustomFeaturePackage.supportsLanguage('de'), true);
      });

      test('returns false when language is NOT supported', () {
        // Arrange
        final arbDirectory = getArbDirectory();
        final arbFile1 = getArbFile();
        when(() => arbFile1.language).thenReturn('de');
        when(() => arbDirectory.arbFiles()).thenReturn([arbFile1]);
        final platformCustomFeaturePackage = _getPlatformCustomFeaturePackage(
          'my_feature',
          Platform.android,
          arbDirectory: arbDirectory,
        );

        // Act + Assert
        expect(platformCustomFeaturePackage.supportsLanguage('fr'), false);
      });
    });

    test('.defaultLanguage()', () {
      // Arrange
      final l10nFile = getL10nFile();
      when(() => l10nFile.templateArbFile()).thenReturn('my_feature_fr.arb');
      final platformCustomFeaturePackage = _getPlatformCustomFeaturePackage(
        'my_feature',
        Platform.android,
        l10nFile: l10nFile,
      );

      // Act + Assert
      expect(platformCustomFeaturePackage.defaultLanguage(), 'fr');
    });

    group('.create()', () {
      test(
        'completes successfully with correct output (android)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.path).thenReturn('project/path');
          when(() => project.name()).thenReturn('my_project');
          final generator = getMasonGenerator();
          final platformCustomFeaturePackage = _getPlatformCustomFeaturePackage(
            'my_feature',
            Platform.android,
            project: project,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await platformCustomFeaturePackage.create(logger: logger);

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'project/path/packages/my_project/my_project_android/my_project_android_my_feature',
                ),
              ),
              vars: <String, dynamic>{
                'name': 'my_feature',
                'description': 'The My Feature feature',
                'project_name': 'my_project',
                'android': true,
                'ios': false,
                'linux': false,
                'macos': false,
                'web': false,
                'windows': false,
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );

      test(
        'completes successfully with correct output (ios)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.path).thenReturn('project/path');
          when(() => project.name()).thenReturn('my_project');
          final generator = getMasonGenerator();
          final platformCustomFeaturePackage = _getPlatformCustomFeaturePackage(
            'my_feature',
            Platform.ios,
            project: project,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await platformCustomFeaturePackage.create(logger: logger);

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'project/path/packages/my_project/my_project_ios/my_project_ios_my_feature',
                ),
              ),
              vars: <String, dynamic>{
                'name': 'my_feature',
                'description': 'The My Feature feature',
                'project_name': 'my_project',
                'android': false,
                'ios': true,
                'linux': false,
                'macos': false,
                'web': false,
                'windows': false,
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );

      test(
        'completes successfully with correct output (linux)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.path).thenReturn('project/path');
          when(() => project.name()).thenReturn('my_project');
          final generator = getMasonGenerator();
          final platformCustomFeaturePackage = _getPlatformCustomFeaturePackage(
            'my_feature',
            Platform.linux,
            project: project,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await platformCustomFeaturePackage.create(logger: logger);

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'project/path/packages/my_project/my_project_linux/my_project_linux_my_feature',
                ),
              ),
              vars: <String, dynamic>{
                'name': 'my_feature',
                'description': 'The My Feature feature',
                'project_name': 'my_project',
                'android': false,
                'ios': false,
                'linux': true,
                'macos': false,
                'web': false,
                'windows': false,
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );

      test(
        'completes successfully with correct output (macos)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.path).thenReturn('project/path');
          when(() => project.name()).thenReturn('my_project');
          final generator = getMasonGenerator();
          final platformCustomFeaturePackage = _getPlatformCustomFeaturePackage(
            'my_feature',
            Platform.macos,
            project: project,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await platformCustomFeaturePackage.create(logger: logger);

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'project/path/packages/my_project/my_project_macos/my_project_macos_my_feature',
                ),
              ),
              vars: <String, dynamic>{
                'name': 'my_feature',
                'description': 'The My Feature feature',
                'project_name': 'my_project',
                'android': false,
                'ios': false,
                'linux': false,
                'macos': true,
                'web': false,
                'windows': false,
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );

      test(
        'completes successfully with correct output (web)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.path).thenReturn('project/path');
          when(() => project.name()).thenReturn('my_project');
          final generator = getMasonGenerator();
          final platformCustomFeaturePackage = _getPlatformCustomFeaturePackage(
            'my_feature',
            Platform.web,
            project: project,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await platformCustomFeaturePackage.create(logger: logger);

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'project/path/packages/my_project/my_project_web/my_project_web_my_feature',
                ),
              ),
              vars: <String, dynamic>{
                'name': 'my_feature',
                'description': 'The My Feature feature',
                'project_name': 'my_project',
                'android': false,
                'ios': false,
                'linux': false,
                'macos': false,
                'web': true,
                'windows': false,
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );

      test(
        'completes successfully with correct output (windows)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.path).thenReturn('project/path');
          when(() => project.name()).thenReturn('my_project');
          final generator = getMasonGenerator();
          final platformCustomFeaturePackage = _getPlatformCustomFeaturePackage(
            'my_feature',
            Platform.windows,
            project: project,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await platformCustomFeaturePackage.create(logger: logger);

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'project/path/packages/my_project/my_project_windows/my_project_windows_my_feature',
                ),
              ),
              vars: <String, dynamic>{
                'name': 'my_feature',
                'description': 'The My Feature feature',
                'project_name': 'my_project',
                'android': false,
                'ios': false,
                'linux': false,
                'macos': false,
                'web': false,
                'windows': true,
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );

      test(
        'completes successfully with correct output with custom description',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.path).thenReturn('project/path');
          when(() => project.name()).thenReturn('my_project');
          final generator = getMasonGenerator();
          final platformCustomFeaturePackage = _getPlatformCustomFeaturePackage(
            'my_feature',
            Platform.android,
            project: project,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await platformCustomFeaturePackage.create(
            description: 'some desc',
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'project/path/packages/my_project/my_project_android/my_project_android_my_feature',
                ),
              ),
              vars: <String, dynamic>{
                'name': 'my_feature',
                'description': 'some desc',
                'project_name': 'my_project',
                'android': true,
                'ios': false,
                'linux': false,
                'macos': false,
                'web': false,
                'windows': false,
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );
    });

    test('.bloc()', () {
      // Arrange
      final platformCustomFeaturePackage = _getPlatformCustomFeaturePackage(
        'my_feature',
        Platform.android,
      );

      // Act + Assert
      expect(
        platformCustomFeaturePackage.bloc(name: 'MyCool'),
        isA<Bloc>()
            .having(
              (bloc) => bloc.name,
              'name',
              'MyCool',
            )
            .having(
              (bloc) => bloc.platformFeaturePackage,
              'platformFeaturePackage',
              platformCustomFeaturePackage,
            ),
      );
    });

    test('.cubit()', () {
      // Arrange
      final platformCustomFeaturePackage = _getPlatformCustomFeaturePackage(
        'my_feature',
        Platform.android,
      );

      // Act + Assert
      expect(
        platformCustomFeaturePackage.cubit(name: 'MyCool'),
        isA<Cubit>()
            .having(
              (cubit) => cubit.name,
              'name',
              'MyCool',
            )
            .having(
              (cubit) => cubit.platformFeaturePackage,
              'platformFeaturePackage',
              platformCustomFeaturePackage,
            ),
      );
    });

    group('.addLanguage()', () {
      test('completes successfully with correct output', () async {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final arbFile = getArbFile();
        when(() => arbFile.exists()).thenReturn(false);
        when(() => arbFile.create(logger: any(named: 'logger')))
            .thenAnswer((_) async {});
        final arbDirectory = getArbDirectory();
        when(() => arbDirectory.arbFile(language: 'de')).thenReturn(arbFile);
        final flutterGenl10n = getFlutterGenl10n();
        final platformCustomFeaturePackage = _getPlatformCustomFeaturePackage(
          'my_feature',
          Platform.android,
          project: project,
          arbDirectory: arbDirectory,
          flutterGenl10n: flutterGenl10n,
        );

        // Act
        final logger = FakeLogger();
        await platformCustomFeaturePackage.addLanguage(
          language: 'de',
          logger: logger,
        );

        // Assert
        verify(() => arbDirectory.arbFile(language: 'de')).called(1);
        verify(() => arbFile.create(logger: logger)).called(1);
        verify(
          () => flutterGenl10n(
            cwd:
                'project/path/packages/my_project/my_project_android/my_project_android_my_feature',
            logger: logger,
          ),
        ).called(1);
      });

      test(
          'completes successfully with correct output when the arb file of the language already exists',
          () async {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final arbFile = getArbFile();
        when(() => arbFile.exists()).thenReturn(true);
        when(() => arbFile.create(logger: any(named: 'logger')))
            .thenAnswer((_) async {});
        final arbDirectory = getArbDirectory();
        when(() => arbDirectory.arbFile(language: 'de')).thenReturn(arbFile);
        final flutterGenl10n = getFlutterGenl10n();
        final platformCustomFeaturePackage = _getPlatformCustomFeaturePackage(
          'my_feature',
          Platform.android,
          project: project,
          arbDirectory: arbDirectory,
          flutterGenl10n: flutterGenl10n,
        );

        // Act
        final logger = FakeLogger();
        await platformCustomFeaturePackage.addLanguage(
          language: 'de',
          logger: logger,
        );

        // Assert
        verify(() => arbDirectory.arbFile(language: 'de')).called(1);
        verifyNever(() => arbFile.create(logger: logger));
        verifyNever(
          () => flutterGenl10n(
            cwd:
                'project/path/packages/my_project/my_project_android/my_project_android_my_feature',
            logger: logger,
          ),
        );
      });
    });

    group('.removeLanguage()', () {
      test('completes successfully with correct output', () async {
        // Arrange
        final arbFile = getArbFile();
        when(() => arbFile.exists()).thenReturn(true);
        when(() => arbFile.create(logger: any(named: 'logger')))
            .thenAnswer((_) async {});
        final arbDirectory = getArbDirectory();
        when(() => arbDirectory.arbFile(language: 'de')).thenReturn(arbFile);
        final languageLocalizationsFile = getLanguageLocalizationsFile();
        when(() => languageLocalizationsFile.exists()).thenReturn(true);
        final flutterGenl10n = getFlutterGenl10n();
        final platformCustomFeaturePackage = _getPlatformCustomFeaturePackage(
          'my_feature',
          Platform.android,
          arbDirectory: arbDirectory,
          languageLocalizationsFile: ({required String language}) =>
              languageLocalizationsFile,
          flutterGenl10n: flutterGenl10n,
        );

        // Act
        final logger = FakeLogger();
        await platformCustomFeaturePackage.removeLanguage(
          language: 'de',
          logger: logger,
        );

        // Assert
        verify(() => arbDirectory.arbFile(language: 'de')).called(1);
        verify(() => arbFile.delete(logger: logger)).called(1);
      });

      test(
          'completes successfully with correct output when the arb file of the language does NOT exists',
          () async {
        final arbFile = getArbFile();
        when(() => arbFile.exists()).thenReturn(false);
        when(() => arbFile.create(logger: any(named: 'logger')))
            .thenAnswer((_) async {});
        final arbDirectory = getArbDirectory();
        when(() => arbDirectory.arbFile(language: 'de')).thenReturn(arbFile);
        final flutterGenl10n = getFlutterGenl10n();
        final platformCustomFeaturePackage = _getPlatformCustomFeaturePackage(
          'my_feature',
          Platform.android,
          arbDirectory: arbDirectory,
          flutterGenl10n: flutterGenl10n,
        );

        // Act
        final logger = FakeLogger();
        await platformCustomFeaturePackage.removeLanguage(
          language: 'de',
          logger: logger,
        );

        // Assert
        verify(() => arbDirectory.arbFile(language: 'de')).called(1);
        verifyNever(() => arbFile.delete(logger: logger));
        verifyNever(() => arbFile.delete(logger: logger));
      });
    });
  });

  group('L10nFile', () {
    test('.path', () {
      // Arrange
      final platformFeaturePackage = getPlatformCustomFeaturePackage();
      when(() => platformFeaturePackage.path)
          .thenReturn('platform_feature_package/path');
      final l10nFile =
          _getL10nFile(platformFeaturePackage: platformFeaturePackage);

      // Act + Assert
      expect(l10nFile.path, 'platform_feature_package/path/l10n.yaml');
    });

    group('.templateArbFile()', () {
      test(
        'reads the template-arb-file property',
        withTempDir(() {
          // Arrange
          final l10nFile = _getL10nFile();
          File(l10nFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync('template-arb-file: foo.dart');

          expect(l10nFile.templateArbFile(), 'foo.dart');
        }),
      );

      test(
        'throws ReadTemplateArbFileFailure when the template-arb-file property does not exist',
        withTempDir(() {
          // Arrange
          final l10nFile = _getL10nFile();
          File(l10nFile.path).createSync(recursive: true);

          // Act
          expect(
            () => l10nFile.templateArbFile(),
            throwsA(isA<ReadTemplateArbFileFailure>()),
          );
        }),
      );

      test(
        'throws ReadTemplateArbFileFailure when the file does not exist',
        withTempDir(() {
          // Arrange
          final l10nFile = _getL10nFile();

          // Act
          expect(
            () => l10nFile.templateArbFile(),
            throwsA(isA<ReadTemplateArbFileFailure>()),
          );
        }),
      );
    });
  });

  group('LanguageLocalizationsFile', () {
    test('.path', () {
      // Arrange
      final platformFeaturePackage = getPlatformCustomFeaturePackage();
      when(() => platformFeaturePackage.path)
          .thenReturn('platform_feature/path');
      when(() => platformFeaturePackage.packageName()).thenReturn('my_feature');
      final languageLocalizationsFile = _getLanguageLocalizationsFile(
        'fr',
        platformFeaturePackage: platformFeaturePackage,
      );

      // Act + Assert
      expect(
        languageLocalizationsFile.path,
        'platform_feature/path/lib/src/presentation/l10n/my_feature_localizations_fr.dart',
      );
    });

    group('.delete()', () {
      test(
        'removes the underlying file',
        withTempDir(() {
          // Arrange
          final languageLocalizationsFile = _getLanguageLocalizationsFile('fr');
          final file = File(languageLocalizationsFile.path)
            ..createSync(recursive: true);

          // Act
          languageLocalizationsFile.delete(logger: FakeLogger());

          // Assert
          expect(file.existsSync(), false);
        }),
      );
    });
  });

  group('ArbDirectory', () {
    test('.platformFeaturePackage', () {
      // Arrange
      final platformFeaturePackage = getPlatformCustomFeaturePackage();
      final arbDirectory = _getArbDirectory(
        platformFeaturePackage: platformFeaturePackage,
      );

      // Act + Assert
      expect(arbDirectory.platformFeaturePackage, platformFeaturePackage);
    });

    group('.arbFiles()', () {
      test('returns empty list if no arb files exists', () {
        // Arrange
        final arbDirectory = _getArbDirectory();

        // Assert
        expect(arbDirectory.arbFiles(), []);
      });

      test(
        'returns list of arb files if arb files exists',
        withTempDir(() {
          // Arrange
          final arbDirectory = _getArbDirectory();
          File(_getArbFile(language: 'fr', arbDirectory: arbDirectory).path)
              .createSync(recursive: true);
          File(_getArbFile(language: 'de', arbDirectory: arbDirectory).path)
              .createSync(recursive: true);

          // Assert
          expect(arbDirectory.arbFiles(), hasLength(2));
          expect(
            arbDirectory.arbFiles(),
            contains(
              isA<ArbFile>().having(
                (arbFile) => arbFile.language,
                'language',
                'fr',
              ),
            ),
          );
          expect(
            arbDirectory.arbFiles(),
            contains(
              isA<ArbFile>().having(
                (arbFile) => arbFile.language,
                'language',
                'de',
              ),
            ),
          );
        }),
      );
    });

    test('.arbFile()', () {
      // Arrange
      final platformFeaturePackage = getPlatformCustomFeaturePackage();
      final arbDirectory = _getArbDirectory(
        platformFeaturePackage: platformFeaturePackage,
      );

      // Act + Assert
      expect(
        arbDirectory.arbFile(language: 'fr'),
        isA<ArbFile>()
            .having(
              (arbFile) => arbFile.language,
              'language',
              'fr',
            )
            .having(
              (arbFile) => arbFile.arbDirectory,
              'arbDirectory',
              arbDirectory,
            ),
      );
    });
  });

  group('ArbFile', () {
    setUpAll(() {
      registerFallbackValue(FakeDirectoryGeneratorTarget());
    });

    test('.arbDirectory', () {
      // Arrange
      final arbDirectory = getArbDirectory();
      final arbfile = _getArbFile(
        language: 'fr',
        arbDirectory: arbDirectory,
      );

      // Act + Assert
      expect(arbfile.arbDirectory, arbDirectory);
    });

    test('.language', () {
      // Arrange
      final arbfile = _getArbFile(language: 'fr');

      // Act + Assert
      expect(arbfile.language, 'fr');
    });

    group('.create()', () {
      test(
        'completes successfully with correct output',
        withTempDir(() async {
          // Arrange
          final platformFeaturePackage = getPlatformCustomFeaturePackage();
          when(() => platformFeaturePackage.name).thenReturn('my_feature');
          final arbDirectory = getArbDirectory();
          when(() => arbDirectory.path).thenReturn('arb_directory/path');
          when(() => arbDirectory.platformFeaturePackage)
              .thenReturn(platformFeaturePackage);
          final generator = getMasonGenerator();
          final arbfile = _getArbFile(
            language: 'fr',
            arbDirectory: arbDirectory,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await arbfile.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'arb_directory/path',
                ),
              ),
              vars: <String, dynamic>{
                'feature_name': 'my_feature',
                'language': 'fr',
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );
    });
  });

  group('Bloc', () {
    setUpAll(() {
      registerFallbackValue(FakeDirectoryGeneratorTarget());
    });

    test('.name', () {
      // Arrange
      final bloc = _getBloc(name: 'Cool');

      // Act + Assert
      expect(bloc.name, 'Cool');
    });

    test('.platformFeaturePackage', () {
      // Arrange
      final platformFeaturePackage = getPlatformCustomFeaturePackage();
      final bloc = _getBloc(
        name: 'Cool',
        platformFeaturePackage: platformFeaturePackage,
      );

      // Act + Assert
      expect(bloc.platformFeaturePackage, platformFeaturePackage);
    });

    group('create', () {
      test(
        'completes successfully with correct output (android)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.name()).thenReturn('my_project');
          final platformFeaturePackage = getPlatformCustomFeaturePackage();
          when(() => platformFeaturePackage.path)
              .thenReturn('platform_feature_package/path');
          when(() => platformFeaturePackage.platform)
              .thenReturn(Platform.android);
          when(() => platformFeaturePackage.name).thenReturn('my_feature');
          when(() => platformFeaturePackage.project).thenReturn(project);
          final generator = getMasonGenerator();
          final bloc = _getBloc(
            name: 'Cool',
            platformFeaturePackage: platformFeaturePackage,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await bloc.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'platform_feature_package/path',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'name': 'Cool',
                'platform': 'android',
                'feature_name': 'my_feature',
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );

      test(
        'completes successfully with correct output (ios)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.name()).thenReturn('my_project');
          final platformFeaturePackage = getPlatformCustomFeaturePackage();
          when(() => platformFeaturePackage.path)
              .thenReturn('platform_feature_package/path');
          when(() => platformFeaturePackage.platform).thenReturn(Platform.ios);
          when(() => platformFeaturePackage.name).thenReturn('my_feature');
          when(() => platformFeaturePackage.project).thenReturn(project);
          final generator = getMasonGenerator();
          final bloc = _getBloc(
            name: 'Cool',
            platformFeaturePackage: platformFeaturePackage,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await bloc.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'platform_feature_package/path',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'name': 'Cool',
                'platform': 'ios',
                'feature_name': 'my_feature',
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );

      test(
        'completes successfully with correct output (linux)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.name()).thenReturn('my_project');
          final platformFeaturePackage = getPlatformCustomFeaturePackage();
          when(() => platformFeaturePackage.path)
              .thenReturn('platform_feature_package/path');
          when(() => platformFeaturePackage.platform)
              .thenReturn(Platform.linux);
          when(() => platformFeaturePackage.name).thenReturn('my_feature');
          when(() => platformFeaturePackage.project).thenReturn(project);
          final generator = getMasonGenerator();
          final bloc = _getBloc(
            name: 'Cool',
            platformFeaturePackage: platformFeaturePackage,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await bloc.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'platform_feature_package/path',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'name': 'Cool',
                'platform': 'linux',
                'feature_name': 'my_feature',
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );

      test(
        'completes successfully with correct output (macos)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.name()).thenReturn('my_project');
          final platformFeaturePackage = getPlatformCustomFeaturePackage();
          when(() => platformFeaturePackage.path)
              .thenReturn('platform_feature_package/path');
          when(() => platformFeaturePackage.platform)
              .thenReturn(Platform.macos);
          when(() => platformFeaturePackage.name).thenReturn('my_feature');
          when(() => platformFeaturePackage.project).thenReturn(project);
          final generator = getMasonGenerator();
          final bloc = _getBloc(
            name: 'Cool',
            platformFeaturePackage: platformFeaturePackage,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await bloc.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'platform_feature_package/path',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'name': 'Cool',
                'platform': 'macos',
                'feature_name': 'my_feature',
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );

      test(
        'completes successfully with correct output (web)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.name()).thenReturn('my_project');
          final platformFeaturePackage = getPlatformCustomFeaturePackage();
          when(() => platformFeaturePackage.path)
              .thenReturn('platform_feature_package/path');
          when(() => platformFeaturePackage.platform).thenReturn(Platform.web);
          when(() => platformFeaturePackage.name).thenReturn('my_feature');
          when(() => platformFeaturePackage.project).thenReturn(project);
          final generator = getMasonGenerator();
          final bloc = _getBloc(
            name: 'Cool',
            platformFeaturePackage: platformFeaturePackage,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await bloc.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'platform_feature_package/path',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'name': 'Cool',
                'platform': 'web',
                'feature_name': 'my_feature',
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );

      test(
        'completes successfully with correct output (windows)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.name()).thenReturn('my_project');
          final platformFeaturePackage = getPlatformCustomFeaturePackage();
          when(() => platformFeaturePackage.path)
              .thenReturn('platform_feature_package/path');
          when(() => platformFeaturePackage.platform)
              .thenReturn(Platform.windows);
          when(() => platformFeaturePackage.name).thenReturn('my_feature');
          when(() => platformFeaturePackage.project).thenReturn(project);
          final generator = getMasonGenerator();
          final bloc = _getBloc(
            name: 'Cool',
            platformFeaturePackage: platformFeaturePackage,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await bloc.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'platform_feature_package/path',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'name': 'Cool',
                'platform': 'windows',
                'feature_name': 'my_feature',
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );
    });

    group('.delete()', () {
      test(
        'deletes all related files',
        withTempDir(() async {
          // Arrange
          final platformFeaturePackage = getPlatformCustomFeaturePackage();
          when(() => platformFeaturePackage.path)
              .thenReturn('platform_feature_package/path');
          final bloc = _getBloc(
            name: 'Cool',
            platformFeaturePackage: platformFeaturePackage,
          );
          final blocDir = Directory(
            'platform_feature_package/path/lib/src/application/cool',
          )..createSync(recursive: true);
          final blocTestDir = Directory(
            'platform_feature_package/path/test/src/application/cool',
          )..createSync(recursive: true);

          // Act
          final logger = FakeLogger();
          bloc.delete(logger: logger);

          // Assert
          expect(blocDir.existsSync(), false);
          expect(blocTestDir.existsSync(), false);
        }),
      );

      test(
        'deletes all related files',
        withTempDir(() async {
          // Arrange
          final platformFeaturePackage = getPlatformCustomFeaturePackage();
          when(() => platformFeaturePackage.path)
              .thenReturn('platform_feature_package/path');
          final bloc = _getBloc(
            name: 'Cool',
            platformFeaturePackage: platformFeaturePackage,
          );
          final blocDir = Directory(
            'platform_feature_package/path/lib/src/application/cool',
          )..createSync(recursive: true);
          final blocTestDir = Directory(
            'platform_feature_package/path/test/src/application/cool',
          )..createSync(recursive: true);

          // Act
          final logger = FakeLogger();
          bloc.delete(logger: logger);

          // Assert
          expect(blocDir.existsSync(), false);
          expect(blocTestDir.existsSync(), false);
        }),
      );
    });
  });

  group('Cubit', () {
    setUpAll(() {
      registerFallbackValue(FakeDirectoryGeneratorTarget());
    });

    test('.name', () {
      // Arrange
      final cubit = _getCubit(name: 'Cool');

      // Act + Assert
      expect(cubit.name, 'Cool');
    });

    test('.platformFeaturePackage', () {
      // Arrange
      final platformFeaturePackage = getPlatformCustomFeaturePackage();
      final cubit = _getCubit(
        name: 'Cool',
        platformFeaturePackage: platformFeaturePackage,
      );

      // Act + Assert
      expect(cubit.platformFeaturePackage, platformFeaturePackage);
    });

    group('create', () {
      test(
        'completes successfully with correct output (android)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.name()).thenReturn('my_project');
          final platformFeaturePackage = getPlatformCustomFeaturePackage();
          when(() => platformFeaturePackage.path)
              .thenReturn('platform_feature_package/path');
          when(() => platformFeaturePackage.platform)
              .thenReturn(Platform.android);
          when(() => platformFeaturePackage.name).thenReturn('my_feature');
          when(() => platformFeaturePackage.project).thenReturn(project);
          final generator = getMasonGenerator();
          final cubit = _getCubit(
            name: 'Cool',
            platformFeaturePackage: platformFeaturePackage,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await cubit.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'platform_feature_package/path',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'name': 'Cool',
                'platform': 'android',
                'feature_name': 'my_feature',
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );

      test(
        'completes successfully with correct output (ios)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.name()).thenReturn('my_project');
          final platformFeaturePackage = getPlatformCustomFeaturePackage();
          when(() => platformFeaturePackage.path)
              .thenReturn('platform_feature_package/path');
          when(() => platformFeaturePackage.platform).thenReturn(Platform.ios);
          when(() => platformFeaturePackage.name).thenReturn('my_feature');
          when(() => platformFeaturePackage.project).thenReturn(project);
          final generator = getMasonGenerator();
          final cubit = _getCubit(
            name: 'Cool',
            platformFeaturePackage: platformFeaturePackage,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await cubit.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'platform_feature_package/path',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'name': 'Cool',
                'platform': 'ios',
                'feature_name': 'my_feature',
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );

      test(
        'completes successfully with correct output (linux)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.name()).thenReturn('my_project');
          final platformFeaturePackage = getPlatformCustomFeaturePackage();
          when(() => platformFeaturePackage.path)
              .thenReturn('platform_feature_package/path');
          when(() => platformFeaturePackage.platform)
              .thenReturn(Platform.linux);
          when(() => platformFeaturePackage.name).thenReturn('my_feature');
          when(() => platformFeaturePackage.project).thenReturn(project);
          final generator = getMasonGenerator();
          final cubit = _getCubit(
            name: 'Cool',
            platformFeaturePackage: platformFeaturePackage,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await cubit.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'platform_feature_package/path',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'name': 'Cool',
                'platform': 'linux',
                'feature_name': 'my_feature',
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );

      test(
        'completes successfully with correct output (macos)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.name()).thenReturn('my_project');
          final platformFeaturePackage = getPlatformCustomFeaturePackage();
          when(() => platformFeaturePackage.path)
              .thenReturn('platform_feature_package/path');
          when(() => platformFeaturePackage.platform)
              .thenReturn(Platform.macos);
          when(() => platformFeaturePackage.name).thenReturn('my_feature');
          when(() => platformFeaturePackage.project).thenReturn(project);
          final generator = getMasonGenerator();
          final cubit = _getCubit(
            name: 'Cool',
            platformFeaturePackage: platformFeaturePackage,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await cubit.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'platform_feature_package/path',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'name': 'Cool',
                'platform': 'macos',
                'feature_name': 'my_feature',
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );

      test(
        'completes successfully with correct output (web)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.name()).thenReturn('my_project');
          final platformFeaturePackage = getPlatformCustomFeaturePackage();
          when(() => platformFeaturePackage.path)
              .thenReturn('platform_feature_package/path');
          when(() => platformFeaturePackage.platform).thenReturn(Platform.web);
          when(() => platformFeaturePackage.name).thenReturn('my_feature');
          when(() => platformFeaturePackage.project).thenReturn(project);
          final generator = getMasonGenerator();
          final cubit = _getCubit(
            name: 'Cool',
            platformFeaturePackage: platformFeaturePackage,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await cubit.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'platform_feature_package/path',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'name': 'Cool',
                'platform': 'web',
                'feature_name': 'my_feature',
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );

      test(
        'completes successfully with correct output (windows)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.name()).thenReturn('my_project');
          final platformFeaturePackage = getPlatformCustomFeaturePackage();
          when(() => platformFeaturePackage.path)
              .thenReturn('platform_feature_package/path');
          when(() => platformFeaturePackage.platform)
              .thenReturn(Platform.windows);
          when(() => platformFeaturePackage.name).thenReturn('my_feature');
          when(() => platformFeaturePackage.project).thenReturn(project);
          final generator = getMasonGenerator();
          final cubit = _getCubit(
            name: 'Cool',
            platformFeaturePackage: platformFeaturePackage,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await cubit.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'platform_feature_package/path',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'name': 'Cool',
                'platform': 'windows',
                'feature_name': 'my_feature',
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );
    });

    group('.delete()', () {
      test(
        'deletes all related files',
        withTempDir(() async {
          // Arrange
          final platformFeaturePackage = getPlatformCustomFeaturePackage();
          when(() => platformFeaturePackage.path)
              .thenReturn('platform_feature_package/path');
          final cubit = _getBloc(
            name: 'Cool',
            platformFeaturePackage: platformFeaturePackage,
          );
          final cubitDir = Directory(
            'platform_feature_package/path/lib/src/application/cool',
          )..createSync(recursive: true);
          final cubitTestDir = Directory(
            'platform_feature_package/path/test/src/application/cool',
          )..createSync(recursive: true);

          // Act
          final logger = FakeLogger();
          cubit.delete(logger: logger);

          // Assert
          expect(cubitDir.existsSync(), false);
          expect(cubitTestDir.existsSync(), false);
        }),
      );
    });
  });
}
