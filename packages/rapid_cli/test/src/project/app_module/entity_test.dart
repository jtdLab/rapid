import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/mason.dart';
import 'package:rapid_cli/src/project/bundles/bundles.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../matchers.dart';
import '../../mock_env.dart';
import '../../mocks.dart';

Entity _getEntity({
  String? projectName,
  String? path,
  String? name,
  String? subDomainName,
}) {
  return Entity(
    projectName: projectName ?? 'projectName',
    path: path ?? 'path',
    name: name ?? 'Name',
    subDomainName: subDomainName,
  );
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('Entity', () {
    test('file', () {
      final entity = _getEntity(
        projectName: 'test_project',
        path: '/path/to/domain_package',
        name: 'User',
      );

      expect(
        entity.file.path,
        '/path/to/domain_package/lib/src/user.dart',
      );
    });

    test('freezedFile', () {
      final entity = _getEntity(
        projectName: 'test_project',
        path: '/path/to/domain_package',
        name: 'User',
      );

      expect(
        entity.freezedFile.path,
        '/path/to/domain_package/lib/src/user.freezed.dart',
      );
    });

    test('testFile', () {
      final entity = _getEntity(
        projectName: 'test_project',
        path: '/path/to/domain_package',
        name: 'User',
      );

      expect(
        entity.testFile.path,
        '/path/to/domain_package/test/src/user_test.dart',
      );
    });

    test('entities', () {
      final entity = _getEntity(
        projectName: 'test_project',
        path: '/path/to/domain_package',
        name: 'User',
      );

      expect(
        entity.entities,
        entityEquals([
          entity.file,
          entity.freezedFile,
          entity.testFile,
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
        final entity = _getEntity(
          projectName: 'test_project',
          path: '/path/to/domain_package',
          name: 'User',
          subDomainName: 'sub_domain',
        );

        await entity.generate();

        verifyInOrder([
          () => generatorBuilder(entityBundle),
          () => generator.generate(
                any(
                  that: isA<DirectoryGeneratorTarget>().having(
                    (e) => e.dir.path,
                    'path',
                    '/path/to/domain_package',
                  ),
                ),
                vars: <String, dynamic>{
                  'project_name': 'test_project',
                  'name': 'User',
                  'output_dir': '.',
                  'output_dir_is_cwd': true,
                  'sub_domain_name': 'sub_domain',
                  'has_sub_domain_name': true,
                },
              ),
        ]);
      }),
    );
  });
}
