import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/io.dart';
import 'package:rapid_cli/src/logging.dart';
import 'package:rapid_cli/src/mason.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:rapid_cli/src/tool.dart';
import 'package:test/test.dart';

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

List<dynamic Function()> setupFlutterPubRunBuildRunnerBuildTask(
  MockProcessManager manager, {
  required DartPackage package,
  required RapidLogger logger,
}) {
  final description = 'Running code generation in ${package.packageName}';
  final progress = MockProgress();
  when(() => logger.progress(description)).thenReturn(progress);
  final workingDirectory = package.path;

  return [
    () => logger.progress(description),
    () => manager.run(
          [
            'flutter',
            'pub',
            'run',
            'build_runner',
            'build',
            '--delete-conflicting-outputs',
          ],
          workingDirectory: workingDirectory,
          runInShell: true,
          stderrEncoding: utf8,
          stdoutEncoding: utf8,
        ),
    () => progress.complete(),
  ];
}

List<dynamic Function()> setupFlutterPubRunBuildRunnerBuildTaskInCommandGroup(
  MockProcessManager manager, {
  required DartPackage package,
  required RapidTool tool,
}) {
  return [
    () => tool.markAsNeedCodeGen(package: package),
  ];
}

List<dynamic Function()> setupFlutterPubRunBuildRunnerBuildTaskGroup(
  MockProcessManager manager, {
  required List<DartPackage> packages,
  required RapidLogger logger,
}) {
  if (packages.isEmpty) {
    final progressGroup = MockProgressGroup();
    when(() => logger.progressGroup(null)).thenReturn(progressGroup);
    final progress = MockGroupableProgress();
    when(() => progressGroup.progress(any())).thenReturn(progress);
    return [
      () => logger.progressGroup(null),
      () => progressGroup.progress(any()),
      () => manager.run(
            [
              'flutter',
              'pub',
              'run',
              'build_runner',
              'build',
              '--delete-conflicting-outputs',
            ],
            workingDirectory: any(named: 'workingDirectory'),
            runInShell: true,
            stderrEncoding: utf8,
            stdoutEncoding: utf8,
          ),
      () => progress.complete()
    ];
  }

  final invocations = <dynamic Function()>[];
  final progressGroup = MockProgressGroup();
  when(() => logger.progressGroup(null)).thenReturn(progressGroup);

  invocations.add(() => logger.progressGroup(null));

  for (final package in packages) {
    final description = 'Running code generation in ${package.packageName}';
    final progress = MockGroupableProgress();
    when(() => progressGroup.progress(description)).thenReturn(progress);
    final path = package.path;

    invocations.add(() => progressGroup.progress(description));
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
    invocations.add(() => progress.complete());
  }

  return invocations;
}

List<dynamic Function()>
    setupFlutterPubRunBuildRunnerBuildTaskGroupInCommandGroup(
  MockProcessManager manager, {
  required List<DartPackage> packages,
  required RapidTool tool,
}) {
  if (packages.isEmpty) {
    return [
      () => tool.markAsNeedCodeGen(package: any(named: 'package')),
    ];
  }

  return [
    for (final package in packages) ...[
      () => tool.markAsNeedCodeGen(package: package),
    ]
  ];
}

// TODO handle working dir could be checked that its project root
List<dynamic Function()> setupMelosBootstrapTask(
  MockProcessManager manager, {
  required List<DartPackage> scope,
  required RapidLogger logger,
}) {
  if (scope.isEmpty) {
    final progress = MockProgress();
    when(() => logger.progress(any())).thenReturn(progress);

    return [
      () => logger.progress(any()),
      () => manager.run(
            any(that: contains(['melos', 'bootstrap', '--scope'])),
            // TODO use project dir ?
            workingDirectory: any(named: 'workingDirectory'),
            runInShell: true,
            stderrEncoding: utf8,
            stdoutEncoding: utf8,
          ),
      () => progress.complete(),
    ];
  }

  final scopeString = scope.map((e) => e.packageName).join(',');
  final description = 'Running "melos bootstrap --scope="$scopeString""';
  final progress = MockProgress();
  when(() => logger.progress(description)).thenReturn(progress);

  return [
    () => logger.progress(description),
    () => manager.run(
          ['melos', 'bootstrap', '--scope', scopeString],
          // TODO use project dir ?
          workingDirectory: any(named: 'workingDirectory'),
          runInShell: true,
          stderrEncoding: utf8,
          stdoutEncoding: utf8,
        ),
    () => progress.complete(),
  ];
}

List<dynamic Function()> setupMelosBootstrapTaskInCommandGroup(
  MockProcessManager manager, {
  required List<DartPackage> scope,
  required RapidTool tool,
}) {
  return [
    () => tool.markAsNeedBootstrap(packages: scope),
  ];
}

List<dynamic Function()> flutterPubGetTaskGroup(
  MockProcessManager manager, {
  required List<DartPackage> packages,
}) {
  final invocations = <dynamic Function()>[];
  for (final package in packages) {
    invocations.add(
      () => manager.run(
        ['flutter', 'pub', 'get'],
        workingDirectory: package.path,
        runInShell: true,
        stderrEncoding: utf8,
        stdoutEncoding: utf8,
      ),
    );
  }

  return invocations;
}

List<dynamic Function()> flutterGenl10nTask(
  MockProcessManager manager, {
  required DartPackage package,
}) {
  return [
    () => manager.run(
          ['flutter', 'gen-l10n'],
          workingDirectory: package.path,
          runInShell: true,
          stderrEncoding: utf8,
          stdoutEncoding: utf8,
        ),
  ];
}

List<dynamic Function()> dartFormatFixTask(MockProcessManager manager) {
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

List<dynamic Function()> flutterPubAddTask(
  MockProcessManager manager, {
  required List<String> dependenciesToAdd,
  required DartPackage package,
}) {
  // TODO move path down
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

List<dynamic Function()> flutterPubGet(
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

List<dynamic Function()> flutterPubRemoveTask(
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

List<dynamic Function()> generateFromBundle(
  MockProcessManager manager, {
  required MockMasonGeneratorBuilder generatorBuilder,
  required MockMasonGenerator generator,
  required MasonBundle bundle,
  required Directory target,
  required Map<String, dynamic> vars,
}) {
  return [
    () => generatorBuilder(bundle),
    () => generator.generate(
          DirectoryGeneratorTarget(target),
          vars: vars,
        ),
  ];
}

List<dynamic Function()> flutterConfigEnablePlatform(
  MockProcessManager manager, {
  required Platform platform,
}) {
  return [
    () => manager.run(
          [
            'flutter',
            'config',
            if (platform == Platform.android) '--enable-android',
            if (platform == Platform.ios) '--enable-ios',
            if (platform == Platform.linux) '--enable-linux-desktop',
            if (platform == Platform.macos) '--enable-macos-desktop',
            if (platform == Platform.web) '--enable-web',
            if (platform == Platform.windows) '--enable-windows-desktop',
          ],
          workingDirectory: any(named: 'workingDirectory'),
          runInShell: true,
          stderrEncoding: utf8,
          stdoutEncoding: utf8,
        ),
  ];
}
