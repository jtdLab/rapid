@Tags(['e2e', 'web'])
import 'dart:convert';

import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/command_runner.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

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

      test(
        'activate web',
        () async {
          final appPackagePath = p.join(
              Directory.current.path, 'packages', projectName, projectName);

          await commandRunner.run(
            [
              'create',
              Directory.current.path,
              '--project-name',
              projectName,
            ],
          );

          final activateWebResult = await commandRunner.run(
            ['activate', 'web'],
          );
          expect(activateWebResult, equals(ExitCode.success.code));

          // TODO other project metrics like no analyze, format issues, no todos, all tests pass, ..
          // TODO check  platform packges and dirs exists
          final integrationTestResult = await Process.start(
            'flutter',
            ['test', 'integration_test/development_test.dart', '-d', '-web'],
            workingDirectory: appPackagePath,
            runInShell: true,
          );
          integrationTestResult.stderr.listen((event) {
            print(utf8.decode(event));
          });
          integrationTestResult.stdout.listen((event) {
            print(utf8.decode(event));
          });
          final exitCode = await integrationTestResult.exitCode;
          expect(
            exitCode,
            equals(ExitCode.success.code),
          );
          expect(integrationTestResult.stderr, isEmpty);
          expect(integrationTestResult.stdout, contains('All tests passed!'));
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 8)),
  );
}
