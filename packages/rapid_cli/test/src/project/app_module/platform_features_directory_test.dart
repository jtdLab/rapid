import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/io/io.dart' hide Platform;
import 'package:rapid_cli/src/mason.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../mock_env.dart';
import '../../mocks.dart';

PlatformFeaturesDirectory _getPlatformFeaturesDirectory({
  String? projectName,
  Platform? platform,
  String? path,
  PlatformAppFeaturePackage? appFeaturePackage,
  T Function<T extends PlatformFeaturePackage>({required String name})?
      featurePackage,
}) {
  T featurePackageDefault<T extends PlatformFeaturePackage>({
    required String name,
  }) {
    throw UnimplementedError();
  }

  return PlatformFeaturesDirectory(
    projectName: projectName ?? 'projectName',
    platform: platform ?? Platform.web,
    path: path ?? 'path',
    appFeaturePackage: appFeaturePackage ?? MockPlatformAppFeaturePackage(),
    featurePackage: featurePackage ?? featurePackageDefault,
  );
}

void main() {
  setUpAll(registerFallbackValues);

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
      final pageFeaturePackage =
          platformFeaturesDirectory.featurePackage<PlatformPageFeaturePackage>(
        name: 'home_page',
      );
      expect(pageFeaturePackage.projectName, 'test_project');
      expect(pageFeaturePackage.platform, Platform.web);
      expect(
        pageFeaturePackage.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_home_page',
      );
      expect(pageFeaturePackage.name, 'home_page');
      final flowFeaturePackage =
          platformFeaturesDirectory.featurePackage<PlatformFlowFeaturePackage>(
        name: 'home_flow',
      );
      expect(flowFeaturePackage.projectName, 'test_project');
      expect(flowFeaturePackage.platform, Platform.web);
      expect(
        flowFeaturePackage.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_home_flow',
      );
      expect(flowFeaturePackage.name, 'home_flow');
      final tabFlowFeaturePackage = platformFeaturesDirectory
          .featurePackage<PlatformTabFlowFeaturePackage>(
        name: 'home_tab_flow',
      );
      expect(tabFlowFeaturePackage.projectName, 'test_project');
      expect(tabFlowFeaturePackage.platform, Platform.web);
      expect(
        tabFlowFeaturePackage.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_home_tab_flow',
      );
      expect(tabFlowFeaturePackage.name, 'home_tab_flow');
      final widgetFeaturePackage = platformFeaturesDirectory
          .featurePackage<PlatformWidgetFeaturePackage>(
        name: 'home_widget',
      );
      expect(widgetFeaturePackage.projectName, 'test_project');
      expect(widgetFeaturePackage.platform, Platform.web);
      expect(
        widgetFeaturePackage.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_home_widget',
      );
      expect(widgetFeaturePackage.name, 'home_widget');
      expect(
        () => platformFeaturesDirectory.featurePackage(name: 'other'),
        throwsA(
          isA<FeaturePackageParseError>().having(
            (e) => e.toString(),
            'toString',
            'Could not resolve feature package test_project_other.',
          ),
        ),
      );
    });

    test(
      'generate',
      withMockFs(
        () async {
          final generator = MockMasonGenerator();
          final generatorBuilder = MockMasonGeneratorBuilder(
            generator: generator,
          );
          generatorOverrides = generatorBuilder.call;
          final appFeaturePackage = MockPlatformAppFeaturePackage();
          final homePageFeaturePackage = MockPlatformPageFeaturePackage();
          T featurePackageBuilder<T extends PlatformFeaturePackage>({
            required String name,
          }) {
            return switch (name) {
              'app' => appFeaturePackage,
              'home' => homePageFeaturePackage,
              _ => throw Error()
            } as T;
          }

          final platformFeaturesDirectory = _getPlatformFeaturesDirectory(
            projectName: 'test_project',
            platform: Platform.web,
            path: '/path/to/platform_features_directory',
            appFeaturePackage: appFeaturePackage,
            featurePackage: featurePackageBuilder,
          );

          await platformFeaturesDirectory.generate();

          verifyInOrder([
            appFeaturePackage.generate,
            homePageFeaturePackage.generate,
          ]);
        },
      ),
    );

    group('featurePackages', () {
      test(
        'parse and returns the existing platform feature packages',
        withMockFs(() {
          Directory(
            '/path/to/platform_features_directory/test_project_cool_page',
          ).createSync(recursive: true);
          Directory(
            '/path/to/platform_features_directory/test_project_swag_flow',
          ).createSync(recursive: true);
          Directory(
            '/path/to/platform_features_directory/test_project_fresh_tab_flow',
          ).createSync(recursive: true);
          Directory(
            '/path/to/platform_features_directory/test_project_sunny_widget',
          ).createSync(recursive: true);
          final coolPageFeaturePackage = PlatformPageFeaturePackage.resolve(
            projectName: 'xxx',
            projectPath: 'xxx',
            platform: Platform.android,
            name: 'test_project_cool_page',
          );
          final swagFlowFeaturePackage = PlatformFlowFeaturePackage.resolve(
            projectName: 'xxx',
            projectPath: 'xxx',
            platform: Platform.android,
            name: 'test_project_swag_flow',
          );
          final freshTabFlowFeaturePackage =
              PlatformTabFlowFeaturePackage.resolve(
            projectName: 'xxx',
            projectPath: 'xxx',
            platform: Platform.android,
            name: 'test_project_fresh_tab_flow',
          );
          final sunnyWidgetFeaturePackage =
              PlatformWidgetFeaturePackage.resolve(
            projectName: 'xxx',
            projectPath: 'xxx',
            platform: Platform.android,
            name: 'test_project_sunny_widget',
          );

          T featurePackageBuilder<T extends PlatformFeaturePackage>({
            required String name,
          }) =>
              switch (name) {
                'test_project_cool_page' => coolPageFeaturePackage,
                'test_project_swag_flow' => swagFlowFeaturePackage,
                'test_project_fresh_tab_flow' => freshTabFlowFeaturePackage,
                'test_project_sunny_widget' => sunnyWidgetFeaturePackage,
                _ => throw Error(),
              } as T;

          final platformFeaturesDirectory = _getPlatformFeaturesDirectory(
            projectName: 'test_project',
            platform: Platform.android,
            path: '/path/to/platform_features_directory',
            featurePackage: featurePackageBuilder,
          );

          final featurePackages = platformFeaturesDirectory.featurePackages();

          expect(featurePackages.length, 4);
          expect(featurePackages[0], coolPageFeaturePackage);
          expect(featurePackages[1], freshTabFlowFeaturePackage);
          expect(featurePackages[2], sunnyWidgetFeaturePackage);
          expect(featurePackages[3], swagFlowFeaturePackage);
        }),
      );

      test('returns empty list if platform features directory does not exist',
          () {
        final platformFeaturesDirectory = _getPlatformFeaturesDirectory(
          path: 'path/to/platform_features_directory',
        );

        final featurePackages = platformFeaturesDirectory.featurePackages();

        expect(featurePackages, isEmpty);
      });
    });
  });
}
