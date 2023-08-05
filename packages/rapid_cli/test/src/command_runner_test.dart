import 'dart:convert';

import 'package:args/command_runner.dart';
import 'package:cli_launcher/cli_launcher.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pub_updater/pub_updater.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/io/io.dart';
import 'package:rapid_cli/src/logging.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:rapid_cli/src/utils.dart';
import 'package:rapid_cli/src/version.dart';
import 'package:test/test.dart';

import 'common.dart';
import 'mock_env.dart';
import 'mocks.dart';
import 'utils.dart';

const expectedUsage = [
  'A CLI tool for developing Flutter apps based on Rapid Architecture.\n'
      '\n'
      'Usage: rapid <command>\n'
      '\n'
      'Global options:\n'
      '-h, --help       Print this usage information.\n'
      '-v, --version    Print the current version.\n'
      '    --verbose    Enable verbose logging.\n'
      '\n'
      'Available commands:\n'
      '  activate         Add support for a platform to an existing Rapid project.\n'
      '  android          Work with the Android part of an existing Rapid project.\n'
      '  begin            Starts a group of Rapid command executions.\n'
      '  create           Create a new Rapid project.\n'
      '  deactivate       Remove support for a platform from an existing Rapid project.\n'
      '  domain           Work with the domain part of an existing Rapid project.\n'
      '  end              Ends a group of Rapid command executions.\n'
      '  infrastructure   Work with the infrastructure part of an existing Rapid project.\n'
      '  ios              Work with the iOS part of an existing Rapid project.\n'
      '  linux            Work with the Linux part of an existing Rapid project.\n'
      '  macos            Work with the macOS part of an existing Rapid project.\n'
      '  mobile           Work with the Mobile part of an existing Rapid project.\n'
      '  pub              Work with packages in a Rapid environment.\n'
      '  ui               Work with the UI part of an existing Rapid project.\n'
      '  web              Work with the Web part of an existing Rapid project.\n'
      '  windows          Work with the Windows part of an existing Rapid project.\n'
      '\n'
      'Run "rapid help <command>" for more information about a command.'
];

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('RapidCommandRunner', () {
    test(
      'help',
      overridePrint((printLogs) async {
        final commandRunner = getCommandRunner();

        await commandRunner.run(['--help']);
        expect(printLogs, equals(expectedUsage));

        printLogs.clear();

        await commandRunner.run(['-h']);
        expect(printLogs, equals(expectedUsage));
      }),
    );
  });

  group('rapidEntryPoint', () {
    late RapidLogger logger;
    late RapidCommandRunner commandRunner;
    late RapidCommandRunner Function({RapidProject? project})
        commandRunnerBuilder;
    late PubUpdater pubUpdater;
    late LaunchContext launchContext;

    setUp(() {
      logger = MockRapidLogger();
      commandRunner = MockRapidCommandRunner();
      commandRunnerBuilder = MockRapidCommandRunnerBuilder();
      when(() => commandRunnerBuilder(project: any(named: 'project')))
          .thenReturn(commandRunner);
      pubUpdater = MockPubUpdater();
      launchContext = MockLaunchContext();
      when(() => launchContext.localInstallation).thenReturn(null);
    });

    test(
      'runs command',
      withMockEnv((_) async {
        final installation = MockExecutableInstallation();
        when(() => installation.packageRoot)
            .thenReturn(Directory('/some_path'));
        File('/some_path/pubspec.yaml')
          ..createSync(recursive: true)
          ..writeAsStringSync(multiLine([
            'name: cool',
            '',
            'environment:',
            '  sdk: ">=3.0.0 <4.0.0"',
            '',
            'rapid:',
            '  name: cool',
            '  foo: [1, 2, 3]'
          ]));
        when(() => launchContext.localInstallation).thenReturn(installation);
        await rapidEntryPoint(
          ['activate android'],
          launchContext,
          commandRunnerBuilder: commandRunnerBuilder,
        );

        verifyInOrder([
          () => commandRunnerBuilder(
                project: any(named: 'project', that: isNotNull),
              ),
          () => commandRunner.run(['activate android']),
        ]);
      }),
    );

    group('--version, -v', () {
      group('given installation is not up to date', () {
        setUp(() {
          when(
            () => pubUpdater.isUpToDate(
              packageName: packageName,
              currentVersion: packageVersion,
            ),
          ).thenAnswer((_) async => false);
          when(
            () => pubUpdater.getLatestVersion(packageName),
          ).thenAnswer((_) async => '1.0.0');
          // indicates local installation
          when(() => launchContext.localInstallation)
              .thenReturn(FakeExecutableInstallation());
        });

        test('informs about update', () async {
          await rapidEntryPoint(
            ['--version'],
            launchContext,
            logger: logger,
            pubUpdater: pubUpdater,
          );

          verifyInOrder([
            () => logger.info(packageVersion),
            () => logger.info(
                  'There is a new version of $packageName available (1.0.0).',
                ),
          ]);
        });

        group('and installation is global', () {
          setUp(() {
            // indicates global installation
            when(() => launchContext.localInstallation).thenReturn(null);
          });

          test('installs update when prompt is accepted', () async {
            when(
              () => logger.prompt(
                any(),
                defaultValue: any(named: 'defaultValue'),
                hidden: any(named: 'hidden'),
              ),
            ).thenReturn('true');

            await rapidEntryPoint(
              ['--version'],
              launchContext,
              logger: logger,
              pubUpdater: pubUpdater,
            );

            verifyInOrder([
              () => logger.info(packageVersion),
              () => logger.prompt(
                    'There is a new version of $packageName available '
                    '(1.0.0). Would you like to update?',
                    defaultValue: false,
                  ),
              () => pubUpdater.update(packageName: packageName),
              () => logger.info(
                    '$packageName has been updated to version 1.0.0.',
                  ),
            ]);
            verifyNoMoreInteractions(logger);
          });

          test('does nothing when is prompt declined', () async {
            when(() => logger.prompt(any())).thenReturn('false');

            await rapidEntryPoint(
              ['--version'],
              launchContext,
              logger: logger,
              pubUpdater: pubUpdater,
            );

            verifyInOrder([
              () => logger.info(packageVersion),
              () => logger.prompt(
                    'There is a new version of $packageName available '
                    '(1.0.0). Would you like to update?',
                    defaultValue: false,
                  ),
            ]);
            verifyNever(
              () => pubUpdater.update(packageName: any(named: 'packageName')),
            );
            verifyNoMoreInteractions(logger);
          });
        });
      });
    });

    test(
      'exits when Dart is not installed',
      withMockEnv((manager) async {
        when(
          () => manager.run(
            ['dart', '--version'],
            workingDirectory: any(named: 'workingDirectory'),
            runInShell: true,
            stderrEncoding: utf8,
            stdoutEncoding: utf8,
          ),
        ).thenAnswer(
          (_) async => ProcessResult(0, 1, 'stdout', 'stderr'),
        );

        await rapidEntryPoint(
          ['activate'],
          launchContext,
          logger: logger,
        );

        verify(() => logger.err('Dart not installed.')).called(1);
        expect(exitCode, 1);
      }),
    );

    test(
      'exits when Flutter is not installed',
      withMockEnv((manager) async {
        when(
          () => manager.run(
            ['flutter', '--version'],
            workingDirectory: any(named: 'workingDirectory'),
            runInShell: true,
            stderrEncoding: utf8,
            stdoutEncoding: utf8,
          ),
        ).thenAnswer(
          (_) async => ProcessResult(0, 1, 'stdout', 'stderr'),
        );

        await rapidEntryPoint(
          ['activate'],
          launchContext,
          logger: logger,
        );

        verify(() => logger.err('Flutter not installed.')).called(1);
        expect(exitCode, 1);
      }),
    );

    test(
      'exits when Melos is not installed',
      withMockEnv((manager) async {
        when(
          () => manager.run(
            ['melos', '--version'],
            workingDirectory: any(named: 'workingDirectory'),
            runInShell: true,
            stderrEncoding: utf8,
            stdoutEncoding: utf8,
          ),
        ).thenAnswer(
          (_) async => ProcessResult(0, 1, 'stdout', 'stderr'),
        );

        await rapidEntryPoint(
          ['activate'],
          launchContext,
          logger: logger,
        );

        verify(() => logger.err('Melos not installed.')).called(1);
        expect(exitCode, 1);
      }),
    );

    test('resolve project with null when will show help', () async {
      await rapidEntryPoint(
        ['activate', '--help'],
        launchContext,
        commandRunnerBuilder: commandRunnerBuilder,
      );

      verify(() => commandRunnerBuilder(project: null)).called(1);
    });

    test('resolve project with null when will run create', () async {
      await rapidEntryPoint(
        ['create'],
        launchContext,
        commandRunnerBuilder: commandRunnerBuilder,
      );

      verify(() => commandRunnerBuilder(project: null)).called(1);
    });

    test(
      'resolve project when cwd is inside a rapid project',
      withMockEnv((_) async {
        final installation = MockExecutableInstallation();
        when(() => installation.packageRoot)
            .thenReturn(Directory('/some_path'));
        File('/some_path/pubspec.yaml')
          ..createSync(recursive: true)
          ..writeAsStringSync(multiLine([
            'name: cool',
            '',
            'environment:',
            '  sdk: ">=3.0.0 <4.0.0"',
            '',
            'rapid:',
            '  name: cool',
          ]));
        when(() => launchContext.localInstallation).thenReturn(installation);
        await rapidEntryPoint(
          ['activate'],
          launchContext,
          commandRunnerBuilder: commandRunnerBuilder,
        );

        verify(
          () => commandRunnerBuilder(
            project: any(named: 'project', that: isNotNull),
          ),
        ).called(1);
      }),
    );

    test(
      'fails resolving project when cwd is not inside a rapid project',
      withMockEnv((_) async {
        await rapidEntryPoint(
          ['activate'],
          launchContext,
          logger: logger,
        );

        verify(
          () => logger.err(
            multiLine([
              'Your current directory does not appear to be within a Rapid ',
              'project.',
              '',
              'For setting up a project, see: ',
              'https://docs.page/jtdLab/rapid/cli/create',
            ]),
          ),
        ).called(1);
        expect(exitCode, 1);
      }),
    );

    test(
      'fails resolving project when cwd does not contain pubspec.yaml',
      withMockEnv((_) async {
        final installation = MockExecutableInstallation();
        when(() => installation.packageRoot).thenReturn(Directory('some_path'));
        when(() => launchContext.localInstallation).thenReturn(installation);
        await rapidEntryPoint(
          ['activate'],
          launchContext,
          logger: logger,
        );

        verify(
          () => logger.err(
            multiLine([
              'Found no pubspec.yaml file in "some_path".',
              '',
              'You must have a ${AnsiStyles.bold('pubspec.yaml')} file in the root ',
              'of your project.',
              '',
              'For more information, see: ',
              'https://docs.page/jtdLab/rapid/cli/create',
            ]),
          ),
        ).called(1);
        expect(exitCode, 1);
      }),
    );

    test(
      'fails resolving project when failed to parse pubspec.yaml',
      withMockEnv((_) async {
        final installation = MockExecutableInstallation();
        when(() => installation.packageRoot)
            .thenReturn(Directory('/some_path'));
        File('/some_path/pubspec.yaml')
          ..createSync(recursive: true)
          ..writeAsStringSync(multiLine([
            'name: cool',
            'name: cool',
          ]));
        when(() => launchContext.localInstallation).thenReturn(installation);
        await rapidEntryPoint(
          ['activate android'],
          launchContext,
          logger: logger,
        );

        verify(
          () => logger.err(
            any(
              that: contains('pubspec.yaml: could not be parsed and failed.'),
            ),
          ),
        ).called(1);
        expect(exitCode, 1);
      }),
    );

    test(
      'fails resolving project when pubspec.yaml does not contain YAML map',
      withMockEnv((_) async {
        final installation = MockExecutableInstallation();
        when(() => installation.packageRoot)
            .thenReturn(Directory('/some_path'));
        File('/some_path/pubspec.yaml')
          ..createSync(recursive: true)
          ..writeAsStringSync('a:b:c:d');
        when(() => launchContext.localInstallation).thenReturn(installation);
        await rapidEntryPoint(
          ['activate android'],
          launchContext,
          logger: logger,
        );

        verify(
          () => logger.err(
            'pubspec.yaml: must contain a YAML map.',
          ),
        ).called(1);
        expect(exitCode, 1);
      }),
    );

    test(
      'handles RapidException',
      withMockEnv((_) async {
        // TODO share setup valid project cwd is used in more cases
        final installation = MockExecutableInstallation();
        when(() => installation.packageRoot)
            .thenReturn(Directory('/some_path'));
        File('/some_path/pubspec.yaml')
          ..createSync(recursive: true)
          ..writeAsStringSync(multiLine([
            'name: cool',
            '',
            'environment:',
            '  sdk: ">=3.0.0 <4.0.0"',
            '',
            'rapid:',
            '  name: cool',
          ]));
        when(() => launchContext.localInstallation).thenReturn(installation);
        when(() => commandRunner.run(any())).thenThrow(FakeRapidException());

        await rapidEntryPoint(
          ['activate'],
          launchContext,
          logger: logger,
          commandRunnerBuilder: commandRunnerBuilder,
        );

        verify(
          () => logger.err('Instance of \'FakeRapidException\''),
        ).called(1);
        expect(exitCode, 1);
      }),
    );

    test(
      'handles UsageException',
      withMockEnv((_) async {
        final installation = MockExecutableInstallation();
        when(() => installation.packageRoot)
            .thenReturn(Directory('/some_path'));
        File('/some_path/pubspec.yaml')
          ..createSync(recursive: true)
          ..writeAsStringSync(multiLine([
            'name: cool',
            '',
            'environment:',
            '  sdk: ">=3.0.0 <4.0.0"',
            '',
            'rapid:',
            '  name: cool',
          ]));
        when(() => launchContext.localInstallation).thenReturn(installation);
        when(() => commandRunner.run(any()))
            .thenThrow(UsageException('message', 'usage'));

        await rapidEntryPoint(
          ['activate'],
          launchContext,
          logger: logger,
          commandRunnerBuilder: commandRunnerBuilder,
        );

        verify(
          () => logger.err(
            multiLine([
              'message',
              '',
              'usage',
            ]),
          ),
        ).called(1);
        expect(exitCode, 1);
      }),
    );

    test(
      'rethrows other errors',
      withMockEnv((_) async {
        final installation = MockExecutableInstallation();
        when(() => installation.packageRoot)
            .thenReturn(Directory('/some_path'));
        File('/some_path/pubspec.yaml')
          ..createSync(recursive: true)
          ..writeAsStringSync(multiLine([
            'name: cool',
            '',
            'environment:',
            '  sdk: ">=3.0.0 <4.0.0"',
            '',
            'rapid:',
            '  name: cool',
          ]));
        when(() => launchContext.localInstallation).thenReturn(installation);
        when(() => commandRunner.run(any())).thenThrow(Error());

        expect(
          () async => rapidEntryPoint(
            ['activate'],
            launchContext,
            logger: logger,
            commandRunnerBuilder: commandRunnerBuilder,
          ),
          throwsA(isA<Error>()),
        );
      }),
    );
  });
}
