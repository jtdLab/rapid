import 'package:rapid_cli/src/project/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

void main() {
  group('AppModule', () {
    test('.resolve', () {
      final appModule = AppModule.resolve(
        projectName: 'test_project',
        projectPath: '/path/to/project',
      );

      expect(appModule.path, '/path/to/project/packages/test_project');
      final diPackage = appModule.diPackage;
      expect(diPackage.projectName, 'test_project');
      expect(
        diPackage.path,
        '/path/to/project/packages/test_project/test_project_di',
      );
      final domainDirectory = appModule.domainDirectory;
      expect(domainDirectory.projectName, 'test_project');
      expect(
        domainDirectory.path,
        '/path/to/project/packages/test_project/test_project_domain',
      );
      final infrastructureDirectory = appModule.infrastructureDirectory;
      expect(infrastructureDirectory.projectName, 'test_project');
      expect(
        infrastructureDirectory.path,
        '/path/to/project/packages/test_project/test_project_infrastructure',
      );
      final loggingPackage = appModule.loggingPackage;
      expect(loggingPackage.projectName, 'test_project');
      expect(
        loggingPackage.path,
        '/path/to/project/packages/test_project/test_project_logging',
      );
      final platformDirectory =
          appModule.platformDirectory(platform: Platform.web);
      expect(
        platformDirectory.path,
        '/path/to/project/packages/test_project/test_project_web',
      );
      expect(platformDirectory.platform, Platform.web);
    });
  });
}
