import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/project/logging_package/logging_package.dart';
import 'package:rapid_cli/src/project/project/project.dart';
import 'package:test/test.dart';

import '../../../common.dart';
import '../../../mocks.dart';

LoggingPackage _getLoggingPackage({
  required RapidProject project,
  GeneratorBuilder? generator,
}) {
  return LoggingPackage(
    project: project,
  )..generatorOverrides = generator;
}

void main() {
  group('LoggingPackage', () {
    setUpAll(() {
      registerFallbackValue(FakeDirectoryGeneratorTarget());
    });

    test('.path', () {
      // Arrange
      final project = getProject();
      when(() => project.path).thenReturn('project/path');
      when(() => project.name).thenReturn('my_project');
      final loggingPackage = _getLoggingPackage(project: project);

      // Act + Assert
      expect(
        loggingPackage.path,
        'project/path/packages/my_project/my_project_logging',
      );
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
          final loggingPackage = _getLoggingPackage(
            project: project,
            generator: (_) async => generator,
          );

          // Act
          await loggingPackage.create();

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'project/path/packages/my_project/my_project_logging',
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
