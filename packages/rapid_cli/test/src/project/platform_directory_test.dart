import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/melos_file.dart';
import 'package:rapid_cli/src/project/platform_directory.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

class _MockMelosFile extends Mock implements MelosFile {}

class _MockProject extends Mock implements Project {}

void main() {
  group('PlatformDirectory', () {
    final cwd = Directory.current;

    const projectName = 'foo_bar';
    late MelosFile melosFile;
    late Project project;
    const platform = Platform.android;
    late PlatformDirectory platformDirectory;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      melosFile = _MockMelosFile();
      when(() => melosFile.name()).thenReturn(projectName);
      project = _MockProject();
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
          'returns a dart package with correct path when the requested feature exists',
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

    group('getFeatures', () {
      test('returns empty list when platform directory has no sub directories',
          () {
        // Act
        final features = platformDirectory.getFeatures();

        // Assert
        expect(features, isEmpty);
      });

      test(
          'returns list with features when platform directory has sub directories',
          () {
        // Arrange
        const featureNames = ['my_feat_a', 'my_feat_b'];
        for (final featureName in featureNames) {
          Directory(
            p.join(
              platformDirectory.path,
              '${projectName}_${platform.name}_$featureName',
            ),
          ).createSync(recursive: true);
        }

        // Act
        final features = platformDirectory.getFeatures();

        // Assert
        expect(features, hasLength(2));
        for (int i = 0; i < 2; i++) {
          final feature = features[i];
          expect(feature.entityName, featureNames[i]);
          expect(feature.platform, platform);
          expect(
            feature.path,
            p.join(
              platformDirectory.path,
              '${projectName}_${platform.name}_${featureNames[i]}',
            ),
          );
        }
      });

      test('excludes features correctly', () {
        // Arrange
        const excludedFeature = 'my_feat_a';
        const featureNames = [excludedFeature, 'my_feat_b'];
        for (final featureName in featureNames) {
          Directory(
            p.join(
              platformDirectory.path,
              '${projectName}_${platform.name}_$featureName',
            ),
          ).createSync(recursive: true);
        }

        // Act
        final features =
            platformDirectory.getFeatures(exclude: {excludedFeature});

        // Assert
        expect(features, hasLength(1));

        final feature = features.first;
        expect(feature.entityName, featureNames.last);
        expect(feature.platform, platform);
        expect(
          feature.path,
          p.join(
            platformDirectory.path,
            '${projectName}_${platform.name}_${featureNames.last}',
          ),
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

    group('platform', () {
      test('is correct', () {
        // Assert
        expect(platformDirectory.platform, platform);
      });
    });

    group('project', () {
      test('is correct', () {
        // Assert
        expect(platformDirectory.project, project);
      });
    });
  });
}
