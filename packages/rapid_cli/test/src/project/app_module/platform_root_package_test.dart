import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/io/io.dart' hide Platform;
import 'package:rapid_cli/src/mason.dart';
import 'package:rapid_cli/src/native_platform.dart';
import 'package:rapid_cli/src/project/bundles/bundles.dart';
import 'package:rapid_cli/src/project/language.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:rapid_cli/src/utils.dart';
import 'package:test/test.dart';

import '../../mock_env.dart';
import '../../mocks.dart';

// TODO(jtdLab): share tests among platforms register etc?

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
    iosNativeDirectory: iosNativeDirectory ?? MockIosNativeDirectory(),
  );
}

void main() {
  setUpAll(registerFallbackValues);

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
      expect(nativeDirectory.platform, NativePlatform.ios);
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
                    "import 'package:auto_route/auto_route.dart';",
                    '',
                    '@InjectableInit(',
                    '  externalPackageModules: [],',
                    ')',
                    '''Future<void> configureDependencies(String environment, String platform) async =>''',
                    '    await getIt.init(',
                    '''      environmentFilter: NoEnvOrContainsAny({environment, platform}),''',
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
              "import 'package:auto_route/auto_route.dart';",
              "import 'package:test_widget/test_widget.dart';",
              '',
              '@InjectableInit(',
              '  externalPackageModules: [TestWidgetPackageModule,],',
              ')',
              '''Future<void> configureDependencies(String environment, String platform) async =>''',
              '    await getIt.init(',
              '''      environmentFilter: NoEnvOrContainsAny({environment, platform}),''',
              '    );',
              '',
            ]),
          );
        }),
      );

      test(
        'updates pubspec, injection and router files accordingly if feature '
        'package is routable',
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
                    "import 'package:injectable/injectable.dart';",
                    '',
                    '@InjectableInit(',
                    '  externalPackageModules: [],',
                    ')',
                    '''Future<void> configureDependencies(String environment, String platform) async =>''',
                    '    await getIt.init(',
                    '''      environmentFilter: NoEnvOrContainsAny({environment, platform}),''',
                    '    );'
                  ]),
                );
          final routerFile = File('/path/to_ios_root_package/lib/router.dart')
            ..createSync(recursive: true)
            ..writeAsStringSync(
              multiLine([
                "import 'package:auto_route/auto_route.dart';",
                '',
                '@AutoRouterConfig(',
                '  replaceInRouteName: null,',
                '  modules: [],',
                ')',
                r'class Router extends $Router {',
                '  @override',
                '  List<AutoRoute> get routes => [];',
                '}',
                '',
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
              "import 'package:injectable/injectable.dart';",
              "import 'package:test_page/test_page.dart';",
              '',
              '@InjectableInit(',
              '  externalPackageModules: [TestPagePackageModule,],',
              ')',
              '''Future<void> configureDependencies(String environment, String platform) async =>''',
              '    await getIt.init(',
              '''      environmentFilter: NoEnvOrContainsAny({environment, platform}),''',
              '    );',
              '',
            ]),
          );
          expect(
            routerFile.readAsStringSync(),
            multiLine([
              "import 'package:auto_route/auto_route.dart';",
              "import 'package:test_page/test_page.dart';",
              '',
              '',
              '// TODO(jtdLab): Add routes of TestPageModule to the router.',
              '',
              '@AutoRouterConfig(',
              '  replaceInRouteName: null,',
              '  modules: [TestPageModule,],',
              ')',
              r'class Router extends $Router {',
              '  @override',
              '  List<AutoRoute> get routes => [];',
              '}',
              '',
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
                    "import 'package:test_widget/test_widget.dart';",
                    '',
                    '@InjectableInit(',
                    '  externalPackageModules: [TestWidgetPackageModule,],',
                    ')',
                    '''Future<void> configureDependencies(String environment, String platform) async =>''',
                    '    await getIt.init(',
                    '''      environmentFilter: NoEnvOrContainsAny({environment, platform}),''',
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
              '''Future<void> configureDependencies(String environment, String platform) async =>''',
              '    await getIt.init(',
              '''      environmentFilter: NoEnvOrContainsAny({environment, platform}),''',
              '    );',
              '',
            ]),
          );
        }),
      );

      test(
        'updates pubspec, injection and router files accordingly '
        'if feature package is routable',
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
                    "import 'package:test_page/test_page.dart';",
                    '',
                    '@InjectableInit(',
                    '  externalPackageModules: [TestPagePackageModule,],',
                    ')',
                    '''Future<void> configureDependencies(String environment, String platform) async =>''',
                    '    await getIt.init(',
                    '''      environmentFilter: NoEnvOrContainsAny({environment, platform}),''',
                    '    );'
                  ]),
                );
          final routerFile = File('/path/to_ios_root_package/lib/router.dart')
            ..createSync(recursive: true)
            ..writeAsStringSync(
              multiLine([
                "import 'package:test_page/test_page.dart';",
                '',
                '@AutoRouterConfig(',
                '  replaceInRouteName: null,',
                '  modules: [TestPageModule,],',
                ')',
                r'class Router extends $Router {',
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
              '''Future<void> configureDependencies(String environment, String platform) async =>''',
              '    await getIt.init(',
              '''      environmentFilter: NoEnvOrContainsAny({environment, platform}),''',
              '    );',
              '',
            ]),
          );
          expect(
            routerFile.readAsStringSync(),
            multiLine([
              '@AutoRouterConfig(',
              '  replaceInRouteName: null,',
              '  modules: [],',
              ')',
              r'class Router extends $Router {',
              '  @override',
              '  List<AutoRoute> get routes => [];',
              '}',
              '',
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
                    "import 'package:injectable/injectable.dart';",
                    '',
                    '@InjectableInit(',
                    '  externalPackageModules: [],',
                    ')',
                    '''Future<void> configureDependencies(String environment, String platform) async =>''',
                    '    await getIt.init(',
                    '''      environmentFilter: NoEnvOrContainsAny({environment, platform}),''',
                    '    );',
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
              "import 'package:foo/foo.dart';",
              "import 'package:injectable/injectable.dart';",
              '',
              '@InjectableInit(',
              '  externalPackageModules: [FooPackageModule,],',
              ')',
              '''Future<void> configureDependencies(String environment, String platform) async =>''',
              '    await getIt.init(',
              '''      environmentFilter: NoEnvOrContainsAny({environment, platform}),''',
              '    );',
              '',
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
                    "import 'package:foo/foo.dart';",
                    '',
                    '@InjectableInit(',
                    '  externalPackageModules: [FooPackageModule,],',
                    ')',
                    '''Future<void> configureDependencies(String environment, String platform) async =>''',
                    '    await getIt.init(',
                    '''      environmentFilter: NoEnvOrContainsAny({environment, platform}),''',
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
              '''Future<void> configureDependencies(String environment, String platform) async =>''',
              '    await getIt.init(',
              '''      environmentFilter: NoEnvOrContainsAny({environment, platform}),''',
              '    );',
              '',
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
        generatorOverrides = generatorBuilder.call;
        final iosRootPackage = _getIosRootPackage(
          projectName: 'test_project',
          path: '/path/to/ios_root_package',
        );

        await iosRootPackage.generate(
          orgName: 'test_org',
          language: const Language(languageCode: 'en'),
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
                  'android': false,
                  'ios': true,
                  'linux': false,
                  'macos': false,
                  'web': false,
                  'windows': false,
                  'mobile': false,
                },
              ),
          () => iosRootPackage.nativeDirectory.generate(
                orgName: 'test_org',
                language: const Language(languageCode: 'en'),
              ),
        ]);
      }),
    );

    test('addLanguage', () {
      final nativeDirectory = MockIosNativeDirectory();
      final iosRootPackage = _getIosRootPackage(
        projectName: 'test_project',
        path: '/path/to/ios_root_package',
        nativeDirectory: nativeDirectory,
      );

      iosRootPackage.addLanguage(const Language(languageCode: 'fr'));

      verify(
        () => nativeDirectory.addLanguage(const Language(languageCode: 'fr')),
      ).called(1);
    });

    test('removeLanguage', () {
      final nativeDirectory = MockIosNativeDirectory();
      final iosRootPackage = _getIosRootPackage(
        projectName: 'test_project',
        path: '/path/to/ios_root_package',
        nativeDirectory: nativeDirectory,
      );

      iosRootPackage.removeLanguage(const Language(languageCode: 'fr'));

      verify(
        () =>
            nativeDirectory.removeLanguage(const Language(languageCode: 'fr')),
      ).called(1);
    });
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
      expect(nativeDirectory.platform, NativePlatform.macos);
    });

    test(
      'generate',
      withMockFs(() async {
        final generator = MockMasonGenerator();
        final generatorBuilder = MockMasonGeneratorBuilder(
          generator: generator,
        );
        generatorOverrides = generatorBuilder.call;
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
                  'android': false,
                  'ios': false,
                  'linux': false,
                  'macos': true,
                  'web': false,
                  'windows': false,
                  'mobile': false,
                },
              ),
          () => nativeDirectory.generate(
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
      expect(androidNativeDirectory.platform, NativePlatform.android);
      final iosNativeDirectory = mobileRootPackage.iosNativeDirectory;
      expect(iosNativeDirectory.projectName, 'test_project');
      expect(
        iosNativeDirectory.path,
        '/path/to/project/packages/test_project/test_project_mobile/test_project_mobile/ios',
      );
      expect(iosNativeDirectory.platform, NativePlatform.ios);
    });

    test(
      'generate',
      withMockFs(() async {
        final generator = MockMasonGenerator();
        final generatorBuilder = MockMasonGeneratorBuilder(
          generator: generator,
        );
        generatorOverrides = generatorBuilder.call;
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
          language: const Language(languageCode: 'en'),
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
                  'android': false,
                  'ios': false,
                  'linux': false,
                  'macos': false,
                  'web': false,
                  'windows': false,
                  'mobile': true,
                },
              ),
          () => androidNativeDirectory.generate(
                orgName: 'test_org',
                description: 'Test description',
              ),
          () => iosNativeDirectory.generate(
                orgName: 'test_org',
                language: const Language(languageCode: 'en'),
              ),
        ]);
      }),
    );

    test('addLanguage', () {
      final iosNativeDirectory = MockIosNativeDirectory();
      final iosRootPackage = _getMobileRootPackage(
        projectName: 'test_project',
        path: '/path/to/ios_root_package',
        iosNativeDirectory: iosNativeDirectory,
      );

      iosRootPackage.addLanguage(const Language(languageCode: 'fr'));

      verify(
        () =>
            iosNativeDirectory.addLanguage(const Language(languageCode: 'fr')),
      ).called(1);
    });

    test('removeLanguage', () {
      final iosNativeDirectory = MockIosNativeDirectory();
      final iosRootPackage = _getMobileRootPackage(
        projectName: 'test_project',
        path: '/path/to/ios_root_package',
        iosNativeDirectory: iosNativeDirectory,
      );

      iosRootPackage.removeLanguage(const Language(languageCode: 'fr'));

      verify(
        () => iosNativeDirectory
            .removeLanguage(const Language(languageCode: 'fr')),
      ).called(1);
    });
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
      expect(nativeDirectory.platform, NativePlatform.android);
    });

    test(
      'generate',
      withMockFs(() async {
        final generator = MockMasonGenerator();
        final generatorBuilder = MockMasonGeneratorBuilder(
          generator: generator,
        );
        generatorOverrides = generatorBuilder.call;
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
                  'android': true,
                  'ios': false,
                  'linux': false,
                  'macos': false,
                  'web': false,
                  'windows': false,
                  'mobile': false,
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
}
