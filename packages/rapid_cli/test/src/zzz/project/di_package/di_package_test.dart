import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/project/di_package/di_package.dart';
import 'package:rapid_cli/src/project/project/project.dart';
import 'package:test/test.dart';

import '../../../common.dart';
import '../../../mocks.dart';

DiPackage _getDiPackage({
  RapidProject? project,
  PubspecFile? pubspecFile,
  GeneratorBuilder? generator,
}) {
  return DiPackage(
    project: project ?? getProject(),
  )
    ..pubspecFileOverrides = pubspecFile
    ..generatorOverrides = generator;
}

void main() {
  group('DiPackage', () {
    setUpAll(() {
      registerFallbackValue(FakeDirectoryGeneratorTarget());
      registerFallbackValue(FakeLogger());
    });

    test('.path', () {
      // Arrange
      final project = getProject();
      when(() => project.path).thenReturn('project/path');
      when(() => project.name).thenReturn('my_project');
      final diPackage = _getDiPackage(project: project);

      // Act + Assert
      expect(diPackage.path, 'project/path/packages/my_project/my_project_di');
    });

    group('.create()', () {
      test(
        'completes successfully with correct output',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.path).thenReturn('project/path');
          when(() => project.name).thenReturn('my_project');
          final generator = getMasonGenerator();
          final diPackage = _getDiPackage(
            project: project,
            generator: (_) async => generator,
          );

          // Act
          await diPackage.create();

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'project/path/packages/my_project/my_project_di',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
              },
            ),
          ).called(1);
        }),
      );
    });
  });
}
