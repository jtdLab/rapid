import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

const projectName = 'foo_bar';

const melos = '''
name: $projectName
''';

const melosWithName = '''
name: foo_bar
''';

const melosWithoutName = '''
some: value
''';

class _MockProject extends Mock implements Project {}

void main() {
  /*  group('Project', () {
    final cwd = Directory.current;

    late Project project;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      project = Project();
    });

    tearDown(() {
      Directory.current = cwd;
    });

    group('appPackage', () {
      test('returns correct app package', () {
        // Act
        final appPackage = project.appPackage;

        // Assert
        expect(appPackage.path, 'packages/$projectName/$projectName');
      });
    });

    group('diPackage', () {
      test('returns correct di package', () {
        // Act
        final diPackage = project.diPackage;

        // Assert
        expect(diPackage.path, 'packages/$projectName/${projectName}_di');
      });
    });

    group('domainPackage', () {
      test('returns correct dart package', () {
        // Act
        final domainPackage = project.domainPackage;

        // Assert
        expect(
          domainPackage.path,
          'packages/$projectName/${projectName}_domain',
        );
      });
    });

    group('melosFile', () {
      test('returns correct melos file', () {
        // Act
        final melosFile = project.melosFile;

        // Assert
        expect(melosFile.path, 'melos.yaml');
      });
    });

    group('isActivated', () {
      const platform = Platform.android;

      setUp(() {
        Directory(project.platformDirectory(platform).path)
            .createSync(recursive: true);
        Directory(project.platformUiPackage(platform).path)
            .createSync(recursive: true);
      });

      test('returns true when platform directory and platform ui package exist',
          () {
        // Act
        final isActivated = project.isActivated(platform);

        // Assert
        expect(isActivated, true);
      });

      test('returns false when platform directory does not exist', () {
        // Arrange
        Directory(project.platformDirectory(platform).path)
            .deleteSync(recursive: true);

        // Act
        final isActivated = project.isActivated(platform);

        // Assert
        expect(isActivated, false);
      });

      test('returns false when platform ui package does not exist', () {
        // Arrange
        Directory(project.platformUiPackage(platform).path)
            .deleteSync(recursive: true);

        // Act
        final isActivated = project.isActivated(platform);

        // Assert
        expect(isActivated, false);
      });
    });

    group('platformDirectory', () {
      test('returns correct platform directory', () {
        // Act
        final platformDirectory = project.platformDirectory(Platform.android);

        // Assert
        expect(platformDirectory.path,
            'packages/$projectName/${projectName}_android');
      });
    });

    group('platformUiPackage', () {
      test('returns correct dart package', () {
        // Act
        final platformUiPackage = project.platformUiPackage(Platform.android);

        // Assert
        expect(
          platformUiPackage.path,
          'packages/${projectName}_ui/${projectName}_ui_android',
        );
      });
    });
  });
 */
  group('MelosFile', () {
    final cwd = Directory.current;

    late Project project;
    const projectPath = 'foo/bar';

    late MelosFile melosFile;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      project = _MockProject();
      when(() => project.path).thenReturn(projectPath);

      melosFile = MelosFile(project: project);

      File(melosFile.path).createSync(recursive: true);
    });

    tearDown(() {
      Directory.current = cwd;
    });

    group('path', () {
      test('is correct', () {
        // Assert
        expect(melosFile.path, '$projectPath/melos.yaml');
      });
    });

    group('exists', () {
      test('returns true when the file exists', () {
        // Act
        final exists = melosFile.exists();

        // Assert
        expect(exists, true);
      });

      test('returns false when the file does not exists', () {
        // Arrange
        File(melosFile.path).deleteSync(recursive: true);

        // Act
        final exists = melosFile.exists();

        // Assert
        expect(exists, false);
      });
    });

    group('name', () {
      test('returns name', () {
        // Arrange
        final file = File(melosFile.path);
        file.writeAsStringSync(melosWithName);

        // Act + Assert
        expect(melosFile.readName(), 'foo_bar');
      });

      test('throws when name is not present', () {
        // Arrange
        final file = File(melosFile.path);
        file.writeAsStringSync(melosWithoutName);

        // Act + Assert
        expect(() => melosFile.readName(), throwsA(isA<ReadNameFailure>()));
      });
    });
  });
}
