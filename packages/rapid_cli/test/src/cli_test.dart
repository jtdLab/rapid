import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/cli.dart';
import 'package:rapid_cli/src/io.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import 'matchers.dart';
import 'mock_env.dart';
import 'mocks.dart';

void main() {
  group('melosBootstrap', () {
    test(
      'throws CliException when process exits with error',
      withMockEnv((manager) async {
        when(
          () => manager.run(
            any(),
            workingDirectory: any(named: 'workingDirectory'),
            runInShell: true,
            stderrEncoding: utf8,
            stdoutEncoding: utf8,
          ),
        ).thenAnswer((_) async => ProcessResult(0, 1, 'stdout', 'stderr'));

        expect(
          () async => melosBootstrap(
            scope: [
              FakeDartPackage(packageName: 'package_a'),
            ],
            project: FakeRapidProject(path: 'project_path'),
          ),
          throwsCliException(
            message: 'Failed to bootstrap',
            workingDirectory: 'project_path',
          ),
        );
      }),
    );

    test(
      'completes',
      withMockEnv((manager) async {
        await melosBootstrap(
          scope: [
            FakeDartPackage(packageName: 'package_a'),
            FakeDartPackage(packageName: 'package_b'),
            FakeDartPackage(packageName: 'package_c'),
          ],
          project: FakeRapidProject(path: 'project_path'),
        );

        verify(
          () => manager.run(
            [
              'melos',
              'bootstrap',
              '--scope',
              'package_a,package_b,package_c',
            ],
            workingDirectory: 'project_path',
            runInShell: true,
            stderrEncoding: utf8,
            stdoutEncoding: utf8,
          ),
        ).called(1);
      }),
    );
  });

  group('flutterPubGet', () {
    test(
      'throws CliException when process exits with error',
      withMockEnv((manager) async {
        when(
          () => manager.run(
            any(),
            workingDirectory: any(named: 'workingDirectory'),
            runInShell: true,
            stderrEncoding: utf8,
            stdoutEncoding: utf8,
          ),
        ).thenAnswer((_) async => ProcessResult(0, 1, 'stdout', 'stderr'));

        expect(
          () async => flutterPubGet(
            package: FakeDartPackage(path: 'example_package_path'),
          ),
          throwsCliException(
            message: 'Failed to install',
            workingDirectory: 'example_package_path',
          ),
        );
      }),
    );

    test(
      'completes',
      withMockEnv((manager) async {
        await flutterPubGet(
          package: FakeDartPackage(path: 'example_package_path'),
        );

        verify(
          () => manager.run(
            ['flutter', 'pub', 'get'],
            workingDirectory: 'example_package_path',
            runInShell: true,
            stderrEncoding: utf8,
            stdoutEncoding: utf8,
          ),
        ).called(1);
      }),
    );

    test(
      'completes (dry run)',
      withMockEnv((manager) async {
        await flutterPubGet(
          dryRun: true,
          package: FakeDartPackage(path: 'example_package_path'),
        );

        verify(
          () => manager.run(
            ['flutter', 'pub', 'get', '--dry-run'],
            workingDirectory: 'example_package_path',
            runInShell: true,
            stderrEncoding: utf8,
            stdoutEncoding: utf8,
          ),
        ).called(1);
      }),
    );
  });

  group('dartFormatFix', () {
    test(
      'throws CliException when process exits with error',
      withMockEnv((manager) async {
        when(
          () => manager.run(
            any(),
            workingDirectory: any(named: 'workingDirectory'),
            runInShell: true,
            stderrEncoding: utf8,
            stdoutEncoding: utf8,
          ),
        ).thenAnswer((_) async => ProcessResult(0, 1, 'stdout', 'stderr'));

        expect(
          () async => dartFormatFix(
            project: FakeRapidProject(path: 'project_path'),
          ),
          throwsCliException(
            message: 'Failed to format',
            workingDirectory: 'project_path',
          ),
        );
      }),
    );

    test(
      'completes',
      withMockEnv((manager) async {
        await dartFormatFix(
          project: FakeRapidProject(path: 'project_path'),
        );

        verify(
          () => manager.run(
            ['dart', 'format', '.', '--fix'],
            workingDirectory: 'project_path',
            runInShell: true,
            stderrEncoding: utf8,
            stdoutEncoding: utf8,
          ),
        ).called(1);
      }),
    );
  });

  group('flutterGenl10n', () {
    test(
      'throws CliException when process exits with error',
      withMockEnv((manager) async {
        when(
          () => manager.run(
            any(),
            workingDirectory: any(named: 'workingDirectory'),
            runInShell: true,
            stderrEncoding: utf8,
            stdoutEncoding: utf8,
          ),
        ).thenAnswer((_) async => ProcessResult(0, 1, 'stdout', 'stderr'));

        expect(
          () async => flutterGenl10n(
            package: FakeDartPackage(path: 'example_package_path'),
          ),
          throwsCliException(
            message: 'Failed to generate localizations',
            workingDirectory: 'example_package_path',
          ),
        );
      }),
    );

    test(
      'completes',
      withMockEnv((manager) async {
        await flutterGenl10n(
          package: FakeDartPackage(path: 'example_package_path'),
        );

        verify(
          () => manager.run(
            ['flutter', 'gen-l10n'],
            workingDirectory: 'example_package_path',
            runInShell: true,
            stderrEncoding: utf8,
            stdoutEncoding: utf8,
          ),
        ).called(1);
      }),
    );
  });

  group('flutterPubRunBuildRunnerBuildDeleteConflictingOutputs', () {
    test(
      'throws CliException when process exits with error',
      withMockEnv((manager) async {
        when(
          () => manager.run(
            any(),
            workingDirectory: any(named: 'workingDirectory'),
            runInShell: true,
            stderrEncoding: utf8,
            stdoutEncoding: utf8,
          ),
        ).thenAnswer((_) async => ProcessResult(0, 1, 'stdout', 'stderr'));

        expect(
          () async => flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
            package: FakeDartPackage(path: 'example_package_path'),
          ),
          throwsCliException(
            message: 'Failed to run code generation',
            workingDirectory: 'example_package_path',
          ),
        );
      }),
    );

    test(
      'completes',
      withMockEnv((manager) async {
        await flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
          package: FakeDartPackage(path: 'example_package_path'),
        );

        verify(
          () => manager.run(
            [
              'flutter',
              'pub',
              'run',
              'build_runner',
              'build',
              '--delete-conflicting-outputs',
            ],
            workingDirectory: 'example_package_path',
            runInShell: true,
            stderrEncoding: utf8,
            stdoutEncoding: utf8,
          ),
        ).called(1);
      }),
    );
  });

  group('flutterPubAdd', () {
    test(
      'throws CliException when process exits with error',
      withMockEnv((manager) async {
        when(
          () => manager.run(
            any(),
            workingDirectory: any(named: 'workingDirectory'),
            runInShell: true,
            stderrEncoding: utf8,
            stdoutEncoding: utf8,
          ),
        ).thenAnswer((_) async => ProcessResult(0, 1, 'stdout', 'stderr'));

        expect(
          () async => flutterPubAdd(
            dependenciesToAdd: ['foo: 1.0.0', 'bar: ^2.0.0'],
            package: FakeDartPackage(path: 'example_package_path'),
          ),
          throwsCliException(
            message: 'Failed to add dependencies',
            workingDirectory: 'example_package_path',
          ),
        );
      }),
    );

    test(
      'completes',
      withMockEnv((manager) async {
        await flutterPubAdd(
          dependenciesToAdd: ['foo: 1.0.0', 'bar: ^2.0.0'],
          package: FakeDartPackage(path: 'example_package_path'),
        );

        verify(
          () => manager.run(
            ['flutter', 'pub', 'add', 'foo: 1.0.0', 'bar: ^2.0.0'],
            workingDirectory: 'example_package_path',
            runInShell: true,
            stderrEncoding: utf8,
            stdoutEncoding: utf8,
          ),
        ).called(1);
      }),
    );
  });

  group('flutterPubRemove', () {
    test(
      'throws CliException when process exits with error',
      withMockEnv((manager) async {
        when(
          () => manager.run(
            any(),
            workingDirectory: any(named: 'workingDirectory'),
            runInShell: true,
            stderrEncoding: utf8,
            stdoutEncoding: utf8,
          ),
        ).thenAnswer((_) async => ProcessResult(0, 1, 'stdout', 'stderr'));

        expect(
          () async => flutterPubRemove(
            packagesToRemove: ['foo', 'bar'],
            package: FakeDartPackage(path: 'example_package_path'),
          ),
          throwsCliException(
            message: 'Failed to remove dependencies',
            workingDirectory: 'example_package_path',
          ),
        );
      }),
    );

    test(
      'completes',
      withMockEnv((manager) async {
        await flutterPubRemove(
          packagesToRemove: ['foo', 'bar'],
          package: FakeDartPackage(path: 'example_package_path'),
        );

        verify(
          () => manager.run(
            ['flutter', 'pub', 'remove', 'foo', 'bar'],
            workingDirectory: 'example_package_path',
            runInShell: true,
            stderrEncoding: utf8,
            stdoutEncoding: utf8,
          ),
        ).called(1);
      }),
    );
  });

  group('flutterConfigEnable', () {
    test(
      'completes (android)',
      withMockEnv((manager) async {
        await flutterConfigEnable(
          platform: Platform.android,
          project: FakeRapidProject(path: 'project_path'),
        );

        verify(
          () => manager.run(
            ['flutter', 'config', '--enable-android'],
            workingDirectory: 'project_path',
            runInShell: true,
            stderrEncoding: utf8,
            stdoutEncoding: utf8,
          ),
        ).called(1);
      }),
    );

    test(
      'completes (ios)',
      withMockEnv((manager) async {
        await flutterConfigEnable(
          platform: Platform.ios,
          project: FakeRapidProject(path: 'project_path'),
        );

        verify(
          () => manager.run(
            ['flutter', 'config', '--enable-ios'],
            workingDirectory: 'project_path',
            runInShell: true,
            stderrEncoding: utf8,
            stdoutEncoding: utf8,
          ),
        ).called(1);
      }),
    );

    test(
      'completes (linux)',
      withMockEnv((manager) async {
        await flutterConfigEnable(
          platform: Platform.linux,
          project: FakeRapidProject(path: 'project_path'),
        );

        verify(
          () => manager.run(
            ['flutter', 'config', '--enable-linux-desktop'],
            workingDirectory: 'project_path',
            runInShell: true,
            stderrEncoding: utf8,
            stdoutEncoding: utf8,
          ),
        ).called(1);
      }),
    );

    test(
      'completes (macos)',
      withMockEnv((manager) async {
        await flutterConfigEnable(
          platform: Platform.macos,
          project: FakeRapidProject(path: 'project_path'),
        );

        verify(
          () => manager.run(
            ['flutter', 'config', '--enable-macos-desktop'],
            workingDirectory: 'project_path',
            runInShell: true,
            stderrEncoding: utf8,
            stdoutEncoding: utf8,
          ),
        ).called(1);
      }),
    );

    test(
      'completes (web)',
      withMockEnv((manager) async {
        await flutterConfigEnable(
          platform: Platform.web,
          project: FakeRapidProject(path: 'project_path'),
        );

        verify(
          () => manager.run(
            ['flutter', 'config', '--enable-web'],
            workingDirectory: 'project_path',
            runInShell: true,
            stderrEncoding: utf8,
            stdoutEncoding: utf8,
          ),
        ).called(1);
      }),
    );

    test(
      'completes (windows)',
      withMockEnv((manager) async {
        await flutterConfigEnable(
          platform: Platform.windows,
          project: FakeRapidProject(path: 'project_path'),
        );

        verify(
          () => manager.run(
            ['flutter', 'config', '--enable-windows-desktop'],
            workingDirectory: 'project_path',
            runInShell: true,
            stderrEncoding: utf8,
            stdoutEncoding: utf8,
          ),
        ).called(1);
      }),
    );
  });
}