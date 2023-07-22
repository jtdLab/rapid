import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/io.dart';
import 'package:rapid_cli/src/mason.dart';
import 'package:rapid_cli/src/project/bundles/bundles.dart';
import 'package:rapid_cli/src/project/language.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:rapid_cli/src/utils.dart';
import 'package:test/test.dart';

import '../../mock_fs.dart';
import '../../mocks.dart';

IosRootPackage _getIosRootPackage({
  String? projectName,
  String? path,
  IosNativeDirectory? nativeDirectory,
}) {
  return IosRootPackage(
    projectName: projectName ?? 'projectName',
    path: path ?? 'path',
    nativeDirectory: nativeDirectory ?? MockIosNativeDirectory(),
  );
}

MacosRootPackage _getMacosRootPackage({
  String? projectName,
  String? path,
  MacosNativeDirectory? nativeDirectory,
}) {
  return MacosRootPackage(
    projectName: projectName ?? 'projectName',
    path: path ?? 'path',
    nativeDirectory: nativeDirectory ?? MockMacosNativeDirectory(),
  );
}

NoneIosRootPackage _getNoneIosRootPackage({
  String? projectName,
  String? path,
  Platform? platform,
  NoneIosNativeDirectory? nativeDirectory,
}) {
  return NoneIosRootPackage(
    projectName: projectName ?? 'projectName',
    path: path ?? 'path',
    platform: platform ?? Platform.android,
    nativeDirectory: nativeDirectory ?? MockNoneIosNativeDirectory(),
  );
}

MobileRootPackage _getMobileRootPackage({
  String? projectName,
  String? path,
  NoneIosNativeDirectory? androidNativeDirectory,
  IosNativeDirectory? iosNativeDirectory,
}) {
  return MobileRootPackage(
      projectName: projectName ?? 'projectName',
      path: path ?? 'path',
      androidNativeDirectory:
          androidNativeDirectory ?? MockNoneIosNativeDirectory(),
      iosNativeDirectory: iosNativeDirectory ?? MockIosNativeDirectory());
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('IosRootPackage', () {
    test('.resolve', () {
      final iosRootPackage = IosRootPackage.resolve(
        projectName: 'test_project',
        projectPath: '/path/to/project',
      );

      expect(iosRootPackage.projectName, 'test_project');
      expect(
        iosRootPackage.path,
        '/path/to/project/packages/test_project/test_project_ios/test_project_ios',
      );
      expect(iosRootPackage.platform, Platform.ios);
      final nativeDirectory = iosRootPackage.nativeDirectory;
      expect(nativeDirectory.projectName, 'test_project');
      expect(
        nativeDirectory.path,
        '/path/to/project/packages/test_project/test_project_ios/test_project_ios/ios',
      );
      expect(nativeDirectory.platform, Platform.ios);
    });

    test('injectionFile', () {
      final iosRootPackage = _getIosRootPackage(
        projectName: 'test_project',
        path: '/path/to/ios_root_package',
      );

      expect(
        iosRootPackage.injectionFile.path,
        '/path/to/ios_root_package/lib/injection.dart',
      );
    });

    test('routerFile', () {
      final iosRootPackage = _getIosRootPackage(
        projectName: 'test_project',
        path: '/path/to/ios_root_package',
      );

      expect(
        iosRootPackage.routerFile.path,
        '/path/to/ios_root_package/lib/router.dart',
      );
    });

    group('registerFeaturePackage', () {
      test(
        'updates pubspec, injection files accordingly',
        withMockFs(() async {
          final pubSpecFile = File('/path/to_ios_root_package/pubspec.yaml')
            ..createSync(recursive: true)
            ..writeAsStringSync(
              multiLine([
                'name: xxx',
                '',
                'dependencies:',
                '  collection: 1.0.0',
                '',
              ]),
            );
          final injectionFile =
              File('/path/to_ios_root_package/lib/injection.dart')
                ..createSync(recursive: true)
                ..writeAsStringSync(
                  multiLine([
                    '@InjectableInit(',
                    '  externalPackageModules: [],',
                    ')',
                    'Future<void> configureDependencies(String environment, String platform) async =>',
                    '    await getIt.init(',
                    '      environmentFilter: NoEnvOrContainsAny({environment, platform}),',
                    '    );'
                  ]),
                );
          final iosRootPackage = _getIosRootPackage(
            path: '/path/to_ios_root_package',
          );
          final featurePackage = MockPlatformWidgetFeaturePackage();
          when(() => featurePackage.packageName).thenReturn('test_widget');

          await iosRootPackage.registerFeaturePackage(featurePackage);

          expect(
            pubSpecFile.readAsStringSync(),
            multiLine([
              'name: xxx',
              '',
              'dependencies:',
              '  collection: 1.0.0',
              '  test_widget:',
              '',
            ]),
          );
          expect(
            injectionFile.readAsStringSync(),
            multiLine([
              'import \'package:test_widget/test_widget.dart\';',
              '@InjectableInit(',
              '  externalPackageModules: [TestWidgetPackageModule,],',
              ')',
              'Future<void> configureDependencies(String environment, String platform) async =>',
              '    await getIt.init(',
              '      environmentFilter: NoEnvOrContainsAny({environment, platform}),',
              '    );'
            ]),
          );
        }),
      );

      test(
        'updates pubspec, injection and router files accordingly if feature package is routable',
        withMockFs(() async {
          final pubSpecFile = File('/path/to_ios_root_package/pubspec.yaml')
            ..createSync(recursive: true)
            ..writeAsStringSync(
              multiLine([
                'name: xxx',
                '',
                'dependencies:',
                '  collection: 1.0.0',
                '',
              ]),
            );
          final injectionFile =
              File('/path/to_ios_root_package/lib/injection.dart')
                ..createSync(recursive: true)
                ..writeAsStringSync(
                  multiLine([
                    '@InjectableInit(',
                    '  externalPackageModules: [],',
                    ')',
                    'Future<void> configureDependencies(String environment, String platform) async =>',
                    '    await getIt.init(',
                    '      environmentFilter: NoEnvOrContainsAny({environment, platform}),',
                    '    );'
                  ]),
                );
          final routerFile = File('/path/to_ios_root_package/lib/router.dart')
            ..createSync(recursive: true)
            ..writeAsStringSync(
              multiLine([
                '@AutoRouterConfig(',
                '  replaceInRouteName: null,',
                '  modules: [],',
                ')',
                'class Router extends \$Router {',
                '  @override',
                '  List<AutoRoute> get routes => [];',
                '}',
              ]),
            );
          final iosRootPackage = _getIosRootPackage(
            path: '/path/to_ios_root_package',
          );
          final featurePackage = MockPlatformPageFeaturePackage();
          when(() => featurePackage.packageName).thenReturn('test_page');

          await iosRootPackage.registerFeaturePackage(featurePackage);

          expect(
            pubSpecFile.readAsStringSync(),
            multiLine([
              'name: xxx',
              '',
              'dependencies:',
              '  collection: 1.0.0',
              '  test_page:',
              '',
            ]),
          );
          expect(
            injectionFile.readAsStringSync(),
            multiLine([
              'import \'package:test_page/test_page.dart\';',
              '@InjectableInit(',
              '  externalPackageModules: [TestPagePackageModule,],',
              ')',
              'Future<void> configureDependencies(String environment, String platform) async =>',
              '    await getIt.init(',
              '      environmentFilter: NoEnvOrContainsAny({environment, platform}),',
              '    );'
            ]),
          );
          expect(
            routerFile.readAsStringSync(),
            multiLine([
              'import \'package:test_page/test_page.dart\';',
              '',
              '',
              '// TODO: Add routes of TestPageModule to the router.',
              '@AutoRouterConfig(',
              '  replaceInRouteName: null,',
              '  modules: [TestPageModule,],',
              ')',
              'class Router extends \$Router {',
              '  @override',
              '  List<AutoRoute> get routes => [];',
              '}',
            ]),
          );
        }),
      );
    });

    group('unregisterFeaturePackage', () {
      test(
        'updates pubspec, injection files accordingly',
        withMockFs(() async {
          final pubSpecFile = File('/path/to_ios_root_package/pubspec.yaml')
            ..createSync(recursive: true)
            ..writeAsStringSync(
              multiLine([
                'name: xxx',
                '',
                'dependencies:',
                '  collection: 1.0.0',
                '  test_widget:',
                '',
              ]),
            );
          final injectionFile =
              File('/path/to_ios_root_package/lib/injection.dart')
                ..createSync(recursive: true)
                ..writeAsStringSync(
                  multiLine([
                    'import \'package:test_widget/test_widget.dart\';',
                    '',
                    '@InjectableInit(',
                    '  externalPackageModules: [TestWidgetPackageModule,],',
                    ')',
                    'Future<void> configureDependencies(String environment, String platform) async =>',
                    '    await getIt.init(',
                    '      environmentFilter: NoEnvOrContainsAny({environment, platform}),',
                    '    );'
                  ]),
                );
          final iosRootPackage = _getIosRootPackage(
            path: '/path/to_ios_root_package',
          );
          final featurePackage = MockPlatformWidgetFeaturePackage();
          when(() => featurePackage.packageName).thenReturn('test_widget');

          await iosRootPackage.unregisterFeaturePackage(featurePackage);

          expect(
            pubSpecFile.readAsStringSync(),
            multiLine([
              'name: xxx',
              '',
              'dependencies:',
              '  collection: 1.0.0',
              '',
            ]),
          );
          expect(
            injectionFile.readAsStringSync(),
            multiLine([
              '@InjectableInit(',
              '  externalPackageModules: [],',
              ')',
              'Future<void> configureDependencies(String environment, String platform) async =>',
              '    await getIt.init(',
              '      environmentFilter: NoEnvOrContainsAny({environment, platform}),',
              '    );'
            ]),
          );
        }),
      );

      test(
        'updates pubspec, injection and router files accordingly if feature package is routable',
        withMockFs(() async {
          final pubSpecFile = File('/path/to_ios_root_package/pubspec.yaml')
            ..createSync(recursive: true)
            ..writeAsStringSync(
              multiLine([
                'name: xxx',
                '',
                'dependencies:',
                '  collection: 1.0.0',
                '  test_page:',
                '',
              ]),
            );
          final injectionFile =
              File('/path/to_ios_root_package/lib/injection.dart')
                ..createSync(recursive: true)
                ..writeAsStringSync(
                  multiLine([
                    'import \'package:test_page/test_page.dart\';',
                    '',
                    '@InjectableInit(',
                    '  externalPackageModules: [TestPagePackageModule,],',
                    ')',
                    'Future<void> configureDependencies(String environment, String platform) async =>',
                    '    await getIt.init(',
                    '      environmentFilter: NoEnvOrContainsAny({environment, platform}),',
                    '    );'
                  ]),
                );
          final routerFile = File('/path/to_ios_root_package/lib/router.dart')
            ..createSync(recursive: true)
            ..writeAsStringSync(
              multiLine([
                'import \'package:test_page/test_page.dart\';',
                '',
                '@AutoRouterConfig(',
                '  replaceInRouteName: null,',
                '  modules: [TestPageModule,],',
                ')',
                'class Router extends \$Router {',
                '  @override',
                '  List<AutoRoute> get routes => [];',
                '}',
              ]),
            );
          final iosRootPackage = _getIosRootPackage(
            path: '/path/to_ios_root_package',
          );
          final featurePackage = MockPlatformPageFeaturePackage();
          when(() => featurePackage.packageName).thenReturn('test_page');

          await iosRootPackage.unregisterFeaturePackage(featurePackage);

          expect(
            pubSpecFile.readAsStringSync(),
            multiLine([
              'name: xxx',
              '',
              'dependencies:',
              '  collection: 1.0.0',
              '',
            ]),
          );
          expect(
            injectionFile.readAsStringSync(),
            multiLine([
              '@InjectableInit(',
              '  externalPackageModules: [],',
              ')',
              'Future<void> configureDependencies(String environment, String platform) async =>',
              '    await getIt.init(',
              '      environmentFilter: NoEnvOrContainsAny({environment, platform}),',
              '    );'
            ]),
          );
          expect(
            routerFile.readAsStringSync(),
            multiLine([
              '@AutoRouterConfig(',
              '  replaceInRouteName: null,',
              '  modules: [],',
              ')',
              'class Router extends \$Router {',
              '  @override',
              '  List<AutoRoute> get routes => [];',
              '}',
            ]),
          );
        }),
      );
    });

    group('registerInfrastructurePackage', () {
      test(
        'updates pubspec, injection files accordingly',
        withMockFs(() async {
          final pubSpecFile = File('/path/to_ios_root_package/pubspec.yaml')
            ..createSync(recursive: true)
            ..writeAsStringSync(
              multiLine([
                'name: xxx',
                '',
                'dependencies:',
                '  collection: 1.0.0',
                '',
              ]),
            );
          final injectionFile =
              File('/path/to_ios_root_package/lib/injection.dart')
                ..createSync(recursive: true)
                ..writeAsStringSync(
                  multiLine([
                    '@InjectableInit(',
                    '  externalPackageModules: [],',
                    ')',
                    'Future<void> configureDependencies(String environment, String platform) async =>',
                    '    await getIt.init(',
                    '      environmentFilter: NoEnvOrContainsAny({environment, platform}),',
                    '    );'
                  ]),
                );
          final iosRootPackage = _getIosRootPackage(
            path: '/path/to_ios_root_package',
          );
          final infrastructurePackage = MockInfrastructurePackage();
          when(() => infrastructurePackage.packageName).thenReturn('foo');

          await iosRootPackage
              .registerInfrastructurePackage(infrastructurePackage);

          expect(
            pubSpecFile.readAsStringSync(),
            multiLine([
              'name: xxx',
              '',
              'dependencies:',
              '  collection: 1.0.0',
              '  foo:',
              '',
            ]),
          );
          expect(
            injectionFile.readAsStringSync(),
            multiLine([
              'import \'package:foo/foo.dart\';',
              '@InjectableInit(',
              '  externalPackageModules: [FooPackageModule,],',
              ')',
              'Future<void> configureDependencies(String environment, String platform) async =>',
              '    await getIt.init(',
              '      environmentFilter: NoEnvOrContainsAny({environment, platform}),',
              '    );'
            ]),
          );
        }),
      );
    });

    group('unregisterInfrastructurePackage', () {
      test(
        'updates pubspec, injection files accordingly',
        withMockFs(() async {
          final pubSpecFile = File('/path/to_ios_root_package/pubspec.yaml')
            ..createSync(recursive: true)
            ..writeAsStringSync(
              multiLine([
                'name: xxx',
                '',
                'dependencies:',
                '  collection: 1.0.0',
                '  foo:',
                '',
              ]),
            );
          final injectionFile =
              File('/path/to_ios_root_package/lib/injection.dart')
                ..createSync(recursive: true)
                ..writeAsStringSync(
                  multiLine([
                    'import \'package:foo/foo.dart\';',
                    '',
                    '@InjectableInit(',
                    '  externalPackageModules: [FooPackageModule,],',
                    ')',
                    'Future<void> configureDependencies(String environment, String platform) async =>',
                    '    await getIt.init(',
                    '      environmentFilter: NoEnvOrContainsAny({environment, platform}),',
                    '    );'
                  ]),
                );
          final iosRootPackage = _getIosRootPackage(
            path: '/path/to_ios_root_package',
          );
          final infrastructurePackage = MockInfrastructurePackage();
          when(() => infrastructurePackage.packageName).thenReturn('foo');

          await iosRootPackage
              .unregisterInfrastructurePackage(infrastructurePackage);

          expect(
            pubSpecFile.readAsStringSync(),
            multiLine([
              'name: xxx',
              '',
              'dependencies:',
              '  collection: 1.0.0',
              '',
            ]),
          );
          expect(
            injectionFile.readAsStringSync(),
            multiLine([
              '@InjectableInit(',
              '  externalPackageModules: [],',
              ')',
              'Future<void> configureDependencies(String environment, String platform) async =>',
              '    await getIt.init(',
              '      environmentFilter: NoEnvOrContainsAny({environment, platform}),',
              '    );'
            ]),
          );
        }),
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
        final iosRootPackage = _getIosRootPackage(
          projectName: 'test_project',
          path: '/path/to/ios_root_package',
        );

        await iosRootPackage.generate(
          orgName: 'test_org',
          language: Language(languageCode: 'en'),
        );

        verifyInOrder([
          () => generatorBuilder(platformRootPackageBundle),
          () => generator.generate(
                any(
                  that: isA<DirectoryGeneratorTarget>().having(
                    (e) => e.dir.path,
                    'path',
                    '/path/to/ios_root_package',
                  ),
                ),
                vars: <String, dynamic>{
                  'project_name': 'test_project',
                  'org_name': 'test_org',
                  'platform': 'ios',
                },
              ),
          () => iosRootPackage.nativeDirectory.generate(
                orgName: 'test_org',
                language: Language(languageCode: 'en'),
              ),
        ]);
      }),
    );
  });

  group('MacosRootPackage', () {
    test('.resolve', () {
      final macosRootPackage = MacosRootPackage.resolve(
        projectName: 'test_project',
        projectPath: '/path/to/project',
      );

      expect(macosRootPackage.projectName, 'test_project');
      expect(
        macosRootPackage.path,
        '/path/to/project/packages/test_project/test_project_macos/test_project_macos',
      );
      expect(macosRootPackage.platform, Platform.macos);
      final nativeDirectory = macosRootPackage.nativeDirectory;
      expect(nativeDirectory.projectName, 'test_project');
      expect(
        nativeDirectory.path,
        '/path/to/project/packages/test_project/test_project_macos/test_project_macos/macos',
      );
      expect(nativeDirectory.platform, Platform.macos);
    });

    test(
      'generate',
      withMockFs(() async {
        final generator = MockMasonGenerator();
        final generatorBuilder = MockMasonGeneratorBuilder(
          generator: generator,
        );
        generatorOverrides = generatorBuilder;
        final nativeDirectory = MockMacosNativeDirectory();
        final macosRootPackage = _getMacosRootPackage(
          projectName: 'test_project',
          path: '/path/to/macos_root_package',
          nativeDirectory: nativeDirectory,
        );

        await macosRootPackage.generate(
          orgName: 'test_org',
        );

        verifyInOrder([
          () => generatorBuilder(platformRootPackageBundle),
          () => generator.generate(
                any(
                  that: isA<DirectoryGeneratorTarget>().having(
                    (e) => e.dir.path,
                    'path',
                    '/path/to/macos_root_package',
                  ),
                ),
                vars: <String, dynamic>{
                  'project_name': 'test_project',
                  'org_name': 'test_org',
                  'platform': 'macos',
                },
              ),
          () => nativeDirectory.generate(
                orgName: 'test_org',
              ),
        ]);
      }),
    );
  });

  group('NoneIosRootPackage', () {
    test('.resolve', () {
      final noneIosRootPackage = NoneIosRootPackage.resolve(
        projectName: 'test_project',
        projectPath: '/path/to/project',
        platform: Platform.android,
      );

      expect(noneIosRootPackage.projectName, 'test_project');
      expect(
        noneIosRootPackage.path,
        '/path/to/project/packages/test_project/test_project_android/test_project_android',
      );
      expect(noneIosRootPackage.platform, Platform.android);
      final nativeDirectory = noneIosRootPackage.nativeDirectory;
      expect(nativeDirectory.projectName, 'test_project');
      expect(
        nativeDirectory.path,
        '/path/to/project/packages/test_project/test_project_android/test_project_android/android',
      );
      expect(nativeDirectory.platform, Platform.android);
    });

    test(
      'generate',
      withMockFs(() async {
        final generator = MockMasonGenerator();
        final generatorBuilder = MockMasonGeneratorBuilder(
          generator: generator,
        );
        generatorOverrides = generatorBuilder;
        final nativeDirectory = MockNoneIosNativeDirectory();
        final noneIosRootPackage = _getNoneIosRootPackage(
          projectName: 'test_project',
          platform: Platform.android,
          path: '/path/to/none_ios_root_package',
          nativeDirectory: nativeDirectory,
        );

        await noneIosRootPackage.generate(
          description: 'Test description',
          orgName: 'test_org',
        );

        verifyInOrder([
          () => generatorBuilder(platformRootPackageBundle),
          () => generator.generate(
                any(
                  that: isA<DirectoryGeneratorTarget>().having(
                    (e) => e.dir.path,
                    'path',
                    '/path/to/none_ios_root_package',
                  ),
                ),
                vars: <String, dynamic>{
                  'project_name': 'test_project',
                  'description': 'Test description',
                  'org_name': 'test_org',
                  'platform': 'android',
                },
              ),
          () => nativeDirectory.generate(
                description: 'Test description',
                orgName: 'test_org',
              ),
        ]);
      }),
    );
  });

  group('MobileRootPackage', () {
    test('.resolve', () {
      final mobileRootPackage = MobileRootPackage.resolve(
        projectName: 'test_project',
        projectPath: '/path/to/project',
      );

      expect(mobileRootPackage.projectName, 'test_project');
      expect(
        mobileRootPackage.path,
        '/path/to/project/packages/test_project/test_project_mobile/test_project_mobile',
      );
      expect(mobileRootPackage.platform, Platform.mobile);
      final androidNativeDirectory = mobileRootPackage.androidNativeDirectory;
      expect(androidNativeDirectory.projectName, 'test_project');
      expect(
        androidNativeDirectory.path,
        '/path/to/project/packages/test_project/test_project_mobile/test_project_mobile/android',
      );
      expect(androidNativeDirectory.platform, Platform.android);
      final iosNativeDirectory = mobileRootPackage.iosNativeDirectory;
      expect(iosNativeDirectory.projectName, 'test_project');
      expect(
        iosNativeDirectory.path,
        '/path/to/project/packages/test_project/test_project_mobile/test_project_mobile/ios',
      );
      expect(iosNativeDirectory.platform, Platform.ios);
    });

    test(
      'generate',
      withMockFs(() async {
        final generator = MockMasonGenerator();
        final generatorBuilder = MockMasonGeneratorBuilder(
          generator: generator,
        );
        generatorOverrides = generatorBuilder;
        final androidNativeDirectory = MockNoneIosNativeDirectory();
        final iosNativeDirectory = MockIosNativeDirectory();
        final mobileRootPackage = _getMobileRootPackage(
          projectName: 'test_project',
          path: '/path/to/mobile_root_package',
          androidNativeDirectory: androidNativeDirectory,
          iosNativeDirectory: iosNativeDirectory,
        );

        await mobileRootPackage.generate(
          orgName: 'test_org',
          description: 'Test description',
          language: Language(languageCode: 'en'),
        );

        verifyInOrder([
          () => generatorBuilder(platformRootPackageBundle),
          () => generator.generate(
                any(
                  that: isA<DirectoryGeneratorTarget>().having(
                    (e) => e.dir.path,
                    'path',
                    '/path/to/mobile_root_package',
                  ),
                ),
                vars: <String, dynamic>{
                  'project_name': 'test_project',
                  'org_name': 'test_org',
                  'platform': 'mobile',
                },
              ),
          () => androidNativeDirectory.generate(
                orgName: 'test_org',
                description: 'Test description',
              ),
          () => iosNativeDirectory.generate(
                orgName: 'test_org',
                language: Language(languageCode: 'en'),
              ),
        ]);
      }),
    );
  });
}
