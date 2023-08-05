import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/mason.dart';
import 'package:rapid_cli/src/project/bundles/bundles.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../mock_env.dart';
import '../../mocks.dart';

PlatformNavigationPackage _getPlatformNavigationPackage({
  String? projectName,
  String? path,
  Platform? platform,
}) {
  return PlatformNavigationPackage(
    projectName: projectName ?? 'projectName',
    path: path ?? 'path',
    platform: platform ?? Platform.android,
    navigatorInterface: ({required String name}) => MockNavigatorInterface(),
  );
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('PlatformNavigationPackage', () {
    test('.resolve', () {
      final platformNavigationPackage = PlatformNavigationPackage.resolve(
        projectName: 'test_project',
        projectPath: '/path/to/project',
        platform: Platform.macos,
      );

      expect(platformNavigationPackage.projectName, 'test_project');
      expect(
        platformNavigationPackage.path,
        '/path/to/project/packages/test_project/test_project_macos/test_project_macos_navigation',
      );
      final navigatorInterface =
          platformNavigationPackage.navigatorInterface(name: 'HomePage');
      expect(navigatorInterface.name, 'HomePage');
      expect(
        navigatorInterface.path,
        '/path/to/project/packages/test_project/test_project_macos/test_project_macos_navigation',
      );
    });

    test('barrelFile', () {
      final platformNavigationPackage = _getPlatformNavigationPackage(
        projectName: 'test_project',
        path: '/path/to/platform_navigation_package',
        platform: Platform.windows,
      );

      expect(
        platformNavigationPackage.barrelFile.path,
        '/path/to/platform_navigation_package/lib/test_project_windows_navigation.dart',
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
          generatorOverrides = generatorBuilder;
          final platformNavigationPackage = _getPlatformNavigationPackage(
            projectName: 'test_project',
            path: '/path/to/platform_navigation_package',
            platform: Platform.linux,
          );

          await platformNavigationPackage.generate();

          verifyInOrder([
            () => generatorBuilder(platformNavigationPackageBundle),
            () => generator.generate(
                  any(
                    that: isA<DirectoryGeneratorTarget>().having(
                      (e) => e.dir.path,
                      'path',
                      '/path/to/platform_navigation_package',
                    ),
                  ),
                  vars: <String, dynamic>{
                    'project_name': 'test_project',
                    'platform': 'linux',
                    'android': false,
                    'ios': false,
                    'linux': true,
                    'macos': false,
                    'web': false,
                    'windows': false,
                    'mobile': false,
                  },
                ),
          ]);
        },
      ),
    );
  });
}
