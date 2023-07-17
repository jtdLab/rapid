import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/mason.dart';
import 'package:rapid_cli/src/project/bundles/bundles.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../matchers.dart';
import '../../mock_fs.dart';
import '../../mocks.dart';

Bloc _getBloc({
  String? projectName,
  Platform? platform,
  String? name,
  String? path,
  String? featureName,
}) {
  return Bloc(
    projectName: projectName ?? 'projectName',
    platform: platform ?? Platform.android,
    name: name ?? 'Name',
    path: path ?? 'path',
    featureName: featureName ?? 'feature_name',
  );
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('Bloc', () {
    test('file', () {
      final bloc = _getBloc(
        platform: Platform.android,
        projectName: 'test_project',
        name: 'Counter',
        path: '/path/to/platform_feature_package',
        featureName: 'my_feature',
      );

      expect(
        bloc.file.path,
        '/path/to/platform_feature_package/lib/src/application/counter_bloc.dart',
      );
    });

    test('freezedFile', () {
      final bloc = _getBloc(
        platform: Platform.android,
        projectName: 'test_project',
        name: 'Counter',
        path: '/path/to/platform_feature_package',
        featureName: 'my_feature',
      );

      expect(
        bloc.freezedFile.path,
        '/path/to/platform_feature_package/lib/src/application/counter_bloc.freezed.dart',
      );
    });

    test('eventFile', () {
      final bloc = _getBloc(
        platform: Platform.android,
        projectName: 'test_project',
        name: 'Counter',
        path: '/path/to/platform_feature_package',
        featureName: 'my_feature',
      );

      expect(
        bloc.eventFile.path,
        '/path/to/platform_feature_package/lib/src/application/counter_event.dart',
      );
    });

    test('stateFile', () {
      final bloc = _getBloc(
        platform: Platform.android,
        projectName: 'test_project',
        name: 'Counter',
        path: '/path/to/platform_feature_package',
        featureName: 'my_feature',
      );

      expect(
        bloc.stateFile.path,
        '/path/to/platform_feature_package/lib/src/application/counter_state.dart',
      );
    });

    test('testFile', () {
      final bloc = _getBloc(
        platform: Platform.android,
        projectName: 'test_project',
        name: 'Counter',
        path: '/path/to/platform_feature_package',
        featureName: 'my_feature',
      );

      expect(
        bloc.testFile.path,
        '/path/to/platform_feature_package/test/src/application/counter_bloc_test.dart',
      );
    });

    test('entities', () {
      final bloc = _getBloc(
        platform: Platform.android,
        projectName: 'test_project',
        name: 'Counter',
        path: '/path/to/platform_feature_package',
        featureName: 'my_feature',
      );

      expect(
        bloc.entities,
        entityEquals([
          bloc.file,
          bloc.freezedFile,
          bloc.eventFile,
          bloc.stateFile,
          bloc.testFile,
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
        final bloc = _getBloc(
          platform: Platform.android,
          projectName: 'test_project',
          name: 'Counter',
          path: '/path/to/platform_feature_package',
          featureName: 'my_feature',
        );

        await bloc.generate();

        verifyInOrder([
          () => generatorBuilder(blocBundle),
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
