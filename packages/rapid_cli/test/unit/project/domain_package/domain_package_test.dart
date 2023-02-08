import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/project/domain_package/domain_package.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../common.dart';
import '../../mocks.dart';

DomainPackage _getDomainPackage({
  required Project project,
  GeneratorBuilder? generator,
}) {
  return DomainPackage(
    project: project,
    generator: generator ?? (_) async => getMasonGenerator(),
  );
}

void main() {
  group('DomainPackage', () {
    setUpAll(() {
      registerFallbackValue(FakeDirectoryGeneratorTarget());
    });

    test('.path', () {
      // Arrange
      final project = getProject();
      when(() => project.path).thenReturn('project/path');
      when(() => project.name()).thenReturn('my_project');
      final domainPackage = _getDomainPackage(project: project);

      // Act + Assert
      expect(
        domainPackage.path,
        'project/path/packages/my_project/my_project_domain',
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
          final domainPackage = _getDomainPackage(
            project: project,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await domainPackage.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'project/path/packages/my_project/my_project_domain',
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

  group('Entity', () {
    // TODO
  });

  group('ServiceInterface', () {
    // TODO
  });

  group('ValueObject', () {
    // TODO
  });
}
