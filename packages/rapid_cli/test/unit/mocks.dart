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
import 'package:rapid_cli/src/project/platform_directory/platform_directory.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_feature_package/platform_feature_package.dart';
import 'package:rapid_cli/src/project/platform_ui_package/platform_ui_package.dart';
import 'package:rapid_cli/src/project/project.dart';

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

class MockLocalizationsFile extends Mock implements LocalizationsFile {}

class MockL10nFile extends Mock implements L10nFile {}

class MockArbDirectory extends Mock implements ArbDirectory {}

class MockLanguageLocalizationsFile extends Mock
    implements LanguageLocalizationsFile {}

class MockPlatformFeaturePackage extends Mock
    implements PlatformFeaturePackage {}

class MockArbFile extends Mock implements ArbFile {}

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

class MockInfrastructurePackage extends Mock implements InfrastructurePackage {}

abstract class _FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand {
  Future<void> call({
    String cwd,
    required Logger logger,
  });
}

class MockFlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
    extends Mock
    implements _FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand {}

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
  final project = getProject();
  when(() => appPackage.project).thenReturn(project);

  return appPackage;
}

MockPubspecFile getPubspecFile() {
  final pubspecFile = MockPubspecFile();

  return pubspecFile;
}

MockInjectionFile getInjectionFile() {
  final injectionFile = MockInjectionFile();

  return injectionFile;
}

MockDiPackage getDiPackage() {
  final diPackage = MockDiPackage();
  when(() => diPackage.path).thenReturn('some/path');

  return diPackage;
}

MockPlatformCustomFeaturePackage getPlatformCustomFeaturePackage() {
  final platformCustomFeaturePackage = MockPlatformCustomFeaturePackage();
  when(() => platformCustomFeaturePackage.path).thenReturn('some/path');
  when(() => platformCustomFeaturePackage.name).thenReturn('some_feature_name');
  when(() => platformCustomFeaturePackage.packageName())
      .thenReturn('some_feature_package_name');

  return platformCustomFeaturePackage;
}

MockPlatformUiPackage getPlatformUiPackage() {
  final platformUiPackage = MockPlatformUiPackage();

  return platformUiPackage;
}

MockPlatformNativeDirectory getPlatformNativeDirectory() {
  final platformNativeDirectory = MockPlatformNativeDirectory();
  when(
    () => platformNativeDirectory.create(
      description: any(named: 'description'),
      orgName: any(named: 'orgName'),
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

  return platformDirectory;
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

  return appFeaturePackage;
}

MockLocalizationsFile getLocalizationsFile() {
  final localizationsFile = MockLocalizationsFile();

  return localizationsFile;
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
  when(() => arbDirectory.platformFeaturePackage)
      .thenReturn(platformFeaturePackage);

  return arbDirectory;
}

MockLanguageLocalizationsFile getLanguageLocalizationsFile() {
  final languageLocalizationsFile = MockLanguageLocalizationsFile();

  return languageLocalizationsFile;
}

MockArbFile getArbFile() {
  final arbFile = MockArbFile();

  return arbFile;
}

MockDomainPackage getDomainPackage() {
  final domainPackage = MockDomainPackage();
  when(() => domainPackage.path).thenReturn('some/path');

  return domainPackage;
}

MockInfrastructurePackage getInfrastructurePackage() {
  final infrastructurePackage = MockInfrastructurePackage();
  when(() => infrastructurePackage.path).thenReturn('some/path');

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
