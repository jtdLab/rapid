import 'package:rapid_cli/src/project/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

void main() {
  group('PlatformDirectory', () {
    test('.resolve', () {
      final platformDirectory = PlatformDirectory.resolve(
        projectName: 'test_project',
        projectPath: '/path/to/project',
        platform: Platform.android,
      );

      expect(platformDirectory.platform, Platform.android);
      expect(
        platformDirectory.path,
        '/path/to/project/packages/test_project/test_project_android',
      );
      final rootPackage = platformDirectory.rootPackage;
      expect(rootPackage, isA<NoneIosRootPackage>());
      expect(rootPackage.projectName, 'test_project');
      expect(
        rootPackage.path,
        '/path/to/project/packages/test_project/test_project_android/test_project_android',
      );
      final localizationPackage = platformDirectory.localizationPackage;
      expect(localizationPackage.projectName, 'test_project');
      expect(
        localizationPackage.path,
        '/path/to/project/packages/test_project/test_project_android/test_project_android_localization',
      );
      expect(localizationPackage.platform, Platform.android);
      final navigationPackage = platformDirectory.navigationPackage;
      expect(navigationPackage.projectName, 'test_project');
      expect(
        navigationPackage.path,
        '/path/to/project/packages/test_project/test_project_android/test_project_android_navigation',
      );
      expect(navigationPackage.platform, Platform.android);
      final featuresDirectory = platformDirectory.featuresDirectory;
      expect(featuresDirectory.projectName, 'test_project');
      expect(
        featuresDirectory.path,
        '/path/to/project/packages/test_project/test_project_android/test_project_android_features',
      );
      expect(featuresDirectory.platform, Platform.android);
    });

    test('.resolve (ios)', () {
      final platformDirectory = PlatformDirectory.resolve(
        projectName: 'test_project',
        projectPath: '/path/to/project',
        platform: Platform.ios,
      );

      expect(platformDirectory.platform, Platform.ios);
      expect(
        platformDirectory.path,
        '/path/to/project/packages/test_project/test_project_ios',
      );
      final rootPackage = platformDirectory.rootPackage;
      expect(rootPackage, isA<IosRootPackage>());
      expect(rootPackage.projectName, 'test_project');
      expect(
        rootPackage.path,
        '/path/to/project/packages/test_project/test_project_ios/test_project_ios',
      );
      final localizationPackage = platformDirectory.localizationPackage;
      expect(localizationPackage.projectName, 'test_project');
      expect(
        localizationPackage.path,
        '/path/to/project/packages/test_project/test_project_ios/test_project_ios_localization',
      );
      expect(localizationPackage.platform, Platform.ios);
      final navigationPackage = platformDirectory.navigationPackage;
      expect(navigationPackage.projectName, 'test_project');
      expect(
        navigationPackage.path,
        '/path/to/project/packages/test_project/test_project_ios/test_project_ios_navigation',
      );
      expect(navigationPackage.platform, Platform.ios);
      final featuresDirectory = platformDirectory.featuresDirectory;
      expect(featuresDirectory.projectName, 'test_project');
      expect(
        featuresDirectory.path,
        '/path/to/project/packages/test_project/test_project_ios/test_project_ios_features',
      );
      expect(featuresDirectory.platform, Platform.ios);
    });

    test('.resolve (macos)', () {
      final platformDirectory = PlatformDirectory.resolve(
        projectName: 'test_project',
        projectPath: '/path/to/project',
        platform: Platform.macos,
      );

      expect(platformDirectory.platform, Platform.macos);
      expect(
        platformDirectory.path,
        '/path/to/project/packages/test_project/test_project_macos',
      );
      final rootPackage = platformDirectory.rootPackage;
      expect(rootPackage, isA<MacosRootPackage>());
      expect(rootPackage.projectName, 'test_project');
      expect(
        rootPackage.path,
        '/path/to/project/packages/test_project/test_project_macos/test_project_macos',
      );
      final localizationPackage = platformDirectory.localizationPackage;
      expect(localizationPackage.projectName, 'test_project');
      expect(
        localizationPackage.path,
        '/path/to/project/packages/test_project/test_project_macos/test_project_macos_localization',
      );
      expect(localizationPackage.platform, Platform.macos);
      final navigationPackage = platformDirectory.navigationPackage;
      expect(navigationPackage.projectName, 'test_project');
      expect(
        navigationPackage.path,
        '/path/to/project/packages/test_project/test_project_macos/test_project_macos_navigation',
      );
      expect(navigationPackage.platform, Platform.macos);
      final featuresDirectory = platformDirectory.featuresDirectory;
      expect(featuresDirectory.projectName, 'test_project');
      expect(
        featuresDirectory.path,
        '/path/to/project/packages/test_project/test_project_macos/test_project_macos_features',
      );
      expect(featuresDirectory.platform, Platform.macos);
    });

    test('.resolve (mobile)', () {
      final platformDirectory = PlatformDirectory.resolve(
        projectName: 'test_project',
        projectPath: '/path/to/project',
        platform: Platform.mobile,
      );

      expect(platformDirectory.platform, Platform.mobile);
      expect(
        platformDirectory.path,
        '/path/to/project/packages/test_project/test_project_mobile',
      );
      final rootPackage = platformDirectory.rootPackage;
      expect(rootPackage, isA<MobileRootPackage>());
      expect(rootPackage.projectName, 'test_project');
      expect(
        rootPackage.path,
        '/path/to/project/packages/test_project/test_project_mobile/test_project_mobile',
      );
      final localizationPackage = platformDirectory.localizationPackage;
      expect(localizationPackage.projectName, 'test_project');
      expect(
        localizationPackage.path,
        '/path/to/project/packages/test_project/test_project_mobile/test_project_mobile_localization',
      );
      expect(localizationPackage.platform, Platform.mobile);
      final navigationPackage = platformDirectory.navigationPackage;
      expect(navigationPackage.projectName, 'test_project');
      expect(
        navigationPackage.path,
        '/path/to/project/packages/test_project/test_project_mobile/test_project_mobile_navigation',
      );
      expect(navigationPackage.platform, Platform.mobile);
      final featuresDirectory = platformDirectory.featuresDirectory;
      expect(featuresDirectory.projectName, 'test_project');
      expect(
        featuresDirectory.path,
        '/path/to/project/packages/test_project/test_project_mobile/test_project_mobile_features',
      );
      expect(featuresDirectory.platform, Platform.mobile);
    });
  });
}
