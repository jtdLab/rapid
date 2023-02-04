import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_directory.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_feature_package/platform_feature_package.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../mocks.dart';

void main() {
  group('PlatformDirectory', () {
    final cwd = Directory.current;

    late Project project;
    const projectPath = 'foo/bar';
    const projectName = 'foo_bar';

    const platform = Platform.android;

    late List<PlatformCustomFeaturePackage>? customFeaturePackages;

    late PlatformDirectory underTest;

    PlatformDirectory platformDirectory() => PlatformDirectory(
          platform,
          project: project,
        )..customFeaturePackagesOverrides = customFeaturePackages;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      project = MockProject();
      when(() => project.path).thenReturn(projectPath);
      when(() => project.name()).thenReturn(projectName);

      customFeaturePackages = null;

      underTest = platformDirectory();

      Directory(underTest.path).createSync(recursive: true);
    });

    tearDown(() {
      Directory.current = cwd;
    });

    group('path', () {
      test('is correct', () {
        // Assert
        expect(
          underTest.path,
          '$projectPath/packages/$projectName/${projectName}_${platform.name}',
        );
      });
    });

    group('appFeaturePackage', () {
      test('returns platform app featuere package with correct path', () {
        // Act
        final appFeaturePackage = underTest.appFeaturePackage;

        // Assert
        expect(
          appFeaturePackage.path,
          '$projectPath/packages/$projectName/${projectName}_${platform.name}/${projectName}_${platform.name}_app',
        );
      });
    });

    group('routingFeaturePackage', () {
      test('returns platform app featuere package with correct path', () {
        // Act
        final routingFeaturePackage = underTest.routingFeaturePackage;

        // Assert
        expect(
          routingFeaturePackage.path,
          '$projectPath/packages/$projectName/${projectName}_${platform.name}/${projectName}_${platform.name}_routing',
        );
      });
    });

    group('allFeaturesHaveSameLanguages', () {
      test('returns true when all custom feature packages have same language',
          () {
        // Arrange
        final feature1 = MockPlatformCustomFeaturePackage();
        when(() => feature1.supportedLanguages()).thenReturn({'en', 'de'});
        final feature2 = MockPlatformCustomFeaturePackage();
        when(() => feature2.supportedLanguages()).thenReturn({'de', 'en'});

        customFeaturePackages = [feature1, feature2];
        underTest = platformDirectory();

        // Act
        final allFeaturesHaveSameLanguages =
            underTest.allFeaturesHaveSameLanguages();

        // Assert
        expect(allFeaturesHaveSameLanguages, true);
      });

      test(
          'returns false when NOT all custom feature packages have same language',
          () {
        // Arrange
        final feature1 = MockPlatformCustomFeaturePackage();
        when(() => feature1.supportedLanguages()).thenReturn({'fr', 'de'});
        final feature2 = MockPlatformCustomFeaturePackage();
        when(() => feature2.supportedLanguages()).thenReturn({'de', 'en'});

        customFeaturePackages = [feature1, feature2];
        underTest = platformDirectory();

        // Act
        final allFeaturesHaveSameLanguages =
            underTest.allFeaturesHaveSameLanguages();

        // Assert
        expect(allFeaturesHaveSameLanguages, false);
      });
    });

    group('allFeaturesHaveSameDefaultLanguage', () {
      test(
          'returns true when all custom feature packages have same default language',
          () {
        // Arrange
        final feature1 = MockPlatformCustomFeaturePackage();
        when(() => feature1.defaultLanguage()).thenReturn('fr');
        final feature2 = MockPlatformCustomFeaturePackage();
        when(() => feature2.defaultLanguage()).thenReturn('fr');

        customFeaturePackages = [feature1, feature2];
        underTest = platformDirectory();

        // Act
        final allFeaturesHaveSameDefaultLanguage =
            underTest.allFeaturesHaveSameDefaultLanguage();

        // Assert
        expect(allFeaturesHaveSameDefaultLanguage, true);
      });

      test(
          'returns false when NOT all custom feature packages have same default language',
          () {
        // Arrange
        final feature1 = MockPlatformCustomFeaturePackage();
        when(() => feature1.defaultLanguage()).thenReturn('en');
        final feature2 = MockPlatformCustomFeaturePackage();
        when(() => feature2.defaultLanguage()).thenReturn('fr');

        customFeaturePackages = [feature1, feature2];
        underTest = platformDirectory();

        // Act
        final allFeaturesHaveSameDefaultLanguage =
            underTest.allFeaturesHaveSameDefaultLanguage();

        // Assert
        expect(allFeaturesHaveSameDefaultLanguage, false);
      });
    });

    group('customFeaturePackage', () {
      test('returns a custom feature package with correct path', () {
        // Arrange
        final featureName = 'my_feat';
        final path = p.join(
          underTest.path,
          '${projectName}_${platform.name}_$featureName',
        );
        Directory(path).createSync(recursive: true);

        // Act
        final customFeaturePackage =
            underTest.customFeaturePackage(name: featureName);

        // Assert
        expect(customFeaturePackage.path, path);
      });
    });

    group('customFeaturePackages', () {
      test('returns empty list when platform directory has no sub directories',
          () {
        // Act
        final features = underTest.customFeaturePackages();

        // Assert
        expect(features, isEmpty);
      });

      test(
          'returns list with custom feature packages when platform directory has sub directories',
          () {
        // Arrange
        const customFeaturePackageNames = ['my_feat_a', 'my_feat_b'];
        for (final featureName in customFeaturePackageNames) {
          Directory(
            p.join(
              underTest.path,
              '${projectName}_${platform.name}_$featureName',
            ),
          ).createSync(recursive: true);
        }

        // Act
        final customFeaturePackages = underTest.customFeaturePackages();

        // Assert
        expect(customFeaturePackages, hasLength(2));
        for (int i = 0; i < 2; i++) {
          final customFeaturePackage = customFeaturePackages[i];
          expect(customFeaturePackage.name, customFeaturePackageNames[i]);
          expect(customFeaturePackage.platform, platform);
          expect(
            customFeaturePackage.path,
            p.join(
              underTest.path,
              '${projectName}_${platform.name}_${customFeaturePackageNames[i]}',
            ),
          );
        }
      });

      test('ignores app and routing feature packages', () {
        // Arrange
        const customFeaturePackageNames = ['my_feat_a', 'my_feat_b'];
        for (final featureName in customFeaturePackageNames) {
          Directory(
            p.join(
              underTest.path,
              '${projectName}_${platform.name}_$featureName',
            ),
          ).createSync(recursive: true);
        }
        Directory(
          p.join(
            underTest.path,
            '${projectName}_${platform.name}_app',
          ),
        ).createSync(recursive: true);
        Directory(
          p.join(
            underTest.path,
            '${projectName}_${platform.name}_routing',
          ),
        ).createSync(recursive: true);

        // Act
        final customFeaturePackages = underTest.customFeaturePackages();

        // Assert
        expect(customFeaturePackages, hasLength(2));
        for (int i = 0; i < 2; i++) {
          final customFeaturePackage = customFeaturePackages[i];
          expect(customFeaturePackage.name, customFeaturePackageNames[i]);
          expect(customFeaturePackage.platform, platform);
          expect(
            customFeaturePackage.path,
            p.join(
              underTest.path,
              '${projectName}_${platform.name}_${customFeaturePackageNames[i]}',
            ),
          );
        }
      });
    });
  });
}
