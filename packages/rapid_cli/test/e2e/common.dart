import 'dart:async';
import 'dart:io';

import 'package:io/io.dart' show copyPath;
import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

/// Runs [fn] in a temporary directory.
///
/// The directory from where the test is executed is passed to [fn] via [root].
/// This can be used to access fixtures and more.
dynamic Function() withTempDir(FutureOr<void> Function(Directory root) fn) {
  return () async {
    final cwd = Directory.current;
    final dir = Directory(p.join('.dart_tool', 'test', 'tmp'));
    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }
    dir.createSync(recursive: true);

    Directory.current = dir;
    try {
      await fn(cwd);
    } catch (_) {
      rethrow;
    } finally {
      // TODO this might influence exceptions that dependen on file system
      // We used to delete dir here but that lead to some tests fail in ci
      Directory.current = cwd;
    }
  };
}

class FixtureNotFound implements Exception {}

final class RapidE2ETester {
  late final String projectName;

  RapidE2ETester(this.projectName);

  /// Create a [RapidE2ETester] having a project with [activatedPlatform] setup in cwd.
  ///
  /// If [activatedPlatform] is null NO platform will be activated.
  static Future<RapidE2ETester> withProject(
    Directory root, [
    Platform? activatedPlatform,
  ]) async {
    final tester = RapidE2ETester(
      activatedPlatform != null
          ? 'project_${activatedPlatform.name}'
          : 'project_none',
    );
    final dir = Directory(
      p.join(root.path, 'test', 'e2e', 'fixtures', tester.projectName),
    );
    if (dir.existsSync()) {
      await copyPath(dir.path, Directory.current.path);

      final dirsWithPubspec = Directory.current
          .listSync(recursive: true)
          .where((e) => e is File && e.path.endsWith('pubspec.yaml'))
          .map((e) => e.parent);
      for (final dirWithPubspec in dirsWithPubspec) {
        await Process.run(
          'flutter',
          ['pub', 'get'],
          workingDirectory: dirWithPubspec.path,
        );
      }

      return tester;
    }

    throw FixtureNotFound();
  }

  /// Runs a rapid command with [args].
  ///
  /// For example:
  /// Runs `rapid activate android` for `args = ['activate', 'android']`
  Future<void> runRapidCommand(List<String> args) async {
    final commandRunner = RapidCommandRunner(
      // TODO this is not perfact as resolveProject should be private
      project: await resolveProject(
        args,
        args.first == 'create' ? null : Directory.current,
      ),
    );

    await commandRunner.run(args);
  }

  Directory get diPackage =>
      Directory(p.join('packages', projectName, '${projectName}_di'));

  Directory get domainDirectory =>
      Directory(p.join('packages', projectName, '${projectName}_domain'));

  Directory get infrastructureDirectory => Directory(
      p.join('packages', projectName, '${projectName}_infrastructure'));

  Directory get loggingPackage =>
      Directory(p.join('packages', projectName, '${projectName}_logging'));

  Directory domainPackage([String? name]) {
    name = name == 'default' ? null : name;
    return Directory(
      p.join(
        domainDirectory.path,
        '${projectName}_domain${name != null ? '_$name' : ''}',
      ),
    );
  }

  Directory infrastructurePackage([String? name]) {
    name = name == 'default' ? null : name;
    return Directory(
      p.join(
        infrastructureDirectory.path,
        '${projectName}_infrastructure${name != null ? '_$name' : ''}',
      ),
    );
  }

  Directory platformDir(Platform platform) => Directory(
      p.join('packages', projectName, '${projectName}_${platform.name}'));

  Directory platformRootPackage(Platform platform) => Directory(
        p.join(
          'packages',
          projectName,
          '${projectName}_${platform.name}',
          '${projectName}_${platform.name}',
        ),
      );

  Directory platformFeaturesDir(Platform platform) => Directory(
        p.join(
          'packages',
          projectName,
          '${projectName}_${platform.name}',
          '${projectName}_${platform.name}_features',
        ),
      );

  Directory featurePackage(String name, Platform platform) => Directory(
        p.join(
          platformFeaturesDir(platform).path,
          '${projectName}_${platform.name}_$name',
        ),
      );

  Directory platformLocalizationPackage(Platform platform) => Directory(
        p.join(
          'packages',
          projectName,
          '${projectName}_${platform.name}',
          '${projectName}_${platform.name}_localization',
        ),
      );

  Directory platformNavigationPackage(Platform platform) => Directory(
        p.join(
          'packages',
          projectName,
          '${projectName}_${platform.name}',
          '${projectName}_${platform.name}_navigation',
        ),
      );

  Directory get uiPackage =>
      Directory(p.join('packages', '${projectName}_ui', '${projectName}_ui'));

  Directory platformUiPackage(Platform platform) => Directory(
        p.join(
          'packages',
          '${projectName}_ui',
          '${projectName}_ui_${platform.name}',
        ),
      );

  List<Directory> get platformIndependentPackages => [
        diPackage,
        loggingPackage,
        uiPackage,
        domainPackage(),
        infrastructurePackage(),
      ];

  List<Directory> platformDependentPackagesWithTests(Platform platform) => [
        platformRootPackage(platform),
        platformUiPackage(platform),
      ];

  List<Directory> platformDependentPackagesWithoutTests(Platform platform) => [
        platformLocalizationPackage(platform),
        platformNavigationPackage(platform),
      ];

  List<Directory> platformDependentPackages(Platform platform) => [
        ...platformDependentPackagesWithTests(platform),
        ...platformDependentPackagesWithoutTests(platform),
      ];

  List<Directory> get allPlatformDependentPackages => [
        for (final platform in Platform.values) ...[
          ...platformDependentPackages(platform),
        ],
      ];

  List<File> blocFiles({
    required String name,
    required String featureName,
    required Platform platform,
    String? outputDir,
  }) =>
      [
        File(
          p.join(
            featurePackage(featureName, platform).path,
            'lib',
            'src',
            'application',
            outputDir ?? '',
            '${name.snakeCase}_bloc.dart',
          ),
        ),
        File(
          p.join(
            featurePackage(featureName, platform).path,
            'lib',
            'src',
            'application',
            outputDir ?? '',
            '${name.snakeCase}_bloc.freezed.dart',
          ),
        ),
        File(
          p.join(
            featurePackage(featureName, platform).path,
            'lib',
            'src',
            'application',
            outputDir ?? '',
            '${name.snakeCase}_event.dart',
          ),
        ),
        File(
          p.join(
            featurePackage(featureName, platform).path,
            'lib',
            'src',
            'application',
            outputDir ?? '',
            '${name.snakeCase}_state.dart',
          ),
        ),
      ];

  List<File> cubitFiles({
    required String name,
    required String featureName,
    required Platform platform,
    String? outputDir,
  }) =>
      [
        File(
          p.join(
            featurePackage(featureName, platform).path,
            'lib',
            'src',
            'application',
            outputDir ?? '',
            '${name.snakeCase}_cubit.dart',
          ),
        ),
        File(
          p.join(
            featurePackage(featureName, platform).path,
            'lib',
            'src',
            'application',
            outputDir ?? '',
            '${name.snakeCase}_cubit.freezed.dart',
          ),
        ),
        File(
          p.join(
            featurePackage(featureName, platform).path,
            'lib',
            'src',
            'application',
            outputDir ?? '',
            '${name.snakeCase}_state.dart',
          ),
        ),
      ];

  File applicationBarrelFile({
    required String featureName,
    required Platform platform,
  }) =>
      File(
        p.join(
          featurePackage(featureName, platform).path,
          'lib',
          'src',
          'application',
          'application.dart',
        ),
      );

  List<File> navigatorFiles({
    required String featureName,
    required Platform platform,
  }) =>
      [
        File(
          p.join(
            platformNavigationPackage(platform).path,
            'lib',
            'src',
            'i_${featureName.snakeCase}_navigator.dart',
          ),
        ),
      ];

  List<File> navigatorImplementationFiles({
    required String featureName,
    required Platform platform,
  }) =>
      [
        File(
          p.join(
            featurePackage(featureName, platform).path,
            'lib',
            'src',
            'presentation',
            'navigator.dart',
          ),
        ),
        File(
          p.join(
            featurePackage(featureName, platform).path,
            'test',
            'src',
            'presentation',
            'navigator_test.dart',
          ),
        ),
      ];

  List<File> entityFiles({
    required String name,
    String? subDomainName,
    String? outputDir,
  }) {
    subDomainName = subDomainName == 'default' ? null : subDomainName;
    return [
      File(p.join(domainPackage(subDomainName).path, 'lib', 'src',
          outputDir ?? '', '${name.snakeCase}.dart')),
      File(p.join(domainPackage(subDomainName).path, 'lib', 'src',
          outputDir ?? '', '${name.snakeCase}.freezed.dart')),
      File(p.join(domainPackage(subDomainName).path, 'test', 'src',
          outputDir ?? '', '${name.snakeCase}_test.dart')),
    ];
  }

  List<File> valueObjectFiles({
    required String name,
    String? subDomainName,
    String? outputDir,
  }) {
    subDomainName = subDomainName == 'default' ? null : subDomainName;
    return [
      File(p.join(domainPackage(subDomainName).path, 'lib', 'src',
          outputDir ?? '', '${name.snakeCase}.dart')),
      File(p.join(domainPackage(subDomainName).path, 'lib', 'src',
          outputDir ?? '', '${name.snakeCase}.freezed.dart')),
      File(p.join(domainPackage(subDomainName).path, 'test', 'src',
          outputDir ?? '', '${name.snakeCase}_test.dart')),
    ];
  }

  List<File> serviceInterfaceFiles({
    required String name,
    String? subDomainName,
    String? outputDir,
  }) {
    subDomainName = subDomainName == 'default' ? null : subDomainName;
    return [
      File(p.join(domainPackage(subDomainName).path, 'lib', 'src',
          outputDir ?? '', 'i_${name.snakeCase}_service.dart')),
      File(p.join(domainPackage(subDomainName).path, 'lib', 'src',
          outputDir ?? '', 'i_${name.snakeCase}_service.freezed.dart')),
    ];
  }

  List<File> dataTransferObjectFiles({
    required String entity,
    String? subInfrastructureName,
    String? outputDir,
  }) {
    subInfrastructureName =
        subInfrastructureName == 'default' ? null : subInfrastructureName;
    return [
      File(p.join(infrastructurePackage(subInfrastructureName).path, 'lib',
          'src', outputDir ?? '', '${entity.snakeCase}_dto.dart')),
      File(p.join(infrastructurePackage(subInfrastructureName).path, 'lib',
          'src', outputDir ?? '', '${entity.snakeCase}_dto.freezed.dart')),
      File(p.join(infrastructurePackage(subInfrastructureName).path, 'lib',
          'src', outputDir ?? '', '${entity.snakeCase}_dto.g.dart')),
      File(p.join(infrastructurePackage(subInfrastructureName).path, 'test',
          'src', outputDir ?? '', '${entity.snakeCase}_dto_test.dart')),
    ];
  }

  List<File> serviceImplementationFiles({
    required String name,
    required String serviceName,
    String? subInfrastructureName,
    String? outputDir,
  }) {
    subInfrastructureName =
        subInfrastructureName == 'default' ? null : subInfrastructureName;
    return [
      File(
        p.join(
          infrastructurePackage(subInfrastructureName).path,
          'lib',
          'src',
          outputDir ?? '',
          '${name.snakeCase}_${serviceName.snakeCase}_service.dart',
        ),
      ),
      File(
        p.join(
          infrastructurePackage(subInfrastructureName).path,
          'test',
          'src',
          outputDir ?? '',
          '${name.snakeCase}_${serviceName.snakeCase}_service_test.dart',
        ),
      ),
    ];
  }

  List<File> widgetFiles({
    required String name,
    Platform? platform,
  }) =>
      [
        File(
          p.join(
            platform != null
                ? platformUiPackage(platform).path
                : uiPackage.path,
            'lib',
            'src',
            '${name.snakeCase}_theme.dart',
          ),
        ),
        File(
          p.join(
            platform != null
                ? platformUiPackage(platform).path
                : uiPackage.path,
            'lib',
            'src',
            '${name.snakeCase}_theme.tailor.dart',
          ),
        ),
        File(
          p.join(
            platform != null
                ? platformUiPackage(platform).path
                : uiPackage.path,
            'lib',
            'src',
            '${name.snakeCase}.dart',
          ),
        ),
        File(
          p.join(
            platform != null
                ? platformUiPackage(platform).path
                : uiPackage.path,
            'test',
            'src',
            '${name.snakeCase}_theme_test.dart',
          ),
        ),
        File(
          p.join(
            platform != null
                ? platformUiPackage(platform).path
                : uiPackage.path,
            'test',
            'src',
            '${name.snakeCase}_test.dart',
          ),
        ),
      ];

  /// Source files of a platform localization package to support [languages].
  List<File> languageFiles(
    Platform platform,
    List<String> languages,
  ) =>
      [
        for (final language in languages) ...[
          File(
            p.join(
              platformLocalizationPackage(platform).path,
              'lib',
              'src',
              'arb',
              '${projectName}_$language.arb',
            ),
          ),
          File(
            p.join(
              platformLocalizationPackage(platform).path,
              'lib',
              'src',
              '${projectName}_localizations_$language.dart',
            ),
          ),
        ],
      ];

  File get dotRapidToolGroupFile => File(p.join('.rapid_tool', 'group.json'));
}

extension IterableX<E extends FileSystemEntity> on Iterable<E> {
  /// All entities inside this without [iterable].
  Iterable<E> without(Iterable<E> iterable) =>
      where((e) => !iterable.any((element) => e.path == element.path));

  /// Creates all entities inside this.
  void create() {
    for (final e in this) {
      if (e is Directory) {
        e.createSync(recursive: true);
      } else {
        (e as File).createSync(recursive: true);
      }
    }
  }
}

/// Verifys whether ALL [entities] exist on disk.
void verifyDoExist(Iterable<FileSystemEntity> entities) {
  for (final entity in entities) {
    _println('Verify does exist ${entity.path}\n');

    expect(entity.existsSync(), true);
  }
}

/// Verifys whether NONE of [entities] exist on disk.
void verifyDoNotExist(Iterable<FileSystemEntity> entities) {
  for (final entity in entities) {
    _println('Verify does NOT exist ${entity.path}\n');

    expect(entity.existsSync(), false);
  }
}

/// Verifys that tests in [dirs] pass with 100 % test coverage.
///
/// Runs `flutter test --coverage` in every provided dir.
Future<void> verifyTestsPassWith100PercentCoverage(
  Iterable<Directory> dirs,
) async {
  for (final dir in dirs) {
    await verifyTestsPass(dir);
  }
}

/// Verifys that tests in [dir] pass with [expectedFailedTests] failed tests
/// and [expectedCoverage] % test coverage.
Future<void> verifyTestsPass(
  Directory dir, {
  int expectedFailedTests = 0,
  double expectedCoverage = 100,
}) async {
  final testResult = await _runFlutterOrDartTest(cwd: dir.path);

  expect(testResult.failedTests, expectedFailedTests);
  expect(testResult.coverage, expectedCoverage);
}

/// Verifys that no element in [dirs] has a test directory with test files in it.
///
/// This passes if no test dir, only empty test/ or test contains empty src/ and/or a mocks.dart exists.
void verifyDoNotHaveTests(
  Iterable<Directory> dirs,
) {
  for (final dir in dirs) {
    _println('Verify does NOT have tests ${dir.path}\n');

    late bool hasNoTests;
    final testDir = Directory(p.join(dir.path, 'test'));
    if (testDir.existsSync()) {
      final testDirSubEntities = testDir.listSync();
      if (testDirSubEntities.isEmpty) {
        hasNoTests = true;
      } else {
        if (testDirSubEntities.length == 2) {
          final testSrcDir = Directory(p.join(dir.path, 'test', 'src'));
          final mocksFile = File(p.join(dir.path, 'test', 'mocks.dart'));
          if (testSrcDir.existsSync() &&
              testSrcDir.listSync().isEmpty &&
              mocksFile.existsSync()) {
            hasNoTests = true;
          } else {
            hasNoTests = false;
          }
        } else if (testDirSubEntities.length == 1) {
          final testSrcDir = Directory(p.join(dir.path, 'test', 'src'));
          final mocksFile = File(p.join(dir.path, 'test', 'mocks.dart'));
          if ((testSrcDir.existsSync() && testSrcDir.listSync().isEmpty) ||
              mocksFile.existsSync()) {
            hasNoTests = true;
          } else {
            hasNoTests = false;
          }
        } else {
          hasNoTests = false;
        }
      }
    } else {
      hasNoTests = true;
    }

    expect(hasNoTests, true);
  }
}

/// Verify that no analyzer issues are found in current directory.
Future<void> verifyNoAnalyzerIssues() async {
  final analyzerIssues = await _runFlutterAnalyze();
  expect(analyzerIssues, 0);
}

/// Verify that no formatting issues are found in current directory.
Future<void> verifyNoFormattingIssues() async {
  final formatIssues = await _runDartFormat();
  expect(formatIssues, 0);
}

/// The device id of the device ios e2e test run on
///
/// This gets passed via -d to a flutter command
///
/// This is needed because of https://github.com/flutter/flutter/issues/117158
const _iosDevice = 'iPhone 11';

/// Thrown when [_runFlutterOrDartTest] didnt find a test directory.
class TestDirNotFound implements Exception {}

class TestResult {
  TestResult(this.failedTests, this.coverage);

  final int failedTests;

  final double? coverage;
}

// TODO(jtdLab): refactor this using https://pub.dev/packages/coverage/install

/// Runs `flutter` or `dart` test` in [cwd].
///
/// If [coverage] is true runs with `--coverage`
Future<TestResult> _runFlutterOrDartTest({
  required String cwd,
  bool coverage = true,
}) async {
  // TODO(jtdLab): required because of https://github.com/dart-lang/test/issues/1977
  final pubspec = File(p.join(cwd, 'pubspec.yaml'));
  final content = pubspec.readAsStringSync();
  final hasFlutterTest = content.contains('flutter_test:');

  late ProcessResult result;
  if (hasFlutterTest) {
    _println(
        'Run "flutter test --run-skipped --update-goldens${coverage ? ' --coverage' : ''}" in $cwd\n');

    result = await Process.run(
      'flutter',
      [
        'test',
        '--run-skipped',
        '--update-goldens',
        if (coverage) '--coverage',
      ],
      workingDirectory: cwd,
      runInShell: true,
    );
  } else {
    _println('Run "test_with_coverage" in $cwd\n');

    result = await Process.run(
      'test_with_coverage',
      [],
      workingDirectory: cwd,
      runInShell: true,
    );
  }

  final String stderr = result.stderr;
  final String stdout = result.stdout;
  if (stderr.contains('Test directory "test" not found')) {
    throw TestDirNotFound();
  }

  double? totalCoverage;
  if (coverage) {
    await Process.run(
      'remove_from_coverage',
      [
        '-f',
        p.join('coverage', 'lcov.info'),
        '-r',
        '.freezed.dart\$',
        '-r',
        '.g.dart\$',
        '-r',
        '.config.dart\$',
        '-r',
        '.module.dart\$',
        '-r',
        '_localizations.dart\$',
        '-r',
        '_localizations_[a-z]+.dart\$',
        '-r',
        '.gr.dart\$',
        '-r',
        '.tailor.dart\$',
      ],
      workingDirectory: cwd,
      runInShell: true,
    );

    final coverageResult = await Process.run(
      'test_cov_console',
      ['-t'],
      workingDirectory: cwd,
      runInShell: true,
    );

    // 100.00 when empty lcov
    totalCoverage = double.tryParse(
      (coverageResult.stdout as String).replaceAll('.00', '.0'),
    );
  }

  if (!stderr.contains('Some tests failed') &&
      (stdout.contains('All tests passed') ||
          stdout.contains(RegExp(r'[1-9][0-9]* tests? passed')))) {
    return TestResult(0, totalCoverage);
  }

  _printSummary(result);

  final regExp = RegExp(r'-([0-9]+): Some tests failed');
  final match = regExp.firstMatch(stderr) ?? regExp.firstMatch(stdout);
  return TestResult(int.parse(match?.group(1) ?? '0'), totalCoverage);
}

/// Runs integration tests at [pathToTests] from [cwd]  using the required mechanism described at https://docs.flutter.dev/testing/integration-tests
/// for the given [platform].
///
/// Returns the amount of failed tests.
Future<int> runFlutterIntegrationTest(
  Directory dir, {
  String pathToTests = '.',
  required Platform platform,
}) async {
  final cwd = dir.path;
  late final ProcessResult result;
  if (platform == Platform.web) {
    await Process.start(
      'chromedriver',
      ['--port=4444'],
      workingDirectory: cwd,
      runInShell: true,
    );
    result = await Process.run(
      'flutter',
      [
        'drive',
        '--driver',
        'test_driver/integration_test.dart',
        '--target',
        pathToTests,
        '-d',
        'web-server'
      ],
      workingDirectory: cwd,
      runInShell: true,
    );
  } else {
    final device = platform == Platform.ios ? _iosDevice : platform.name;
    result = await Process.run(
      'flutter',
      ['test', pathToTests, '-d', device],
      workingDirectory: cwd,
      runInShell: true,
    );
  }

  final String stderr = result.stderr;
  final String stdout = result.stdout;
  if (stderr.contains('Test directory "test" not found')) {
    throw TestDirNotFound();
  }

  if (!stderr.contains('Some tests failed') &&
      (stdout.contains('All tests passed') ||
          stdout.contains(RegExp(r'[1-9][0-9]* tests? passed')))) {
    return 0;
  }

  _printSummary(result);

  final regExp = RegExp(r'-([0-9]+): Some tests failed');
  final match = regExp.firstMatch(stderr) ?? regExp.firstMatch(stdout)!;
  return int.parse(match.group(1)!);
}

/// Run `flutter analyze` in [cwd].
///
/// Returns the amount of analyzer issues.
Future<int> _runFlutterAnalyze({
  String cwd = '.',
}) async {
  _println('Run "flutter analyze" in $cwd\n');

  final result = await Process.run(
    'flutter',
    ['analyze'],
    workingDirectory: cwd,
    runInShell: true,
  );

  final String stderr = result.stderr;
  if (stderr.isEmpty) {
    return 0;
  }

  _printSummary(result);

  final regExp = RegExp(r'([0-9]+) issues? found');
  final match = regExp.firstMatch(stderr)!;
  return int.parse(match.group(1)!);
}

/// Run `dart format . --set-exit-if-changed` in [cwd].
///
/// Returns the exit code of the process.
Future<int> _runDartFormat({
  String cwd = '.',
}) async {
  _println('Run "dart format . --set-exit-if-changed" in $cwd\n');

  final result = await Process.run(
    'dart',
    ['format', '.', '--set-exit-if-changed'],
    workingDirectory: cwd,
    runInShell: true,
  );

  _printSummary(result);

  return result.exitCode;
}

void _printSummary(ProcessResult result) {
  final exitCode = result.exitCode;
  final String stdout = result.stdout;
  final String stderr = result.stderr;

  if (exitCode == 0) {
    _println('Exited with 0.');
  } else {
    if (stdout.isNotEmpty) {
      _println(stdout.trimTrailingNewLines());
    }
    if (stderr.isNotEmpty) {
      _errPrintln('${stderr.trimTrailingNewLines()}\n');
    }
    _errPrintln('Exited with ${result.exitCode}.');
  }
}

final _verbose = bool.fromEnvironment('verbose', defaultValue: true);

void _println(String? object) => _verbose ? stdout.writeln(object) : null;

void _errPrintln(String? object) => _verbose ? stderr.writeln(object) : null;

extension on String {
  String trimTrailingNewLines() {
    final regExp = RegExp('[\n]+');
    final matches = regExp.allMatches(this);
    if (matches.isEmpty) {
      return this;
    }

    final lastMatch = matches.last;
    final start = lastMatch.start;
    if (substring(start).split('').every((e) => e == '\n')) {
      return substring(0, start);
    }

    return this;
  }
}
