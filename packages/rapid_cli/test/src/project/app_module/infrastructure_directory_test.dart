import 'package:rapid_cli/src/io.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../mock_fs.dart';
import '../../mocks.dart';

InfrastructureDirectory _getInfrastructureDirectory({
  String? projectName,
  String? path,
  InfrastructurePackage Function({String? name})? infrastructurePackage,
}) {
  return InfrastructureDirectory(
    projectName: projectName ?? 'projectName',
    path: path ?? 'path',
    infrastructurePackage: infrastructurePackage ??
        (({String? name}) => MockInfrastructurePackage()),
  );
}

void main() {
  group('InfrastructureDirectory', () {
    test('.resolve', () {
      final infrastructureDirectory = InfrastructureDirectory.resolve(
        projectName: 'test_project',
        projectPath: '/path/to/project',
      );

      expect(
        infrastructureDirectory.path,
        '/path/to/project/packages/test_project/test_project_infrastructure',
      );
      final infrastructurePackage =
          infrastructureDirectory.infrastructurePackage(name: 'cool');
      expect(infrastructurePackage.projectName, 'test_project');
      expect(
        infrastructurePackage.path,
        '/path/to/project/packages/test_project/test_project_infrastructure/test_project_infrastructure_cool',
      );
    });

    group('infrastructurePackages', () {
      test(
        'parse and returns the existing infrastructure packages',
        withMockFs(() {
          Directory(
                  'path/to/infrastructure_directory/test_project_infrastructure')
              .createSync(recursive: true);
          Directory(
                  'path/to/infrastructure_directory/test_project_infrastructure_cool')
              .createSync(recursive: true);
          Directory(
                  'path/to/infrastructure_directory/test_project_infrastructure_swag')
              .createSync(recursive: true);
          InfrastructurePackage infrastructurePackage({String? name}) =>
              InfrastructurePackage.resolve(
                  projectName: 'xxx', projectPath: 'xxx', name: name);
          final defaultInfrastructurePackage = infrastructurePackage();
          final coolInfrastructurePackage = infrastructurePackage(name: 'cool');
          final swagInfrastructurePackage = infrastructurePackage(name: 'swag');
          final infrastructureDirectory = _getInfrastructureDirectory(
            projectName: 'test_project',
            path: 'path/to/infrastructure_directory',
            infrastructurePackage: ({name}) => switch (name) {
              null => defaultInfrastructurePackage,
              'cool' => coolInfrastructurePackage,
              _ => swagInfrastructurePackage,
            },
          );

          final infrastructurePackages =
              infrastructureDirectory.infrastructurePackages();

          expect(infrastructurePackages.length, 3);
          expect(infrastructurePackages[0], defaultInfrastructurePackage);
          expect(infrastructurePackages[1], coolInfrastructurePackage);
          expect(infrastructurePackages[2], swagInfrastructurePackage);
        }),
      );

      test('returns empty list if infrastructure directory does not exist', () {
        final infrastructureDirectory = _getInfrastructureDirectory(
          path: 'path/to/infrastructure_directory',
        );

        final infrastructurePackages =
            infrastructureDirectory.infrastructurePackages();

        expect(infrastructurePackages, isEmpty);
      });
    });
  });
}
