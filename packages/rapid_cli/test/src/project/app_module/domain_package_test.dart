import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/mason.dart';
import 'package:rapid_cli/src/project/bundles/bundles.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../mock_fs.dart';
import '../../mocks.dart';

DomainPackage _getDomainPackage({
  String? projectName,
  String? path,
  String? name,
}) {
  return DomainPackage(
    projectName: projectName ?? 'projectName',
    path: path ?? 'path',
    name: name,
    entity: ({required String name}) => MockEntity(),
    serviceInterface: ({required String name}) => MockServiceInterface(),
    valueObject: ({required String name}) => MockValueObject(),
  );
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('DomainPackage', () {
    test('.resolve', () {
      final domainPackage = DomainPackage.resolve(
        projectName: 'test_project',
        projectPath: '/path/to/project',
        name: 'cool',
      );

      expect(domainPackage.projectName, 'test_project');
      expect(
        domainPackage.path,
        '/path/to/project/packages/test_project/test_project_domain/test_project_domain_cool',
      );
      final entity = domainPackage.entity(name: 'User');
      expect(entity.projectName, 'test_project');
      expect(
        entity.path,
        '/path/to/project/packages/test_project/test_project_domain/test_project_domain_cool',
      );
      expect(entity.name, 'User');
      expect(entity.subDomainName, 'cool');
      final serviceInterface =
          domainPackage.serviceInterface(name: 'AuthService');
      expect(serviceInterface.projectName, 'test_project');
      expect(
        serviceInterface.path,
        '/path/to/project/packages/test_project/test_project_domain/test_project_domain_cool',
      );
      expect(serviceInterface.name, 'AuthService');
      final valueObject = domainPackage.valueObject(name: 'EmailAddress');
      expect(valueObject.projectName, 'test_project');
      expect(
        valueObject.path,
        '/path/to/project/packages/test_project/test_project_domain/test_project_domain_cool',
      );
      expect(valueObject.name, 'EmailAddress');
      expect(valueObject.subDomainName, 'cool');
    });

    test('barrelFile', () {
      final domainPackage = _getDomainPackage(
        projectName: 'test_project',
        path: '/path/to/domain_package',
        name: 'cool',
      );

      expect(
        domainPackage.barrelFile.path,
        '/path/to/domain_package/lib/test_project_domain_cool.dart',
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
          final domainPackage = _getDomainPackage(
            projectName: 'test_project',
            path: '/path/to/domain_package',
            name: 'cool',
          );

          await domainPackage.generate();

          verifyInOrder([
            () => generatorBuilder(domainPackageBundle),
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
                    'name': 'cool',
                  },
                ),
          ]);
        },
      ),
    );

    test('compareTo', () {
      final domainPackage1 = _getDomainPackage(name: null);
      final domainPackage2 = _getDomainPackage(name: 'cool');
      final domainPackage3 = _getDomainPackage(name: 'swag');

      final result1 = domainPackage1.compareTo(domainPackage2);
      final result2 = domainPackage2.compareTo(domainPackage1);
      final result3 = domainPackage2.compareTo(domainPackage3);
      final result4 = domainPackage3.compareTo(domainPackage2);

      expect(result1, -1);
      expect(result2, 1);
      expect(result3, -1);
      expect(result4, 1);
    });
  });
}
