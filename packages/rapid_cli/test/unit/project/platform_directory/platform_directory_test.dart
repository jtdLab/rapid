import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_directory.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_feature_package/platform_feature_package.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../common.dart';
import '../../mocks.dart';

PlatformDirectory _getPlatformDirectory(
  Platform platform, {
  required Project project,
  List<PlatformCustomFeaturePackage>? customFeaturePackages,
}) {
  return PlatformDirectory(
    platform,
    project: project,
  )..customFeaturePackagesOverrides = customFeaturePackages;
}

void main() {
  group('PlatformDirectory', () {
    group('.path', () {
      test('(android)', () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final loggingPackage = _getPlatformDirectory(
          Platform.android,
          project: project,
        );

        // Act + Assert
        expect(
          loggingPackage.path,
          'project/path/packages/my_project/my_project_android',
        );
      });

      test('(ios)', () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final loggingPackage = _getPlatformDirectory(
          Platform.ios,
          project: project,
        );

        // Act + Assert
        expect(
          loggingPackage.path,
          'project/path/packages/my_project/my_project_ios',
        );
      });

      test('(linux)', () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final loggingPackage = _getPlatformDirectory(
          Platform.linux,
          project: project,
        );

        // Act + Assert
        expect(
          loggingPackage.path,
          'project/path/packages/my_project/my_project_linux',
        );
      });

      test('(macos)', () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final loggingPackage = _getPlatformDirectory(
          Platform.macos,
          project: project,
        );

        // Act + Assert
        expect(
          loggingPackage.path,
          'project/path/packages/my_project/my_project_macos',
        );
      });

      test('(web)', () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final loggingPackage = _getPlatformDirectory(
          Platform.web,
          project: project,
        );

        // Act + Assert
        expect(
          loggingPackage.path,
          'project/path/packages/my_project/my_project_web',
        );
      });

      test('(windows)', () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final loggingPackage = _getPlatformDirectory(
          Platform.windows,
          project: project,
        );

        // Act + Assert
        expect(
          loggingPackage.path,
          'project/path/packages/my_project/my_project_windows',
        );
      });
    });

    test('.appFeaturePackage', () {
      // Arrange
      final project = getProject();
      final loggingPackage = _getPlatformDirectory(
        Platform.android,
        project: project,
      );

      // Act + Assert
      expect(
        loggingPackage.appFeaturePackage,
        isA<PlatformAppFeaturePackage>()
            .having((appfp) => appfp.platform, 'platform', Platform.android)
            .having((appfp) => appfp.project, 'project', project),
      );
    });

    test('.routingFeaturePackage', () {
      // Arrange
      final project = getProject();
      final loggingPackage = _getPlatformDirectory(
        Platform.android,
        project: project,
      );

      // Act + Assert
      expect(
        loggingPackage.routingFeaturePackage,
        isA<PlatformRoutingFeaturePackage>()
            .having(
              (routingfp) => routingfp.platform,
              'platform',
              Platform.android,
            )
            .having((routingfp) => routingfp.project, 'project', project),
      );
    });

    group('.allFeaturesHaveSameLanguages()', () {
      test('returns true when all custom feature packages have same language',
          () {
        // Arrange
        final project = getProject();
        final feature1 = getPlatformCustomFeaturePackage();
        when(() => feature1.supportedLanguages()).thenReturn({'en', 'de'});
        final feature2 = getPlatformCustomFeaturePackage();
        when(() => feature2.supportedLanguages()).thenReturn({'de', 'en'});
        final platformDirectory = _getPlatformDirectory(
          Platform.android,
          project: project,
          customFeaturePackages: [feature1, feature2],
        );

        // Act + Assert
        expect(platformDirectory.allFeaturesHaveSameLanguages(), true);
      });

      test(
          'returns false when NOT all custom feature packages have same language',
          () {
        // Arrange
        final project = getProject();
        final feature1 = getPlatformCustomFeaturePackage();
        when(() => feature1.supportedLanguages()).thenReturn({'fr', 'de'});
        final feature2 = getPlatformCustomFeaturePackage();
        when(() => feature2.supportedLanguages()).thenReturn({'de', 'en'});
        final platformDirectory = _getPlatformDirectory(
          Platform.android,
          project: project,
          customFeaturePackages: [feature1, feature2],
        );

        // Act + Assert
        expect(platformDirectory.allFeaturesHaveSameLanguages(), false);
      });
    });

    group('.allFeaturesHaveSameDefaultLanguage()', () {
      test(
          'returns true when all custom feature packages have same default language',
          () {
        // Arrange
        final project = getProject();
        final feature1 = getPlatformCustomFeaturePackage();
        when(() => feature1.defaultLanguage()).thenReturn('fr');
        final feature2 = getPlatformCustomFeaturePackage();
        when(() => feature2.defaultLanguage()).thenReturn('fr');
        final platformDirectory = _getPlatformDirectory(
          Platform.android,
          project: project,
          customFeaturePackages: [feature1, feature2],
        );

        // Act + Assert
        expect(platformDirectory.allFeaturesHaveSameDefaultLanguage(), true);
      });

      test(
          'returns false when NOT all custom feature packages have same default language',
          () {
        // Arrange
        final project = getProject();
        final feature1 = getPlatformCustomFeaturePackage();
        when(() => feature1.defaultLanguage()).thenReturn('en');
        final feature2 = getPlatformCustomFeaturePackage();
        when(() => feature2.defaultLanguage()).thenReturn('fr');
        final platformDirectory = _getPlatformDirectory(
          Platform.android,
          project: project,
          customFeaturePackages: [feature1, feature2],
        );

        // Act + Assert
        expect(platformDirectory.allFeaturesHaveSameDefaultLanguage(), false);
      });
    });

    group('.customFeaturePackage()', () {
      test('returns a custom feature package with correct path', () {
        // Arrange
        final project = getProject();
        final platformDirectory = _getPlatformDirectory(
          Platform.android,
          project: project,
        );

        // Act + Assert
        expect(
          platformDirectory.customFeaturePackage(name: 'my_feature'),
          isA<PlatformCustomFeaturePackage>()
              .having((customfp) => customfp.name, 'name', 'my_feature')
              .having(
                (customfp) => customfp.platform,
                'platform',
                Platform.android,
              )
              .having((customfp) => customfp.project, 'project', project),
        );
      });
    });

    group('.customFeaturePackages()', () {
      test('returns empty list when platform directory has no sub directories',
          () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn(getTempDir().path);
        final platformDirectory = _getPlatformDirectory(
          Platform.android,
          project: project,
        );
        Directory(platformDirectory.path).createSync(recursive: true);

        // Act + Assert
        expect(platformDirectory.customFeaturePackages(), isEmpty);
      });

      test(
          'returns list with custom feature packages when platform directory has sub directories',
          () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn(getTempDir().path);
        when(() => project.name()).thenReturn('my_project');
        final platformDirectory = _getPlatformDirectory(
          Platform.android,
          project: project,
        );
        const customFeaturePackageNames = ['my_feat_a', 'my_feat_b'];
        for (final featureName in customFeaturePackageNames) {
          Directory(
            p.join(platformDirectory.path, 'my_project_android_$featureName'),
          ).createSync(recursive: true);
        }

        // Act
        final customFeaturePackages = platformDirectory.customFeaturePackages();

        // Assert
        expect(customFeaturePackages, hasLength(2));
        for (int i = 0; i < 2; i++) {
          final customFeaturePackage = customFeaturePackages[i];
          expect(customFeaturePackage.name, customFeaturePackageNames[i]);
          expect(customFeaturePackage.platform, Platform.android);
          expect(
            customFeaturePackage.path,
            endsWith('my_project_android_${customFeaturePackageNames[i]}'),
          );
        }
      });

      test('ignores app and routing feature packages', () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn(getTempDir().path);
        when(() => project.name()).thenReturn('my_project');
        final platformDirectory = _getPlatformDirectory(
          Platform.android,
          project: project,
        );
        const customFeaturePackageNames = [
          'app',
          'routing',
          'my_feat_a',
          'my_feat_b'
        ];
        for (final featureName in customFeaturePackageNames) {
          Directory(
            p.join(platformDirectory.path, 'my_project_android_$featureName'),
          ).createSync(recursive: true);
        }

        // Act
        final customFeaturePackages = platformDirectory.customFeaturePackages();

        // Assert
        expect(customFeaturePackages, hasLength(2));
        for (int i = 2; i < 4; i++) {
          final customFeaturePackage = customFeaturePackages[i - 2];
          expect(customFeaturePackage.name, customFeaturePackageNames[i]);
          expect(customFeaturePackage.platform, Platform.android);
          expect(
            customFeaturePackage.path,
            p.join(
              platformDirectory.path,
              'my_project_android_${customFeaturePackageNames[i]}',
            ),
          );
        }
      });
    });
  });
}
