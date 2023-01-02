import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

const projectName = 'foo_bar';

const melos = '''
name: $projectName
''';

void main() {
  group('Project', () {
    final cwd = Directory.current;

    late Project project;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync().path;

      project = Project();
      final melosFile = File(project.melosFile.path);
      melosFile.createSync(recursive: true);
      melosFile.writeAsStringSync(melos);
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

      test('returns false when  platform ui package does not exist', () {
        // Arrange
        Directory(project.platformUiPackage(platform).path)
            .deleteSync(recursive: false);

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
}
