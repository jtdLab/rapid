import 'package:io/io.dart' show copyPath;
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/platform.dart';
import 'package:recase/recase.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

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

/// Set up a Rapid test project in the cwd with NO platforms activated.
Future<void> setupProjectNoPlatforms() async {
  projectName = 'project_none';
  await copyPath(
    Directory(p.join(cwd.path, 'fixtures/$projectName')).path,
    Directory.current.path,
  );

  await _runFlutterPubGetInAllDirsWithPubspec();
}

/// Set up a Rapid test project in the cwd with [platform] activated.
Future<void> setupProjectWithPlatform(Platform platform) async {
  projectName = 'project_${platform.name}';
  await copyPath(
    Directory(p.join(cwd.path, 'fixtures/$projectName')).path,
    Directory.current.path,
  );

  await _runFlutterPubGetInAllDirsWithPubspec();
}

Future<void> addEntity({required String name, String? outputDir}) async {
  await copyPath(
    Directory(p.join(cwd.path, 'fixtures', 'entity', 'lib')).path,
    p.join(domainPackage.path, 'lib', outputDir ?? ''),
  );
  await copyPath(
    Directory(p.join(cwd.path, 'fixtures', 'entity', 'test')).path,
    p.join(domainPackage.path, 'test', outputDir ?? ''),
  );
}

/// Runs `flutter pub get` recursivly in all dirs with pubspec.yaml
/// starting from current directory.
Future<void> _runFlutterPubGetInAllDirsWithPubspec() async {
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

/// Verifys wheter ALL [entities] exist on disk.
void verifyDoExist(Iterable<FileSystemEntity> entities) {
  for (final entity in entities) {
    print(entity.path);
    expect(entity.existsSync(), true);
  }
}

/// Verifys wheter NONE of [entities] exist on disk.
void verifyDoNotExist(Iterable<FileSystemEntity> entities) {
  for (final entity in entities) {
    print(entity.path);
    expect(entity.existsSync(), false);
  }
}

late String projectName;

/// The app package containing all setup.
final appPackage = Directory(p.join('packages', projectName, projectName));

/// The dependency injection package.
final diPackage =
    Directory(p.join('packages', projectName, '${projectName}_di'));

/// The domain package.
final domainPackage =
    Directory(p.join('packages', projectName, '${projectName}_domain'));

/// The infrastructure package.
final infrastructurePackage =
    Directory(p.join('packages', projectName, '${projectName}_infrastructure'));

/// The logging package.
final loggingPackage =
    Directory(p.join('packages', projectName, '${projectName}_logging'));

/// The directory of [platform] containing platform specific features.
Directory platformDir(Platform platform) => Directory(
    p.join('packages', projectName, '${projectName}_${platform.name}'));

/// The platform-independent ui package.
final uiPackage =
    Directory(p.join('packages', '${projectName}_ui', '${projectName}_ui'));

/// The package of [feature] on platform.
Directory featurePackage(String feature, Platform platform) => Directory(p.join(
    platformDir(platform).path, '${projectName}_${platform.name}_$feature'));

/// The ui package of [platform].
Directory platformUiPackage(Platform platform) => Directory(p.join(
    'packages', '${projectName}_ui', '${projectName}_ui_${platform.name}'));

/// All platform independent packages.
final platformIndependentPackages = [
  appPackage,
  diPackage,
  domainPackage,
  infrastructurePackage,
  loggingPackage,
  uiPackage
];

/// All [platform]-dependent dirs of the test project.
List<Directory> platformDirs(Platform platform) => [
      Directory(p.join(appPackage.path, platform.name)),
      platformDir(platform),
      platformUiPackage(platform),
    ];

List<Directory> get allPlatformDirs => Platform.values
    .map((e) => platformDirs(e))
    .fold(<Directory>[], (prev, curr) => prev + curr).toList();

List<File> entityFiles({
  required String name,
  String? outputDir,
}) =>
    [
      File(p.join(domainPackage.path, 'lib', outputDir ?? '', name.snakeCase,
          '${name.snakeCase}.dart')),
      File(p.join(domainPackage.path, 'lib', outputDir ?? '', name.snakeCase,
          '${name.snakeCase}.freezed.dart')),
      File(p.join(domainPackage.path, 'test', outputDir ?? '', name.snakeCase,
          '${name.snakeCase}_test.dart')),
    ];

List<File> serviceInterfaceFiles({
  required String name,
  String? outputDir,
}) =>
    [
      File(p.join(domainPackage.path, 'lib', outputDir ?? '', name.snakeCase,
          'i_${name.snakeCase}_service.dart')),
      File(p.join(domainPackage.path, 'lib', outputDir ?? '', name.snakeCase,
          'i_${name.snakeCase}_service.freezed.dart')),
    ];

List<File> dataTransferObjectFiles({
  required String entity,
  String? outputDir,
}) =>
    [
      File(p.join(infrastructurePackage.path, 'lib', 'src', outputDir ?? '',
          entity.snakeCase, '${entity.snakeCase}_dto.dart')),
      File(p.join(infrastructurePackage.path, 'lib', 'src', outputDir ?? '',
          entity.snakeCase, '${entity.snakeCase}_dto.freezed.dart')),
      File(p.join(infrastructurePackage.path, 'lib', 'src', outputDir ?? '',
          entity.snakeCase, '${entity.snakeCase}_dto.g.dart')),
      File(p.join(infrastructurePackage.path, 'test', 'src', outputDir ?? '',
          entity.snakeCase, '${entity.snakeCase}_dto_test.dart')),
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
          serviceName.snakeCase,
          '${name.snakeCase}_${serviceName.snakeCase}_service.dart',
        ),
      ),
      File(
        p.join(
          infrastructurePackage.path,
          'test',
          'src',
          outputDir ?? '',
          serviceName.snakeCase,
          '${name.snakeCase}_${serviceName.snakeCase}_service_test.dart',
        ),
      ),
    ];

// TODO cleaner

/// All source files a feature requires to support [languages].
List<File> languageFiles(
  String feature,
  Platform platform,
  List<String> languages,
) =>
    [
      for (final language in languages) ...[
        File(
          p.join(
            'packages',
            projectName,
            '${projectName}_${platform.name}',
            '${projectName}_${platform.name}_$feature',
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
            'packages',
            projectName,
            '${projectName}_${platform.name}',
            '${projectName}_${platform.name}_$feature',
            'lib',
            'src',
            'presentation',
            'l10n',
            '${projectName}_${platform.name}_${feature}_localizations_$language.dart',
          ),
        ),
      ],
      File(
        p.join(
          'packages',
          projectName,
          '${projectName}_${platform.name}',
          '${projectName}_${platform.name}_$feature',
          'lib',
          'src',
          'presentation',
          'l10n',
          '${projectName}_${platform.name}_${feature}_localizations.dart',
        ),
      ),
      File(
        p.join(
          'packages',
          projectName,
          '${projectName}_${platform.name}',
          '${projectName}_${platform.name}_$feature',
          'lib',
          'src',
          'presentation',
          'l10n',
          'l10n.dart',
        ),
      ),
    ];

extension IterableX<E extends FileSystemEntity> on Iterable<E> {
  Iterable<E> without(Iterable<E> iterable) =>
      where((e) => !iterable.any((element) => e.path == element.path));
}

/// Verifys that tests in [dirs] pass with 100% test coverage.
///
/// Runs `flutter test --coverage` in every provided dir.
Future<void> verifyTestsPassWith100PercentCoverage(
  Iterable<Directory> dirs,
) async {
  for (final dir in dirs) {
    print(dir.path);
    final testResult = await _runFlutterTest(cwd: dir.path);

    expect(testResult.failedTests, 0);
    expect(testResult.coverage, 100);
  }
}

/// Verifys that no element in [dirs] has a test directory.
Future<void> verifyDoNotHaveTests(
  Iterable<Directory> dirs,
) async {
  for (final dir in dirs) {
    print(dir.path);
    final hasTestDir = dir.listSync().any((e) => p.basename(e.path) == 'test');

    expect(hasTestDir, false);
  }
}

/// Verify that no analyzer issues are found in current directory.
Future<void> verifyNoAnalyzerIssues() async {
  final analyzerIssues = await _runFlutterAnalyze();
  expect(analyzerIssues, 0);
}

/// Verify that no formatting issues are found in current directory.
Future<void> verifyNoFormattingIssues() async {
  final formatIssues = await _runFlutterFormat();
  expect(formatIssues, 0);
}

/// The device id of the device ios e2e test run on
///
/// This gets passed via -d to a flutter command
///
/// This is needed because of https://github.com/flutter/flutter/issues/117158
const _iosDevice = 'iPhone 11';

/// Thrown when [_runFlutterTest] didnt find a test directory.
class TestDirNotFound implements Exception {}

class TestResult {
  TestResult(this.failedTests, this.coverage);

  final int failedTests;

  final double? coverage;
}

/// Runs `flutter test` in [cwd].
///
/// If [coverage] is true runs with `--coverage`
Future<TestResult> _runFlutterTest({
  required String cwd,
  bool coverage = true,
}) async {
  final testResult = await Process.run(
    'flutter',
    ['test', if (coverage) '--coverage'],
    workingDirectory: cwd,
    runInShell: true,
  );

  final String stderr = testResult.stderr;
  final String stdout = testResult.stdout;

  print(stderr);
  print(stdout);

  if (stderr.contains('Test directory "test" not found')) {
    throw TestDirNotFound();
  }

  double? totalCoverage;
  if (coverage) {
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

  if (stderr.isEmpty || stdout.contains('All tests passed')) {
    return TestResult(0, totalCoverage);
  }

  final regExp = RegExp(r'-([0-9]+): Some tests failed');
  final match = regExp.firstMatch(stderr)!;
  return TestResult(int.parse(match.group(1)!), totalCoverage);
}

/// Runs integration tests at [pathToTests] from [cwd]  using the required mechanism described at https://docs.flutter.dev/testing/integration-tests
/// for the given [platform].
///
/// Returns the amount of failed tests.
Future<int> runFlutterIntegrationTest({
  required String cwd,
  String pathToTests = '.',
  required Platform platform,
}) async {
  late final ProcessResult testResult;
  if (platform == Platform.web) {
    await Process.start(
      'chromedriver',
      ['--port=4444'],
      workingDirectory: cwd,
      runInShell: true,
    );
    testResult = await Process.run(
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
    testResult = await Process.run(
      'flutter',
      ['test', pathToTests, '-d', device],
      workingDirectory: cwd,
      runInShell: true,
    );
  }

  final String stderr = testResult.stderr;
  final String stdout = testResult.stdout;

  print(stderr);
  print(stdout);

  if (stderr.contains('Test directory "test" not found')) {
    throw TestDirNotFound();
  }

  if (stderr.isEmpty || stdout.contains('All tests passed')) {
    return 0;
  }

  final regExp = RegExp(r'-([0-9]+): Some tests failed');
  final match = regExp.firstMatch(stderr)!;
  return int.parse(match.group(1)!);
}

/// Run `flutter analyze` in [cwd].
///
/// Returns the amount of analyzer issues.
Future<int> _runFlutterAnalyze({
  String cwd = '.',
}) async {
  final result = await Process.run(
    'flutter',
    ['analyze'],
    workingDirectory: cwd,
    runInShell: true,
  );

  final String stderr = result.stderr;
  final String stdout = result.stdout;
  print(stderr);
  print(stdout);

  if (stderr.isEmpty) {
    return 0;
  }

  final regExp = RegExp(r'([0-9]+) issues? found');
  final match = regExp.firstMatch(stderr)!;
  return int.parse(match.group(1)!);
}

/// Run `flutter format --set-exit-if-changed` in [cwd].
///
/// Returns the amount of formatting issues.
Future<int> _runFlutterFormat({
  String cwd = '.',
}) async {
  final result = await Process.run(
    'flutter',
    ['format', '.', '--set-exit-if-changed'],
    workingDirectory: cwd,
    runInShell: true,
  );

  final String stderr = result.stderr;
  final String stdout = result.stdout;
  print(stderr);
  print(stdout);

  if (stderr.isEmpty) {
    return 0;
  }

  final regExp = RegExp(r'Formatted [0-9]+ files \(([0-9]+) changed\)');
  final match = regExp.firstMatch(stdout)!;
  return int.parse(match.group(1)!);
}
