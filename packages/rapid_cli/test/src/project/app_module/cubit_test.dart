import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/mason.dart';
import 'package:rapid_cli/src/project/bundles/bundles.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../matchers.dart';
import '../../mock_env.dart';
import '../../mocks.dart';

Cubit _getCubit({
  String? projectName,
  Platform? platform,
  String? name,
  String? path,
  String? featureName,
}) {
  return Cubit(
    projectName: projectName ?? 'projectName',
    platform: platform ?? Platform.android,
    name: name ?? 'Name',
    path: path ?? 'path',
    featureName: featureName ?? 'feature_name',
  );
}

void main() {
  setUpAll(registerFallbackValues);

  group('Cubit', () {
    test('file', () {
      final cubit = _getCubit(
        projectName: 'test_project',
        platform: Platform.android,
        name: 'Counter',
        path: '/path/to/platform_feature_package',
        featureName: 'my_feature',
      );

      expect(
        cubit.file.path,
        '/path/to/platform_feature_package/lib/src/application/counter_cubit.dart',
      );
    });

    test('freezedFile', () {
      final cubit = _getCubit(
        projectName: 'test_project',
        platform: Platform.android,
        name: 'Counter',
        path: '/path/to/platform_feature_package',
        featureName: 'my_feature',
      );

      expect(
        cubit.freezedFile.path,
        '/path/to/platform_feature_package/lib/src/application/counter_cubit.freezed.dart',
      );
    });

    test('stateFile', () {
      final cubit = _getCubit(
        projectName: 'test_project',
        platform: Platform.android,
        name: 'Counter',
        path: '/path/to/platform_feature_package',
        featureName: 'my_feature',
      );

      expect(
        cubit.stateFile.path,
        '/path/to/platform_feature_package/lib/src/application/counter_state.dart',
      );
    });

    test('testFile', () {
      final cubit = _getCubit(
        projectName: 'test_project',
        platform: Platform.android,
        name: 'Counter',
        path: '/path/to/platform_feature_package',
        featureName: 'my_feature',
      );

      expect(
        cubit.testFile.path,
        '/path/to/platform_feature_package/test/src/application/counter_cubit_test.dart',
      );
    });

    test('entities', () {
      final cubit = _getCubit(
        projectName: 'test_project',
        platform: Platform.android,
        name: 'Counter',
        path: '/path/to/platform_feature_package',
        featureName: 'my_feature',
      );

      expect(
        cubit.entities,
        entityEquals([
          cubit.file,
          cubit.freezedFile,
          cubit.stateFile,
          cubit.testFile,
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
        generatorOverrides = generatorBuilder.call;
        final cubit = _getCubit(
          projectName: 'test_project',
          platform: Platform.android,
          name: 'Counter',
          path: '/path/to/platform_feature_package',
          featureName: 'my_feature',
        );

        await cubit.generate();

        verifyInOrder([
          () => generatorBuilder(cubitBundle),
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
                  'name': 'Counter',
                  'platform': 'android',
                  'feature_name': 'my_feature',
                  'output_dir': '.',
                },
              ),
        ]);
      }),
    );
  });
}
