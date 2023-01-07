import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

/// Verify that no analyzer issues are found in current directory.
Future<void> verifyNoAnalyzerIssues() async {
  final analyzerIssues = await _runFlutterAnalyze();
  expect(analyzerIssues, 0);
}

/* /// Verify that no formatting issues are found in current directory.
Future<void> verifyNoFormattingIssues() async {
  final formatIssues = await _runFlutterFormat();
  expect(formatIssues, 0);
} */

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
Future<TestResult> runFlutterTest({
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
      stderr.contains('Test directory "test" not found') ||
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
      stderr.contains('Test directory "test" not found') ||
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
  final regExp = RegExp(r'([0-9]+) issues found');
  final match = regExp.firstMatch(stderr)!;
  return int.parse(match.group(1)!);
}

/* /// Run `flutter format --set-exit-if-changed` in [cwd].
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
} */

/// Returns a [Matcher] that matches when a [FileSystemEntity] exists on disk.
final Matcher exists = _EntityExists();

class _EntityExists extends CustomMatcher {
  _EntityExists() : super('File with existing', 'existing', true);

  @override
  featureValueOf(actual) => (actual as FileSystemEntity).existsSync();
}

/// Returns a [Matcher] that matches when a [File] exists and is a valid dart file.
final Matcher isValidDartFile = _IsValidDartFile();

class _IsValidDartFile extends CustomMatcher {
  _IsValidDartFile()
      : super('File with is valid dart file', 'is valid dart file', true);

  @override
  featureValueOf(actual) {
    final file = actual as File;

    final ext = p.extension(file.path);
    final contents = file.readAsStringSync();
    var valid = false;
    try {
      DartFormatter().format(contents);
      valid = true;
    } catch (_) {}

    return ext == '.dart' && valid;
  }
}
