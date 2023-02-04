import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/app_package/app_package.dart';
import 'package:rapid_cli/src/project/app_package/platform_native_directory/platform_native_directory.dart';
import 'package:rapid_cli/src/project/di_package/di_package.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_directory.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_feature_package/platform_feature_package.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:universal_io/io.dart';

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
