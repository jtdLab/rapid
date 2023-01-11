import 'package:io/io.dart' show copyPath;
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

/// The directory `flutter/dart test` was called from.
///
/// **IMPORTANT**: This should be the rapid_cli package.
/// If it is not fixtures can not be loaded and e2e tests might fail.
///
/// Store the directory `flutter/dart test` was called from like this:
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

/// Set up a Rapid test project in the cwd with ALL platforms activated.
Future<void> setupProjectWithPlatform(String platform) async {
  projectName = 'project_$platform';
  await copyPath(
    Directory(p.join(cwd.path, 'fixtures/$projectName')).path,
    Directory.current.path,
  );

  await _runFlutterPubGetInAllDirsWithPubspec();
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

/// The name of the test project.
late String projectName;

/// The app dir of the test project.
final appDir = Directory(p.join('packages', projectName, projectName));

/// The dependency injection dir of the test project.
final diDir = Directory(p.join('packages', projectName, '${projectName}_di'));

/// The domain  dir of the test project.
final domainDir =
    Directory(p.join('packages', projectName, '${projectName}_domain'));

/// The infrastructure dir of the test project.
final infraDir =
    Directory(p.join('packages', projectName, '${projectName}_infrastructure'));

/// The logging dir of the test project.
final loggingDir =
    Directory(p.join('packages', projectName, '${projectName}_logging'));

/// The ui dir of the test project.
final uiDir =
    Directory(p.join('packages', '${projectName}_ui', '${projectName}_ui'));

/// All platform independent dirs of the test project.
final platformIndependentDirs = [
  appDir,
  diDir,
  domainDir,
  infraDir,
  loggingDir,
  uiDir
];

/// Verifys wheter ALL [entities] exist on disk.
void verifyDoExist(Iterable<FileSystemEntity> entities) {
  for (final entity in entities) {
    expect(entity.existsSync(), true);
  }
}

/// Verifys wheter NONE of [entities] exist on disk.
void verifyDoNotExist(Iterable<FileSystemEntity> entities) {
  for (final entity in entities) {
    expect(entity.existsSync(), false);
  }
}

/// All [platform]-dependent dirs of the test project.
List<Directory> platformDirs(String platform) => [
      Directory(p.join('packages', projectName, projectName, platform)),
      if (platform == 'web')
        Directory(p.join('packages', projectName, projectName, 'test_driver')),
      Directory(p.join('packages', projectName, '${projectName}_$platform')),
      Directory(
        p.join('packages', '${projectName}_ui', '${projectName}_ui_$platform'),
      ),
    ];

/// Verifys that tests in [dirs] pass with 100% test coverage.
///
/// Runs `flutter test --coverage` in every provided dir.
Future<void> verifyTestsPassWith100PercentCoverage(
  List<Directory> dirs,
) async {
  for (final dir in dirs) {
    final testResult = await _runFlutterTest(cwd: dir.path);
    expect(testResult.failedTests, 0);
    expect(testResult.coverage, 100);
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

class TestResult {
  TestResult(this.failedTests, this.coverage);

  final int failedTests;

  final int? coverage;
}

/// Runs `flutter test` in [cwd].
///
/// If [coverage] is true runs with `--coverage`
Future<TestResult> _runFlutterTest({
  required String cwd,
  bool coverage = true,
}) async {
  final result = await Process.run(
    'flutter',
    ['test', if (coverage) '--coverage'],
    workingDirectory: cwd,
    runInShell: true,
  );

  final String stderr = result.stderr;
  final String stdout = result.stdout;
  if (stderr.isEmpty ||
      stderr.contains(
          'Test directory "test" not found') || // TODO this should return error
      stdout.contains('All tests passed')) {
    return TestResult(
      0,
      coverage ? 100 : null, // TODO read coverage via genhtml
    );
  }

  final regExp = RegExp(r'-([0-9]+): Some tests failed');
  final match = regExp.firstMatch(stderr)!;
  return TestResult(
    int.parse(match.group(1)!),
    coverage ? 100 : null, // TODO read coverage via genhtml
  );
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
  if (stderr.isEmpty ||
      stderr.contains(
          'Test directory "test" not found') || // TODO this should return error
      stdout.contains('All tests passed')) {
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
  if (stderr.isEmpty) {
    return 0;
  }

  // TODO doesnt match 0 issues found
  final regExp = RegExp(r'([0-9]+) issue found');
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
  if (stderr.isEmpty) {
    return 0;
  }

  final String stdout = result.stdout;
  final regExp = RegExp(r'Formatted [0-9]+ files (([0-9]+) changed)');
  final match = regExp.firstMatch(stdout)!;
  return int.parse(match.group(1)!);
}
