import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:rapid_cli/src/project/ui_package/ui_package.dart';
import 'package:test/test.dart';

import '../../common.dart';
import '../../mocks.dart';

UiPackage _getUiPackage({
  required Project project,
  GeneratorBuilder? generator,
}) {
  return UiPackage(
    project: project,
    generator: generator ?? (_) async => getMasonGenerator(),
  );
}

void main() {
  group('UiPackage', () {
    setUpAll(() {
      registerFallbackValue(FakeDirectoryGeneratorTarget());
    });

    test('.path', () {
      // Arrange
      final project = getProject();
      when(() => project.path).thenReturn('project/path');
      when(() => project.name()).thenReturn('my_project');
      final uiPackage = _getUiPackage(project: project);

      // Act + Assert
      expect(
        uiPackage.path,
        'project/path/packages/my_project_ui/my_project_ui',
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
          final uiPackage = _getUiPackage(
            project: project,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await uiPackage.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'project/path/packages/my_project_ui/my_project_ui',
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
}
