import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/mason.dart';
import 'package:rapid_cli/src/project/bundles/bundles.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../mock_env.dart';
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
  setUpAll(registerFallbackValues);

  group('UiPackage', () {
    test('.resolve', () {
      final uiPackage = UiPackage.resolve(
        projectName: 'test_project',
        projectPath: '/path/to/project',
      );

      expect(uiPackage.projectName, 'test_project');
      expect(
        uiPackage.path,
        '/path/to/project/packages/test_project_ui/test_project_ui',
      );
      final widget = uiPackage.widget(name: 'CoolButton');
      expect(widget.projectName, 'test_project');
      expect(widget.name, 'CoolButton');
      expect(
        widget.path,
        '/path/to/project/packages/test_project_ui/test_project_ui',
      );
      final themedWidget = uiPackage.themedWidget(name: 'CoolButton');
      expect(themedWidget.projectName, 'test_project');
      expect(themedWidget.name, 'CoolButton');
      expect(
        themedWidget.path,
        '/path/to/project/packages/test_project_ui/test_project_ui',
      );
    });

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
          generatorOverrides = generatorBuilder.call;
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
