import 'dart:io';

import 'package:io/io.dart' show copyPath;
import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

/// The directory `flutter/dart test` was called from.
///
/// **IMPORTANT**: This should be the rapid_cli package.
/// If it is not fixtures can not be loaded and e2e tests might fail.
///
/// Store the directory `flutter test` or `dart test` was called from like this:
///
/// ```dart
/// group(
///   'E2E',
///   () {
///     cwd = Directory.current;
///
///     // e2e testing here
///   }
/// );
/// ```
late Directory cwd;

String tempPath = p.join(cwd.path, '.dart_tool', 'test', 'tmp');
String fixturesPath = p.join(cwd.path, 'test', 'e2e', 'fixtures');

Directory getTempDir() {
  final dir = Directory(tempPath);
  if (dir.existsSync()) {
    dir.deleteSync(recursive: true);
  }
  dir.createSync(recursive: true);
  return dir;
}

class FixtureNotFound implements Exception {}

Directory _getFixture(String name) {
  final dir = Directory(p.join(fixturesPath, name));
  if (dir.existsSync()) {
    return dir;
  }
  throw FixtureNotFound();
}

/// Set up a Rapid test project in the cwd with [activatedPlatform] platform activated.
///
/// If [activatedPlatform] is null NO platform will be activated.
Future<void> setupProject([Platform? activatedPlatform]) async {
  projectName = activatedPlatform != null
      ? 'project_${activatedPlatform.name}'
      : 'project_none';
  await copyPath(
    _getFixture(projectName).path,
    Directory.current.path,
  );

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
}

Future<void> addEntity({String? outputDir}) async {
  await copyPath(
    p.join(fixturesPath, 'entity', 'lib'),
    p.join(domainPackage.path, 'lib', outputDir ?? ''),
  );
  await copyPath(
    p.join(fixturesPath, 'entity', 'test'),
    p.join(domainPackage.path, 'test', outputDir ?? ''),
  );
}

Future<void> addServiceInterface({String? outputDir}) async {
  await copyPath(
    p.join(fixturesPath, 'service_interface'),
    p.join(domainPackage.path, 'lib', outputDir ?? ''),
  );
}

Future<void> addFeature(String name, {required Platform platform}) async {
  final feature = featurePackage(name, platform);
  final pubspecFile = File(p.join(feature.path, 'pubspec.yaml'));

  await pubspecFile.create(recursive: true);
  await pubspecFile.writeAsString('name: $name');
}

Future<void> addPlatformUiPackageThemeExtensionsFile(
  String widgetName, {
  required Platform platform,
}) async {
  final content = [
    if (platform == Platform.ios || platform == Platform.macos)
      "import 'package:flutter/material.dart' show ThemeExtension;",
    "import 'package:project_${platform.name}_ui_${platform.name}/project_${platform.name}_ui_${platform.name}.dart';",
    '',
    'final lightExtensions = <ThemeExtension>[',
    '  ${projectName.pascalCase}ColorTheme.light,',
    '  ${projectName.pascalCase}ScaffoldTheme.light,',
    '  ${projectName.pascalCase}${widgetName.pascalCase}Theme.light,',
    '];',
    '',
    'final darkExtensions = <ThemeExtension>[',
    '  ${projectName.pascalCase}ColorTheme.dark,',
    '  ${projectName.pascalCase}ScaffoldTheme.dark,',
    '  ${projectName.pascalCase}${widgetName.pascalCase}Theme.dark,',
    '];',
  ].join('\n');

  await File(
    p.join(
      platformUiPackage(platform).path,
      'lib',
      'src',
      'theme_extensions.dart',
    ),
  ).writeAsString(content);
}

Future<void> addPlatformUiPackageBarrelFile(
  String widgetName, {
  required Platform platform,
}) async {
  await File(
    p.join(
      platformUiPackage(platform).path,
      'lib',
      '${projectName}_ui_${platform.name}.dart',
    ),
  ).writeAsString(
    '''
export 'src/foo_bar.dart';
export 'src/foo_bar_theme.dart';
''',
    mode: FileMode.append,
  );
}

late String projectName;

final diPackage =
    Directory(p.join('packages', projectName, '${projectName}_di'));

final domainPackage =
    Directory(p.join('packages', projectName, '${projectName}_domain'));

final infrastructurePackage =
    Directory(p.join('packages', projectName, '${projectName}_infrastructure'));

final loggingPackage =
    Directory(p.join('packages', projectName, '${projectName}_logging'));

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

Directory platformNavigationPackage(Platform platform) => Directory(
      p.join(
        'packages',
        projectName,
        '${projectName}_${platform.name}',
        '${projectName}_${platform.name}_navigation',
      ),
    );

final uiPackage =
    Directory(p.join('packages', '${projectName}_ui', '${projectName}_ui'));

Directory platformUiPackage(Platform platform) => Directory(
      p.join(
        'packages',
        '${projectName}_ui',
        '${projectName}_ui_${platform.name}',
      ),
    );

final platformIndependentPackagesWithTests = [
  diPackage,
  loggingPackage,
  uiPackage,
];

final platformIndependentPackagesWithoutTests = [
  domainPackage,
  infrastructurePackage,
];

final platformIndependentPackages = [
  ...platformIndependentPackagesWithTests,
  ...platformIndependentPackagesWithoutTests,
];

List<Directory> platformDependentPackagesWithTests(Platform platform) => [
      platformRootPackage(platform),
      platformUiPackage(platform),
    ];

List<Directory> platformDependentPackagesWithoutTests(Platform platform) => [
      platformNavigationPackage(platform),
    ];

List<Directory> platformDependentPackages(List<Platform> platforms) => [
      for (final platform in platforms) ...[
        ...platformDependentPackagesWithTests(platform),
        ...platformDependentPackagesWithoutTests(platform),
      ]
    ];

List<Directory> get allPlatformDependentPackages =>
    platformDependentPackages(Platform.values);

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

List<File> entityFiles({
  required String name,
  String? outputDir,
}) =>
    [
      File(p.join(domainPackage.path, 'lib', outputDir ?? '',
          '${name.snakeCase}.dart')),
      File(p.join(domainPackage.path, 'lib', outputDir ?? '',
          '${name.snakeCase}.freezed.dart')),
      File(p.join(domainPackage.path, 'test', outputDir ?? '',
          '${name.snakeCase}_test.dart')),
    ];

List<File> valueObjectFiles({
  required String name,
  String? outputDir,
}) =>
    [
      File(p.join(domainPackage.path, 'lib', outputDir ?? '',
          '${name.snakeCase}.dart')),
      File(p.join(domainPackage.path, 'lib', outputDir ?? '',
          '${name.snakeCase}.freezed.dart')),
      File(p.join(domainPackage.path, 'test', outputDir ?? '',
          '${name.snakeCase}_test.dart')),
    ];

List<File> serviceInterfaceFiles({
  required String name,
  String? outputDir,
}) =>
    [
      File(p.join(domainPackage.path, 'lib', outputDir ?? '',
          'i_${name.snakeCase}_service.dart')),
      File(p.join(domainPackage.path, 'lib', outputDir ?? '',
          'i_${name.snakeCase}_service.freezed.dart')),
    ];

List<File> dataTransferObjectFiles({
  required String entity,
  String? outputDir,
}) =>
    [
      File(p.join(infrastructurePackage.path, 'lib', 'src', outputDir ?? '',
          '${entity.snakeCase}_dto.dart')),
      File(p.join(infrastructurePackage.path, 'lib', 'src', outputDir ?? '',
          '${entity.snakeCase}_dto.freezed.dart')),
      File(p.join(infrastructurePackage.path, 'lib', 'src', outputDir ?? '',
          '${entity.snakeCase}_dto.g.dart')),
      File(p.join(infrastructurePackage.path, 'test', 'src', outputDir ?? '',
          '${entity.snakeCase}_dto_test.dart')),
    ];

List<File> serviceImplementationFiles({
  required String name,
  required String serviceName,
  String? outputDir,
}) =>
    [
      File(
        p.join(
          infrastructurePackage.path,
          'lib',
          'src',
          outputDir ?? '',
          '${name.snakeCase}_${serviceName.snakeCase}_service.dart',
        ),
      ),
      File(
        p.join(
          infrastructurePackage.path,
          'test',
          'src',
          outputDir ?? '',
          '${name.snakeCase}_${serviceName.snakeCase}_service_test.dart',
        ),
      ),
    ];

List<File> widgetFiles({
  required String name,
  required Platform platform,
}) =>
    [
      File(
        p.join(
          platformUiPackage(platform).path,
          'lib',
          'src',
          '${name.snakeCase}_theme.dart',
        ),
      ),
      File(
        p.join(
          platformUiPackage(platform).path,
          'lib',
          'src',
          '${name.snakeCase}_theme.tailor.dart',
        ),
      ),
      File(
        p.join(
          platformUiPackage(platform).path,
          'lib',
          'src',
          '${name.snakeCase}.dart',
        ),
      ),
      File(
        p.join(
          platformUiPackage(platform).path,
          'test',
          'src',
          '${name.snakeCase}_theme_test.dart',
        ),
      ),
      File(
        p.join(
          platformUiPackage(platform).path,
          'test',
          'src',
          '${name.snakeCase}_test.dart',
        ),
      ),
    ];

/// Source files a feature requires to support [languages].
List<File> languageFiles(
  String feature,
  Platform platform,
  List<String> languages,
) =>
    [
      for (final language in languages) ...[
        File(
          p.join(
            featurePackage(feature, platform).path,
            'lib',
            'src',
            'presentation',
            'l10n',
            'arb',
            '${feature}_$language.arb',
          ),
        ),
        File(
          p.join(
            featurePackage(feature, platform).path,
            'lib',
            'src',
            'presentation',
            'l10n',
            '${projectName}_${platform.name}_${feature}_localizations_$language.dart',
          ),
        ),
      ],
    ];

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

extension StringX on String {
  List<Platform> toPlatforms() {
    switch (this) {
      case 'android':
        return [Platform.android];
      case 'ios':
        return [Platform.ios];
      case 'linux':
        return [Platform.linux];
      case 'macos':
        return [Platform.macos];
      case 'web':
        return [Platform.web];
      case 'windows':
        return [Platform.windows];
      case 'mobile':
        return [Platform.android, Platform.ios];
      case 'desktop':
        return [Platform.linux, Platform.macos, Platform.windows];
      case 'all':
        return Platform.values;
      default:
        throw ArgumentError(
          'Invalid String which does not represent a platform group.',
          this,
        );
    }
  }
}

/// Verifys wheter ALL [entities] exist on disk.
void verifyDoExist(Iterable<FileSystemEntity> entities) {
  for (final entity in entities) {
    _println('Verify does exist ${entity.path}\n');

    expect(entity.existsSync(), true);
  }
}

/// Verifys wheter NONE of [entities] exist on disk.
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
/// This passes if no test dir or only empty test/ or only empty test/src exists.
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
        if (testDirSubEntities.length == 1) {
          final testSrcDir = Directory(p.join(dir.path, 'test', 'src'));
          if (testSrcDir.existsSync() && testSrcDir.listSync().isEmpty) {
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

/// Verify that [amount] analyzer issues are found in current directory.
Future<void> verifyHasAnalyzerIssues(int amount) async {
  final analyzerIssues = await _runFlutterAnalyze();
  expect(analyzerIssues, amount);
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

/// Runs `flutter` or `dart` test` in [cwd].
///
/// If [coverage] is true runs with `--coverage`
Future<TestResult> _runFlutterOrDartTest({
  required String cwd,
  bool coverage = true,
}) async {
  // TODO required because of https://github.com/dart-lang/test/issues/1977
  final pubspec = File(p.join(cwd, 'pubspec.yaml'));
  final content = pubspec.readAsStringSync();
  final hasFlutterTest = content.contains('flutter_test:');

  late ProcessResult result;
  if (hasFlutterTest) {
    _println('Run "flutter test${coverage ? ' --coverage' : ''}" in $cwd\n');

    result = await Process.run(
      'flutter',
      ['test', if (coverage) '--coverage'],
      workingDirectory: cwd,
      runInShell: true,
    );
  } else {
    _println('Run "dart test${coverage ? ' --coverage' : ''}" in $cwd\n');

    result = await Process.run(
      'dart',
      ['test'],
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
  final match = regExp.firstMatch(stderr) ?? regExp.firstMatch(stdout)!;
  return TestResult(int.parse(match.group(1)!), totalCoverage);
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
