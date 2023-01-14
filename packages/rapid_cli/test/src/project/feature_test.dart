import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/feature.dart';
import 'package:rapid_cli/src/project/melos_file.dart';
import 'package:rapid_cli/src/project/platform_directory.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

const l10nWithTemplateArbFile = '''
template-arb-file: foo_bar
''';

const l10nWithoutTemplateArbFile = '''
some: value
''';

class _MockMelosFile extends Mock implements MelosFile {}

class _MockProject extends Mock implements Project {}

class _MockPlatformDirectory extends Mock implements PlatformDirectory {}

class _MockFeature extends Mock implements Feature {}

void main() {
  group('Feature', () {
    final cwd = Directory.current;

    const projectName = 'my_app';
    late MelosFile melosFile;
    late Project project;
    const platform = Platform.android;
    const platformDirPath = 'bom/bam';
    late PlatformDirectory platformDirectory;
    const featureName = 'my_feature';
    late Feature feature;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      melosFile = _MockMelosFile();
      when(() => melosFile.name()).thenReturn(projectName);
      project = _MockProject();
      when(() => project.melosFile).thenReturn(melosFile);
      platformDirectory = _MockPlatformDirectory();
      when(() => platformDirectory.platform).thenReturn(platform);
      when(() => platformDirectory.path).thenReturn(platformDirPath);
      when(() => platformDirectory.project).thenReturn(project);
      feature = Feature(
        name: featureName,
        platformDirectory: platformDirectory,
      );
      Directory(feature.path).createSync(recursive: true);
      Directory(
        p.join(feature.path, 'lib', 'src', 'presentation', 'l10n', 'arb'),
      ).createSync(recursive: true);
    });

    tearDown(() {
      Directory.current = cwd;
    });

    group('delete', () {
      test('deletes the directory', () {
        // Arrange
        final directory = Directory(feature.path);

        // Act
        feature.delete();

        // Assert
        expect(directory.existsSync(), false);
      });
    });

    group('defaultLanguage', () {
      test('returns the correct default language extracted from l10n.yaml', () {
        // Arrange
        final l10nFile = File(p.join(feature.path, 'l10n.yaml'));
        l10nFile.createSync(recursive: true);
        l10nFile.writeAsStringSync('template-arb-file: ${featureName}_fr.arb');

        // Act
        final defaultLanguage = feature.defaultLanguage();

        // Assert
        expect(defaultLanguage, 'fr');
      });
    });

    group('exists', () {
      test('returns true when the directory exists', () {
        // Act
        final exists = feature.exists();

        // Assert
        expect(exists, true);
      });

      test('returns false when the directory does not exists', () {
        // Arrange
        Directory(feature.path).deleteSync(recursive: true);

        // Act
        final exists = feature.exists();

        // Assert
        expect(exists, false);
      });
    });

    group('findArbFileByLanguage', () {
      test('returns the arb file corresponding to the language', () {
        // Arrange
        const language = 'de';
        final path = p.join(
          feature.path,
          'lib',
          'src',
          'presentation',
          'l10n',
          'arb',
          '${featureName}_$language.arb',
        );
        final file = File(path);
        file.createSync(recursive: true);

        // Act
        final arbFile = feature.findArbFileByLanguage(language);

        // Assert
        expect(arbFile.path, path);
        expect(arbFile.language, language);
      });

      test('throws when the arb file does not exist', () {
        // Arrange
        const language = 'de';

        // Act & Assert
        expect(
          () => feature.findArbFileByLanguage(language),
          throwsA(isA<ArbFileNotExisting>()),
        );
      });
    });

    group('supportedLanguages', () {
      test(
          'returns the correct supported languages depending on existing .arb files',
          () {
        // Arrange
        const languages = ['de', 'en', 'fr'];
        for (final language in languages) {
          final arbFile = File(
            p.join(
              feature.path,
              'lib',
              'src',
              'presentation',
              'l10n',
              'arb',
              '${featureName}_$language.arb',
            ),
          );
          arbFile.createSync(recursive: true);
        }

        // Act
        final supportedLanguages = feature.supportedLanguages();

        // Assert
        expect(supportedLanguages, equals(languages));
      });
    });

    group('supportsLanguage', () {
      test('returns true when the corresponding .arb file exists', () {
        // Arrange
        const language = 'de';
        final arbFile = File(
          p.join(
            feature.path,
            'lib',
            'src',
            'presentation',
            'l10n',
            'arb',
            '${featureName}_$language.arb',
          ),
        );
        arbFile.createSync(recursive: true);

        // Act
        final supportsLanguage = feature.supportsLanguage(language);

        // Assert
        expect(supportsLanguage, true);
      });

      test('returns false when the corresponding .arb file does not exist', () {
        // Arrange
        const language = 'de';

        // Act
        final supportsLanguage = feature.supportsLanguage(language);

        // Assert
        expect(supportsLanguage, false);
      });
    });

    group('name', () {
      test('is correct', () {
        // Assert
        expect(feature.name, featureName);
      });
    });

    group('path', () {
      test('is correct', () {
        // Assert
        expect(
          feature.path,
          '$platformDirPath/${projectName}_${platform.name}_$featureName',
        );
      });
    });

    group('platform', () {
      test('is correct', () {
        // Assert
        expect(feature.platform, platform);
      });
    });

    group('pubspecFile', () {
      test('has correct path', () {
        // Act
        final pubspecFile = feature.pubspecFile;

        // Assert
        expect(
          pubspecFile.path,
          '$platformDirPath/${projectName}_${platform.name}_$featureName/pubspec.yaml',
        );
      });
    });
  });

  group('ArbFile', () {
    final cwd = Directory.current;

    const featureName = 'my_feature';
    const featurePath = 'foo/bar';
    late Feature feature;
    const language = 'en';
    late ArbFile arbFile;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      feature = _MockFeature();
      when(() => feature.name).thenReturn(featureName);
      when(() => feature.path).thenReturn(featurePath);
      arbFile = ArbFile(language: language, feature: feature);
      File(arbFile.path).createSync(recursive: true);
    });

    tearDown(() {
      Directory.current = cwd;
    });

    group('language', () {
      test('is correct', () {
        // Assert
        expect(arbFile.language, language);
      });
    });

    group('path', () {
      test('is correct', () {
        // Assert
        expect(
          arbFile.path,
          'foo/bar/lib/src/presentation/l10n/arb/my_feature_en.arb',
        );
      });
    });

    group('delete', () {
      test('deletes the file', () {
        // Arrange
        final file = File(arbFile.path);

        // Act
        arbFile.delete();

        // Assert
        expect(file.existsSync(), false);
      });
    });
  });

  group('L10nFile', () {
    final cwd = Directory.current;

    late L10nFile l10nFile;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      l10nFile = L10nFile();
      File(l10nFile.path).createSync(recursive: true);
    });

    tearDown(() {
      Directory.current = cwd;
    });

    group('path', () {
      test('is correct', () {
        // Assert
        expect(l10nFile.path, 'l10n.yaml');
      });
    });

    group('templateArbFile', () {
      test('returns template-arb-file', () {
        // Arrange
        final file = File(l10nFile.path);
        file.writeAsStringSync(l10nWithTemplateArbFile);

        // Act + Assert
        expect(l10nFile.templateArbFile(), 'foo_bar');
      });

      test('throws when name is not present', () {
        // Arrange
        final file = File(l10nFile.path);
        file.writeAsStringSync(l10nWithoutTemplateArbFile);

        // Act + Assert
        expect(() => l10nFile.templateArbFile(),
            throwsA(isA<ReadTemplateArbFileFailure>()));
      });
    });
  });
}
