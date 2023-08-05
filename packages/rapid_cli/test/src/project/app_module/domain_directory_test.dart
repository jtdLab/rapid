import 'package:rapid_cli/src/io/io.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../mock_env.dart';
import '../../mocks.dart';

DomainDirectory _getDomainDirectory({
  String? projectName,
  String? path,
  DomainPackage Function({String? name})? domainPackage,
}) {
  return DomainDirectory(
    projectName: projectName ?? 'projectName',
    path: path ?? 'path',
    domainPackage: domainPackage ?? (({String? name}) => MockDomainPackage()),
  );
}

void main() {
  group('DomainDirectory', () {
    test('.resolve', () {
      final domainDirectory = DomainDirectory.resolve(
        projectName: 'test_project',
        projectPath: '/path/to/project',
      );

      expect(
        domainDirectory.path,
        '/path/to/project/packages/test_project/test_project_domain',
      );
      final domainPackage = domainDirectory.domainPackage(name: 'cool');
      expect(domainPackage.name, 'cool');
      expect(domainPackage.projectName, 'test_project');
      expect(
        domainPackage.path,
        '/path/to/project/packages/test_project/test_project_domain/test_project_domain_cool',
      );
    });

    group('domainPackages', () {
      test('parse and returns the existing domain packages', withMockFs(() {
        Directory('path/to/domain_directory/test_project_domain')
            .createSync(recursive: true);
        Directory('path/to/domain_directory/test_project_domain_cool')
            .createSync(recursive: true);
        Directory('path/to/domain_directory/test_project_domain_swag')
            .createSync(recursive: true);
        DomainPackage domainPackage({String? name}) => DomainPackage.resolve(
            projectName: 'xxx', projectPath: 'xxx', name: name);
        final defaultDomainPackage = domainPackage();
        final coolDomainPackage = domainPackage(name: 'cool');
        final swagDomainPackage = domainPackage(name: 'swag');
        final domainDirectory = _getDomainDirectory(
          projectName: 'test_project',
          path: 'path/to/domain_directory',
          domainPackage: ({name}) => switch (name) {
            null => defaultDomainPackage,
            'cool' => coolDomainPackage,
            _ => swagDomainPackage,
          },
        );

        final domainPackages = domainDirectory.domainPackages();

        expect(domainPackages.length, 3);
        expect(domainPackages[0], defaultDomainPackage);
        expect(domainPackages[1], coolDomainPackage);
        expect(domainPackages[2], swagDomainPackage);
      }));

      test('returns empty list if domain directory does not exist', () {
        final domainDirectory = _getDomainDirectory(
          path: 'path/to/domain_directory',
        );

        final domainPackages = domainDirectory.domainPackages();

        expect(domainPackages, isEmpty);
      });
    });
  });
}
