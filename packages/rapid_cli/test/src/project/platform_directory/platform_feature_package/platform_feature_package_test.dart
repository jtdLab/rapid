import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_feature_package/platform_feature_package.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

abstract class _FlutterGenl10nCommand {
  Future<void> call({
    required String cwd,
    required Logger logger,
  });
}

abstract class _LanguageLocalizationsFileBuilder {
  LanguageLocalizationsFile call({required String language});
}

class _MockProject extends Mock implements Project {}

class _MockPubspecFile extends Mock implements PubspecFile {}

class _MockLocalizationsFile extends Mock implements LocalizationsFile {}

class _MockMasonGenerator extends Mock implements MasonGenerator {}

class _MockLogger extends Mock implements Logger {}

class _MockPlatformCustomFeaturePackage extends Mock
    implements PlatformCustomFeaturePackage {}

class _MockPlatformAppFeaturePackage extends Mock
    implements PlatformAppFeaturePackage {}

class _MockL10nFile extends Mock implements L10nFile {}

class _MockArbDirectory extends Mock implements ArbDirectory {}

class _MockLanguageLocalizationsFileBuilder extends Mock
    implements _LanguageLocalizationsFileBuilder {}

class _MockLanguageLocalizationsFile extends Mock
    implements LanguageLocalizationsFile {}

class _MockFlutterGenL10nCommand extends Mock
    implements _FlutterGenl10nCommand {}

class _MockPlatformFeaturePackage extends Mock
    implements PlatformFeaturePackage {}

class _MockArbFile extends Mock implements ArbFile {}

class _FakeLogger extends Fake implements Logger {}

class _FakeDirectoryGeneratorTarget extends Fake
    implements DirectoryGeneratorTarget {}

void main() {
  group('PlatformAppFeaturePackage', () {
    late Platform platform;

    late Project project;
    const projectPath = 'foo/bar';
    const projectName = 'foo_bar';

    late PubspecFile pubspecFile;

    late LocalizationsFile localizationsFile;

    late MasonGenerator generator;
    final generatedFiles = List.filled(
      23,
      const GeneratedFile.created(path: ''),
    );

    late PlatformAppFeaturePackage underTest;

    PlatformAppFeaturePackage platformAppFeaturePackage() =>
        PlatformAppFeaturePackage(
          platform,
          project: project,
          pubspecFile: pubspecFile,
          localizationsFile: localizationsFile,
          generator: (_) async => generator,
        );

    setUpAll(() {
      registerFallbackValue(_FakeLogger());
      registerFallbackValue(_FakeDirectoryGeneratorTarget());
    });

    setUp(() {
      platform = Platform.android;

      project = _MockProject();
      when(() => project.path).thenReturn(projectPath);
      when(() => project.name()).thenReturn(projectName);

      pubspecFile = _MockPubspecFile();

      localizationsFile = _MockLocalizationsFile();

      generator = _MockMasonGenerator();
      when(() => generator.id).thenReturn('generator_id');
      when(() => generator.description).thenReturn('generator description');
      when(
        () => generator.generate(
          any(),
          vars: any(named: 'vars'),
          logger: any(named: 'logger'),
        ),
      ).thenAnswer((_) async => generatedFiles);

      underTest = platformAppFeaturePackage();
    });

    group('path', () {
      test('is correct', () {
        // Assert
        expect(
          underTest.path,
          '$projectPath/packages/$projectName/${projectName}_${platform.name}/${projectName}_${platform.name}_app',
        );
      });
    });

    group('localizationsFile', () {
      test('returns correct localizations file', () {
        // Assert
        expect(
          underTest.localizationsFile,
          localizationsFile,
        );
      });
    });

    group('create', () {
      late Logger logger;

      setUp(() {
        logger = _MockLogger();
      });

      test('completes successfully with correct output (android)', () async {
        // Arrange
        platform = Platform.android;
        underTest = platformAppFeaturePackage();

        // Act
        await underTest.create(
          logger: logger,
        );

        // Assert
        verify(
          () => generator.generate(
            any(
              that: isA<DirectoryGeneratorTarget>().having(
                (g) => g.dir.path,
                'dir',
                '$projectPath/packages/$projectName/${projectName}_${platform.name}/${projectName}_${platform.name}_app',
              ),
            ),
            vars: <String, dynamic>{
              'project_name': projectName,
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
      });

      test('completes successfully with correct output (ios)', () async {
        // Arrange
        platform = Platform.ios;
        underTest = platformAppFeaturePackage();

        // Act
        await underTest.create(
          logger: logger,
        );

        // Assert
        verify(
          () => generator.generate(
            any(
              that: isA<DirectoryGeneratorTarget>().having(
                (g) => g.dir.path,
                'dir',
                '$projectPath/packages/$projectName/${projectName}_${platform.name}/${projectName}_${platform.name}_app',
              ),
            ),
            vars: <String, dynamic>{
              'project_name': projectName,
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
      });

      test('completes successfully with correct output (linux)', () async {
        // Arrange
        platform = Platform.linux;
        underTest = platformAppFeaturePackage();

        // Act
        await underTest.create(
          logger: logger,
        );

        // Assert
        verify(
          () => generator.generate(
            any(
              that: isA<DirectoryGeneratorTarget>().having(
                (g) => g.dir.path,
                'dir',
                '$projectPath/packages/$projectName/${projectName}_${platform.name}/${projectName}_${platform.name}_app',
              ),
            ),
            vars: <String, dynamic>{
              'project_name': projectName,
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
      });

      test('completes successfully with correct output (macos)', () async {
        // Arrange
        platform = Platform.macos;
        underTest = platformAppFeaturePackage();

        // Act
        await underTest.create(
          logger: logger,
        );

        // Assert
        verify(
          () => generator.generate(
            any(
              that: isA<DirectoryGeneratorTarget>().having(
                (g) => g.dir.path,
                'dir',
                '$projectPath/packages/$projectName/${projectName}_${platform.name}/${projectName}_${platform.name}_app',
              ),
            ),
            vars: <String, dynamic>{
              'project_name': projectName,
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
      });

      test('completes successfully with correct output (web)', () async {
        // Arrange
        platform = Platform.web;
        underTest = platformAppFeaturePackage();

        // Act
        await underTest.create(
          logger: logger,
        );

        // Assert
        verify(
          () => generator.generate(
            any(
              that: isA<DirectoryGeneratorTarget>().having(
                (g) => g.dir.path,
                'dir',
                '$projectPath/packages/$projectName/${projectName}_${platform.name}/${projectName}_${platform.name}_app',
              ),
            ),
            vars: <String, dynamic>{
              'project_name': projectName,
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
      });

      test('completes successfully with correct output (windows)', () async {
        // Arrange
        platform = Platform.windows;
        underTest = platformAppFeaturePackage();

        // Act
        await underTest.create(
          logger: logger,
        );

        // Assert
        verify(
          () => generator.generate(
            any(
              that: isA<DirectoryGeneratorTarget>().having(
                (g) => g.dir.path,
                'dir',
                '$projectPath/packages/$projectName/${projectName}_${platform.name}/${projectName}_${platform.name}_app',
              ),
            ),
            vars: <String, dynamic>{
              'project_name': projectName,
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
      });
    });

    group('registerCustomFeaturePackage', () {
      late PlatformCustomFeaturePackage customFeaturePackage;
      late String customFeaturePackageName;
      late Logger logger;

      setUp(() {
        customFeaturePackage = _MockPlatformCustomFeaturePackage();
        customFeaturePackageName = 'foo_bar';
        when(() => customFeaturePackage.packageName())
            .thenReturn(customFeaturePackageName);
        logger = _MockLogger();
      });

      test('register custom feature package correctly', () async {
        // Act
        await underTest.registerCustomFeaturePackage(
          customFeaturePackage,
          logger: logger,
        );

        // Assert
        verify(() => pubspecFile.setDependency(customFeaturePackageName));
        verify(
          () => localizationsFile.addLocalizationsDelegate(
            customFeaturePackage,
          ),
        );
      });
    });

    group('unregisterCustomFeaturePackage', () {
      late PlatformCustomFeaturePackage customFeaturePackage;
      late String customFeaturePackageName;
      late Logger logger;

      setUp(() {
        customFeaturePackage = _MockPlatformCustomFeaturePackage();
        customFeaturePackageName = 'foo_bar';
        when(() => customFeaturePackage.packageName())
            .thenReturn(customFeaturePackageName);
        logger = _MockLogger();
      });

      test('unregister custom feature package correctly', () async {
        // Act
        await underTest.unregisterCustomFeaturePackage(
          customFeaturePackage,
          logger: logger,
        );

        // Assert
        verify(() => pubspecFile.removeDependency(customFeaturePackageName));
        verify(
          () => localizationsFile.removeLocalizationsDelegate(
            customFeaturePackage,
          ),
        );
      });
    });
  });

  group('LocalizationsFile', () {
    late PlatformAppFeaturePackage platformAppFeaturePackage;
    const platformAppFeaturePackagePath = 'foo/bam';

    late LocalizationsFile underTest;

    LocalizationsFile localizationsFile() => LocalizationsFile(
          platformAppFeaturePackage: platformAppFeaturePackage,
        );

    setUp(() {
      platformAppFeaturePackage = _MockPlatformAppFeaturePackage();
      when(() => platformAppFeaturePackage.path)
          .thenReturn(platformAppFeaturePackagePath);

      underTest = localizationsFile();
    });

    group('path', () {
      test('is correct', () {
        // Assert
        expect(
          underTest.path,
          '$platformAppFeaturePackagePath/lib/src/presentation/localizations.dart',
        );
      });
    });

    group('addLocalizationsDelegate', () {
      // TODO
    });

    group('removeLocalizationsDelegate', () {
      // TODO
    });

    group('addSupportedLanguage', () {
      // TODO
    });

    group('removeSupportedLanguage', () {
      // TODO
    });
  });

  group('PlatformRoutingFeaturePackage', () {
    late Platform platform;

    late Project project;
    const projectPath = 'foo/bar';
    const projectName = 'foo_bar';

    late PubspecFile pubspecFile;

    late MasonGenerator generator;
    final generatedFiles = List.filled(
      23,
      const GeneratedFile.created(path: ''),
    );

    late PlatformRoutingFeaturePackage underTest;

    PlatformRoutingFeaturePackage platformRoutingFeaturePackage() =>
        PlatformRoutingFeaturePackage(
          platform,
          project: project,
          pubspecFile: pubspecFile,
          generator: (_) async => generator,
        );

    setUpAll(() {
      registerFallbackValue(_FakeLogger());
      registerFallbackValue(_FakeDirectoryGeneratorTarget());
    });

    setUp(() {
      platform = Platform.android;

      project = _MockProject();
      when(() => project.path).thenReturn(projectPath);
      when(() => project.name()).thenReturn(projectName);

      pubspecFile = _MockPubspecFile();

      generator = _MockMasonGenerator();
      when(() => generator.id).thenReturn('generator_id');
      when(() => generator.description).thenReturn('generator description');
      when(
        () => generator.generate(
          any(),
          vars: any(named: 'vars'),
          logger: any(named: 'logger'),
        ),
      ).thenAnswer((_) async => generatedFiles);

      underTest = platformRoutingFeaturePackage();
    });

    group('path', () {
      test('is correct', () {
        // Assert
        expect(
          underTest.path,
          '$projectPath/packages/$projectName/${projectName}_${platform.name}/${projectName}_${platform.name}_routing',
        );
      });
    });

    group('create', () {
      late Logger logger;

      setUp(() {
        logger = _MockLogger();
      });

      test('completes successfully with correct output (android)', () async {
        // Arrange
        platform = Platform.android;
        underTest = platformRoutingFeaturePackage();

        // Act
        await underTest.create(
          logger: logger,
        );

        // Assert
        verify(
          () => generator.generate(
            any(
              that: isA<DirectoryGeneratorTarget>().having(
                (g) => g.dir.path,
                'dir',
                '$projectPath/packages/$projectName/${projectName}_${platform.name}/${projectName}_${platform.name}_routing',
              ),
            ),
            vars: <String, dynamic>{
              'project_name': projectName,
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
      });

      test('completes successfully with correct output (ios)', () async {
        // Arrange
        platform = Platform.ios;
        underTest = platformRoutingFeaturePackage();

        // Act
        await underTest.create(
          logger: logger,
        );

        // Assert
        verify(
          () => generator.generate(
            any(
              that: isA<DirectoryGeneratorTarget>().having(
                (g) => g.dir.path,
                'dir',
                '$projectPath/packages/$projectName/${projectName}_${platform.name}/${projectName}_${platform.name}_routing',
              ),
            ),
            vars: <String, dynamic>{
              'project_name': projectName,
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
      });

      test('completes successfully with correct output (linux)', () async {
        // Arrange
        platform = Platform.linux;
        underTest = platformRoutingFeaturePackage();

        // Act
        await underTest.create(
          logger: logger,
        );

        // Assert
        verify(
          () => generator.generate(
            any(
              that: isA<DirectoryGeneratorTarget>().having(
                (g) => g.dir.path,
                'dir',
                '$projectPath/packages/$projectName/${projectName}_${platform.name}/${projectName}_${platform.name}_routing',
              ),
            ),
            vars: <String, dynamic>{
              'project_name': projectName,
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
      });

      test('completes successfully with correct output (macos)', () async {
        // Arrange
        platform = Platform.macos;
        underTest = platformRoutingFeaturePackage();

        // Act
        await underTest.create(
          logger: logger,
        );

        // Assert
        verify(
          () => generator.generate(
            any(
              that: isA<DirectoryGeneratorTarget>().having(
                (g) => g.dir.path,
                'dir',
                '$projectPath/packages/$projectName/${projectName}_${platform.name}/${projectName}_${platform.name}_routing',
              ),
            ),
            vars: <String, dynamic>{
              'project_name': projectName,
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
      });

      test('completes successfully with correct output (web)', () async {
        // Arrange
        platform = Platform.web;
        underTest = platformRoutingFeaturePackage();

        // Act
        await underTest.create(
          logger: logger,
        );

        // Assert
        verify(
          () => generator.generate(
            any(
              that: isA<DirectoryGeneratorTarget>().having(
                (g) => g.dir.path,
                'dir',
                '$projectPath/packages/$projectName/${projectName}_${platform.name}/${projectName}_${platform.name}_routing',
              ),
            ),
            vars: <String, dynamic>{
              'project_name': projectName,
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
      });

      test('completes successfully with correct output (windows)', () async {
        // Arrange
        platform = Platform.windows;
        underTest = platformRoutingFeaturePackage();

        // Act
        await underTest.create(
          logger: logger,
        );

        // Assert
        verify(
          () => generator.generate(
            any(
              that: isA<DirectoryGeneratorTarget>().having(
                (g) => g.dir.path,
                'dir',
                '$projectPath/packages/$projectName/${projectName}_${platform.name}/${projectName}_${platform.name}_routing',
              ),
            ),
            vars: <String, dynamic>{
              'project_name': projectName,
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
      });
    });

    group('registerCustomFeaturePackage', () {
      late PlatformCustomFeaturePackage customFeaturePackage;
      late String customFeaturePackageName;
      late Logger logger;

      setUp(() {
        customFeaturePackage = _MockPlatformCustomFeaturePackage();
        customFeaturePackageName = 'foo_bar';
        when(() => customFeaturePackage.packageName())
            .thenReturn(customFeaturePackageName);
        logger = _MockLogger();
      });

      test('register custom feature package correctly', () async {
        // Act
        await underTest.registerCustomFeaturePackage(
          customFeaturePackage,
          logger: logger,
        );

        // Assert
        verify(() => pubspecFile.setDependency(customFeaturePackageName));
      });
    });

    group('unregisterCustomFeaturePackage', () {
      late PlatformCustomFeaturePackage customFeaturePackage;
      late String customFeaturePackageName;
      late Logger logger;

      setUp(() {
        customFeaturePackage = _MockPlatformCustomFeaturePackage();
        customFeaturePackageName = 'foo_bar';
        when(() => customFeaturePackage.packageName())
            .thenReturn(customFeaturePackageName);
        logger = _MockLogger();
      });

      test('unregister custom feature package correctly', () async {
        // Act
        await underTest.unregisterCustomFeaturePackage(
          customFeaturePackage,
          logger: logger,
        );

        // Assert
        verify(() => pubspecFile.removeDependency(customFeaturePackageName));
      });
    });
  });

  group('PlatformCustomFeaturePackage', () {
    late String name;

    late Platform platform;

    late Project project;
    const projectPath = 'foo/bar';
    const projectName = 'foo_bar';

    late L10nFile l10nFile;

    late ArbDirectory arbDirectory;

    late MasonGenerator generator;
    final generatedFiles = List.filled(
      23,
      const GeneratedFile.created(path: ''),
    );

    late LanguageLocalizationsFileBuilder languageLocalizationsFileBuilder;
    late LanguageLocalizationsFile languageLocalizationsFile;

    late FlutterGenl10nCommand flutterGenl10n;

    late PlatformCustomFeaturePackage underTest;

    PlatformCustomFeaturePackage platformCustomFeaturePackage() =>
        PlatformCustomFeaturePackage(
          name,
          platform,
          project: project,
          l10nFile: l10nFile,
          arbDirectory: arbDirectory,
          languageLocalizationsFile: languageLocalizationsFileBuilder,
          flutterGenl10n: flutterGenl10n,
          generator: (_) async => generator,
        );

    setUpAll(() {
      registerFallbackValue(_FakeLogger());
      registerFallbackValue(_FakeDirectoryGeneratorTarget());
    });

    setUp(() {
      name = 'my_feature';

      platform = Platform.android;

      project = _MockProject();
      when(() => project.path).thenReturn(projectPath);
      when(() => project.name()).thenReturn(projectName);

      l10nFile = _MockL10nFile();

      arbDirectory = _MockArbDirectory();

      generator = _MockMasonGenerator();
      when(() => generator.id).thenReturn('generator_id');
      when(() => generator.description).thenReturn('generator description');
      when(
        () => generator.generate(
          any(),
          vars: any(named: 'vars'),
          logger: any(named: 'logger'),
        ),
      ).thenAnswer((_) async => generatedFiles);

      languageLocalizationsFileBuilder =
          _MockLanguageLocalizationsFileBuilder();
      languageLocalizationsFile = _MockLanguageLocalizationsFile();
      when(
        () => languageLocalizationsFileBuilder(
          language: any(named: 'language'),
        ),
      ).thenReturn(languageLocalizationsFile);

      flutterGenl10n = _MockFlutterGenL10nCommand();
      when(
        () => flutterGenl10n(
          cwd: any(named: 'cwd'),
          logger: any(named: 'logger'),
        ),
      ).thenAnswer((_) async {});

      underTest = platformCustomFeaturePackage();
    });

    group('path', () {
      test('is correct', () {
        // Assert
        expect(
          underTest.path,
          '$projectPath/packages/$projectName/${projectName}_${platform.name}/${projectName}_${platform.name}_my_feature',
        );
      });
    });

    group('supportedLanguages', () {
      late ArbFile arbFile1;
      const arbFile1Language = 'de';
      late ArbFile arbFile2;
      const arbFile2Language = 'fr';

      setUp(() {
        arbFile1 = _MockArbFile();
        when(() => arbFile1.language).thenReturn(arbFile1Language);
        arbFile2 = _MockArbFile();
        when(() => arbFile2.language).thenReturn(arbFile2Language);
        when(() => arbDirectory.arbFiles()).thenReturn([arbFile1, arbFile2]);
      });

      test('returns correct supported languages', () {
        // Act
        final supportedLanguages = underTest.supportedLanguages();

        // Assert
        expect(
            supportedLanguages, equals([arbFile1Language, arbFile2Language]));
      });
    });

    group('supportsLanguage', () {
      late ArbFile arbFile1;
      const arbFile1Language = 'de';

      setUp(() {
        arbFile1 = _MockArbFile();
        when(() => arbFile1.language).thenReturn(arbFile1Language);
        when(() => arbDirectory.arbFiles()).thenReturn([arbFile1]);
      });

      test('returns true when language is supported', () {
        // Act
        final supportsLanguage = underTest.supportsLanguage(arbFile1Language);

        // Assert
        expect(supportsLanguage, true);
      });

      test('returns false when language is NOT supported', () {
        // Act
        final supportsLanguage = underTest.supportsLanguage('fr');

        // Assert
        expect(supportsLanguage, false);
      });
    });

    group('defaultLanguage', () {
      const templateArbFileProp = 'my_feature_fr.arb';

      setUp(() {
        when(() => l10nFile.templateArbFile()).thenReturn(templateArbFileProp);
        underTest = platformCustomFeaturePackage();
      });

      test('returns correct defaultLanguage', () {
        // Act
        final defaultLanguage = underTest.defaultLanguage();

        // Assert
        expect(defaultLanguage, 'fr');
      });
    });

    group('create', () {
      late String? description;
      late Logger logger;

      setUp(() {
        description = null;
        logger = _MockLogger();
      });

      test('completes successfully with correct output (android)', () async {
        // Arrange
        platform = Platform.android;
        underTest = platformCustomFeaturePackage();

        // Act
        await underTest.create(
          description: description,
          logger: logger,
        );

        // Assert
        verify(
          () => generator.generate(
            any(
              that: isA<DirectoryGeneratorTarget>().having(
                (g) => g.dir.path,
                'dir',
                '$projectPath/packages/$projectName/${projectName}_${platform.name}/${projectName}_${platform.name}_my_feature',
              ),
            ),
            vars: <String, dynamic>{
              'name': name,
              'description': 'The My Feature feature',
              'project_name': projectName,
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
      });

      test('completes successfully with correct output (ios)', () async {
        // Arrange
        platform = Platform.ios;
        underTest = platformCustomFeaturePackage();

        // Act
        await underTest.create(
          logger: logger,
        );

        // Assert
        verify(
          () => generator.generate(
            any(
              that: isA<DirectoryGeneratorTarget>().having(
                (g) => g.dir.path,
                'dir',
                '$projectPath/packages/$projectName/${projectName}_${platform.name}/${projectName}_${platform.name}_my_feature',
              ),
            ),
            vars: <String, dynamic>{
              'name': name,
              'description': 'The My Feature feature',
              'project_name': projectName,
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
      });

      test('completes successfully with correct output (linux)', () async {
        // Arrange
        platform = Platform.linux;
        underTest = platformCustomFeaturePackage();

        // Act
        await underTest.create(
          logger: logger,
        );

        // Assert
        verify(
          () => generator.generate(
            any(
              that: isA<DirectoryGeneratorTarget>().having(
                (g) => g.dir.path,
                'dir',
                '$projectPath/packages/$projectName/${projectName}_${platform.name}/${projectName}_${platform.name}_my_feature',
              ),
            ),
            vars: <String, dynamic>{
              'name': name,
              'description': 'The My Feature feature',
              'project_name': projectName,
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
      });

      test('completes successfully with correct output (macos)', () async {
        // Arrange
        platform = Platform.macos;
        underTest = platformCustomFeaturePackage();

        // Act
        await underTest.create(
          logger: logger,
        );

        // Assert
        verify(
          () => generator.generate(
            any(
              that: isA<DirectoryGeneratorTarget>().having(
                (g) => g.dir.path,
                'dir',
                '$projectPath/packages/$projectName/${projectName}_${platform.name}/${projectName}_${platform.name}_my_feature',
              ),
            ),
            vars: <String, dynamic>{
              'name': name,
              'description': 'The My Feature feature',
              'project_name': projectName,
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
      });

      test('completes successfully with correct output (web)', () async {
        // Arrange
        platform = Platform.web;
        underTest = platformCustomFeaturePackage();

        // Act
        await underTest.create(
          logger: logger,
        );

        // Assert
        verify(
          () => generator.generate(
            any(
              that: isA<DirectoryGeneratorTarget>().having(
                (g) => g.dir.path,
                'dir',
                '$projectPath/packages/$projectName/${projectName}_${platform.name}/${projectName}_${platform.name}_my_feature',
              ),
            ),
            vars: <String, dynamic>{
              'name': name,
              'description': 'The My Feature feature',
              'project_name': projectName,
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
      });

      test('completes successfully with correct output (windows)', () async {
        // Arrange
        platform = Platform.windows;
        underTest = platformCustomFeaturePackage();

        // Act
        await underTest.create(
          logger: logger,
        );

        // Assert
        verify(
          () => generator.generate(
            any(
              that: isA<DirectoryGeneratorTarget>().having(
                (g) => g.dir.path,
                'dir',
                '$projectPath/packages/$projectName/${projectName}_${platform.name}/${projectName}_${platform.name}_my_feature',
              ),
            ),
            vars: <String, dynamic>{
              'name': name,
              'description': 'The My Feature feature',
              'project_name': projectName,
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
      });

      test('completes successfully with correct output with custom description',
          () async {
        // Arrange
        platform = Platform.android;
        description = 'Some desc';
        underTest = platformCustomFeaturePackage();

        // Act
        await underTest.create(
          logger: logger,
          description: description,
        );

        // Assert
        verify(
          () => generator.generate(
            any(
              that: isA<DirectoryGeneratorTarget>().having(
                (g) => g.dir.path,
                'dir',
                '$projectPath/packages/$projectName/${projectName}_${platform.name}/${projectName}_${platform.name}_my_feature',
              ),
            ),
            vars: <String, dynamic>{
              'name': name,
              'description': description,
              'project_name': projectName,
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
      });
    });

    group('bloc', () {
      late String blocName;

      setUp(() {
        blocName = 'FooBar';
      });

      test('returns correct bloc', () {
        // Act
        final bloc = underTest.bloc(name: blocName);

        // Assert
        expect(bloc.name, blocName);
        expect(bloc.platformFeaturePackage, underTest);
      });
    });

    group('cubit', () {
      late String cubitName;

      setUp(() {
        cubitName = 'FooBar';
      });

      test('returns correct bloc', () {
        // Act
        final cubit = underTest.cubit(name: cubitName);

        // Assert
        expect(cubit.name, cubitName);
        expect(cubit.platformFeaturePackage, underTest);
      });
    });

    group('addLanguage', () {
      late ArbFile arbFile;
      late String language;

      late Logger logger;

      setUp(() {
        arbFile = _MockArbFile();
        language = 'de';
        when(() => arbFile.exists()).thenReturn(false);
        when(() => arbFile.create(logger: any(named: 'logger')))
            .thenAnswer((_) async {});
        when(() => arbDirectory.arbFile(language: language))
            .thenReturn(arbFile);

        logger = _MockLogger();
      });

      test('completes successfully with correct output', () async {
        // Act
        await underTest.addLanguage(language: language, logger: logger);

        // Assert
        verify(() => arbDirectory.arbFile(language: language)).called(1);
        verify(() => arbFile.create(logger: logger)).called(1);
        verify(
          () => flutterGenl10n(
            cwd:
                '$projectPath/packages/$projectName/${projectName}_${platform.name}/${projectName}_${platform.name}_my_feature',
            logger: logger,
          ),
        ).called(1);
      });

      test(
          'completes successfully with correct output when the arb file of the language already exists',
          () async {
        // Arrange
        when(() => arbFile.exists()).thenReturn(true);

        // Act
        await underTest.addLanguage(language: language, logger: logger);

        // Assert
        verify(() => arbDirectory.arbFile(language: language)).called(1);
        verifyNever(() => arbFile.create(logger: logger));
        verifyNever(
          () => flutterGenl10n(
            cwd:
                '$projectPath/packages/$projectName/${projectName}_${platform.name}/${projectName}_${platform.name}_my_feature',
            logger: logger,
          ),
        );
      });
    });

    group('removeLanguage', () {
      late ArbFile arbFile;
      late String language;

      late Logger logger;

      setUp(() {
        arbFile = _MockArbFile();
        language = 'de';
        when(() => arbFile.exists()).thenReturn(true);
        when(() => arbFile.create(logger: any(named: 'logger')))
            .thenAnswer((_) async {});
        when(() => arbDirectory.arbFile(language: language))
            .thenReturn(arbFile);

        when(() => languageLocalizationsFile.exists()).thenReturn(true);

        logger = _MockLogger();
      });

      test('completes successfully with correct output', () async {
        // Act
        await underTest.removeLanguage(language: language, logger: logger);

        // Assert
        verify(() => arbDirectory.arbFile(language: language)).called(1);
        verify(() => arbFile.delete(logger: logger)).called(1);
      });

      test(
          'completes successfully with correct output when the arb file of the language does NOT exists',
          () async {
        // Arrange
        when(() => arbFile.exists()).thenReturn(false);

        // Act
        await underTest.removeLanguage(language: language, logger: logger);

        // Assert
        verify(() => arbDirectory.arbFile(language: language)).called(1);
        verifyNever(() => arbFile.delete(logger: logger));
        verifyNever(() => arbFile.delete(logger: logger));
      });
    });
  });

  group('L10nFile', () {
    group('templateArbFile', () {
      // TODO
    });
  });

  group('LanguageLocalizationsFile', () {
    late String language;

    late PlatformFeaturePackage platformFeaturePackage;
    const platformFeaturePackagePackagName = 'foo_bar';
    const platformFeaturePackagePackagPath = 'foo/bar';

    late LanguageLocalizationsFile underTest;

    setUp(() {
      language = 'de';

      platformFeaturePackage = _MockPlatformFeaturePackage();
      when(() => platformFeaturePackage.packageName())
          .thenReturn(platformFeaturePackagePackagName);
      when(() => platformFeaturePackage.path)
          .thenReturn(platformFeaturePackagePackagPath);

      underTest = LanguageLocalizationsFile(
        language,
        platformFeaturePackage: platformFeaturePackage,
      );
    });

    group('path', () {
      test('is correct', () {
        // Assert
        expect(
          underTest.path,
          '$platformFeaturePackagePackagPath/lib/src/presentation/l10n/${platformFeaturePackagePackagName}_localizations_$language.dart',
        );
      });
    });

    group('delete', () {
      late Logger logger;

      setUp(() {
        logger = _MockLogger();
      });

      test('removes the underlying file', () {
        // Arrange
        final file = File(underTest.path);
        file.createSync(recursive: true);

        // Act
        underTest.delete(logger: logger);

        // Assert
        expect(file.existsSync(), false);
      });
    });
  });

  group('ArbDirectory', () {
    group('platformFeaturePackage', () {
      // TODO
    });

    group('arbFiles', () {
      // TODO
    });

    group('arbFile', () {
      // TODO
    });
  });

  group('ArbFile', () {
    group('arbDirectory', () {
      // TODO
    });

    group('language', () {
      // TODO
    });

    group('create', () {
      // TODO
    });
  });

  group('Bloc', () {
    group('name', () {
      // TODO
    });

    group('platformFeaturePackage', () {
      // TODO
    });

    group('create', () {
      // TODO
    });
  });

  group('Cubit', () {
    group('name', () {
      // TODO
    });

    group('platformFeaturePackage', () {
      // TODO
    });

    group('create', () {
      // TODO
    });
  });
}

/// group('delete', () {
///    test('deletes the directory', () {
///      // Arrange
///      final directory = Directory(platformDirectory.path);
///
///      // Act
///      platformDirectory.delete();
///
///      // Assert
///      expect(directory.existsSync(), false);
///    });
///  });
///
///  group('exists', () {
///    test('returns true when the directory exists', () {
///      // Act
///      final exists = platformDirectory.exists();
///
///      // Assert
///      expect(exists, true);
///    });
///
///    test('returns false when the directory does not exists', () {
///      // Arrange
///      Directory(platformDirectory.path).deleteSync(recursive: true);
///
///      // Act
///      final exists = platformDirectory.exists();
///
///      // Assert
///      expect(exists, false);
///    });
///  });
///
///  group('featureExists', () {
///    test('returns true when the requested feature exists', () {
///      // Arrange
///      final featureName = 'existing_feature';
///      Directory(p.join(platformDirectory.path,
///              '${projectName}_${platform.name}_$featureName'))
///          .createSync(recursive: true);
///
///      // Act
///      final exists = platformDirectory.featureExists(featureName);
///
///      // Assert
///      expect(exists, true);
///    });
///
///    test('returns false when the requested package does not exist', () {
///      // Arrange
///      final featureName = 'not_existing_feature';
///
///      // Act
///      final exists = platformDirectory.featureExists(featureName);
///
///      // Assert
///      expect(exists, false);
///    });
///  });

///  import 'package:mocktail/mocktail.dart';
/// import 'package:path/path.dart' as p;
/// import 'package:rapid_cli/src/core/platform.dart';
/// import 'package:rapid_cli/src/project/feature.dart';
/// import 'package:rapid_cli/src/project/melos_file.dart';
/// import 'package:rapid_cli/src/project/platform_directory.dart';
/// import 'package:rapid_cli/src/project/project.dart';
/// import 'package:test/test.dart';
/// import 'package:universal_io/io.dart';
///
/// const l10nWithTemplateArbFile = '''
/// template-arb-file: foo_bar
/// ''';
///
/// const l10nWithoutTemplateArbFile = '''
/// some: value
/// ''';
///
/// class _MockMelosFile extends Mock implements MelosFile {}
///
/// class _MockProject extends Mock implements Project {}
///
/// class _MockPlatformDirectory extends Mock implements PlatformDirectory {}
///
/// class _MockFeature extends Mock implements Feature {}
///
/// void main() {
///   group('Feature', () {
///     final cwd = Directory.current;
///
///     const projectName = 'my_app';
///     late MelosFile melosFile;
///     late Project project;
///     const platform = Platform.android;
///     const platformDirPath = 'bom/bam';
///     late PlatformDirectory platformDirectory;
///     const featureName = 'my_feature';
///     late Feature feature;
///
///     setUp(() {
///       Directory.current = Directory.systemTemp.createTempSync();
///
///       melosFile = _MockMelosFile();
///       when(() => melosFile.readName()).thenReturn(projectName);
///       project = _MockProject();
///       when(() => project.melosFile).thenReturn(melosFile);
///       platformDirectory = _MockPlatformDirectory();
///       when(() => platformDirectory.platform).thenReturn(platform);
///       when(() => platformDirectory.path).thenReturn(platformDirPath);
///       when(() => platformDirectory.project).thenReturn(project);
///       feature = Feature(
///         entityName: featureName,
///         platformDirectory: platformDirectory,
///       );
///       Directory(feature.path).createSync(recursive: true);
///       Directory(
///         p.join(feature.path, 'lib', 'src', 'presentation', 'l10n', 'arb'),
///       ).createSync(recursive: true);
///     });
///
///     tearDown(() {
///       Directory.current = cwd;
///     });
///
///     group('delete', () {
///       test('deletes the directory', () {
///         // Arrange
///         final directory = Directory(feature.path);
///
///         // Act
///         feature.delete();
///
///         // Assert
///         expect(directory.existsSync(), false);
///       });
///     });
///
///     group('defaultLanguage', () {
///       test('returns the correct default language extracted from l10n.yaml', () {
///         // Arrange
///         final l10nFile = File(p.join(feature.path, 'l10n.yaml'));
///         l10nFile.createSync(recursive: true);
///         l10nFile.writeAsStringSync('template-arb-file: ${featureName}_fr.arb');
///
///         // Act
///         final defaultLanguage = feature.defaultLanguage();
///
///         // Assert
///         expect(defaultLanguage, 'fr');
///       });
///     });
///
///     group('exists', () {
///       test('returns true when the directory exists', () {
///         // Act
///         final exists = feature.exists();
///
///         // Assert
///         expect(exists, true);
///       });
///
///       test('returns false when the directory does not exists', () {
///         // Arrange
///         Directory(feature.path).deleteSync(recursive: true);
///
///         // Act
///         final exists = feature.exists();
///
///         // Assert
///         expect(exists, false);
///       });
///     });
///
///     group('findArbFileByLanguage', () {
///       test('returns the arb file corresponding to the language', () {
///         // Arrange
///         const language = 'de';
///         final path = p.join(
///           feature.path,
///           'lib',
///           'src',
///           'presentation',
///           'l10n',
///           'arb',
///           '${featureName}_$language.arb',
///         );
///         final file = File(path);
///         file.createSync(recursive: true);
///
///         // Act
///         final arbFile = feature.findArbFileByLanguage(language);
///
///         // Assert
///         expect(arbFile.path, path);
///         expect(arbFile.language, language);
///       });
///
///       test('throws when the arb file does not exist', () {
///         // Arrange
///         const language = 'de';
///
///         // Act & Assert
///         expect(
///           () => feature.findArbFileByLanguage(language),
///           throwsA(isA<ArbFileNotExisting>()),
///         );
///       });
///     });
///
///     group('supportedLanguages', () {
///       test(
///           'returns the correct supported languages depending on existing .arb files',
///           () {
///         // Arrange
///         const languages = ['de', 'en', 'fr'];
///         for (final language in languages) {
///           final arbFile = File(
///             p.join(
///               feature.path,
///               'lib',
///               'src',
///               'presentation',
///               'l10n',
///               'arb',
///               '${featureName}_$language.arb',
///             ),
///           );
///           arbFile.createSync(recursive: true);
///         }
///
///         // Act
///         final supportedLanguages = feature.supportedLanguages();
///
///         // Assert
///         expect(supportedLanguages, equals(languages));
///       });
///     });
///
///     group('supportsLanguage', () {
///       test('returns true when the corresponding .arb file exists', () {
///         // Arrange
///         const language = 'de';
///         final arbFile = File(
///           p.join(
///             feature.path,
///             'lib',
///             'src',
///             'presentation',
///             'l10n',
///             'arb',
///             '${featureName}_$language.arb',
///           ),
///         );
///         arbFile.createSync(recursive: true);
///
///         // Act
///         final supportsLanguage = feature.supportsLanguage(language);
///
///         // Assert
///         expect(supportsLanguage, true);
///       });
///
///       test('returns false when the corresponding .arb file does not exist', () {
///         // Arrange
///         const language = 'de';
///
///         // Act
///         final supportsLanguage = feature.supportsLanguage(language);
///
///         // Assert
///         expect(supportsLanguage, false);
///       });
///     });
///
///     group('name', () {
///       test('is correct', () {
///         // Assert
///         expect(feature.entityName, featureName);
///       });
///     });
///
///     group('path', () {
///       test('is correct', () {
///         // Assert
///         expect(
///           feature.path,
///           '$platformDirPath/${projectName}_${platform.name}_$featureName',
///         );
///       });
///     });
///
///     group('platform', () {
///       test('is correct', () {
///         // Assert
///         expect(feature.platform, platform);
///       });
///     });
///
///     group('pubspecFile', () {
///       test('has correct path', () {
///         // Act
///         final pubspecFile = feature.pubspecFile;
///
///         // Assert
///         expect(
///           pubspecFile.path,
///           '$platformDirPath/${projectName}_${platform.name}_$featureName/pubspec.yaml',
///         );
///       });
///     });
///   });
///
///   group('ArbFile', () {
///     final cwd = Directory.current;
///
///     const featureName = 'my_feature';
///     const featurePath = 'foo/bar';
///     late Feature feature;
///     const language = 'en';
///     late ArbFile arbFile;
///
///     setUp(() {
///       Directory.current = Directory.systemTemp.createTempSync();
///
///       feature = _MockFeature();
///       when(() => feature.entityName).thenReturn(featureName);
///       when(() => feature.path).thenReturn(featurePath);
///       arbFile = ArbFile(language: language, feature: feature);
///       File(arbFile.path).createSync(recursive: true);
///     });
///
///     tearDown(() {
///       Directory.current = cwd;
///     });
///
///     group('language', () {
///       test('is correct', () {
///         // Assert
///         expect(arbFile.language, language);
///       });
///     });
///
///     group('path', () {
///       test('is correct', () {
///         // Assert
///         expect(
///           arbFile.path,
///           'foo/bar/lib/src/presentation/l10n/arb/my_feature_en.arb',
///         );
///       });
///     });
///
///     group('delete', () {
///       test('deletes the file', () {
///         // Arrange
///         final file = File(arbFile.path);
///
///         // Act
///         arbFile.delete();
///
///         // Assert
///         expect(file.existsSync(), false);
///       });
///     });
///   });
///
///   group('L10nFile', () {
///     final cwd = Directory.current;
///
///     late L10nFile l10nFile;
///
///     setUp(() {
///       Directory.current = Directory.systemTemp.createTempSync();
///
///       l10nFile = L10nFile();
///       File(l10nFile.path).createSync(recursive: true);
///     });
///
///     tearDown(() {
///       Directory.current = cwd;
///     });
///
///     group('path', () {
///       test('is correct', () {
///         // Assert
///         expect(l10nFile.path, 'l10n.yaml');
///       });
///     });
///
///     group('templateArbFile', () {
///       test('returns template-arb-file', () {
///         // Arrange
///         final file = File(l10nFile.path);
///         file.writeAsStringSync(l10nWithTemplateArbFile);
///
///         // Act + Assert
///         expect(l10nFile.templateArbFile(), 'foo_bar');
///       });
///
///       test('throws when name is not present', () {
///         // Arrange
///         final file = File(l10nFile.path);
///         file.writeAsStringSync(l10nWithoutTemplateArbFile);
///
///         // Act + Assert
///         expect(() => l10nFile.templateArbFile(),
///             throwsA(isA<ReadTemplateArbFileFailure>()));
///       });
///     });
///   });
/// }
///

