import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/mason.dart';
import 'package:rapid_cli/src/project/bundles/bundles.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../matchers.dart';
import '../../mock_fs.dart';
import '../../mocks.dart';

NavigatorImplementation _getNavigatorImplementation({
  String? projectName,
  Platform? platform,
  String? path,
  String? name,
}) {
  return NavigatorImplementation(
    projectName: projectName ?? 'projectName',
    platform: platform ?? Platform.android,
    path: path ?? 'path',
    name: name ?? 'Name',
  );
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('NavigatorImplementation', () {
    test('file', () {
      final navigator = _getNavigatorImplementation(
        projectName: 'test_project',
        platform: Platform.android,
        path: '/path/to/platform_feature_package',
        name: 'HomePage',
      );

      expect(
        navigator.file.path,
        '/path/to/platform_feature_package/lib/src/presentation/navigator.dart',
      );
    });

    test('testFile', () {
      final navigator = _getNavigatorImplementation(
        projectName: 'test_project',
        platform: Platform.android,
        path: '/path/to/platform_feature_package',
        name: 'HomePage',
      );

      expect(
        navigator.testFile.path,
        '/path/to/platform_feature_package/test/src/presentation/navigator_test.dart',
      );
    });

    test('entities', () {
      final navigator = _getNavigatorImplementation(
        projectName: 'test_project',
        platform: Platform.android,
        path: '/path/to/platform_feature_package',
        name: 'HomePage',
      );

      expect(
        navigator.entities,
        entityEquals([
          navigator.file,
          navigator.testFile,
        ]),
      );
    });

    test(
      'generate',
      withMockFs(() async {
        final generator = MockMasonGenerator();
        final generatorBuilder = MockMasonGeneratorBuilder(
          generator: generator,
        );
        generatorOverrides = generatorBuilder;
        final navigator = _getNavigatorImplementation(
          projectName: 'test_project',
          platform: Platform.android,
          path: '/path/to/platform_feature_package',
          name: 'HomePage',
        );

        await navigator.generate();

        verifyInOrder([
          () => generatorBuilder(navigatorImplementationBundle),
          () => generator.generate(
                any(
                  that: isA<DirectoryGeneratorTarget>().having(
                    (e) => e.dir.path,
                    'path',
                    '/path/to/platform_feature_package',
                  ),
                ),
                vars: <String, dynamic>{
                  'project_name': 'test_project',
                  'name': 'HomePage',
                  'platform': 'android',
                  'android': true,
                  'ios': false,
                  'linux': false,
                  'macos': false,
                  'web': false,
                  'windows': false,
                  'mobile': false,
                },
              ),
        ]);
      }),
    );
  });
}
