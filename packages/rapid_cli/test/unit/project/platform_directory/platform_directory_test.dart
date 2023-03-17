import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_directory.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../common.dart';
import '../../mocks.dart';

PlatformDirectory _getPlatformDirectory(
  Platform platform, {
  required Project project,
}) {
  return PlatformDirectory(
    platform,
    project: project,
  );
}

void main() {
  group('PlatformDirectory', () {
    group('.path', () {
      test('(android)', () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final platformDirectory = _getPlatformDirectory(
          Platform.android,
          project: project,
        );

        // Act + Assert
        expect(
          platformDirectory.path,
          'project/path/packages/my_project/my_project_android',
        );
      });

      test('(ios)', () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final platformDirectory = _getPlatformDirectory(
          Platform.ios,
          project: project,
        );

        // Act + Assert
        expect(
          platformDirectory.path,
          'project/path/packages/my_project/my_project_ios',
        );
      });

      test('(linux)', () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final platformDirectory = _getPlatformDirectory(
          Platform.linux,
          project: project,
        );

        // Act + Assert
        expect(
          platformDirectory.path,
          'project/path/packages/my_project/my_project_linux',
        );
      });

      test('(macos)', () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final platformDirectory = _getPlatformDirectory(
          Platform.macos,
          project: project,
        );

        // Act + Assert
        expect(
          platformDirectory.path,
          'project/path/packages/my_project/my_project_macos',
        );
      });

      test('(web)', () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final platformDirectory = _getPlatformDirectory(
          Platform.web,
          project: project,
        );

        // Act + Assert
        expect(
          platformDirectory.path,
          'project/path/packages/my_project/my_project_web',
        );
      });

      test('(windows)', () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final platformDirectory = _getPlatformDirectory(
          Platform.windows,
          project: project,
        );

        // Act + Assert
        expect(
          platformDirectory.path,
          'project/path/packages/my_project/my_project_windows',
        );
      });
    });

    test('.project', () {
      // Arrange
      final project = getProject();
      final platformDirectory = _getPlatformDirectory(
        Platform.android,
        project: project,
      );

      // Act + Assert
      expect(platformDirectory.project, project);
    });

    test('.appFeaturePackage', () {
      // Arrange
      final project = getProject();
      final platformDirectory = _getPlatformDirectory(
        Platform.android,
        project: project,
      );

      // Act + Assert
      expect(
        platformDirectory.appFeaturePackage,
        isA<PlatformAppFeaturePackage>()
            .having((appfp) => appfp.platform, 'platform', Platform.android)
            .having((appfp) => appfp.project, 'project', project),
      );
    });

    test('.routingFeaturePackage', () {
      // Arrange
      final project = getProject();
      final platformDirectory = _getPlatformDirectory(
        Platform.android,
        project: project,
      );

      // Act + Assert
      expect(
        platformDirectory.routingFeaturePackage,
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
      void createFeatureFiles({
        required String name,
        required Set<String> languages,
        required PlatformDirectory platformDirectory,
      }) {
        for (final language in languages) {
          File(
            LanguageArbFile(
              language: language,
              arbDirectory: ArbDirectory(
                platformCustomizableFeaturePackage:
                    platformDirectory.customFeaturePackage(
                  name: name,
                ),
              ),
            ).path,
          ).createSync(recursive: true);
        }
      }

      test(
        'returns true when all custom feature packages and the app feature package have same supported languages',
        withTempDir(() {
          // Arrange
          final project = getProject();
          final platformDirectory = _getPlatformDirectory(
            Platform.android,
            project: project,
          );
          createFeatureFiles(
            name: 'app',
            languages: {'de', 'fr'},
            platformDirectory: platformDirectory,
          );
          createFeatureFiles(
            name: 'my_feature_a',
            languages: {'de', 'fr'},
            platformDirectory: platformDirectory,
          );
          createFeatureFiles(
            name: 'my_feature_b',
            languages: {'fr', 'de'},
            platformDirectory: platformDirectory,
          );

          // Act + Assert
          expect(platformDirectory.allFeaturesHaveSameLanguages(), true);
        }),
      );

      test(
        'returns false when NOT all custom feature packages have same supported languages',
        withTempDir(() {
          // Arrange
          final project = getProject();
          final platformDirectory = _getPlatformDirectory(
            Platform.android,
            project: project,
          );
          createFeatureFiles(
            name: 'my_feature_a',
            languages: {'de', 'fr'},
            platformDirectory: platformDirectory,
          );
          createFeatureFiles(
            name: 'my_feature_b',
            languages: {'de', 'en'},
            platformDirectory: platformDirectory,
          );

          // Act + Assert
          expect(platformDirectory.allFeaturesHaveSameLanguages(), false);
        }),
      );

      test(
        'returns false when the app feature package does NOT have same supported languages',
        withTempDir(() {
          // Arrange
          final project = getProject();
          final platformDirectory = _getPlatformDirectory(
            Platform.android,
            project: project,
          );
          createFeatureFiles(
            name: 'app',
            languages: {'de', 'en'},
            platformDirectory: platformDirectory,
          );
          createFeatureFiles(
            name: 'my_feature_a',
            languages: {'de', 'fr'},
            platformDirectory: platformDirectory,
          );
          createFeatureFiles(
            name: 'my_feature_b',
            languages: {'de', 'en'},
            platformDirectory: platformDirectory,
          );

          // Act + Assert
          expect(platformDirectory.allFeaturesHaveSameLanguages(), false);
        }),
      );
    });

    group('.allFeaturesHaveSameDefaultLanguage()', () {
      void createFeatureFiles({
        required String name,
        required String language,
        required PlatformDirectory platformDirectory,
      }) {
        File(
          L10nFile(
            platformCustomizableFeaturePackage:
                platformDirectory.customFeaturePackage(
              name: name,
            ),
          ).path,
        )
          ..createSync(recursive: true)
          ..writeAsStringSync('template-arb-file: ${name}_$language.arb');
      }

      test(
        'returns true when all custom feature packages and the app feature package have same default language',
        withTempDir(() {
          // Arrange
          final project = getProject();
          final platformDirectory = _getPlatformDirectory(
            Platform.android,
            project: project,
          );
          createFeatureFiles(
            name: 'app',
            language: 'de',
            platformDirectory: platformDirectory,
          );
          createFeatureFiles(
            name: 'my_feature_a',
            language: 'de',
            platformDirectory: platformDirectory,
          );
          createFeatureFiles(
            name: 'my_feature_b',
            language: 'de',
            platformDirectory: platformDirectory,
          );

          // Act + Assert
          expect(platformDirectory.allFeaturesHaveSameDefaultLanguage(), true);
        }),
      );

      test(
        'returns false when NOT all custom feature packages have same default language',
        withTempDir(() {
          // Arrange
          final project = getProject();
          final platformDirectory = _getPlatformDirectory(
            Platform.android,
            project: project,
          );
          createFeatureFiles(
            name: 'app',
            language: 'de',
            platformDirectory: platformDirectory,
          );
          createFeatureFiles(
            name: 'my_feature_a',
            language: 'de',
            platformDirectory: platformDirectory,
          );
          createFeatureFiles(
            name: 'my_feature_b',
            language: 'fr',
            platformDirectory: platformDirectory,
          );

          // Act + Assert
          expect(platformDirectory.allFeaturesHaveSameDefaultLanguage(), false);
        }),
      );

      test(
        'returns false when the app feature package does NOT have same default language',
        withTempDir(() {
          // Arrange
          final project = getProject();
          final platformDirectory = _getPlatformDirectory(
            Platform.android,
            project: project,
          );
          createFeatureFiles(
            name: 'app',
            language: 'fr',
            platformDirectory: platformDirectory,
          );
          createFeatureFiles(
            name: 'my_feature_a',
            language: 'de',
            platformDirectory: platformDirectory,
          );
          createFeatureFiles(
            name: 'my_feature_b',
            language: 'fr',
            platformDirectory: platformDirectory,
          );

          // Act + Assert
          expect(platformDirectory.allFeaturesHaveSameDefaultLanguage(), false);
        }),
      );
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
      test(
        'returns empty list when platform directory has no sub directories',
        withTempDir(() {
          // Arrange
          final project = getProject();
          final platformDirectory = _getPlatformDirectory(
            Platform.android,
            project: project,
          );
          Directory(platformDirectory.path).createSync(recursive: true);

          // Act + Assert
          expect(platformDirectory.customFeaturePackages(), isEmpty);
        }),
      );

      test(
        'returns list with custom feature packages when platform directory has sub directories',
        withTempDir(() {
          // Arrange
          final project = getProject();
          when(() => project.name()).thenReturn('my_project');
          final platformDirectory = _getPlatformDirectory(
            Platform.android,
            project: project,
          );
          const customFeaturePackageNames = ['my_feat_a', 'my_feat_b'];
          for (final featureName in customFeaturePackageNames) {
            Directory(
              p.join(
                platformDirectory.path,
                'my_project_android_$featureName',
              ),
            ).createSync(recursive: true);
          }

          // Act
          final customFeaturePackages =
              platformDirectory.customFeaturePackages();

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
        }),
      );

      test(
        'ignores app and routing feature packages',
        withTempDir(() {
          // Arrange
          final project = getProject();

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
          final customFeaturePackages =
              platformDirectory.customFeaturePackages();

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
        }),
      );
    });
  });
}
