import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/mason.dart';
import 'package:rapid_cli/src/project/bundles/bundles.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../mock_env.dart';
import '../../mocks.dart';

InfrastructurePackage _getInfrastructurePackage({
  String? projectName,
  String? path,
  String? name,
}) {
  return InfrastructurePackage(
    projectName: projectName ?? 'projectName',
    path: path ?? 'path',
    name: name,
    dataTransferObject: ({required String entityName}) =>
        MockDataTransferObject(),
    serviceImplementation: ({
      required String name,
      required String serviceInterfaceName,
    }) =>
        MockServiceImplementation(),
  );
}

void main() {
  setUpAll(registerFallbackValues);

  group('InfrastructurePackage', () {
    test('.resolve', () {
      final infrastructurePackage = InfrastructurePackage.resolve(
        projectName: 'test_project',
        projectPath: '/path/to/project',
        name: 'cool',
      );

      expect(infrastructurePackage.projectName, 'test_project');
      expect(
        infrastructurePackage.path,
        '/path/to/project/packages/test_project/test_project_infrastructure/test_project_infrastructure_cool',
      );
      final dataTransferObject =
          infrastructurePackage.dataTransferObject(entityName: 'User');
      expect(dataTransferObject.projectName, 'test_project');
      expect(
        dataTransferObject.path,
        '/path/to/project/packages/test_project/test_project_infrastructure/test_project_infrastructure_cool',
      );
      expect(dataTransferObject.entityName, 'User');
      expect(dataTransferObject.subInfrastructureName, 'cool');
      final serviceImplementation = infrastructurePackage.serviceImplementation(
        name: 'Fake',
        serviceInterfaceName: 'AuthService',
      );
      expect(serviceImplementation.projectName, 'test_project');
      expect(
        serviceImplementation.path,
        '/path/to/project/packages/test_project/test_project_infrastructure/test_project_infrastructure_cool',
      );
      expect(serviceImplementation.name, 'Fake');
      expect(serviceImplementation.serviceInterfaceName, 'AuthService');
      expect(serviceImplementation.subInfrastructureName, 'cool');
    });

    test('.resolve (default)', () {
      final infrastructurePackage = InfrastructurePackage.resolve(
        projectName: 'test_project',
        projectPath: '/path/to/project',
        name: null,
      );

      expect(infrastructurePackage.projectName, 'test_project');
      expect(
        infrastructurePackage.path,
        '/path/to/project/packages/test_project/test_project_infrastructure/test_project_infrastructure',
      );
      final dataTransferObject =
          infrastructurePackage.dataTransferObject(entityName: 'User');
      expect(dataTransferObject.projectName, 'test_project');
      expect(
        dataTransferObject.path,
        '/path/to/project/packages/test_project/test_project_infrastructure/test_project_infrastructure',
      );
      expect(dataTransferObject.entityName, 'User');
      expect(dataTransferObject.subInfrastructureName, null);
      final serviceImplementation = infrastructurePackage.serviceImplementation(
        name: 'Fake',
        serviceInterfaceName: 'AuthService',
      );
      expect(serviceImplementation.projectName, 'test_project');
      expect(
        serviceImplementation.path,
        '/path/to/project/packages/test_project/test_project_infrastructure/test_project_infrastructure',
      );
      expect(serviceImplementation.name, 'Fake');
      expect(serviceImplementation.serviceInterfaceName, 'AuthService');
      expect(serviceImplementation.subInfrastructureName, null);
    });

    test('barrelFile', () {
      final infrastructurePackage = _getInfrastructurePackage(
        projectName: 'test_project',
        path: '/path/to/infrastructure_package',
        name: 'cool',
      );

      expect(
        infrastructurePackage.barrelFile.path,
        '/path/to/infrastructure_package/lib/test_project_infrastructure_cool.dart',
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
          final infrastructurePackage = _getInfrastructurePackage(
            projectName: 'test_project',
            path: '/path/to/infrastructure_package',
            name: 'cool',
          );

          await infrastructurePackage.generate();

          verifyInOrder([
            () => generatorBuilder(infrastructurePackageBundle),
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
                    'name': 'cool',
                    'has_name': true,
                  },
                ),
          ]);
        },
      ),
    );

    test('compareTo', () {
      final infrastructurePackage1 = _getInfrastructurePackage();
      final infrastructurePackage2 = _getInfrastructurePackage(name: 'cool');
      final infrastructurePackage3 = _getInfrastructurePackage(name: 'swag');

      final result1 = infrastructurePackage1.compareTo(infrastructurePackage2);
      final result2 = infrastructurePackage2.compareTo(infrastructurePackage1);
      final result3 = infrastructurePackage2.compareTo(infrastructurePackage3);
      final result4 = infrastructurePackage3.compareTo(infrastructurePackage2);

      expect(result1, -1);
      expect(result2, 1);
      expect(result3, -1);
      expect(result4, 1);
    });

    test('isDefault', () {
      final infrastructurePackage1 = _getInfrastructurePackage();
      final infrastructurePackage2 = _getInfrastructurePackage(name: 'cool');

      final result1 = infrastructurePackage1.isDefault;
      final result2 = infrastructurePackage2.isDefault;

      expect(result1, true);
      expect(result2, false);
    });
  });
}
