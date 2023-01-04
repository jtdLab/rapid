@Tags(['e2e'])
import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/command_runner.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../helpers/helpers.dart';

void main() {
  group(
    'E2E',
    () {
      final cwd = Directory.current;

      late RapidCommandRunner commandRunner;

      const projectName = 'test_app';

      setUp(() {
        Directory.current = Directory.systemTemp.createTempSync();

        commandRunner = RapidCommandRunner();
      });

      tearDown(() {
        Directory.current = cwd;
      });

// TODO add ci setup and uncomment this test
/*       test(
        '--create',
        () async {
          final commandResult = await commandRunner.run(
            [
              'create',
              Directory.current.path,
              '--project-name',
              projectName,
            ],
          );
          expect(commandResult, equals(ExitCode.success.code));

          // TODO other project metrics like no analyze, format issues, no todos, all tests pass, ..
          // TODO check no platform packges and dirs exists
        },
      ); */

      group('create', () {
        test(
          '--android',
          () async {
            final appPackagePath = p.join(
                Directory.current.path, 'packages', projectName, projectName);

            final commandResult = await commandRunner.run(
              [
                'create',
                Directory.current.path,
                '--project-name',
                projectName,
                '--android'
              ],
            );
            expect(commandResult, equals(ExitCode.success.code));

            // TODO other project metrics like no analyze, format issues, no todos, all tests pass, ..
            // TODO check  platform packges and dirs exists
            final integrationTestResult = await Process.run(
              'flutter',
              [
                'test',
                'integration_test/development_test.dart',
                '-d',
                'android'
              ],
              workingDirectory: appPackagePath,
              runInShell: true,
            );
            expect(
              integrationTestResult.exitCode,
              equals(ExitCode.success.code),
            );
            expect(integrationTestResult.stderr, isEmpty);
            expect(integrationTestResult.stdout, contains('All tests passed!'));
          },
          tags: ['android'],
        );

        test(
          '--ios',
          () async {
            final appPackagePath = p.join(
                Directory.current.path, 'packages', projectName, projectName);

            final commandResult = await commandRunner.run(
              [
                'create',
                Directory.current.path,
                '--project-name',
                projectName,
                '--ios'
              ],
            );
            expect(commandResult, equals(ExitCode.success.code));

            // TODO other project metrics like no analyze, format issues, no todos, all tests pass, ..
            // TODO check  platform packges and dirs exists
            final integrationTestResult = await Process.run(
              'flutter',
              [
                'test',
                'integration_test/development_test.dart',
                '-d',
                iosDevice,
              ], // TODO device should be ios but does not work
              workingDirectory: appPackagePath,
              runInShell: true,
            );
            expect(
              integrationTestResult.exitCode,
              equals(ExitCode.success.code),
            );
            expect(integrationTestResult.stderr, isEmpty);
            expect(integrationTestResult.stdout, contains('All tests passed!'));
          },
          tags: ['ios'],
        );

        test(
          '--linux',
          () async {
            final appPackagePath = p.join(
                Directory.current.path, 'packages', projectName, projectName);

            final commandResult = await commandRunner.run(
              [
                'create',
                Directory.current.path,
                '--project-name',
                projectName,
                '--linux'
              ],
            );
            expect(commandResult, equals(ExitCode.success.code));

            // TODO other project metrics like no analyze, format issues, no todos, all tests pass, ..
            // TODO check  platform packges and dirs exists
            final integrationTestResult = await Process.run(
              'flutter',
              ['test', 'integration_test/development_test.dart', '-d', 'linux'],
              workingDirectory: appPackagePath,
              runInShell: true,
            );
            expect(
              integrationTestResult.exitCode,
              equals(ExitCode.success.code),
            );
            expect(integrationTestResult.stderr, isEmpty);
            expect(integrationTestResult.stdout, contains('All tests passed!'));
          },
          tags: ['linux'],
        );

        test(
          '--macos',
          () async {
            final appPackagePath = p.join(
                Directory.current.path, 'packages', projectName, projectName);

            final commandResult = await commandRunner.run(
              [
                'create',
                Directory.current.path,
                '--project-name',
                projectName,
                '--macos'
              ],
            );
            expect(commandResult, equals(ExitCode.success.code));

            // TODO other project metrics like no analyze, format issues, no todos, all tests pass, ..
            // TODO check  platform packges and dirs exists
            final integrationTestResult = await Process.run(
              'flutter',
              ['test', 'integration_test/development_test.dart', '-d', 'macos'],
              workingDirectory: appPackagePath,
              runInShell: true,
            );
            expect(
              integrationTestResult.exitCode,
              equals(ExitCode.success.code),
            );
            expect(integrationTestResult.stderr, isEmpty);
            expect(integrationTestResult.stdout, contains('All tests passed!'));
          },
          tags: ['macos'],
        );

        test(
          '--web',
          () async {
            final appPackagePath = p.join(
                Directory.current.path, 'packages', projectName, projectName);

            final commandResult = await commandRunner.run(
              [
                'create',
                Directory.current.path,
                '--project-name',
                projectName,
                '--web'
              ],
            );
            expect(commandResult, equals(ExitCode.success.code));

            // TODO other project metrics like no analyze, format issues, no todos, all tests pass, ..
            // TODO check  platform packges and dirs exists
            await Process.start(
              'chromedriver',
              ['--port=4444'],
              workingDirectory: appPackagePath,
              runInShell: true,
            );
            final integrationTestResult = await Process.run(
              'flutter',
              [
                'drive',
                '--driver',
                'test_driver/integration_test.dart',
                '--target',
                'integration_test/development_test.dart',
                '-d',
                'web-server'
              ],
              workingDirectory: appPackagePath,
              runInShell: true,
            );
            expect(
              integrationTestResult.exitCode,
              equals(ExitCode.success.code),
            );
            expect(integrationTestResult.stdout, contains('All tests passed.'));
          },
          tags: ['web'],
        );

        test(
          '--windows',
          () async {
            final appPackagePath = p.join(
                Directory.current.path, 'packages', projectName, projectName);

            final commandResult = await commandRunner.run(
              [
                'create',
                Directory.current.path,
                '--project-name',
                projectName,
                '--windows'
              ],
            );
            expect(commandResult, equals(ExitCode.success.code));

            // TODO other project metrics like no analyze, format issues, no todos, all tests pass, ..
            // TODO check  platform packges and dirs exists
            final integrationTestResult = await Process.run(
              'flutter',
              [
                'test',
                'integration_test/development_test.dart',
                '-d',
                'windows'
              ],
              workingDirectory: appPackagePath,
              runInShell: true,
            );
            print(integrationTestResult.stderr); // TODO
            print(integrationTestResult.stdout); // TODO
            expect(
              integrationTestResult.exitCode,
              equals(ExitCode.success.code),
            );
            expect(integrationTestResult.stderr, isEmpty);
            expect(integrationTestResult.stdout, contains('All tests passed!'));
          },
          tags: ['windows'],
        );
      });
    },
    timeout: const Timeout(Duration(minutes: 8)),
  );
}
