import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/io.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:rapid_cli/src/project_config.dart';
import 'package:test/test.dart';

import '../mock_fs.dart';
import '../mocks.dart';

RapidProject _getRapidProject({
  String? projectName,
  String? path,
  RootPackage? rootPackage,
  UiModule? uiModule,
  AppModule? appModule,
}) {
  projectName ??= 'project_name';
  path ??= '/path/to/project';
  rootPackage ??= MockRootPackage();
  uiModule ??= MockUiModule();
  appModule ??= MockAppModule();

  return RapidProject(
    name: projectName,
    path: path,
    rootPackage: rootPackage,
    uiModule: uiModule,
    appModule: appModule,
  );
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('RapidProject', () {
    // TODO good ?
    final projectName = 'test_project';
    final projectPath = '/path/to/project';

    test('.fromConfig', () {
      final config = RapidProjectConfig(
        name: projectName,
        path: projectPath,
      );
      final project = RapidProject.fromConfig(config);

      expect(project.name, projectName);
      expect(project.path, projectPath);
      final rootPackage = project.rootPackage;
      expect(rootPackage.projectName, projectName);
      expect(rootPackage.path, projectPath);
      final appModule = project.appModule;
      expect(appModule.path, '$projectPath/packages/$projectName');
      final uiModule = project.uiModule;
      expect(uiModule.path, '$projectPath/packages/${projectName}_ui');
    });

    group('platformIsActivated', () {
      test('returns true if platform is activated', () {
        final project = _getRapidProject(
          projectName: projectName,
          path: projectPath,
          appModule: MockAppModule(
            platformDirectory: ({required platform}) => MockPlatformDirectory(
              rootPackage: MockNoneIosRootPackage(existsSync: true),
              localizationPackage:
                  MockPlatformLocalizationPackage(existsSync: true),
              navigationPackage:
                  MockPlatformNavigationPackage(existsSync: true),
              featuresDirectory: MockPlatformFeaturesDirectory(
                appFeaturePackage:
                    MockPlatformAppFeaturePackage(existsSync: true),
              ),
            ),
          ),
          uiModule: MockUiModule(
            platformUiPackage: ({required platform}) => MockPlatformUiPackage(
              existsSync: true,
            ),
          ),
        );

        expect(project.platformIsActivated(Platform.android), true);
      });

      test('returns false if platform root package is missing', () {
        final project = _getRapidProject(
          projectName: projectName,
          path: projectPath,
          appModule: MockAppModule(
            platformDirectory: ({required platform}) => MockPlatformDirectory(
              rootPackage: MockNoneIosRootPackage(existsSync: false),
              localizationPackage:
                  MockPlatformLocalizationPackage(existsSync: true),
              navigationPackage:
                  MockPlatformNavigationPackage(existsSync: true),
              featuresDirectory: MockPlatformFeaturesDirectory(
                appFeaturePackage:
                    MockPlatformAppFeaturePackage(existsSync: true),
              ),
            ),
          ),
          uiModule: MockUiModule(
            platformUiPackage: ({required platform}) => MockPlatformUiPackage(
              existsSync: true,
            ),
          ),
        );

        expect(project.platformIsActivated(Platform.android), false);
      });

      test('returns false if platform localization package is missing', () {
        final project = _getRapidProject(
          projectName: projectName,
          path: projectPath,
          appModule: MockAppModule(
            platformDirectory: ({required platform}) => MockPlatformDirectory(
              rootPackage: MockNoneIosRootPackage(existsSync: true),
              localizationPackage:
                  MockPlatformLocalizationPackage(existsSync: false),
              navigationPackage:
                  MockPlatformNavigationPackage(existsSync: true),
              featuresDirectory: MockPlatformFeaturesDirectory(
                appFeaturePackage:
                    MockPlatformAppFeaturePackage(existsSync: true),
              ),
            ),
          ),
          uiModule: MockUiModule(
            platformUiPackage: ({required platform}) => MockPlatformUiPackage(
              existsSync: true,
            ),
          ),
        );

        expect(project.platformIsActivated(Platform.android), false);
      });

      test('returns false if platform navigation package is missing', () {
        final project = _getRapidProject(
          projectName: projectName,
          path: projectPath,
          appModule: MockAppModule(
            platformDirectory: ({required platform}) => MockPlatformDirectory(
              rootPackage: MockNoneIosRootPackage(existsSync: true),
              localizationPackage:
                  MockPlatformLocalizationPackage(existsSync: true),
              navigationPackage:
                  MockPlatformNavigationPackage(existsSync: false),
              featuresDirectory: MockPlatformFeaturesDirectory(
                appFeaturePackage:
                    MockPlatformAppFeaturePackage(existsSync: true),
              ),
            ),
          ),
          uiModule: MockUiModule(
            platformUiPackage: ({required platform}) => MockPlatformUiPackage(
              existsSync: true,
            ),
          ),
        );

        expect(project.platformIsActivated(Platform.android), false);
      });

      test('returns false if platform app feature package is missing', () {
        final project = _getRapidProject(
          projectName: projectName,
          path: projectPath,
          appModule: MockAppModule(
            platformDirectory: ({required platform}) => MockPlatformDirectory(
              rootPackage: MockNoneIosRootPackage(existsSync: true),
              localizationPackage:
                  MockPlatformLocalizationPackage(existsSync: true),
              navigationPackage:
                  MockPlatformNavigationPackage(existsSync: true),
              featuresDirectory: MockPlatformFeaturesDirectory(
                appFeaturePackage:
                    MockPlatformAppFeaturePackage(existsSync: false),
              ),
            ),
          ),
          uiModule: MockUiModule(
            platformUiPackage: ({required platform}) => MockPlatformUiPackage(
              existsSync: true,
            ),
          ),
        );

        expect(project.platformIsActivated(Platform.android), false);
      });

      test('returns false if platform ui package is missing', () {
        final project = _getRapidProject(
          projectName: projectName,
          path: projectPath,
          appModule: MockAppModule(
            platformDirectory: ({required platform}) => MockPlatformDirectory(
              rootPackage: MockNoneIosRootPackage(existsSync: true),
              localizationPackage:
                  MockPlatformLocalizationPackage(existsSync: true),
              navigationPackage:
                  MockPlatformNavigationPackage(existsSync: true),
              featuresDirectory: MockPlatformFeaturesDirectory(
                appFeaturePackage:
                    MockPlatformAppFeaturePackage(existsSync: true),
              ),
            ),
          ),
          uiModule: MockUiModule(
            platformUiPackage: ({required platform}) => MockPlatformUiPackage(
              existsSync: false,
            ),
          ),
        );

        expect(project.platformIsActivated(Platform.android), false);
      });
    });

    group('packages', () {
      test('returns a list of all packages', () {
        final rootPackage = MockRootPackage();
        final diPackage = MockDiPackage();
        final loggingPackage = MockLoggingPackage();
        final domainPackage1 = MockDomainPackage();
        final domainPackage2 = MockDomainPackage();
        final infrastructurePackage1 = MockInfrastructurePackage();
        final infrastructurePackage2 = MockInfrastructurePackage();
        final uiPackage = MockUiPackage();
        final platformRootPackage = MockNoneIosRootPackage(existsSync: true);
        final platformLocalizationPackage =
            MockPlatformLocalizationPackage(existsSync: true);
        final platformNavigationPackage =
            MockPlatformNavigationPackage(existsSync: true);
        final platformAppFeaturePackage =
            MockPlatformAppFeaturePackage(existsSync: true);
        final platformFeaturePackage1 =
            MockPlatformPageFeaturePackage(existsSync: true);
        final platformFeaturePackage2 =
            MockPlatformPageFeaturePackage(existsSync: true);
        final platformUiPackage = MockPlatformUiPackage(existsSync: true);
        final project = _getRapidProject(
          projectName: projectName,
          path: projectPath,
          rootPackage: rootPackage,
          appModule: MockAppModule(
            diPackage: diPackage,
            domainDirectory: MockDomainDirectory(
              domainPackages: [domainPackage1, domainPackage2],
            ),
            infrastructureDirectory: MockInfrastructureDirectory(
              infrastructurePackages: [
                infrastructurePackage1,
                infrastructurePackage2
              ],
            ),
            loggingPackage: loggingPackage,
            platformDirectory: ({required platform}) =>
                platform == Platform.android
                    ? MockPlatformDirectory(
                        rootPackage: platformRootPackage,
                        localizationPackage: platformLocalizationPackage,
                        navigationPackage: platformNavigationPackage,
                        featuresDirectory: MockPlatformFeaturesDirectory(
                          appFeaturePackage: platformAppFeaturePackage,
                          featurePackages: [
                            platformFeaturePackage1,
                            platformFeaturePackage2,
                          ],
                        ),
                      )
                    : MockPlatformDirectory(),
          ),
          uiModule: MockUiModule(
            uiPackage: uiPackage,
            platformUiPackage: ({required platform}) =>
                platform == Platform.android
                    ? platformUiPackage
                    : MockPlatformUiPackage(),
          ),
        );

        final packages = project.packages();

        expect(
          packages,
          equals(
            [
              rootPackage,
              diPackage,
              loggingPackage,
              domainPackage1,
              domainPackage2,
              infrastructurePackage1,
              infrastructurePackage2,
              uiPackage,
              platformRootPackage,
              platformLocalizationPackage,
              platformNavigationPackage,
              platformAppFeaturePackage,
              platformFeaturePackage1,
              platformFeaturePackage2,
              platformUiPackage,
            ],
          ),
        );
      });
    });

    group('rootPackages', () {
      test('returns a list of activated root packages', () {
        final platformRootPackageIos = MockIosRootPackage(existsSync: true);
        final platformRootPackageMobile =
            MockMobileRootPackage(existsSync: true);
        final project = _getRapidProject(
          projectName: projectName,
          path: projectPath,
          appModule: MockAppModule(
            platformDirectory: ({required platform}) => MockPlatformDirectory(
              rootPackage: platform == Platform.ios
                  ? platformRootPackageIos
                  : platform == Platform.mobile
                      ? platformRootPackageMobile
                      : MockNoneIosRootPackage(),
              localizationPackage:
                  MockPlatformLocalizationPackage(existsSync: true),
              navigationPackage:
                  MockPlatformNavigationPackage(existsSync: true),
              featuresDirectory: MockPlatformFeaturesDirectory(
                appFeaturePackage:
                    MockPlatformAppFeaturePackage(existsSync: true),
              ),
            ),
          ),
          uiModule: MockUiModule(
            platformUiPackage: ({required platform}) =>
                MockPlatformUiPackage(existsSync: true),
          ),
        );
        final rootPackages = project.rootPackages();

        expect(
          rootPackages,
          equals([platformRootPackageIos, platformRootPackageMobile]),
        );
      });
    });

    group('findByPackageName', () {
      test('returns the correct package by package name', () {
        final diPackage = MockDiPackage(packageName: 'test_project_di');
        final project = _getRapidProject(
          projectName: projectName,
          path: projectPath,
          appModule: MockAppModule(diPackage: diPackage),
        );

        final foundPackage = project.findByPackageName('test_project_di');
        expect(foundPackage, diPackage);
      });

      test('throws if package not found', () {
        final project = _getRapidProject(
          projectName: projectName,
          path: projectPath,
        );

        expect(
          () => project.findByPackageName('xxx'),
          throwsA(isA<StateError>()),
        );
      });
    });

    group('findByCwd', () {
      test(
        'returns the correct package by package name',
        withMockFs(() {
          Directory('/path/to/di_package').createSync(recursive: true);
          final diPackage = MockDiPackage(path: '/path/to/di_package');
          final project = _getRapidProject(
            projectName: projectName,
            path: projectPath,
            appModule: MockAppModule(diPackage: diPackage),
          );
          Directory.current = '/path/to/di_package';

          final foundPackage = project.findByCwd();
          expect(foundPackage, diPackage);
        }),
      );

      test(
        'throws if package not found',
        withMockFs(() {
          final project = _getRapidProject(
            projectName: projectName,
            path: projectPath,
          );

          expect(() => project.findByCwd(), throwsA(isA<StateError>()));
        }),
      );
    });

    group('dependentPackages', () {
      test('returns the correct list of dependent packages', () {
        final rootDomainPackage =
            MockDomainPackage(packageName: 'root_domain_package');
        final dependentPubSpec1 = MockPubspecYamlFile();
        when(
          () => dependentPubSpec1.hasDependency(name: 'root_domain_package'),
        ).thenReturn(true);
        final dependentDomainPackage1 = MockDomainPackage(
          packageName: 'dependent_domain_package_1',
          pubSpec: dependentPubSpec1,
        );
        final dependentPubSpec2 = MockPubspecYamlFile();
        when(
          () => dependentPubSpec2.hasDependency(name: 'root_domain_package'),
        ).thenReturn(true);
        final dependentDomainPackage2 = MockDomainPackage(
          packageName: 'dependent_domain_package_2',
          pubSpec: dependentPubSpec2,
        );

        final project = _getRapidProject(
          projectName: projectName,
          path: projectPath,
          appModule: MockAppModule(
            domainDirectory: MockDomainDirectory(
              domainPackages: [
                rootDomainPackage,
                dependentDomainPackage1,
                dependentDomainPackage2
              ],
            ),
          ),
        );

        final dependentPackages = project.dependentPackages(rootDomainPackage);

        expect(
          dependentPackages,
          equals([dependentDomainPackage1, dependentDomainPackage2]),
        );
      });

      test('returns the correct list of dependent packages (multi level)', () {
        final rootDomainPackage =
            MockDomainPackage(packageName: 'root_domain_package');
        final dependentPubSpec1 = MockPubspecYamlFile();
        when(
          () => dependentPubSpec1.hasDependency(name: 'root_domain_package'),
        ).thenReturn(true);
        final dependentDomainPackage1 = MockDomainPackage(
          packageName: 'dependent_domain_package_1',
          pubSpec: dependentPubSpec1,
        );
        final dependentPubSpec2 = MockPubspecYamlFile();
        when(
          () => dependentPubSpec2.hasDependency(
            name: 'dependent_domain_package_1',
          ),
        ).thenReturn(true);
        final dependentDomainPackage2 = MockDomainPackage(
          packageName: 'dependent_domain_package_2',
          pubSpec: dependentPubSpec2,
        );

        final project = _getRapidProject(
          projectName: projectName,
          path: projectPath,
          appModule: MockAppModule(
            domainDirectory: MockDomainDirectory(
              domainPackages: [
                rootDomainPackage,
                dependentDomainPackage1,
                dependentDomainPackage2
              ],
            ),
          ),
        );

        final dependentPackages = project.dependentPackages(rootDomainPackage);

        expect(
          dependentPackages,
          equals([dependentDomainPackage1, dependentDomainPackage2]),
        );
      });

      test('returns an empty list if package has no dependents', () {
        final domainPackage = MockDomainPackage();
        final project = _getRapidProject(
          projectName: projectName,
          path: projectPath,
          appModule: MockAppModule(
            domainDirectory: MockDomainDirectory(
              domainPackages: [
                domainPackage,
              ],
            ),
          ),
        );

        final dependentPackages = project.dependentPackages(domainPackage);

        expect(dependentPackages, isEmpty);
      });
    });
  });
}
