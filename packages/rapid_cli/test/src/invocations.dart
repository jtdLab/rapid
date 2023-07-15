import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/io.dart';

import 'mocks.dart';

// TODO add logging verification to tasks

/// Same as [verifyNever] but takes multiple invocations.
///
/// This is useful when reusing a list of invocations across multiple tests.
///
/// For example to verify the invocations from [melosBootstrapTask] are never called setup
/// your test like this:
///
/// ```dart
/// verifyNeverMulti(melosBootstrapTask);
/// ```
List<VerificationResult> Function<T>(
  List<T Function()> invocations,
) get verifyNeverMulti {
  return <T>(List<T Function()> invocations) {
    final results = <VerificationResult>[];
    for (final invocation in invocations) {
      final result = verifyNever(invocation);
      results.add(result);
    }
    return results;
  };
}

// TODO handle working dir could be checked that its project root
// and the command could be match better if scope is empty -> maybe make it nullable and handle that case
List<dynamic Function()> melosBootstrapTask<T>(
  MockProcessManager manager, {
  required List<DartPackage> scope,
}) {
  final scopeString = scope.map((e) => e.packageName).join(',');
  return [
    () => manager.run(
          ['melos', 'bootstrap', '--scope', scopeString],
          workingDirectory: any(named: 'workingDirectory'),
          runInShell: true,
          stderrEncoding: utf8,
          stdoutEncoding: utf8,
        ),
  ];
}

List<dynamic Function()> flutterPubRunBuildRunnerBuildTask<T>(
  MockProcessManager manager, {
  DartPackage? package,
}) {
  final path = package?.path;
  return [
    () => manager.run(
          [
            'flutter',
            'pub',
            'run',
            'build_runner',
            'build',
            '--delete-conflicting-outputs',
          ],
          workingDirectory: path ?? any(named: 'workingDirectory'),
          runInShell: true,
          stderrEncoding: utf8,
          stdoutEncoding: utf8,
        ),
  ];
}

// TODO handle empty packages better maybe not allow it or make nullable
List<dynamic Function()> flutterPubRunBuildRunnerBuildTaskGroup<T>(
  MockProcessManager manager, {
  required List<DartPackage> packages,
}) {
  final invocations = <dynamic Function()>[];

  for (final package in packages) {
    final path = package.path;
    invocations.add(
      () => manager.run(
        [
          'flutter',
          'pub',
          'run',
          'build_runner',
          'build',
          '--delete-conflicting-outputs',
        ],
        workingDirectory: path,
        runInShell: true,
        stderrEncoding: utf8,
        stdoutEncoding: utf8,
      ),
    );
  }

  return invocations;
}

List<dynamic Function()> dartFormatFixTask<T>(MockProcessManager manager) {
  return [
    () => manager.run(
          ['dart', 'format', '.', '--fix'],
          workingDirectory: any(named: 'workingDirectory'),
          runInShell: true,
          stderrEncoding: utf8,
          stdoutEncoding: utf8,
        ),
  ];
}

List<dynamic Function()> flutterPubAddTask<T>(
  MockProcessManager manager, {
  required List<String> dependenciesToAdd,
  required DartPackage package,
}) {
  final path = package.path;
  return [
    () => manager.run(
          ['flutter', 'pub', 'add', ...dependenciesToAdd],
          workingDirectory: path,
          runInShell: true,
          stderrEncoding: utf8,
          stdoutEncoding: utf8,
        ),
  ];
}

List<dynamic Function()> flutterPubGet<T>(
  MockProcessManager manager, {
  required DartPackage package,
  bool dryRun = false,
}) {
  final path = package.path;
  return [
    () => manager.run(
          [
            'flutter',
            'pub',
            'get',
            if (dryRun) '--dry-run',
          ],
          workingDirectory: path,
          runInShell: true,
          stderrEncoding: utf8,
          stdoutEncoding: utf8,
        ),
  ];
}

List<dynamic Function()> flutterPubRemoveTask<T>(
  MockProcessManager manager, {
  required List<String> packagesToRemove,
  required DartPackage package,
}) {
  final path = package.path;
  return [
    () => manager.run(
          ['flutter', 'pub', 'remove', ...packagesToRemove],
          workingDirectory: path,
          runInShell: true,
          stderrEncoding: utf8,
          stdoutEncoding: utf8,
        ),
  ];
}
