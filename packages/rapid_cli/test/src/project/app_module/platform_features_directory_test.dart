import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/mason.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../mock_fs.dart';
import '../../mocks.dart';

class MockPlatformFeaturePackage extends Mock
    implements PlatformFeaturePackage {}

PlatformFeaturesDirectory _getPlatformFeaturesDirectory({
  String? projectName,
  Platform? platform,
  String? path,
  PlatformAppFeaturePackage? appFeaturePackage,
  PlatformFeaturePackage Function({required String name})? featurePackage,
}) {
  return PlatformFeaturesDirectory(
    projectName: projectName ?? 'projectName',
    platform: platform ?? Platform.web,
    path: path ?? 'path',
    appFeaturePackage: appFeaturePackage ?? MockPlatformAppFeaturePackage(),
    featurePackage: featurePackage ??
        (({required String name}) => MockPlatformFeaturePackage()),
  );
}

void main() {
  group('PlatformFeaturesDirectory', () {
    test('.resolve', () {
      final platformFeaturesDirectory = PlatformFeaturesDirectory.resolve(
        projectName: 'test_project',
        projectPath: '/path/to/project',
        platform: Platform.web,
      );

      expect(platformFeaturesDirectory.projectName, 'test_project');
      expect(
        platformFeaturesDirectory.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features',
      );
      final appFeaturePackage = platformFeaturesDirectory.appFeaturePackage;
      expect(appFeaturePackage.projectName, 'test_project');
      expect(appFeaturePackage.platform, Platform.web);
      expect(
        appFeaturePackage.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_app',
      );
      final featurePackage =
          platformFeaturesDirectory.featurePackage<PlatformPageFeaturePackage>(
        name: 'home',
      );
      expect(featurePackage.projectName, 'test_project');
      expect(featurePackage.platform, Platform.web);
      expect(
        featurePackage.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_home_page',
      );
      expect(featurePackage.name, 'home_page');
    });

    test(
      'generate',
      withMockFs(
        () async {
          final appFeaturePackage = MockPlatformAppFeaturePackage();
          final homePageFeaturePackage = MockPlatformPageFeaturePackage();
          final generator = MockMasonGenerator();
          final generatorBuilder = MockMasonGeneratorBuilder(
            generator: generator,
          );
          generatorOverrides = generatorBuilder;
          final platformFeaturesDirectory = _getPlatformFeaturesDirectory(
            projectName: 'test_project',
            platform: Platform.web,
            path: '/path/to/platform_features_directory',
            appFeaturePackage: appFeaturePackage,
            featurePackage: ({required String name}) {
              if (name == 'home') return homePageFeaturePackage;
              throw FeaturePackageParseError._(name);
            },
          );

          await platformFeaturesDirectory.generate();

          verifyInOrder([
            () => appFeaturePackage.generate(),
            () => homePageFeaturePackage.generate(),
          ]);
        },
      ),
    );

    test('featurePackages', () {
      final platformFeaturesDirectory = _getPlatformFeaturesDirectory(
        projectName: 'test_project',
        platform: Platform.web,
        path: '/path/to/platform_features_directory',
        featurePackage: ({required String name}) {
          return MockPlatformFeaturePackage(name: name);
        },
      );

      final result = platformFeaturesDirectory.featurePackages();

      expect(result, isA<List<PlatformFeaturePackage>>());
      expect(result, isEmpty);
    });
  });
}
