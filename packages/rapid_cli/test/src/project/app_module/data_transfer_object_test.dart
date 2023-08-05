import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/mason.dart';
import 'package:rapid_cli/src/project/bundles/bundles.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../matchers.dart';
import '../../mock_fs.dart';
import '../../mocks.dart';

DataTransferObject _getDataTransferObject({
  String? projectName,
  String? path,
  String? entityName,
  String? subInfrastructureName,
}) {
  return DataTransferObject(
    projectName: projectName ?? 'projectName',
    path: path ?? 'path',
    entityName: entityName ?? 'EntityName',
    subInfrastructureName: subInfrastructureName,
  );
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('DataTransferObject', () {
    test('file', () {
      final dto = _getDataTransferObject(
        projectName: 'test_project',
        path: '/path/to/infrastructure_package',
        entityName: 'User',
      );

      expect(
        dto.file.path,
        '/path/to/infrastructure_package/lib/src/user_dto.dart',
      );
    });

    test('freezedFile', () {
      final dto = _getDataTransferObject(
        projectName: 'test_project',
        path: '/path/to/infrastructure_package',
        entityName: 'User',
      );

      expect(
        dto.freezedFile.path,
        '/path/to/infrastructure_package/lib/src/user_dto.freezed.dart',
      );
    });

    test('gFile', () {
      final dto = _getDataTransferObject(
        projectName: 'test_project',
        path: '/path/to/infrastructure_package',
        entityName: 'User',
      );

      expect(
        dto.gFile.path,
        '/path/to/infrastructure_package/lib/src/user_dto.g.dart',
      );
    });

    test('testFile', () {
      final dto = _getDataTransferObject(
        projectName: 'test_project',
        path: '/path/to/infrastructure_package',
        entityName: 'User',
      );

      expect(
        dto.testFile.path,
        '/path/to/infrastructure_package/test/src/user_dto_test.dart',
      );
    });

    test('entities', () {
      final dto = _getDataTransferObject(
        projectName: 'test_project',
        path: '/path/to/infrastructure_package',
        entityName: 'User',
      );

      expect(
        dto.entities,
        entityEquals([
          dto.file,
          dto.freezedFile,
          dto.gFile,
          dto.testFile,
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
        final dto = _getDataTransferObject(
          projectName: 'test_project',
          path: '/path/to/infrastructure_package',
          entityName: 'User',
          subInfrastructureName: 'sub_infrastructure',
        );

        await dto.generate();

        verifyInOrder([
          () => generatorBuilder(dataTransferObjectBundle),
          () => generator.generate(
                any(
                  that: isA<DirectoryGeneratorTarget>().having(
                    (e) => e.dir.path,
                    'path',
                    '/path/to/infrastructure_package',
                  ),
                ),
                vars: <String, dynamic>{
                  'project_name': 'test_project',
                  'entity_name': 'User',
                  'output_dir': '.',
                  'output_dir_is_cwd': true,
                  'sub_infrastructure_name': 'sub_infrastructure',
                  'has_sub_infrastructure_name': true,
                },
              ),
        ]);
      }),
    );
  });
}
