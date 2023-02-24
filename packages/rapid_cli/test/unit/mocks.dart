import 'dart:io';

import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/app_package/app_package.dart';
import 'package:rapid_cli/src/project/app_package/platform_native_directory/platform_native_directory.dart';
import 'package:rapid_cli/src/project/di_package/di_package.dart';
import 'package:rapid_cli/src/project/domain_package/domain_package.dart';
import 'package:rapid_cli/src/project/infrastructure_package/infrastructure_package.dart';
import 'package:rapid_cli/src/project/logging_package/logging_package.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_directory.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_feature_package/platform_feature_package.dart';
import 'package:rapid_cli/src/project/platform_ui_package/platform_ui_package.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:rapid_cli/src/project/ui_package/ui_package.dart';

// Mocks

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

class MockLogger extends Mock implements Logger {}

class MockProgress extends Mock implements Progress {}

abstract class _FlutterConfigEnablePlatformCommand {
  Future<void> call({required Logger logger});
}

class MockFlutterConfigEnablePlatformCommand extends Mock
    implements _FlutterConfigEnablePlatformCommand {}

class MockProject extends Mock implements Project {}

class MockArgResults extends Mock implements ArgResults {}

abstract class _FlutterInstalledCommand {
  Future<bool> call({required Logger logger});
}

class MockFlutterInstalledCommand extends Mock
    implements _FlutterInstalledCommand {}

abstract class _MelosInstalledCommand {
  Future<bool> call({required Logger logger});
}

class MockMelosInstalledCommand extends Mock
    implements _MelosInstalledCommand {}

abstract class _ProjectBuilder {
  Project call({String path});
}

class MockProjectBuilder extends Mock implements _ProjectBuilder {}

abstract class _PlatformDirectoryBuilder {
  PlatformDirectory call({required Platform platform});
}

class MockPlatformDirectoryBuilder extends Mock
    implements _PlatformDirectoryBuilder {}

class MockPlatformDirectory extends Mock implements PlatformDirectory {}

class MockPlatformCustomFeaturePackage extends Mock
    implements PlatformCustomFeaturePackage {}

class MockPlatformRoutingFeaturePackage extends Mock
    implements PlatformRoutingFeaturePackage {}

class MockPubspecFile extends Mock implements PubspecFile {}

class MockInjectionFile extends Mock implements InjectionFile {}

class MockMasonGenerator extends Mock implements MasonGenerator {}

class MockDiPackage extends Mock implements DiPackage {}

abstract class _PlatformNativeDirectoryBuilder {
  PlatformNativeDirectory call({required Platform platform});
}

class MockPlatformNativeDirectoryBuilder extends Mock
    implements _PlatformNativeDirectoryBuilder {}

class MockPlatformAppFeaturePackage extends Mock
    implements PlatformAppFeaturePackage {}

class MockPlatformNativeDirectory extends Mock
    implements PlatformNativeDirectory {}

class MockMainFile extends Mock implements MainFile {}

class MockAppPackage extends Mock implements AppPackage {}

abstract class _GeneratorBuilder {
  Future<MasonGenerator> call(MasonBundle bundle);
}

class MockGeneratorBuilder extends Mock implements _GeneratorBuilder {}

abstract class _FlutterGenl10nCommand {
  Future<void> call({
    required String cwd,
    required Logger logger,
  });
}

class MockFlutterGenL10nCommand extends Mock
    implements _FlutterGenl10nCommand {}

abstract class _LanguageLocalizationsFileBuilder {
  LanguageLocalizationsFile call({required String language});
}

class MockLanguageLocalizationsFileBuilder extends Mock
    implements _LanguageLocalizationsFileBuilder {}

class MockLocalizationsDelegatesFile extends Mock
    implements LocalizationsDelegatesFile {}

class MockL10nFile extends Mock implements L10nFile {}

class MockArbDirectory extends Mock implements ArbDirectory {}

class MockLanguageLocalizationsFile extends Mock
    implements LanguageLocalizationsFile {}

class MockPlatformFeaturePackage extends Mock
    implements PlatformFeaturePackage {}

class MockLanguageArbFile extends Mock implements LanguageArbFile {}

class MockMelosFile extends Mock implements MelosFile {}

class MockPlatformUiPackage extends Mock implements PlatformUiPackage {}

abstract class _DartFormatFixCommand {
  Future<void> call({
    String cwd,
    required Logger logger,
  });
}

class MockDartFormatFixCommand extends Mock implements _DartFormatFixCommand {}

class MockDomainPackage extends Mock implements DomainPackage {}

class MockEntity extends Mock implements Entity {}

class MockServiceInterface extends Mock implements ServiceInterface {}

class MockServiceImplementation extends Mock implements ServiceImplementation {}

class MockValueObject extends Mock implements ValueObject {}

class MockInfrastructurePackage extends Mock implements InfrastructurePackage {}

class MockInfoPlistFile extends Mock implements InfoPlistFile {}

abstract class _FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand {
  Future<void> call({
    String cwd,
    required Logger logger,
  });
}

class MockFlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
    extends Mock
    implements _FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand {}

abstract class _MelosBootstrapCommand {
  Future<void> call({
    String cwd,
    required Logger logger,
    List<String>? scope,
  });
}

class MockMelosBootstrapCommand extends Mock
    implements _MelosBootstrapCommand {}

abstract class _FlutterPubGet {
  Future<void> call({
    String cwd,
    required Logger logger,
  });
}

class MockFlutterPubGetCommand extends Mock implements _FlutterPubGet {}

class MockLoggingPackage extends Mock implements LoggingPackage {}

class MockUiPackage extends Mock implements UiPackage {}

abstract class _PlatformUiPackageBuilder {
  PlatformUiPackage call({required Platform platform});
}

class MockPlatformUiPackageBuilder extends Mock
    implements _PlatformUiPackageBuilder {}

class MockDataTransferObject extends Mock implements DataTransferObject {}

class MockWidget extends Mock implements Widget {}

class MockBloc extends Mock implements Bloc {}

class MockCubit extends Mock implements Cubit {}

class MockIosNativeDirectory extends Mock implements IosNativeDirectory {}

// Fakes

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

class FakeDirectoryGeneratorTarget extends Fake
    implements DirectoryGeneratorTarget {}

class FakeMasonBundle extends Fake implements MasonBundle {}

class FakeLogger extends Fake implements Logger {}

class FakePlatformCustomFeaturePackage extends Fake
    implements PlatformCustomFeaturePackage {}

// Common Mock Setups

MockProject getProject() {
  final project = MockProject();
  when(() => project.path).thenReturn('some/path');
  when(() => project.name()).thenReturn('some_name');

  return project;
}

MockMasonGenerator getMasonGenerator() {
  final generator = MockMasonGenerator();
  when(() => generator.id).thenReturn('some id');
  when(() => generator.description).thenReturn('some description');
  when(
    () => generator.generate(
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

  return generator;
}

MockGeneratorBuilder getGeneratorBuilder() {
  final generatorBuilder = MockGeneratorBuilder();
  when(() => generatorBuilder(any())).thenAnswer(
    (_) async => getMasonGenerator(),
  );

  return generatorBuilder;
}

MockDartFormatFixCommand getDartFormatFix() {
  final dartFormatFix = MockDartFormatFixCommand();
  when(
    () => dartFormatFix(
      cwd: any(named: 'cwd'),
      logger: any(named: 'logger'),
    ),
  ).thenAnswer((_) async {});

  return dartFormatFix;
}

MockAppPackage getAppPackage() {
  final appPackage = MockAppPackage();
  when(() => appPackage.path).thenReturn('some/path');
  when(() => appPackage.exists()).thenReturn(true);
  final project = getProject();
  when(() => appPackage.project).thenReturn(project);
  when(
    () => appPackage.create(
      description: any(named: 'description'),
      orgName: any(named: 'orgName'),
      language: any(named: 'language'),
      android: any(named: 'android'),
      ios: any(named: 'ios'),
      linux: any(named: 'linux'),
      macos: any(named: 'macos'),
      web: any(named: 'web'),
      windows: any(named: 'windows'),
      logger: any(named: 'logger'),
    ),
  ).thenAnswer((_) async {});
  when(
    () => appPackage.addPlatform(
      any(),
      description: any(named: 'description'),
      orgName: any(named: 'orgName'),
      logger: any(named: 'logger'),
    ),
  ).thenAnswer((_) async {});
  when(
    () => appPackage.removePlatform(
      any(),
      logger: any(named: 'logger'),
    ),
  ).thenAnswer((_) async {});

  return appPackage;
}

MockPubspecFile getPubspecFile() {
  final pubspecFile = MockPubspecFile();
  when(() => pubspecFile.readName()).thenReturn('some_name');

  return pubspecFile;
}

MockInjectionFile getInjectionFile() {
  final injectionFile = MockInjectionFile();

  return injectionFile;
}

MockDiPackage getDiPackage() {
  final diPackage = MockDiPackage();
  when(() => diPackage.path).thenReturn('some/path');
  when(() => diPackage.exists()).thenReturn(true);
  when(
    () => diPackage.create(
      android: any(named: 'android'),
      ios: any(named: 'ios'),
      linux: any(named: 'linux'),
      macos: any(named: 'macos'),
      web: any(named: 'web'),
      windows: any(named: 'windows'),
      logger: any(named: 'logger'),
    ),
  ).thenAnswer((_) async {});
  when(
    () => diPackage.registerCustomFeaturePackage(
      any(),
      logger: any(named: 'logger'),
    ),
  ).thenAnswer((_) async {});
  when(
    () => diPackage.unregisterCustomFeaturePackages(
      any(),
      logger: any(named: 'logger'),
    ),
  ).thenAnswer((_) async {});

  return diPackage;
}

MockPlatformCustomFeaturePackage getPlatformCustomFeaturePackage() {
  final platformCustomFeaturePackage = MockPlatformCustomFeaturePackage();
  when(() => platformCustomFeaturePackage.path).thenReturn('some/path');
  when(() => platformCustomFeaturePackage.name).thenReturn('some_feature_name');
  when(() => platformCustomFeaturePackage.packageName())
      .thenReturn('some_feature_package_name');
  when(
    () => platformCustomFeaturePackage.create(
      description: any(named: 'description'),
      defaultLanguage: any(named: 'defaultLanguage'),
      languages: any(named: 'languages'),
      logger: any(named: 'logger'),
    ),
  ).thenAnswer((_) async {});
  when(
    () => platformCustomFeaturePackage.addLanguage(
      language: any(named: 'language'),
      logger: any(named: 'logger'),
    ),
  ).thenAnswer((_) async {});
  when(
    () => platformCustomFeaturePackage.removeLanguage(
      language: any(named: 'language'),
      logger: any(named: 'logger'),
    ),
  ).thenAnswer((_) async {});
  when(
    () => platformCustomFeaturePackage.setDefaultLanguage(
      any(),
      logger: any(named: 'logger'),
    ),
  ).thenAnswer((_) async {});

  return platformCustomFeaturePackage;
}

MockPlatformRoutingFeaturePackage getPlatformRoutingFeaturePackage() {
  final platformRoutingFeaturePackage = MockPlatformRoutingFeaturePackage();
  when(() => platformRoutingFeaturePackage.path)
      .thenReturn('routing_feature/path');
  when(() => platformRoutingFeaturePackage.name)
      .thenReturn('routing_feature_name');
  when(() => platformRoutingFeaturePackage.packageName())
      .thenReturn('routing_feature_package_name');
  when(
    () => platformRoutingFeaturePackage.create(logger: any(named: 'logger')),
  ).thenAnswer((_) async {});
  when(
    () => platformRoutingFeaturePackage.registerCustomFeaturePackage(
      any(),
      logger: any(named: 'logger'),
    ),
  ).thenAnswer((_) async {});
  when(
    () => platformRoutingFeaturePackage.unregisterCustomFeaturePackage(
      any(),
      logger: any(named: 'logger'),
    ),
  ).thenAnswer((_) async {});

  return platformRoutingFeaturePackage;
}

MockPlatformUiPackage getPlatformUiPackage() {
  final platformUiPackage = MockPlatformUiPackage();
  when(() => platformUiPackage.exists()).thenReturn(true);
  when(
    () => platformUiPackage.create(logger: any(named: 'logger')),
  ).thenAnswer((_) async {});

  return platformUiPackage;
}

MockPlatformUiPackageBuilder getPlatformUiPackageBuilder() {
  final platformUiPackageBuilder = MockPlatformUiPackageBuilder();
  final platformUiPackage = getPlatformUiPackage();
  when(
    () => platformUiPackageBuilder(platform: any(named: 'platform')),
  ).thenReturn(platformUiPackage);

  return platformUiPackageBuilder;
}

MockPlatformNativeDirectory getPlatformNativeDirectory() {
  final platformNativeDirectory = MockPlatformNativeDirectory();
  when(
    () => platformNativeDirectory.create(
      description: any(named: 'description'),
      orgName: any(named: 'orgName'),
      language: any(named: 'language'),
      logger: any(named: 'logger'),
    ),
  ).thenAnswer((_) async {});

  return platformNativeDirectory;
}

MockPlatformNativeDirectoryBuilder getPlatfromNativeDirectoryBuilder() {
  final platformNativeDirectoryBuilder = MockPlatformNativeDirectoryBuilder();
  final platformNativeDirectory = getPlatformNativeDirectory();
  when(
    () => platformNativeDirectoryBuilder(platform: any(named: 'platform')),
  ).thenReturn(platformNativeDirectory);

  return platformNativeDirectoryBuilder;
}

MockPlatformDirectory getPlatformDirectory() {
  final platformDirectory = MockPlatformDirectory();
  when(() => platformDirectory.exists()).thenReturn(true);

  return platformDirectory;
}

MockBloc getBloc() {
  final bloc = MockBloc();
  when(
    () => bloc.create(logger: any(named: 'logger')),
  ).thenAnswer((_) async {});

  return bloc;
}

MockCubit getCubit() {
  final cubit = MockCubit();
  when(
    () => cubit.create(logger: any(named: 'logger')),
  ).thenAnswer((_) async {});

  return cubit;
}

MockWidget getWidget() {
  final widget = MockWidget();
  when(
    () => widget.create(logger: any(named: 'logger')),
  ).thenAnswer((_) async {});

  return widget;
}

MockPlatformDirectoryBuilder getPlatfromDirectoryBuilder() {
  final platformDirectoryBuilder = MockPlatformDirectoryBuilder();
  final platformDirectory = getPlatformDirectory();
  when(
    () => platformDirectoryBuilder(platform: any(named: 'platform')),
  ).thenReturn(platformDirectory);

  return platformDirectoryBuilder;
}

MockMainFile getMainFile() {
  final mainFile = MockMainFile();

  return mainFile;
}

MockPlatformAppFeaturePackage getPlatformAppFeaturePackage() {
  final appFeaturePackage = MockPlatformAppFeaturePackage();
  when(() => appFeaturePackage.path).thenReturn('some/path');
  when(
    () => appFeaturePackage.create(
      defaultLanguage: any(named: 'defaultLanguage'),
      languages: any(named: 'languages'),
      logger: any(named: 'logger'),
    ),
  ).thenAnswer((_) async {});
  when(
    () => appFeaturePackage.registerCustomFeaturePackage(
      any(),
      logger: any(named: 'logger'),
    ),
  ).thenAnswer((_) async {});
  when(
    () => appFeaturePackage.unregisterCustomFeaturePackage(
      any(),
      logger: any(named: 'logger'),
    ),
  ).thenAnswer((_) async {});
  when(
    () => appFeaturePackage.addLanguage(
      language: any(named: 'language'),
      logger: any(named: 'logger'),
    ),
  ).thenAnswer((_) async {});
  when(
    () => appFeaturePackage.removeLanguage(
      language: any(named: 'language'),
      logger: any(named: 'logger'),
    ),
  ).thenAnswer((_) async {});
  when(
    () => appFeaturePackage.setDefaultLanguage(
      any(),
      logger: any(named: 'logger'),
    ),
  ).thenAnswer((_) async {});

  return appFeaturePackage;
}

MockLocalizationsDelegatesFile getLocalizationsDelegatesFile() {
  final localizationsDelegatesFile = MockLocalizationsDelegatesFile();

  return localizationsDelegatesFile;
}

MockL10nFile getL10nFile() {
  final l10nFile = MockL10nFile();

  return l10nFile;
}

MockFlutterGenL10nCommand getFlutterGenl10n() {
  final flutterGenL10n = MockFlutterGenL10nCommand();
  when(
    () => flutterGenL10n(cwd: any(named: 'cwd'), logger: any(named: 'logger')),
  ).thenAnswer((_) async {});

  return flutterGenL10n;
}

MockArbDirectory getArbDirectory() {
  final arbDirectory = MockArbDirectory();
  when(() => arbDirectory.path).thenReturn('some/path');
  final platformFeaturePackage = getPlatformCustomFeaturePackage();
  when(() => arbDirectory.platformCustomizableFeaturePackage)
      .thenReturn(platformFeaturePackage);
  final languageArbFile = getLanguageArbFile();
  when(
    () => arbDirectory.languageArbFile(
      language: any(named: 'language'),
    ),
  ).thenReturn(languageArbFile);

  return arbDirectory;
}

MockLanguageLocalizationsFile getLanguageLocalizationsFile() {
  final languageLocalizationsFile = MockLanguageLocalizationsFile();

  return languageLocalizationsFile;
}

MockLanguageArbFile getLanguageArbFile() {
  final arbLanguageFile = MockLanguageArbFile();
  when(() => arbLanguageFile.exists()).thenReturn(true);
  when(() => arbLanguageFile.create(logger: any(named: 'logger')))
      .thenAnswer((_) async {});

  return arbLanguageFile;
}

MockDomainPackage getDomainPackage() {
  final domainPackage = MockDomainPackage();
  when(() => domainPackage.path).thenReturn('some/path');
  when(() => domainPackage.exists()).thenReturn(true);
  when(
    () => domainPackage.create(logger: any(named: 'logger')),
  ).thenAnswer((_) async {});

  return domainPackage;
}

MockEntity getEntity() {
  final entity = MockEntity();
  when(
    () => entity.create(logger: any(named: 'logger')),
  ).thenAnswer((_) async {});

  return entity;
}

MockServiceInterface getServiceInterface() {
  final serviceInterface = MockServiceInterface();
  when(
    () => serviceInterface.create(logger: any(named: 'logger')),
  ).thenAnswer((_) async {});

  return serviceInterface;
}

MockServiceImplementation getServiceImplementation() {
  final serviceImplementation = MockServiceImplementation();
  when(
    () => serviceImplementation.create(logger: any(named: 'logger')),
  ).thenAnswer((_) async {});

  return serviceImplementation;
}

MockValueObject getValueObject() {
  final valueObject = MockValueObject();
  when(
    () => valueObject.create(
      type: any(named: 'type'),
      generics: any(named: 'generics'),
      logger: any(named: 'logger'),
    ),
  ).thenAnswer((_) async {});

  return valueObject;
}

MockInfrastructurePackage getInfrastructurePackage() {
  final infrastructurePackage = MockInfrastructurePackage();
  when(() => infrastructurePackage.path).thenReturn('some/path');
  when(() => infrastructurePackage.exists()).thenReturn(true);
  when(
    () => infrastructurePackage.create(logger: any(named: 'logger')),
  ).thenAnswer((_) async {});

  return infrastructurePackage;
}

MockFlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
    getFlutterPubRunBuildRunnerBuildDeleteConflictingOutputs() {
  final flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
      MockFlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand();

  when(
    () => flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
      cwd: any(named: 'cwd'),
      logger: any(named: 'logger'),
    ),
  ).thenAnswer((_) async {});

  return flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;
}

MockMelosBootstrapCommand getMelosBootstrap() {
  final melosBootstrap = MockMelosBootstrapCommand();
  when(
    () => melosBootstrap(
      cwd: any(named: 'cwd'),
      logger: any(named: 'logger'),
      scope: any(named: 'scope'),
    ),
  ).thenAnswer((_) async {});

  return melosBootstrap;
}

MockFlutterPubGetCommand getFlutterPubGet() {
  final flutterPubGet = MockFlutterPubGetCommand();
  when(
    () => flutterPubGet(
      cwd: any(named: 'cwd'),
      logger: any(named: 'logger'),
    ),
  ).thenAnswer((_) async {});

  return flutterPubGet;
}

MockMelosFile getMelosFile() {
  final melosFile = MockMelosFile();
  when(() => melosFile.path).thenReturn('some/path');
  when(() => melosFile.readName()).thenReturn('some_name');
  when(() => melosFile.exists()).thenReturn(true);

  return melosFile;
}

MockLoggingPackage getLoggingPackage() {
  final loggingPackage = MockLoggingPackage();
  when(() => loggingPackage.path).thenReturn('some/path');
  when(
    () => loggingPackage.create(logger: any(named: 'logger')),
  ).thenAnswer((_) async {});

  return loggingPackage;
}

MockUiPackage getUiPackage() {
  final uiPackage = MockUiPackage();
  when(() => uiPackage.path).thenReturn('some/path');
  when(() => uiPackage.exists()).thenReturn(true);
  when(
    () => uiPackage.create(logger: any(named: 'logger')),
  ).thenAnswer((_) async {});

  return uiPackage;
}

MockPlatformDirectoryBuilder getPlatformDirectoryBuilder() {
  final platformDirectoryBuilder = MockPlatformDirectoryBuilder();
  final platfromDirectory = getPlatformDirectory();
  when(
    () => platformDirectoryBuilder(platform: any(named: 'platform')),
  ).thenReturn(platfromDirectory);

  return platformDirectoryBuilder;
}

MockDataTransferObject getDataTransferObject() {
  final dataTransferObject = MockDataTransferObject();
  when(
    () => dataTransferObject.create(logger: any(named: 'logger')),
  ).thenAnswer((_) async {});

  return dataTransferObject;
}

MockIosNativeDirectory getIosNativeDirectory() {
  final iosNativeDirectory = MockIosNativeDirectory();
  when(() => iosNativeDirectory.path).thenReturn('some/path');
  when(
    () => iosNativeDirectory.create(logger: any(named: 'logger')),
  ).thenAnswer((_) async {});

  return iosNativeDirectory;
}

MockInfoPlistFile getInfoPlistFile() {
  final infoPlistFile = MockInfoPlistFile();

  return infoPlistFile;
}
