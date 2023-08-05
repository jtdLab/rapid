import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/mason.dart';
import 'package:rapid_cli/src/project/bundles/bundles.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../mock_fs.dart';
import '../../mocks.dart';

PlatformUiPackage _getPlatformUiPackage({
  String? projectName,
  Platform? platform,
  String? path,
}) {
  return PlatformUiPackage(
    projectName: projectName ?? 'projectName',
    platform: platform ?? Platform.android,
    path: path ?? 'path',
    widget: ({required String name}) => MockWidget(),
    themedWidget: ({required String name}) => MockThemedWidget(),
  );
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('PlatformUiPackage', () {
    test('.resolve', () {
      final platformUiPackage = PlatformUiPackage.resolve(
        projectName: 'test_project',
        projectPath: '/path/to/project',
        platform: Platform.linux,
      );

      expect(platformUiPackage.projectName, 'test_project');
      expect(
        platformUiPackage.path,
        '/path/to/project/packages/test_project_ui/test_project_ui_linux',
      );
      expect(platformUiPackage.platform, Platform.linux);
      final widget = platformUiPackage.widget(name: 'CoolButton');
      expect(widget.projectName, 'test_project');
      expect(widget.name, 'CoolButton');
      expect(
        widget.path,
        '/path/to/project/packages/test_project_ui/test_project_ui_linux',
      );
      expect(widget.platform, Platform.linux);
      final themedWidget = platformUiPackage.themedWidget(name: 'CoolButton');
      expect(themedWidget.projectName, 'test_project');
      expect(themedWidget.name, 'CoolButton');
      expect(
        themedWidget.path,
        '/path/to/project/packages/test_project_ui/test_project_ui_linux',
      );
      expect(themedWidget.platform, Platform.linux);
    });

    test('barrelFile', () {
      final uiPackage = _getPlatformUiPackage(
        projectName: 'test_project',
        path: '/path/to/ui_package',
        platform: Platform.macos,
      );

      expect(
        uiPackage.barrelFile.path,
        '/path/to/ui_package/lib/test_project_ui_macos.dart',
      );
    });

    test(
      'generate',
      withMockFs(() async {
        final generator = MockMasonGenerator();
        final generatorBuilder = MockMasonGeneratorBuilder(
          generator: generator,
        );
        generatorOverrides = generatorBuilder;
        final platformUiPackage = _getPlatformUiPackage(
          projectName: 'test_project',
          path: '/path/to/platform_ui_package',
          platform: Platform.ios,
        );

        await platformUiPackage.generate();

        verifyInOrder([
          () => generatorBuilder(platformUiPackageBundle),
          () => generator.generate(
                any(
                  that: isA<DirectoryGeneratorTarget>().having(
                    (e) => e.dir.path,
                    'path',
                    '/path/to/platform_ui_package',
                  ),
                ),
                vars: <String, dynamic>{
                  'project_name': 'test_project',
                  'platform': 'ios',
                  'android': false,
                  'ios': true,
                  'linux': false,
                  'macos': false,
                  'web': false,
                  'windows': false,
                  'mobile': false,
                },
              ),
        ]);
      }),
    );
  });
}
