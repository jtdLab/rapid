import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/melos_file.dart';
import 'package:rapid_cli/src/project/platform_directory.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

class MockMelosFile extends Mock implements MelosFile {}

class MockProject extends Mock implements Project {}

void main() {
  group('PlatformDirectory', () {
    final cwd = Directory.current;

    const projectName = 'foo_bar';
    late MelosFile melosFile;
    late Project project;
    const platform = Platform.android;
    late PlatformDirectory platformDirectory;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync().path;

      melosFile = MockMelosFile();
      when(() => melosFile.name()).thenReturn(projectName);
      project = MockProject();
      when(() => project.melosFile).thenReturn(melosFile);
      platformDirectory = PlatformDirectory(
        platform: platform,
        project: project,
      );
      Directory(platformDirectory.path).createSync(recursive: true);
    });

    tearDown(() {
      Directory.current = cwd;
    });

    group('delete', () {
      test('deletes the directory', () {
        // Arrange
        final directory = Directory(platformDirectory.path);

        // Act
        platformDirectory.delete();

        // Assert
        expect(directory.existsSync(), false);
      });
    });

    group('exists', () {
      test('returns true when the directory exists', () {
        // Act
        final exists = platformDirectory.exists();

        // Assert
        expect(exists, true);
      });

      test('returns false when the directory does not exists', () {
        // Arrange
        Directory(platformDirectory.path).deleteSync(recursive: true);

        // Act
        final exists = platformDirectory.exists();

        // Assert
        expect(exists, false);
      });
    });

    group('featureExists', () {
      test('returns true when the requested feature exists', () {
        // Arrange
        final featureName = 'existing_feature';
        Directory(p.join(platformDirectory.path,
                '${projectName}_${platform.name}_$featureName'))
            .createSync(recursive: true);

        // Act
        final exists = platformDirectory.featureExists(featureName);

        // Assert
        expect(exists, true);
      });

      test('returns false when the requested package does not exist', () {
        // Arrange
        final featureName = 'not_existing_feature';

        // Act
        final exists = platformDirectory.featureExists(featureName);

        // Assert
        expect(exists, false);
      });
    });

    group('findFeature', () {
      test(
          'returns a dartpackage with correct path when the requested feature exists',
          () {
        // Arrange
        final featureName = 'existing_feature';
        final path = p.join(platformDirectory.path,
            '${projectName}_${platform.name}_$featureName');
        Directory(path).createSync(recursive: true);

        // Act
        final package = platformDirectory.findFeature(featureName);

        // Assert
        expect(package.path, path);
      });

      test('throws FeatureNotFound when the requested package does not exist',
          () {
        // Arrange
        final featureName = 'not_existing_feature';

        // Act & Assert
        expect(
          () => platformDirectory.findFeature(featureName),
          throwsA(isA<FeatureNotFound>()),
        );
      });
    });

    group('path', () {
      test('is correct', () {
        // Assert
        expect(
          platformDirectory.path,
          'packages/$projectName/${projectName}_${platform.name}',
        );
      });
    });
  });
}
