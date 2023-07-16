import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/mason.dart';
import 'package:rapid_cli/src/project/bundles/bundles.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../mock_fs.dart';
import '../mocks.dart';

RootPackage _getRootPackage({
  String? projectName,
  String? path,
}) {
  return RootPackage(
    projectName: projectName ?? 'projectName',
    path: path ?? 'path',
  );
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('RootPackage', () {
    test(
      'generate',
      withMockFs(() async {
        final generator = MockMasonGenerator();
        final generatorBuilder = MockMasonGeneratorBuilder(
          generator: generator,
        );
        generatorOverrides = generatorBuilder;

        final rootPackage = _getRootPackage(
          projectName: 'test_app',
          path: '/path/to/root_package',
        );

        await rootPackage.generate();

        verifyInOrder([
          () => generatorBuilder(rootPackageBundle),
          () => generator.generate(
                any(
                  that: isA<DirectoryGeneratorTarget>().having(
                    (e) => e.dir.path,
                    'path',
                    '/path/to/root_package',
                  ),
                ),
                vars: <String, dynamic>{
                  'project_name': 'test_app',
                },
              ),
        ]);
      }),
    );
  });
}
