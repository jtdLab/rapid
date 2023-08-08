// ignore_for_file: one_member_abstracts

import 'dart:convert';
import 'dart:io' as io;

import 'package:args/args.dart';
import 'package:cli_launcher/cli_launcher.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pub_updater/pub_updater.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/commands/runner.dart';
import 'package:rapid_cli/src/exception.dart';
import 'package:rapid_cli/src/io/io.dart' hide Platform;
import 'package:rapid_cli/src/logging.dart';
import 'package:rapid_cli/src/mason.dart';
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
  registerFallbackValue(FakePlatformFeaturePackage());
  registerFallbackValue(FileMode.append);
  registerFallbackValue(FileSystemEvent.create);
  registerFallbackValue(utf8);
}

class MockBloc extends Mock implements Bloc {
  MockBloc() {
    when(() => this.generate()).thenAnswer((_) async {});
  }
}

class MockCubit extends Mock implements Cubit {
  MockCubit() {
    when(() => this.generate()).thenAnswer((_) async {});
  }
}

class MockDartPackage extends Mock implements DartPackage {
  MockDartPackage({
    String? packageName,
    String? path,
    PubspecYamlFile? pubSpec,
  }) {
    packageName ??= 'dart_package';
    path ??= 'dart_package_path';
    pubSpec ??= MockPubspecYamlFile();

    when(() => this.packageName).thenReturn(packageName);
    when(() => this.path).thenReturn(path);
    when(() => pubSpecFile).thenReturn(pubSpec);
  }
}

class MockDartFile extends Mock implements DartFile {
  MockDartFile({String? path, bool? existsSync}) {
    path ??= 'path';
    existsSync ??= false;

    when(() => this.path).thenReturn(path);
    when(() => this.existsSync()).thenReturn(existsSync);
  }
}

class MockDirectory extends Mock implements Directory {
  MockDirectory({String? path, bool? existsSync}) {
    path ??= 'path';
    existsSync ??= false;

    when(() => this.path).thenReturn(path);
    when(() => this.existsSync()).thenReturn(existsSync);
  }
}

class MockArbFile extends Mock implements ArbFile {}

class MockYamlFile extends Mock implements YamlFile {}

class MockFile extends Mock implements File {
  MockFile({bool? existsSync}) {
    existsSync ??= false;

    when(() => this.existsSync()).thenReturn(existsSync);
  }
}

class MockRandomAccessFile extends Mock implements io.RandomAccessFile {}

class MockIOFile extends Mock implements io.File {
  MockIOFile({bool? existsSync}) {
    existsSync ??= false;

    when(() => this.existsSync()).thenReturn(existsSync);
  }
}

class MockIODirectory extends Mock implements io.Directory {
  MockIODirectory({bool? existsSync}) {
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

class MockRapidProjectBuilder extends Mock implements _RapidProjectBuilder {
  MockRapidProjectBuilder({RapidProject? project}) {
    project ??= MockRapidProject();

    when(() => this(config: any(named: 'config'))).thenReturn(project);
  }
}

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
      () => this.generate(
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

class MockRapid extends Mock implements Rapid {
  MockRapid() {
    when(
      () => activateAndroid(
        description: any(named: 'description'),
        orgName: any(named: 'orgName'),
        language: any(named: 'language'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => activateIos(
        orgName: any(named: 'orgName'),
        language: any(named: 'language'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => activateLinux(
        orgName: any(named: 'orgName'),
        language: any(named: 'language'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => activateMacos(
        orgName: any(named: 'orgName'),
        language: any(named: 'language'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => activateMobile(
        description: any(named: 'description'),
        orgName: any(named: 'orgName'),
        language: any(named: 'language'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => activateWeb(
        description: any(named: 'description'),
        language: any(named: 'language'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => activateWindows(
        orgName: any(named: 'orgName'),
        language: any(named: 'language'),
      ),
    ).thenAnswer((_) async {});
    when(begin).thenAnswer((_) async {});
    when(
      () => create(
        projectName: any(named: 'projectName'),
        outputDir: any(named: 'outputDir'),
        description: any(named: 'description'),
        orgName: any(named: 'orgName'),
        language: any(named: 'language'),
        platforms: any(named: 'platforms'),
      ),
    ).thenAnswer((_) async {});
    when(() => deactivatePlatform(any())).thenAnswer((_) async {});
    when(
      () => domainAddSubDomain(name: any(named: 'name')),
    ).thenAnswer((_) async {});
    when(
      () => domainRemoveSubDomain(name: any(named: 'name')),
    ).thenAnswer((_) async {});
    when(
      () => domainSubDomainAddEntity(
        name: any(named: 'name'),
        subDomainName: any(named: 'subDomainName'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => domainSubDomainAddServiceInterface(
        name: any(named: 'name'),
        subDomainName: any(named: 'subDomainName'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => domainSubDomainAddValueObject(
        name: any(named: 'name'),
        subDomainName: any(named: 'subDomainName'),
        type: any(named: 'type'),
        generics: any(named: 'generics'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => domainSubDomainRemoveEntity(
        name: any(named: 'name'),
        subDomainName: any(named: 'subDomainName'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => domainSubDomainRemoveServiceInterface(
        name: any(named: 'name'),
        subDomainName: any(named: 'subDomainName'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => domainSubDomainRemoveValueObject(
        name: any(named: 'name'),
        subDomainName: any(named: 'subDomainName'),
      ),
    ).thenAnswer((_) async {});
    when(end).thenAnswer((_) async {});
    when(
      () => infrastructureSubInfrastructureAddDataTransferObject(
        subInfrastructureName: any(named: 'subInfrastructureName'),
        entityName: any(named: 'entityName'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => infrastructureSubInfrastructureAddServiceImplementation(
        subInfrastructureName: any(named: 'subInfrastructureName'),
        serviceInterfaceName: any(named: 'serviceInterfaceName'),
        name: any(named: 'name'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => infrastructureSubInfrastructureRemoveDataTransferObject(
        subInfrastructureName: any(named: 'subInfrastructureName'),
        entityName: any(named: 'entityName'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => infrastructureSubInfrastructureRemoveServiceImplementation(
        subInfrastructureName: any(named: 'subInfrastructureName'),
        serviceInterfaceName: any(named: 'serviceInterfaceName'),
        name: any(named: 'name'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => platformAddFeatureFlow(
        any(),
        name: any(named: 'name'),
        description: any(named: 'description'),
        navigator: any(named: 'navigator'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => platformAddFeaturePage(
        any(),
        name: any(named: 'name'),
        description: any(named: 'description'),
        navigator: any(named: 'navigator'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => platformAddFeatureTabFlow(
        any(),
        name: any(named: 'name'),
        description: any(named: 'description'),
        navigator: any(named: 'navigator'),
        subFeatures: any(named: 'subFeatures'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => platformAddFeatureWidget(
        any(),
        name: any(named: 'name'),
        description: any(named: 'description'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => platformAddLanguage(
        any(),
        language: any(named: 'language'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => platformAddNavigator(
        any(),
        featureName: any(named: 'featureName'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => platformFeatureAddBloc(
        any(),
        name: any(named: 'name'),
        featureName: any(named: 'featureName'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => platformFeatureAddCubit(
        any(),
        name: any(named: 'name'),
        featureName: any(named: 'featureName'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => platformFeatureRemoveBloc(
        any(),
        name: any(named: 'name'),
        featureName: any(named: 'featureName'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => platformFeatureRemoveCubit(
        any(),
        name: any(named: 'name'),
        featureName: any(named: 'featureName'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => platformSetDefaultLanguage(
        any(),
        language: any(named: 'language'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => platformRemoveFeature(
        any(),
        name: any(named: 'name'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => platformRemoveLanguage(
        any(),
        language: any(named: 'language'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => platformRemoveNavigator(
        any(),
        featureName: any(named: 'featureName'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => pubAdd(
        packageName: any(named: 'packageName'),
        packages: any(named: 'packages'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => pubGet(
        packageName: any(named: 'packageName'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => pubRemove(
        packageName: any(named: 'packageName'),
        packages: any(named: 'packages'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => uiAddWidget(
        name: any(named: 'name'),
        theme: any(named: 'theme'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => uiPlatformAddWidget(
        any(),
        name: any(named: 'name'),
        theme: any(named: 'theme'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => uiPlatformRemoveWidget(
        any(),
        name: any(named: 'name'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => uiRemoveWidget(name: any(named: 'name')),
    ).thenAnswer((_) async {});
  }
}

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
    packageName ??= 'root_package';
    path ??= 'root_package_path';
    existsSync ??= false;
    pubSpec ??= MockPubspecYamlFile();

    when(() => this.packageName).thenReturn(packageName);
    when(() => this.path).thenReturn(path);
    when(() => this.existsSync()).thenReturn(existsSync);
    when(() => this.generate()).thenAnswer((_) async {});
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
    when(() => this.generate()).thenAnswer((_) async {});
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
    when(() => this.generate()).thenAnswer((_) async {});
    when(() => pubSpecFile).thenReturn(pubSpec);
  }
}

class MockEntity extends Mock implements Entity {
  MockEntity({
    String? name,
  }) {
    name ??= 'Foo';

    when(() => this.name).thenReturn(name);
    when(() => this.generate()).thenAnswer((_) async {});
  }
}

class MockServiceInterface extends Mock implements ServiceInterface {
  MockServiceInterface({
    String? name,
  }) {
    name ??= 'Foo';

    when(() => this.name).thenReturn(name);
    when(() => this.generate()).thenAnswer((_) async {});
  }
}

class MockValueObject extends Mock implements ValueObject {
  MockValueObject({
    String? name,
  }) {
    name ??= 'Foo';

    when(() => this.name).thenReturn(name);
    when(
      () => this.generate(
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
    DartFile? barrelFile,
  }) {
    packageName ??= 'infrastructure_package';
    path ??= 'infrastructure_package_path';
    dataTransferObject ??=
        ({required String entityName}) => MockDataTransferObject();
    serviceImplementation ??= ({
      required String name,
      required String serviceInterfaceName,
    }) =>
        MockServiceImplementation();
    isDefault ??= false;
    pubSpec ??= MockPubspecYamlFile();
    barrelFile ??= MockDartFile();

    when(() => this.packageName).thenReturn(packageName);
    when(() => this.path).thenReturn(path);
    when(() => this.name).thenReturn(name);
    when(() => this.dataTransferObject).thenReturn(dataTransferObject);
    when(() => this.serviceImplementation).thenReturn(serviceImplementation);
    when(() => this.isDefault).thenReturn(isDefault);
    when(() => this.generate()).thenAnswer((_) async {});
    when(() => pubSpecFile).thenReturn(pubSpec);
    when(() => this.barrelFile).thenReturn(barrelFile);
  }
}

class MockDataTransferObject extends Mock implements DataTransferObject {
  MockDataTransferObject({
    String? entityName,
  }) {
    entityName ??= 'Foo';

    when(() => this.entityName).thenReturn(entityName);
    when(() => this.generate()).thenAnswer((_) async {});
  }
}

class MockServiceImplementation extends Mock implements ServiceImplementation {
  MockServiceImplementation({
    String? serviceInterfaceName,
  }) {
    serviceInterfaceName ??= 'Foo';

    when(() => this.serviceInterfaceName).thenReturn(serviceInterfaceName);
    when(() => this.generate()).thenAnswer((_) async {});
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
    when(() => this.generate()).thenAnswer((_) async {});
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
      () => this.generate(
        orgName: any(named: 'orgName'),
        language: any(named: 'language'),
      ),
    ).thenAnswer((_) async {});
    when(() => registerFeaturePackage(any())).thenAnswer((_) async {});
    when(() => registerInfrastructurePackage(any())).thenAnswer((_) async {});
    when(() => unregisterFeaturePackage(any())).thenAnswer((_) async {});
    when(() => unregisterInfrastructurePackage(any())).thenAnswer((_) async {});
  }
}

class MockIosNativeDirectory extends Mock implements IosNativeDirectory {
  MockIosNativeDirectory() {
    when(
      () => this.generate(
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
      () => this.generate(orgName: any(named: 'orgName')),
    ).thenAnswer((_) async {});
  }
}

class MockMacosNativeDirectory extends Mock implements MacosNativeDirectory {
  MockMacosNativeDirectory() {
    when(
      () => this.generate(orgName: any(named: 'orgName')),
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
    path ??= 'none_ios_root_package_path';
    nativeDirectory ??= MockNoneIosNativeDirectory();
    existsSync ??= false;

    when(() => this.packageName).thenReturn(packageName);
    when(() => this.path).thenReturn(path);
    when(() => this.nativeDirectory).thenReturn(nativeDirectory);
    when(() => this.existsSync()).thenReturn(existsSync);
    when(
      () => this.generate(
        description: any(named: 'description'),
        orgName: any(named: 'orgName'),
      ),
    ).thenAnswer((_) async {});
    when(() => registerFeaturePackage(any())).thenAnswer((_) async {});
    when(() => registerInfrastructurePackage(any())).thenAnswer((_) async {});
    when(() => unregisterFeaturePackage(any())).thenAnswer((_) async {});
    when(() => unregisterInfrastructurePackage(any())).thenAnswer((_) async {});
  }
}

class MockNoneIosNativeDirectory extends Mock
    implements NoneIosNativeDirectory {
  MockNoneIosNativeDirectory() {
    when(
      () => this.generate(
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
      () => this.generate(
        orgName: any(named: 'orgName'),
        description: any(named: 'description'),
        language: any(named: 'language'),
      ),
    ).thenAnswer((_) async {});
    when(() => registerFeaturePackage(any())).thenAnswer((_) async {});
    when(() => registerInfrastructurePackage(any())).thenAnswer((_) async {});
    when(() => unregisterFeaturePackage(any())).thenAnswer((_) async {});
    when(() => unregisterInfrastructurePackage(any())).thenAnswer((_) async {});
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
    path ??= 'platform_localization_package_path';
    languageArbFile ??= ({required Language language}) => MockArbFile();
    languageLocalizationsFile ??=
        ({required Language language}) => MockDartFile();
    localizationsFile ??= MockDartFile();
    l10nFile ??= MockYamlFile();
    supportedLanguages ??= {const Language(languageCode: 'en')};
    defaultLanguage ??= const Language(languageCode: 'en');
    existsSync ??= false;

    when(() => this.packageName).thenReturn(packageName);
    when(() => this.path).thenReturn(path);
    when(() => this.languageArbFile).thenReturn(languageArbFile);
    when(() => this.languageLocalizationsFile)
        .thenReturn(languageLocalizationsFile);
    when(() => this.localizationsFile).thenReturn(localizationsFile);
    when(() => this.l10nFile).thenReturn(l10nFile);
    when(() => this.existsSync()).thenReturn(existsSync);
    when(() => this.generate(defaultLanguage: any(named: 'defaultLanguage')))
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
    path ??= 'platform_navigation_package_path';
    navigatorInterface ??= ({required String name}) => MockNavigatorInterface();
    barrelFile ??= MockDartFile();
    existsSync ??= false;

    when(() => this.packageName).thenReturn(packageName);
    when(() => this.path).thenReturn(path);
    when(() => this.navigatorInterface).thenReturn(navigatorInterface);
    when(() => this.barrelFile).thenReturn(barrelFile);
    when(() => this.existsSync()).thenReturn(existsSync);
    when(() => this.generate()).thenAnswer((_) async {});
  }
}

class MockNavigatorInterface extends Mock implements NavigatorInterface {
  MockNavigatorInterface({
    String? name,
  }) {
    name ??= 'Foo';

    when(() => this.name).thenReturn(name);
    when(() => this.generate()).thenAnswer((_) async {});
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
    path ??= 'platform_app_feature_package_path';
    existsSync ??= false;

    when(() => this.packageName).thenReturn(packageName);
    when(() => this.path).thenReturn(path);
    when(() => this.existsSync()).thenReturn(existsSync);
    when(() => this.generate()).thenAnswer((_) async {});
  }
}

class MockPlatformPageFeaturePackage extends Mock
    implements PlatformPageFeaturePackage {
  MockPlatformPageFeaturePackage({
    String? name,
    String? packageName,
    String? path,
    bool? existsSync,
    NavigatorImplementation? navigatorImplementation,
  }) {
    name ??= 'name';
    packageName ??= 'platform_page_feature_package';
    path ??= 'platform_page_feature_package_path';
    navigatorImplementation ??= MockNavigatorImplementation();
    existsSync ??= false;

    when(() => this.name).thenReturn(name);
    when(() => this.packageName).thenReturn(packageName);
    when(() => this.path).thenReturn(path);
    when(() => this.navigatorImplementation)
        .thenReturn(navigatorImplementation);
    when(() => this.existsSync()).thenReturn(existsSync);
    when(() => this.generate(description: any(named: 'description')))
        .thenAnswer((_) async {});
  }
}

class MockPlatformTabFlowFeaturePackage extends Mock
    implements PlatformTabFlowFeaturePackage {
  MockPlatformTabFlowFeaturePackage({
    String? name,
    String? packageName,
    String? path,
    NavigatorImplementation? navigatorImplementation,
  }) {
    name ??= 'name';
    packageName ??= 'platform_tab_flow_feature_package';
    path ??= 'platform_tab_flow_feature_path';
    navigatorImplementation ??= MockNavigatorImplementation();

    when(() => this.name).thenReturn(name);
    when(() => this.packageName).thenReturn(packageName);
    when(() => this.path).thenReturn(path);
    when(
      () => this.generate(
        description: any(named: 'description'),
        subFeatures: any(named: 'subFeatures'),
      ),
    ).thenAnswer((_) async {});
    when(() => this.navigatorImplementation)
        .thenReturn(navigatorImplementation);
  }
}

class MockPlatformFlowFeaturePackage extends Mock
    implements PlatformFlowFeaturePackage {
  MockPlatformFlowFeaturePackage({
    String? name,
    String? packageName,
    String? path,
    NavigatorImplementation? navigatorImplementation,
  }) {
    name ??= 'name';
    packageName ??= 'platform_flow_feature_package';
    path ??= 'platform_flow_feature_path';
    navigatorImplementation ??= MockNavigatorImplementation();

    when(() => this.name).thenReturn(name);
    when(() => this.packageName).thenReturn(packageName);
    when(() => this.path).thenReturn(path);
    when(() => this.generate(description: any(named: 'description')))
        .thenAnswer((_) async {});
    when(() => this.navigatorImplementation)
        .thenReturn(navigatorImplementation);
  }
}

class MockPlatformWidgetFeaturePackage extends Mock
    implements PlatformWidgetFeaturePackage {
  MockPlatformWidgetFeaturePackage({
    String? name,
    String? packageName,
    String? path,
    PubspecYamlFile? pubSpec,
    DartFile? barrelFile,
    DartFile? applicationBarrelFile,
  }) {
    name ??= 'name';
    packageName ??= 'platform_widget_feature_package';
    path ??= 'platform_widget_feature_path';
    pubSpec ??= MockPubspecYamlFile();
    barrelFile ??= MockDartFile();
    applicationBarrelFile ??= MockDartFile();

    when(() => this.name).thenReturn(name);
    when(() => this.packageName).thenReturn(packageName);
    when(() => this.path).thenReturn(path);
    when(() => this.generate(description: any(named: 'description')))
        .thenAnswer((_) async {});
    when(() => pubSpecFile).thenReturn(pubSpec);
    when(() => this.barrelFile).thenReturn(barrelFile);
    when(() => this.applicationBarrelFile).thenReturn(applicationBarrelFile);
  }
}

class MockNavigatorImplementation extends Mock
    implements NavigatorImplementation {
  MockNavigatorImplementation({
    String? name,
  }) {
    name ??= 'Foo';

    when(() => this.name).thenReturn(name);
    when(() => this.generate()).thenAnswer((_) async {});
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
    DartFile? barrelFile,
    DartFile? themeExtensionsFile,
  }) {
    packageName ??= 'ui_package';
    path ??= 'ui_package_path';
    widget ??= ({required String name}) => MockWidget();
    themedWidget ??= ({required String name}) => MockThemedWidget();
    pubSpec ??= MockPubspecYamlFile();
    barrelFile ??= MockDartFile();
    themeExtensionsFile ??= MockDartFile();

    when(() => this.packageName).thenReturn(packageName);
    when(() => this.path).thenReturn(path);
    when(() => this.widget).thenReturn(widget);
    when(() => this.themedWidget).thenReturn(themedWidget);
    when(() => this.generate()).thenAnswer((_) async {});
    when(() => pubSpecFile).thenReturn(pubSpec);
    when(() => this.barrelFile).thenReturn(barrelFile);
    when(() => this.themeExtensionsFile).thenReturn(themeExtensionsFile);
  }
}

class MockPlatformUiPackage extends Mock implements PlatformUiPackage {
  MockPlatformUiPackage({
    String? packageName,
    String? path,
    Widget Function({required String name})? widget,
    ThemedWidget Function({required String name})? themedWidget,
    DartFile? barrelFile,
    DartFile? themeExtensionsFile,
    bool? existsSync,
  }) {
    packageName ??= 'platform_ui_package';
    path ??= 'platform_ui_package_path';
    widget ??= ({required String name}) => MockWidget();
    themedWidget ??= ({required String name}) => MockThemedWidget();
    barrelFile ??= MockDartFile();
    themeExtensionsFile ??= MockDartFile();
    existsSync ??= false;

    when(() => this.packageName).thenReturn(packageName);
    when(() => this.path).thenReturn(path);
    when(() => this.widget).thenReturn(widget);
    when(() => this.themedWidget).thenReturn(themedWidget);
    when(() => this.barrelFile).thenReturn(barrelFile);
    when(() => this.themeExtensionsFile).thenReturn(themeExtensionsFile);
    when(() => this.existsSync()).thenReturn(existsSync);
    when(() => this.generate()).thenAnswer((_) async {});
  }
}

abstract class PlatformFeaturePackageBuilder {
  T call<T extends PlatformFeaturePackage>({required String name});
}

class MockPlatformFeaturePackageBuilder extends Mock
    implements PlatformFeaturePackageBuilder {}

abstract class BlocBuilder {
  Bloc call({required String name});
}

class MockBlocBuilder extends Mock implements BlocBuilder {}

abstract class CubitBuilder {
  Cubit call({required String name});
}

class MockCubitBuilder extends Mock implements CubitBuilder {}

abstract class NavigatorInterfaceBuilder {
  NavigatorInterface call({required String name});
}

class MockNavigatorInterfaceBuilder extends Mock
    implements NavigatorInterfaceBuilder {}

abstract class WidgetBuilder {
  Widget call({required String name});
}

class MockWidgetBuilder extends Mock implements WidgetBuilder {
  MockWidgetBuilder({Widget? widget}) {
    widget ??= MockWidget();

    when(() => call(name: any(named: 'name'))).thenReturn(widget);
  }
}

class MockWidget extends Mock implements Widget {
  MockWidget() {
    when(() => this.generate()).thenAnswer((_) async {});
  }
}

abstract class ThemedWidgetBuilder {
  ThemedWidget call({required String name});
}

class MockThemedWidgetBuilder extends Mock implements ThemedWidgetBuilder {
  MockThemedWidgetBuilder({ThemedWidget? themedWidget}) {
    themedWidget ??= MockThemedWidget();

    when(() => call(name: any(named: 'name'))).thenReturn(themedWidget);
  }
}

class MockThemedWidget extends Mock implements ThemedWidget {
  MockThemedWidget({Theme? theme}) {
    theme ??= MockTheme();

    when(() => this.generate()).thenAnswer((_) async {});
    when(() => this.theme).thenReturn(theme);
  }
}

class MockTheme extends Mock implements Theme {}

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
    when(
      () => prompt(
        any(),
        defaultValue: any(named: 'defaultValue'),
        hidden: any(named: 'hidden'),
      ),
    ).thenReturn('false');
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

class MockIOSink extends Mock implements IOSink {}

class MockFileStat extends Mock implements io.FileStat {}

class MockRapidCommandRunner extends Mock implements RapidCommandRunner {
  MockRapidCommandRunner() {
    when(() => run(any())).thenAnswer((_) async {});
  }
}

abstract class _RapidCommandRunnerBuilder {
  RapidCommandRunner call({RapidProject? project});
}

class MockRapidCommandRunnerBuilder extends Mock
    implements _RapidCommandRunnerBuilder {}

class MockPubUpdater extends Mock implements PubUpdater {
  MockPubUpdater() {
    when(() => update(packageName: packageName)).thenAnswer(
      (_) async => ProcessResult(0, 0, '', ''),
    );
  }
}

class MockLaunchContext extends Mock implements LaunchContext {}

class MockExecutableInstallation extends Mock
    implements ExecutableInstallation {}

class MockStdout extends Mock implements Stdout {}

class MockStdin extends Mock implements Stdin {}

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

class FakeRapidProject extends Fake implements RapidProject {
  FakeRapidProject({
    String? path,
  }) {
    this.path = path ?? 'path/to/project';
  }

  @override
  late final String path;
}

class FakeIODirectory extends Fake implements io.Directory {
  FakeIODirectory({String? path, bool? existsSync}) {
    this.path = path ?? 'path/to/directory';
    _existsSync = existsSync ?? false;
  }

  @override
  late final String path;

  @override
  bool existsSync() => _existsSync;

  late final bool _existsSync;
}

class FakeIOFile extends Fake implements io.File {
  FakeIOFile({String? path, bool? existsSync}) {
    this.path = path ?? 'path/to/file';
    _existsSync = existsSync ?? false;
  }

  @override
  late final String path;

  @override
  bool existsSync() => _existsSync;

  late final bool _existsSync;
}

class FakeDartFile extends Fake implements DartFile {
  FakeDartFile({String? path, bool? existsSync}) {
    this.path = path ?? 'path/to/file.dart';
    _existsSync = existsSync ?? false;
  }

  @override
  late final String path;

  @override
  bool existsSync() => _existsSync;

  late final bool _existsSync;
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

class FakePlatformPageFeaturePackage extends Fake
    implements PlatformPageFeaturePackage {
  FakePlatformPageFeaturePackage({String? name}) {
    this.name = name ?? 'platform_page_feature_package';
  }

  @override
  late final String name;
}

class FakeExecutableInstallation extends Fake
    implements ExecutableInstallation {}

class FakeRapidException extends Fake implements RapidException {}
