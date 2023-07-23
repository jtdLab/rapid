import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/mason.dart';
import 'package:rapid_cli/src/project/bundles/bundles.dart';
import 'package:rapid_cli/src/project/language.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../mock_fs.dart';
import '../../mocks.dart';

IosNativeDirectory _getIosNativeDirectory({
  String? projectName,
  String? path,
}) {
  return IosNativeDirectory(
    projectName: projectName ?? 'projectName',
    path: path ?? 'path',
  );
}

MacosNativeDirectory _getMacosNativeDirectory({
  String? projectName,
  String? path,
}) {
  return MacosNativeDirectory(
    projectName: projectName ?? 'projectName',
    path: path ?? 'path',
  );
}

NoneIosNativeDirectory _getNoneIosNativeDirectory({
  String? projectName,
  String? path,
  Platform? platform,
}) {
  return NoneIosNativeDirectory(
    projectName: projectName ?? 'projectName',
    path: path ?? 'path',
    platform: platform ?? Platform.android,
  );
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('IosNativeDirectory', () {
    test('.resolve', () {
      final iosNativeDirectory = IosNativeDirectory.resolve(
        projectName: 'test_project',
        platformRootPackagePath: '/path/to/platform_root_package',
      );

      expect(iosNativeDirectory.projectName, 'test_project');
      expect(
        iosNativeDirectory.path,
        '/path/to/platform_root_package/ios',
      );
    });

    test('infoFile', () {
      final iosNativeDirectory = _getIosNativeDirectory(
        projectName: 'test_project',
        path: '/path/to/ios_native_directory',
      );

      expect(
        iosNativeDirectory.infoFile.path,
        '/path/to/ios_native_directory/Runner/Info.plist',
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
          final iosNativeDirectory = _getIosNativeDirectory(
            projectName: 'test_project',
            path: '/path/to/ios_native_directory',
          );

          await iosNativeDirectory.generate(
            orgName: 'com.example',
            language: Language(languageCode: 'en'),
          );

          verifyInOrder([
            () => generatorBuilder(iosNativeDirectoryBundle),
            () => generator.generate(
                  any(
                    that: isA<DirectoryGeneratorTarget>().having(
                      (e) => e.dir.path,
                      'path',
                      '/path/to/ios_native_directory',
                    ),
                  ),
                  vars: <String, dynamic>{
                    'project_name': 'test_project',
                    'org_name': 'com.example',
                    'language_code': 'en',
                    'has_script_code': false,
                    'script_code': null,
                    'has_country_code': false,
                    'country_code': null,
                  },
                ),
          ]);
        },
      ),
    );
  });

  group('MacosNativeDirectory', () {
    test('.resolve', () {
      final macosNativeDirectory = MacosNativeDirectory.resolve(
        projectName: 'test_project',
        platformRootPackagePath: '/path/to/platform_root_package',
      );

      expect(macosNativeDirectory.projectName, 'test_project');
      expect(
        macosNativeDirectory.path,
        '/path/to/platform_root_package/macos',
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
        final macosNativeDirectory = _getMacosNativeDirectory(
          projectName: 'test_project',
          path: '/path/to/macos_native_directory',
        );

        await macosNativeDirectory.generate(orgName: 'com.example');

        verifyInOrder([
          () => generatorBuilder(macosNativeDirectoryBundle),
          () => generator.generate(
                any(
                  that: isA<DirectoryGeneratorTarget>().having(
                    (e) => e.dir.path,
                    'path',
                    '/path/to/macos_native_directory',
                  ),
                ),
                vars: <String, dynamic>{
                  'project_name': 'test_project',
                  'org_name': 'com.example',
                },
              ),
        ]);
      }),
    );
  });

  group('NoneIosNativeDirectory', () {
    test('.resolve', () {
      final noneIosNativeDirectory = NoneIosNativeDirectory.resolve(
        projectName: 'test_project',
        platformRootPackagePath: '/path/to/platform_root_package',
        platform: Platform.android,
      );

      expect(noneIosNativeDirectory.projectName, 'test_project');
      expect(
        noneIosNativeDirectory.path,
        '/path/to/platform_root_package/android',
      );
      expect(noneIosNativeDirectory.platform, Platform.android);
    });

    test(
      'generate (android)',
      withMockFs(() async {
        final generator = MockMasonGenerator();
        final generatorBuilder = MockMasonGeneratorBuilder(
          generator: generator,
        );
        generatorOverrides = generatorBuilder;
        final noneIosNativeDirectory = _getNoneIosNativeDirectory(
          projectName: 'test_project',
          path: '/path/to/none_ios_native_directory',
          platform: Platform.android,
        );

        await noneIosNativeDirectory.generate(
          orgName: 'com.example',
          description: 'Test description',
        );

        verifyInOrder([
          () => generatorBuilder(androidNativeDirectoryBundle),
          () => generator.generate(
                any(
                  that: isA<DirectoryGeneratorTarget>().having(
                    (e) => e.dir.path,
                    'path',
                    '/path/to/none_ios_native_directory',
                  ),
                ),
                vars: <String, dynamic>{
                  'project_name': 'test_project',
                  'description': 'Test description',
                  'org_name': 'com.example',
                },
              ),
        ]);
      }),
    );

    test(
      'generate (linux)',
      withMockFs(() async {
        final generator = MockMasonGenerator();
        final generatorBuilder = MockMasonGeneratorBuilder(
          generator: generator,
        );
        generatorOverrides = generatorBuilder;
        final noneIosNativeDirectory = _getNoneIosNativeDirectory(
          projectName: 'test_project',
          path: '/path/to/none_ios_native_directory',
          platform: Platform.linux,
        );

        await noneIosNativeDirectory.generate(
          orgName: 'com.example',
          description: 'Test description',
        );

        verifyInOrder([
          () => generatorBuilder(linuxNativeDirectoryBundle),
          () => generator.generate(
                any(
                  that: isA<DirectoryGeneratorTarget>().having(
                    (e) => e.dir.path,
                    'path',
                    '/path/to/none_ios_native_directory',
                  ),
                ),
                vars: <String, dynamic>{
                  'project_name': 'test_project',
                  'description': 'Test description',
                  'org_name': 'com.example',
                },
              ),
        ]);
      }),
    );

    test(
      'generate (web)',
      withMockFs(() async {
        final generator = MockMasonGenerator();
        final generatorBuilder = MockMasonGeneratorBuilder(
          generator: generator,
        );
        generatorOverrides = generatorBuilder;
        final noneIosNativeDirectory = _getNoneIosNativeDirectory(
          projectName: 'test_project',
          path: '/path/to/none_ios_native_directory',
          platform: Platform.web,
        );

        await noneIosNativeDirectory.generate(
          orgName: 'com.example',
          description: 'Test description',
        );

        verifyInOrder([
          () => generatorBuilder(webNativeDirectoryBundle),
          () => generator.generate(
                any(
                  that: isA<DirectoryGeneratorTarget>().having(
                    (e) => e.dir.path,
                    'path',
                    '/path/to/none_ios_native_directory',
                  ),
                ),
                vars: <String, dynamic>{
                  'project_name': 'test_project',
                  'description': 'Test description',
                  'org_name': 'com.example',
                },
              ),
        ]);
      }),
    );

    test(
      'generate (windows)',
      withMockFs(() async {
        final generator = MockMasonGenerator();
        final generatorBuilder = MockMasonGeneratorBuilder(
          generator: generator,
        );
        generatorOverrides = generatorBuilder;
        final noneIosNativeDirectory = _getNoneIosNativeDirectory(
          projectName: 'test_project',
          path: '/path/to/none_ios_native_directory',
          platform: Platform.windows,
        );

        await noneIosNativeDirectory.generate(
          orgName: 'com.example',
          description: 'Test description',
        );

        verifyInOrder([
          () => generatorBuilder(windowsNativeDirectoryBundle),
          () => generator.generate(
                any(
                  that: isA<DirectoryGeneratorTarget>().having(
                    (e) => e.dir.path,
                    'path',
                    '/path/to/none_ios_native_directory',
                  ),
                ),
                vars: <String, dynamic>{
                  'project_name': 'test_project',
                  'description': 'Test description',
                  'org_name': 'com.example',
                },
              ),
        ]);
      }),
    );
  });
}
