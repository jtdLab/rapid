import 'package:rapid_cli/src/project/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

void main() {
  group('UiModule', () {
    test('.resolve', () {
      final uiModule = UiModule.resolve(
        projectName: 'test_project',
        projectPath: '/path/to/project',
      );

      expect(uiModule.path, '/path/to/project/packages/test_project_ui');
      final uiPackage = uiModule.uiPackage;
      expect(uiPackage.projectName, 'test_project');
      expect(
        uiPackage.path,
        '/path/to/project/packages/test_project_ui/test_project_ui',
      );
      final platformUiPackage =
          uiModule.platformUiPackage(platform: Platform.macos);
      expect(platformUiPackage.projectName, 'test_project');
      expect(
        platformUiPackage.path,
        '/path/to/project/packages/test_project_ui/test_project_ui_macos',
      );
      expect(platformUiPackage.platform, Platform.macos);
    });
  });
}
