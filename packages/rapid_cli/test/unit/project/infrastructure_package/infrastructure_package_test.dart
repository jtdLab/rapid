import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/project/infrastructure_package/infrastructure_package.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../common.dart';
import '../../mocks.dart';

InfrastructurePackage _getInfrastructurePackage({
  required Project project,
  GeneratorBuilder? generator,
}) {
  return InfrastructurePackage(
    project: project,
    generator: generator ?? (_) async => getMasonGenerator(),
  );
}

void main() {
  group('InfrastructurePackage', () {
    setUpAll(() {
      registerFallbackValue(FakeDirectoryGeneratorTarget());
    });

    test('.path', () {
      // Arrange
      final project = getProject();
      when(() => project.path).thenReturn('project/path');
      when(() => project.name()).thenReturn('my_project');
      final infrastructurePackage = _getInfrastructurePackage(project: project);

      // Act + Assert
      expect(
        infrastructurePackage.path,
        'project/path/packages/my_project/my_project_infrastructure',
      );
    });

    group('.create()', () {
      test(
        'completes successfully with correct output',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.path).thenReturn('project/path');
          when(() => project.name()).thenReturn('my_project');
          final generator = getMasonGenerator();
          final infrastructurePackage = _getInfrastructurePackage(
            project: project,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await infrastructurePackage.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'project/path/packages/my_project/my_project_infrastructure',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );
    });
  });

  group('DataTransferObject', () {
    // TODO
  });

  group('ServiceImplementation', () {
    // TODO
  });
}
