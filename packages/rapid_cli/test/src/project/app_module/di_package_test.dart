import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/mason.dart';
import 'package:rapid_cli/src/project/bundles/bundles.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../mock_fs.dart';
import '../../mocks.dart';

DiPackage _getDiPackage({
  String? projectName,
  String? path,
}) {
  return DiPackage(
    projectName: projectName ?? 'projectName',
    path: path ?? 'path',
  );
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('DiPackage', () {
    test('.resolve', () {
      final diPackage = DiPackage.resolve(
        projectName: 'test_project',
        projectPath: '/path/to/project',
      );

      expect(diPackage.projectName, 'test_project');
      expect(
        diPackage.path,
        '/path/to/project/packages/test_project/test_project_di',
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
          final diPackage = _getDiPackage(
            projectName: 'test_project',
            path: '/path/to/di_package',
          );

          await diPackage.generate();

          verifyInOrder([
            () => generatorBuilder(diPackageBundle),
            () => generator.generate(
                  any(
                    that: isA<DirectoryGeneratorTarget>().having(
                      (e) => e.dir.path,
                      'path',
                      '/path/to/di_package',
                    ),
                  ),
                  vars: <String, dynamic>{
                    'project_name': 'test_project',
                  },
                ),
          ]);
        },
      ),
    );
  });
}
