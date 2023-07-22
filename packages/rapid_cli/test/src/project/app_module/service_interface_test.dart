import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/mason.dart';
import 'package:rapid_cli/src/project/bundles/bundles.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../matchers.dart';
import '../../mock_fs.dart';
import '../../mocks.dart';

ServiceInterface _getServiceInterface({
  String? projectName,
  String? path,
  String? name,
}) {
  return ServiceInterface(
    projectName: projectName ?? 'projectName',
    path: path ?? 'path',
    name: name ?? 'Name',
  );
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('ServiceInterface', () {
    test('file', () {
      final serviceInterface = _getServiceInterface(
        projectName: 'test_project',
        path: '/path/to/domain_package',
        name: 'Auth',
      );

      expect(
        serviceInterface.file.path,
        '/path/to/domain_package/lib/src/i_auth_service.dart',
      );
    });

    test('freezedFile', () {
      final serviceInterface = _getServiceInterface(
        projectName: 'test_project',
        path: '/path/to/domain_package',
        name: 'Auth',
      );

      expect(
        serviceInterface.freezedFile.path,
        '/path/to/domain_package/lib/src/i_auth_service.freezed.dart',
      );
    });

    test('entities', () {
      final serviceInterface = _getServiceInterface(
        projectName: 'test_project',
        path: '/path/to/domain_package',
        name: 'Auth',
      );

      expect(
        serviceInterface.entities,
        entityEquals([
          serviceInterface.file,
          serviceInterface.freezedFile,
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
        final serviceInterface = _getServiceInterface(
          projectName: 'test_project',
          path: '/path/to/domain_package',
          name: 'Auth',
        );

        await serviceInterface.generate();

        verifyInOrder([
          () => generatorBuilder(serviceInterfaceBundle),
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
                  'name': 'Auth',
                  'output_dir': '.',
                },
              ),
        ]);
      }),
    );
  });
}
