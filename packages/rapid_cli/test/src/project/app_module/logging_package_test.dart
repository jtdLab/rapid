import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/mason.dart';
import 'package:rapid_cli/src/project/bundles/bundles.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../mock_fs.dart';
import '../../mocks.dart';

LoggingPackage _getLoggingPackage({
  String? projectName,
  String? path,
}) {
  return LoggingPackage(
    projectName: projectName ?? 'projectName',
    path: path ?? 'path',
  );
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('LoggingPackage', () {
    test('.resolve', () {
      final loggingPackage = LoggingPackage.resolve(
        projectName: 'test_project',
        projectPath: '/path/to/project',
      );

      expect(loggingPackage.projectName, 'test_project');
      expect(
        loggingPackage.path,
        '/path/to/project/packages/test_project/test_project_logging',
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
          final loggingPackage = _getLoggingPackage(
            projectName: 'test_project',
            path: '/path/to/logging_package',
          );

          await loggingPackage.generate();

          verifyInOrder([
            () => generatorBuilder(loggingPackageBundle),
            () => generator.generate(
                  any(
                    that: isA<DirectoryGeneratorTarget>().having(
                      (e) => e.dir.path,
                      'path',
                      '/path/to/logging_package',
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
