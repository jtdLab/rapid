import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/mason.dart';
import 'package:rapid_cli/src/project/bundles/bundles.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../mock_fs.dart';
import '../../mocks.dart';

UiPackage _getUiPackage({
  String? projectName,
  String? path,
}) {
  return UiPackage(
    projectName: projectName ?? 'projectName',
    path: path ?? 'path',
    widget: ({required String name}) => MockWidget(),
    themedWidget: ({required String name}) => MockThemedWidget(),
  );
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('UiPackage', () {
    test('barrelFile', () {
      final uiPackage = _getUiPackage(
        projectName: 'test_project',
        path: '/path/to/ui_package',
      );

      expect(
        uiPackage.barrelFile.path,
        '/path/to/ui_package/lib/test_project_ui.dart',
      );
    });

    test('themeExtensionsFile', () {
      final uiPackage = _getUiPackage(path: '/path/to/ui_package');

      expect(
        uiPackage.themeExtensionsFile.path,
        '/path/to/ui_package/lib/src/theme_extensions.dart',
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
          final uiPackage = _getUiPackage(
            projectName: 'test_project',
            path: '/path/to/ui_package',
          );

          await uiPackage.generate();

          verifyInOrder([
            () => generatorBuilder(uiPackageBundle),
            () => generator.generate(
                  any(
                    that: isA<DirectoryGeneratorTarget>().having(
                      (e) => e.dir.path,
                      'path',
                      '/path/to/ui_package',
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
