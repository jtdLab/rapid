import 'dart:convert';

import 'package:args/args.dart';
import 'package:mason/mason.dart' hide Logger, Progress;
import 'package:mocktail/mocktail.dart';
import 'package:process/process.dart';
import 'package:rapid_cli/src/commands/runner.dart';
import 'package:rapid_cli/src/io.dart';
import 'package:rapid_cli/src/logging.dart';
import 'package:rapid_cli/src/project/language.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:rapid_cli/src/project_config.dart';
import 'package:rapid_cli/src/tool.dart';

// Mocks

void registerFallbackValues() {
  registerFallbackValue(Platform.android);
  registerFallbackValue(FakeLanguage());
  registerFallbackValue(FakeDartPackage());
  registerFallbackValue(FakeGeneratorTarget());
  registerFallbackValue(FakeMasonBundle());
  registerFallbackValue(FakeRapidProjectConfig());
  registerFallbackValue(FakeInfrastructurePackage());
}

class MockBloc extends Mock implements Bloc {}

class MockCubit extends Mock implements Cubit {}

class MockDartPackage extends Mock implements DartPackage {
  MockDartPackage({
    String? packageName,
    PubspecYamlFile? pubSpec,
  }) {
    packageName ??= 'package_name';
    pubSpec ??= MockPubspecYamlFile();

    when(() => this.packageName).thenReturn(packageName);
    when(() => pubSpecFile).thenReturn(pubSpec);
  }
}

class MockDartFile extends Mock implements DartFile {}

class MockArbFile extends Mock implements ArbFile {}

class MockYamlFile extends Mock implements YamlFile {}

class MockFile extends Mock implements File {
  MockFile({bool? existsSync}) {
    existsSync ??= false;

    when(() => this.existsSync()).thenReturn(existsSync);
  }
}

class MockArgResults extends Mock implements ArgResults {}

abstract class _StartProcess {
  Future<Process> call(
    String command,
    List<String> args, {
    bool runInShell = false,
    String? workingDirectory,
  });
}

class MockStartProcess extends Mock implements _StartProcess {}

class MockProcess extends Mock implements Process {}

abstract class _RapidProjectBuilder {
  RapidProject call({required RapidProjectConfig config});
}

class MockRapidProjectBuilder extends Mock implements _RapidProjectBuilder {}

class MockRapidProjectConfig extends Mock implements RapidProjectConfig {}

class MockPubspecYamlFile extends Mock implements PubspecYamlFile {
  MockPubspecYamlFile() {
    when(() => name).thenReturn('pubspec.yaml');
    when(() => hasDependency(name: any(named: 'name'))).thenReturn(false);
  }
}

class MockMasonGenerator extends Mock implements MasonGenerator {
  MockMasonGenerator({GeneratorHooks? hooks}) {
    hooks ??= MockGeneratorHooks();

    when(() => id).thenReturn('some id');
    when(() => description).thenReturn('some description');
    when(() => this.hooks).thenReturn(hooks);
    when(
      () => generate(
        any(),
        vars: any(named: 'vars'),
        logger: any(named: 'logger'),
      ),
    ).thenAnswer(
      (_) async => List.filled(
        2,
        const GeneratedFile.created(path: ''),
      ),
    );
  }
}

class MockGeneratorHooks extends Mock implements GeneratorHooks {
  MockGeneratorHooks() {
    when(
      () => preGen(
        vars: any(named: 'vars'),
        onVarsChanged: any(named: 'onVarsChanged'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => postGen(
        vars: any(named: 'vars'),
        workingDirectory: any(named: 'workingDirectory'),
      ),
    ).thenAnswer((_) async {});
  }
}

class MockRapid extends Mock implements Rapid {}

class MockRapidProject extends Mock implements RapidProject {
  MockRapidProject({
    String? name,
    String? path,
    RootPackage? rootPackage,
    AppModule? appModule,
    UiModule? uiModule,
    List<DartPackage>? packages,
    List<PlatformRootPackage>? rootPackages,
    DartPackage? findByPackageName,
    DartPackage? findByCwd,
    List<DartPackage>? dependentPackages,
  }) {
    name ??= 'test_project';
    path ??= 'project_path';
    rootPackage ??= MockRootPackage();
    appModule ??= MockAppModule();
    uiModule ??= MockUiModule();
    packages ??= [];
    rootPackages ??= [];
    findByPackageName ??= MockDartPackage();
    findByCwd ??= MockDartPackage();
    dependentPackages ??= [];

    when(() => this.name).thenReturn(name);
    when(() => this.path).thenReturn(path);
    when(() => this.rootPackage).thenReturn(rootPackage);
    when(() => this.appModule).thenReturn(appModule);
    when(() => this.uiModule).thenReturn(uiModule);
    when(() => platformIsActivated(any())).thenReturn(false);
    when(() => this.packages()).thenReturn(packages);
    when(() => this.rootPackages()).thenReturn(rootPackages);
    when(() => this.findByPackageName(any())).thenReturn(findByPackageName);
    when(() => this.findByCwd()).thenReturn(findByCwd);
    when(() => this.dependentPackages(any())).thenReturn(dependentPackages);
  }
}

class MockRootPackage extends Mock implements RootPackage {
  MockRootPackage({
    String? packageName,
    String? path,
    bool? existsSync,
    PubspecYamlFile? pubSpec,
  }) {
    packageName ??= 'macos_root_package';
    path ??= 'macos_root_package_path';
    existsSync ??= false;
    pubSpec ??= MockPubspecYamlFile();

    when(() => this.packageName).thenReturn(packageName);
    when(() => this.path).thenReturn(path);
    when(() => this.existsSync()).thenReturn(existsSync);
    when(() => generate()).thenAnswer((_) async {});
    when(() => pubSpecFile).thenReturn(pubSpec);
  }
}

class MockAppModule extends Mock implements AppModule {
  MockAppModule({
    String? path,
    DiPackage? diPackage,
    DomainDirectory? domainDirectory,
    InfrastructureDirectory? infrastructureDirectory,
    LoggingPackage? loggingPackage,
    PlatformDirectory Function({required Platform platform})? platformDirectory,
  }) {
    path ??= 'app_module_path';
    diPackage ??= MockDiPackage();
    domainDirectory ??= MockDomainDirectory();
    infrastructureDirectory ??= MockInfrastructureDirectory();
    loggingPackage ??= MockLoggingPackage();
    platformDirectory ??=
        ({required Platform platform}) => MockPlatformDirectory();

    when(() => this.path).thenReturn(path);
    when(() => this.diPackage).thenReturn(diPackage);
    when(() => this.domainDirectory).thenReturn(domainDirectory);
    when(() => this.infrastructureDirectory)
        .thenReturn(infrastructureDirectory);
    when(() => this.loggingPackage).thenReturn(loggingPackage);
    when(() => this.platformDirectory).thenReturn(platformDirectory);
  }
}

class MockDiPackage extends Mock implements DiPackage {
  MockDiPackage({
    String? packageName,
    String? path,
    PubspecYamlFile? pubSpec,
  }) {
    packageName ??= 'di_package';
    path ??= 'di_package_path';
    pubSpec ??= MockPubspecYamlFile();

    when(() => this.packageName).thenReturn(packageName);
    when(() => this.path).thenReturn(path);
    when(() => generate()).thenAnswer((_) async {});
    when(() => pubSpecFile).thenReturn(pubSpec);
  }
}

class MockDomainDirectory extends Mock implements DomainDirectory {
  MockDomainDirectory({
    String? path,
    DomainPackage Function({String? name})? domainPackage,
    List<DomainPackage>? domainPackages,
  }) {
    path ??= 'domain_directory_path';
    domainPackage ??= ({String? name}) => MockDomainPackage();
    domainPackages ??= [];

    when(() => this.path).thenReturn(path);
    when(() => this.domainPackage).thenReturn(domainPackage);
    when(() => this.domainPackages()).thenReturn(domainPackages);
  }
}

class MockDomainPackage extends Mock implements DomainPackage {
  MockDomainPackage({
    String? packageName,
    String? path,
    String? name,
    Entity Function({required String name})? entity,
    ServiceInterface Function({required String name})? serviceInterface,
    ValueObject Function({required String name})? valueObject,
    DartFile? barrelFile,
    PubspecYamlFile? pubSpec,
  }) {
    packageName ??= 'domain_package';
    path ??= 'domain_package_path';
    entity ??= ({required String name}) => MockEntity();
    serviceInterface ??= ({required String name}) => MockServiceInterface();
    valueObject ??= ({required String name}) => MockValueObject();
    barrelFile ??= MockDartFile();
    pubSpec ??= MockPubspecYamlFile();

    when(() => this.packageName).thenReturn(packageName);
    when(() => this.path).thenReturn(path);
    when(() => this.name).thenReturn(name);
    when(() => this.entity).thenReturn(entity);
    when(() => this.serviceInterface).thenReturn(serviceInterface);
    when(() => this.valueObject).thenReturn(valueObject);
    when(() => this.barrelFile).thenReturn(barrelFile);
    when(() => generate()).thenAnswer((_) async {});
    when(() => pubSpecFile).thenReturn(pubSpec);
  }
}

class MockEntity extends Mock implements Entity {
  MockEntity({
    String? name,
  }) {
    name ??= 'Foo';

    when(() => this.name).thenReturn(name);
    when(() => generate()).thenAnswer((_) async {});
  }
}

class MockServiceInterface extends Mock implements ServiceInterface {
  MockServiceInterface({
    String? name,
  }) {
    name ??= 'Foo';

    when(() => this.name).thenReturn(name);
    when(() => generate()).thenAnswer((_) async {});
  }
}

class MockValueObject extends Mock implements ValueObject {
  MockValueObject({
    String? name,
  }) {
    name ??= 'Foo';

    when(() => this.name).thenReturn(name);
    when(
      () => generate(
        type: any(named: 'type'),
        generics: any(named: 'generics'),
      ),
    ).thenAnswer((_) async {});
  }
}

class MockInfrastructureDirectory extends Mock
    implements InfrastructureDirectory {
  MockInfrastructureDirectory({
    String? path,
    InfrastructurePackage Function({String? name})? infrastructurePackage,
    List<InfrastructurePackage>? infrastructurePackages,
  }) {
    path ??= 'infrastructure_directory_path';
    infrastructurePackage ??= ({String? name}) => MockInfrastructurePackage();
    infrastructurePackages ??= [];

    when(() => this.path).thenReturn(path);
    when(() => this.infrastructurePackage).thenReturn(infrastructurePackage);
    when(() => this.infrastructurePackages())
        .thenReturn(infrastructurePackages);
  }
}

class MockInfrastructurePackage extends Mock implements InfrastructurePackage {
  MockInfrastructurePackage({
    String? packageName,
    String? path,
    String? name,
    DataTransferObject Function({required String entityName})?
        dataTransferObject,
    ServiceImplementation Function({
      required String name,
      required String serviceInterfaceName,
    })? serviceImplementation,
    bool? isDefault,
    PubspecYamlFile? pubSpec,
  }) {
    packageName ??= 'domain_package';
    path ??= 'infrastructure_package_path';
    dataTransferObject ??=
        ({required String entityName}) => MockDataTransferObject();
    serviceImplementation ??= (
            {required String name, required String serviceInterfaceName}) =>
        MockServiceImplementation();
    isDefault ??= false;
    pubSpec ??= MockPubspecYamlFile();

    when(() => this.packageName).thenReturn(packageName);
    when(() => this.path).thenReturn(path);
    when(() => this.name).thenReturn(name);
    when(() => this.dataTransferObject).thenReturn(dataTransferObject);
    when(() => this.serviceImplementation).thenReturn(serviceImplementation);
    when(() => this.isDefault).thenReturn(isDefault);
    // when(() => this.barrelFile).thenReturn(MockDartFile()); // TODO needed ?
    when(() => generate()).thenAnswer((_) async {});
    when(() => pubSpecFile).thenReturn(pubSpec);
  }
}

class MockDataTransferObject extends Mock implements DataTransferObject {
  MockDataTransferObject({
    String? entityName,
  }) {
    entityName ??= 'Foo';

    when(() => this.entityName).thenReturn(entityName);
    when(() => generate()).thenAnswer((_) async {});
  }
}

class MockServiceImplementation extends Mock implements ServiceImplementation {
  MockServiceImplementation({
    String? serviceInterfaceName,
  }) {
    serviceInterfaceName ??= 'Foo';

    when(() => this.serviceInterfaceName).thenReturn(serviceInterfaceName);
    when(() => generate()).thenAnswer((_) async {});
  }
}

class MockLoggingPackage extends Mock implements LoggingPackage {
  MockLoggingPackage({
    String? packageName,
    String? path,
    PubspecYamlFile? pubSpec,
  }) {
    packageName ??= 'logging_package';
    path ??= 'logging_package_path';
    pubSpec ??= MockPubspecYamlFile();

    when(() => this.packageName).thenReturn(packageName);
    when(() => this.path).thenReturn(path);
    when(() => generate()).thenAnswer((_) async {});
    when(() => pubSpecFile).thenReturn(pubSpec);
  }
}

class MockPlatformDirectory extends Mock implements PlatformDirectory {
  MockPlatformDirectory({
    String? path,
    PlatformRootPackage? rootPackage,
    PlatformLocalizationPackage? localizationPackage,
    PlatformNavigationPackage? navigationPackage,
    PlatformFeaturesDirectory? featuresDirectory,
  }) {
    path ??= 'platform_directory_path';
    rootPackage ??= MockNoneIosRootPackage();
    localizationPackage ??= MockPlatformLocalizationPackage();
    navigationPackage ??= MockPlatformNavigationPackage();
    featuresDirectory ??= MockPlatformFeaturesDirectory();

    when(() => this.rootPackage).thenReturn(rootPackage);
    when(() => this.path).thenReturn(path);
    when(() => this.localizationPackage).thenReturn(localizationPackage);
    when(() => this.navigationPackage).thenReturn(navigationPackage);
    when(() => this.featuresDirectory).thenReturn(featuresDirectory);
  }
}

class MockIosRootPackage extends Mock implements IosRootPackage {
  MockIosRootPackage({
    String? packageName,
    String? path,
    IosNativeDirectory? nativeDirectory,
    bool? existsSync,
  }) {
    packageName ??= 'ios_root_package';
    path ??= 'ios_root_path';
    nativeDirectory ??= MockIosNativeDirectory();
    existsSync ??= false;

    when(() => this.packageName).thenReturn(packageName);
    when(() => this.path).thenReturn(path);
    when(() => this.nativeDirectory).thenReturn(nativeDirectory);
    when(() => this.existsSync()).thenReturn(existsSync);
    when(
      () => generate(
        orgName: any(named: 'orgName'),
        language: any(named: 'language'),
      ),
    ).thenAnswer((_) async {});
  }
}

class MockIosNativeDirectory extends Mock implements IosNativeDirectory {
  MockIosNativeDirectory() {
    when(
      () => generate(
        orgName: any(named: 'orgName'),
        language: any(named: 'language'),
      ),
    ).thenAnswer((_) async {});
  }
}

class MockMacosRootPackage extends Mock implements MacosRootPackage {
  MockMacosRootPackage({
    String? packageName,
    String? path,
    MacosNativeDirectory? nativeDirectory,
  }) {
    packageName ??= 'macos_root_package';
    path ??= 'macos_root_path';
    nativeDirectory ??= MockMacosNativeDirectory();

    when(() => this.packageName).thenReturn(packageName);
    when(() => this.path).thenReturn(path);
    when(() => this.nativeDirectory).thenReturn(nativeDirectory);
    when(() => registerInfrastructurePackage(any())).thenAnswer((_) async {});
    when(
      () => generate(orgName: any(named: 'orgName')),
    ).thenAnswer((_) async {});
  }
}

class MockMacosNativeDirectory extends Mock implements MacosNativeDirectory {
  MockMacosNativeDirectory({
    File? podFile,
  }) {
    podFile ??= MockFile();

    when(() => this.podFile).thenReturn(podFile);
    when(
      () => generate(orgName: any(named: 'orgName')),
    ).thenAnswer((_) async {});
  }
}

class MockNoneIosRootPackage extends Mock implements NoneIosRootPackage {
  MockNoneIosRootPackage({
    String? packageName,
    String? path,
    NoneIosNativeDirectory? nativeDirectory,
    bool? existsSync,
  }) {
    packageName ??= 'none_ios_root_package';
    path ??= 'none_ios_root_path';
    nativeDirectory ??= MockNoneIosNativeDirectory();
    existsSync ??= false;

    when(() => this.packageName).thenReturn(packageName);
    when(() => this.path).thenReturn(path);
    when(() => this.nativeDirectory).thenReturn(nativeDirectory);
    when(() => this.existsSync()).thenReturn(existsSync);
    when(
      () => generate(
        description: any(named: 'description'),
        orgName: any(named: 'orgName'),
      ),
    ).thenAnswer((_) async {});
  }
}

class MockNoneIosNativeDirectory extends Mock
    implements NoneIosNativeDirectory {
  MockNoneIosNativeDirectory() {
    when(
      () => generate(
        orgName: any(named: 'orgName'),
        description: any(named: 'description'),
      ),
    ).thenAnswer((_) async {});
  }
}

class MockMobileRootPackage extends Mock implements MobileRootPackage {
  MockMobileRootPackage({
    String? packageName,
    String? path,
    NoneIosNativeDirectory? androidNativeDirectory,
    IosNativeDirectory? iosNativeDirectory,
    bool? existsSync,
  }) {
    packageName ??= 'mobile_root_package';
    path ??= 'mobile_root_path';
    androidNativeDirectory ??= MockNoneIosNativeDirectory();
    iosNativeDirectory ??= MockIosNativeDirectory();
    existsSync ??= false;

    when(() => this.packageName).thenReturn(packageName);
    when(() => this.path).thenReturn(path);
    when(() => this.androidNativeDirectory).thenReturn(androidNativeDirectory);
    when(() => this.iosNativeDirectory).thenReturn(iosNativeDirectory);
    when(() => this.existsSync()).thenReturn(existsSync);
    when(
      () => generate(
        orgName: any(named: 'orgName'),
        description: any(named: 'description'),
        language: any(named: 'language'),
      ),
    ).thenAnswer((_) async {});
  }
}

class MockPlatformLocalizationPackage extends Mock
    implements PlatformLocalizationPackage {
  MockPlatformLocalizationPackage({
    String? packageName,
    String? path,
    ArbFile Function({required Language language})? languageArbFile,
    DartFile Function({required Language language})? languageLocalizationsFile,
    DartFile? localizationsFile,
    YamlFile? l10nFile,
    Set<Language>? supportedLanguages,
    Language? defaultLanguage,
    bool? existsSync,
  }) {
    packageName ??= 'platform_localization_package';
    path ??= 'platform_localization_path';
    languageArbFile ??= ({required Language language}) => MockArbFile();
    languageLocalizationsFile ??=
        ({required Language language}) => MockDartFile();
    localizationsFile ??= MockDartFile();
    l10nFile ??= MockYamlFile();
    supportedLanguages ??= {Language(languageCode: 'en')};
    defaultLanguage ??= Language(languageCode: 'en');
    existsSync ??= false;

    when(() => this.packageName).thenReturn(packageName);
    when(() => this.path).thenReturn(path);
    when(() => this.languageArbFile).thenReturn(languageArbFile);
    when(() => this.languageLocalizationsFile)
        .thenReturn(languageLocalizationsFile);
    when(() => this.localizationsFile).thenReturn(localizationsFile);
    when(() => this.l10nFile).thenReturn(l10nFile);
    when(() => this.existsSync()).thenReturn(existsSync);
    when(() => generate(defaultLanguage: any(named: 'defaultLanguage')))
        .thenAnswer((_) async {});
    when(() => this.supportedLanguages()).thenReturn(supportedLanguages);
    when(() => this.defaultLanguage()).thenReturn(defaultLanguage);
  }
}

class MockPlatformNavigationPackage extends Mock
    implements PlatformNavigationPackage {
  MockPlatformNavigationPackage({
    String? packageName,
    String? path,
    NavigatorInterface Function({required String name})? navigatorInterface,
    DartFile? barrelFile,
    bool? existsSync,
  }) {
    packageName ??= 'platform_navigation_package';
    path ??= 'platform_navigation_path';
    navigatorInterface ??= ({required String name}) => MockNavigatorInterface();
    barrelFile ??= MockDartFile();
    existsSync ??= false;

    when(() => this.packageName).thenReturn(packageName);
    when(() => this.path).thenReturn(path);
    when(() => this.navigatorInterface).thenReturn(navigatorInterface);
    when(() => this.barrelFile).thenReturn(barrelFile);
    when(() => this.existsSync()).thenReturn(existsSync);
    when(() => generate()).thenAnswer((_) async {});
  }
}

class MockNavigatorInterface extends Mock implements NavigatorInterface {
  MockNavigatorInterface({
    String? name,
  }) {
    name ??= 'Foo'; // TODO upper case good?

    when(() => this.name).thenReturn(name);
    when(() => generate()).thenAnswer((_) async {});
  }
}

class MockPlatformFeaturesDirectory extends Mock
    implements PlatformFeaturesDirectory {
  MockPlatformFeaturesDirectory({
    PlatformAppFeaturePackage? appFeaturePackage,
    T Function<T extends PlatformFeaturePackage>({required String name})?
        featurePackage,
    List<PlatformFeaturePackage>? featurePackages,
  }) {
    T defaultFeaturePackage<T extends PlatformFeaturePackage>({
      required String name,
    }) {
      if (name.endsWith('page')) {
        return MockPlatformPageFeaturePackage() as T;
      } else if (name.endsWith('tab_flow')) {
        return MockPlatformTabFlowFeaturePackage() as T;
      } else if (name.endsWith('flow')) {
        return MockPlatformFlowFeaturePackage() as T;
      } else {
        return MockPlatformWidgetFeaturePackage() as T;
      }
    }

    appFeaturePackage ??= MockPlatformAppFeaturePackage();
    featurePackage ??= defaultFeaturePackage;
    featurePackages ??= [];

    when(() => this.appFeaturePackage).thenReturn(appFeaturePackage);
    when(() => this.featurePackage).thenReturn(featurePackage);
    when(() => generate()).thenAnswer((_) async {});
    when(() => this.featurePackages()).thenReturn(featurePackages);
  }
}

class MockPlatformAppFeaturePackage extends Mock
    implements PlatformAppFeaturePackage {
  MockPlatformAppFeaturePackage({
    String? packageName,
    String? path,
    bool? existsSync,
  }) {
    packageName ??= 'platform_app_feature_package';
    path ??= 'platform_app_feature_path';
    existsSync ??= false;

    when(() => this.packageName).thenReturn(packageName);
    when(() => this.path).thenReturn(path);
    when(() => this.existsSync()).thenReturn(existsSync);
    when(() => generate()).thenAnswer((_) async {});
  }
}

class MockPlatformPageFeaturePackage extends Mock
    implements PlatformPageFeaturePackage {
  MockPlatformPageFeaturePackage({
    String? packageName,
    String? path,
    bool? existsSync,
  }) {
    packageName ??= 'platform_page_feature_package';
    path ??= 'platform_page_feature_path';
    existsSync ??= false;

    when(() => this.packageName).thenReturn(packageName);
    when(() => this.path).thenReturn(path);
    when(() => this.existsSync()).thenReturn(existsSync);
    when(() => generate()).thenAnswer((_) async {});
  }
}

class MockPlatformTabFlowFeaturePackage extends Mock
    implements PlatformTabFlowFeaturePackage {
  MockPlatformTabFlowFeaturePackage({
    String? packageName,
  }) {
    packageName ??= 'platform_tab_flow_feature_package';
    when(() => this.packageName).thenReturn(packageName);
    when(
      () => generate(
        description: any(named: 'description'),
        subFeatures: any(named: 'subFeatures'),
      ),
    ).thenAnswer((_) async {});
  }
}

class MockPlatformFlowFeaturePackage extends Mock
    implements PlatformFlowFeaturePackage {
  MockPlatformFlowFeaturePackage({
    String? packageName,
  }) {
    packageName ??= 'platform_flow_feature_package';
    when(() => this.packageName).thenReturn(packageName);
    when(() => generate()).thenAnswer((_) async {});
  }
}

class MockPlatformWidgetFeaturePackage extends Mock
    implements PlatformWidgetFeaturePackage {
  MockPlatformWidgetFeaturePackage({
    String? packageName,
  }) {
    packageName ??= 'platform_widget_feature_package';
    when(() => this.packageName).thenReturn(packageName);
    when(() => generate()).thenAnswer((_) async {});
  }
}

class MockNavigatorImplementation extends Mock
    implements NavigatorImplementation {
  MockNavigatorImplementation({
    String? name,
  }) {
    name ??= 'Foo'; // TODO upper case good?

    when(() => this.name).thenReturn(name);
    when(() => generate()).thenAnswer((_) async {});
  }
}

class MockUiModule extends Mock implements UiModule {
  MockUiModule({
    String? path,
    UiPackage? uiPackage,
    PlatformUiPackage Function({required Platform platform})? platformUiPackage,
  }) {
    path ??= 'ui_module_path';
    uiPackage ??= MockUiPackage();
    platformUiPackage ??=
        ({required Platform platform}) => MockPlatformUiPackage();

    when(() => this.path).thenReturn(path);
    when(() => this.uiPackage).thenReturn(uiPackage);
    when(() => this.platformUiPackage).thenReturn(platformUiPackage);
  }
}

class MockUiPackage extends Mock implements UiPackage {
  MockUiPackage({
    String? packageName,
    String? path,
    Widget Function({required String name})? widget,
    ThemedWidget Function({required String name})? themedWidget,
    PubspecYamlFile? pubSpec,
  }) {
    packageName ??= 'ui_package';
    path ??= 'ui_package_path';
    widget ??= ({required String name}) => MockWidget();
    themedWidget ??= ({required String name}) => MockThemedWidget();
    pubSpec ??= MockPubspecYamlFile();

    when(() => this.packageName).thenReturn(packageName);
    when(() => this.path).thenReturn(path);
    when(() => this.widget).thenReturn(widget);
    when(() => this.themedWidget).thenReturn(themedWidget);
    when(() => generate()).thenAnswer((_) async {});
    when(() => pubSpecFile).thenReturn(pubSpec);
  }
}

class MockPlatformUiPackage extends Mock implements PlatformUiPackage {
  MockPlatformUiPackage({
    String? packageName,
    String? path,
    Widget Function({required String name})? widget,
    ThemedWidget Function({required String name})? themedWidget,
    bool? existsSync,
  }) {
    packageName ??= 'platform_ui_package';
    path ??= 'platform_ui_package_path';
    widget ??= ({required String name}) => MockWidget();
    themedWidget ??= ({required String name}) => MockThemedWidget();
    existsSync ??= false;

    when(() => this.packageName).thenReturn(packageName);
    when(() => this.path).thenReturn(path);
    when(() => this.widget).thenReturn(widget);
    when(() => this.themedWidget).thenReturn(themedWidget);
    when(() => this.existsSync()).thenReturn(existsSync);
    when(() => generate()).thenAnswer((_) async {});
  }
}

class MockWidget extends Mock implements Widget {
  MockWidget() {
    when(() => generate()).thenAnswer((_) async {});
  }
}

class MockThemedWidget extends Mock implements ThemedWidget {
  MockThemedWidget() {
    when(() => generate()).thenAnswer((_) async {});
  }
}

class MockProcessManager extends Mock implements ProcessManager {
  MockProcessManager() {
    when(
      () => run(
        any(),
        workingDirectory: any(named: 'workingDirectory'),
        runInShell: true,
        stderrEncoding: utf8,
        stdoutEncoding: utf8,
      ),
    ).thenAnswer(
      (_) async => ProcessResult(0, 0, 'stdout', 'stderr'),
    );
  }
}

abstract class _MasonGeneratorBuilder {
  Future<MasonGenerator> call(MasonBundle bundle);
}

class MockMasonGeneratorBuilder extends Mock implements _MasonGeneratorBuilder {
  MockMasonGeneratorBuilder({MasonGenerator? generator}) {
    generator ??= MockMasonGenerator();

    when(() => call(any())).thenAnswer((_) async => generator!);
  }
}

class MockRapidLogger extends Mock implements RapidLogger {
  MockRapidLogger({
    Progress? progress,
    ProgressGroup? progressGroup,
  }) {
    progress ??= MockProgress();
    progressGroup ??= MockProgressGroup();

    when(() => this.progress(any())).thenReturn(progress);
    when(() => this.progressGroup(any())).thenReturn(progressGroup);
  }
}

class MockProgress extends Mock implements Progress {}

class MockProgressGroup extends Mock implements ProgressGroup {
  MockProgressGroup({GroupableProgress? progress}) {
    progress ??= MockGroupableProgress();

    when(() => this.progress(any())).thenReturn(progress);
  }
}

class MockGroupableProgress extends Mock implements GroupableProgress {}

class MockRapidTool extends Mock implements RapidTool {}

class MockCommandGroup extends Mock implements CommandGroup {}

// Fakes

class FakeDartPackage extends Fake implements DartPackage {
  FakeDartPackage({
    String? packageName,
    String? path,
    PubspecYamlFile? pubSpecFile,
  }) {
    this.packageName = packageName ?? 'some_dart_package';
    this.path = path ?? 'path/to/${this.packageName}';
    this.pubSpecFile = pubSpecFile ?? FakePubspecYamlFile();
  }

  @override
  late final String packageName;

  @override
  late final String path;

  @override
  late final PubspecYamlFile pubSpecFile;
}

class FakeDirectoryGeneratorTarget extends Fake
    implements DirectoryGeneratorTarget {}

class FakeDomainPackage extends Mock implements DomainPackage {
  FakeDomainPackage({String? name}) {
    this.name = name ?? 'some_domain_package';
  }

  @override
  late final String name;
}

class FakeGeneratorTarget extends Fake implements GeneratorTarget {}

class FakeInfrastructurePackage extends Mock implements InfrastructurePackage {
  FakeInfrastructurePackage({String? name}) {
    this.name = name ?? 'some_infrastructure_package';
  }

  @override
  late final String name;
}

class FakeLanguage extends Fake implements Language {}

class FakeMasonBundle extends Fake implements MasonBundle {}

class FakePlatformFeaturePackage extends Mock
    implements PlatformFeaturePackage {
  FakePlatformFeaturePackage({String? name}) {
    this.name = name ?? 'some_feature_package';
  }

  @override
  late final String name;
}

class FakeProcess {
  Future<Process> start(
    String command,
    List<String> args, {
    bool runInShell = false,
    String? workingDirectory,
  }) {
    throw UnimplementedError();
  }

  Future<ProcessResult> run(
    String command,
    List<String> args, {
    bool runInShell = false,
    String? workingDirectory,
  }) {
    throw UnimplementedError();
  }
}

class FakePubspecYamlFile extends Fake implements PubspecYamlFile {}

class FakeRapidProjectConfig extends Fake implements RapidProjectConfig {}

class FakeRootPackage extends Fake implements RootPackage {
  FakeRootPackage({String? path}) {
    this.path = path ?? 'path/to/root_package';
  }

  @override
  late final String path;
}
