@Tags(['e2e', 'ios'])
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

      test(
        'activate ios',
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

          final activateIosResult = await commandRunner.run(
            ['activate', 'ios'],
          );
          expect(activateIosResult, equals(ExitCode.success.code));

          // TODO other project metrics like no analyze, format issues, no todos, all tests pass, ..
          // TODO check  platform packges and dirs exists
          final integrationTestResult = await Process.run(
            'flutter',
            [
              'test',
              'integration_test/development_test.dart',
              '-d',
              iosDevice,
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
      );
    },
    timeout: const Timeout(Duration(minutes: 8)),
  );
}
