import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/mason.dart';
import 'package:rapid_cli/src/project/bundles/bundles.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../matchers.dart';
import '../../mock_fs.dart';
import '../../mocks.dart';

ServiceImplementation _getServiceImplementation({
  String? projectName,
  String? path,
  String? name,
  String? serviceInterfaceName,
  String? subInfrastructureName,
}) {
  return ServiceImplementation(
    projectName: projectName ?? 'projectName',
    path: path ?? 'path',
    name: name ?? 'Name',
    serviceInterfaceName: serviceInterfaceName ?? 'ServiceInterfaceName',
    subInfrastructureName: subInfrastructureName,
  );
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('ServiceImplementation', () {
    test('file', () {
      final service = _getServiceImplementation(
        projectName: 'test_project',
        path: '/path/to/infrastructure_package',
        name: 'Fake',
        serviceInterfaceName: 'Auth',
      );

      expect(
        service.file.path,
        '/path/to/infrastructure_package/lib/src/fake_auth_service.dart',
      );
    });

    test('testFile', () {
      final service = _getServiceImplementation(
        projectName: 'test_project',
        path: '/path/to/infrastructure_package',
        name: 'Fake',
        serviceInterfaceName: 'Auth',
      );

      expect(
        service.testFile.path,
        '/path/to/infrastructure_package/test/src/fake_auth_service_test.dart',
      );
    });

    test('entities', () {
      final service = _getServiceImplementation(
        projectName: 'test_project',
        path: '/path/to/infrastructure_package',
        name: 'Fake',
        serviceInterfaceName: 'Auth',
      );

      expect(
        service.entities,
        entityEquals([
          service.file,
          service.testFile,
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
        final service = _getServiceImplementation(
          projectName: 'test_project',
          path: '/path/to/infrastructure_package',
          name: 'Fake',
          serviceInterfaceName: 'Auth',
          subInfrastructureName: 'sub_infrastrucuture',
        );

        await service.generate();

        verifyInOrder([
          () => generatorBuilder(serviceImplementationBundle),
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
                  'name': 'Fake',
                  'output_dir': '.',
                  'service_interface_name': 'Auth',
                  'sub_infrastructure_name': 'sub_infrastrucuture',
                },
              ),
        ]);
      }),
    );
  });
}
