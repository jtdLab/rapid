@Tags(['e2e'])
import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../helpers/helpers.dart';

void main() {
  group(
    'E2E',
    () {
      final cwd = Directory.current;

      const projectName = 'test_app';

      late Directory appDir;
      late Directory diDir;
      late Directory domainDir;
      late Directory infraDir;
      late Directory loggingDir;
      late Directory uiDir;

      late RapidCommandRunner commandRunner;

      setUp(() {
        Directory.current = Directory.systemTemp.createTempSync();

        appDir = Directory(p.join('packages', projectName, projectName));
        diDir = Directory(p.join('packages', projectName, '${projectName}_di'));
        domainDir =
            Directory(p.join('packages', projectName, '${projectName}_domain'));
        infraDir = Directory(
            p.join('packages', projectName, '${projectName}_infrastructure'));
        loggingDir = Directory(
            p.join('packages', projectName, '${projectName}_logging'));
        uiDir = Directory(
            p.join('packages', '${projectName}_ui', '${projectName}_ui'));

        commandRunner = RapidCommandRunner();
      });

      tearDown(() {
        Directory.current = cwd;
      });

      Future<void> verifyTestsPassWith100PercentCoverage(
        List<Directory> dirs,
      ) async {
        for (final dir in dirs) {
          final testResult = await runFlutterTest(cwd: dir.path);
          expect(testResult.failedTests, 0);
          expect(testResult.coverage, 100);
        }
      }

      List<Directory> platformIndependentDirs() =>
          [appDir, diDir, domainDir, infraDir, loggingDir, uiDir];

      test(
        '--create',
        () async {
          // Act
          final commandResult = await commandRunner.run(
            ['create', '.', '--project-name', projectName],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          // await verifyNoFormattingIssues(); TODO add later

          final dirs = platformIndependentDirs();
          verifyTestsPassWith100PercentCoverage(dirs);

          // TODO maybe verify that no platform dir exists
        },
      );

      group('create', () {
        test(
          '--android',
          () async {
            // Act
            final commandResult = await commandRunner.run(
              ['create', '.', '--project-name', projectName, '--android'],
            );

            // Assert
            expect(commandResult, equals(ExitCode.success.code));

            await verifyNoAnalyzerIssues();
            // await verifyNoFormattingIssues(); TODO add later

            // TODO maybe verify that platform dir exist

            final failedIntegrationTests = await runFlutterIntegrationTest(
              cwd: appDir.path,
              pathToTests: 'integration_test/development_test.dart',
              platform: Platform.android,
            );
            expect(failedIntegrationTests, 0);
          },
          tags: ['android'],
        );

        test(
          '--ios',
          () async {
            // Act
            final commandResult = await commandRunner.run(
              ['create', '.', '--project-name', projectName, '--ios'],
            );

            // Assert
            expect(commandResult, equals(ExitCode.success.code));

            await verifyNoAnalyzerIssues();
            // await verifyNoFormattingIssues(); TODO add later

            // TODO maybe verify that platform dir exist

            final failedIntegrationTests = await runFlutterIntegrationTest(
              cwd: appDir.path,
              pathToTests: 'integration_test/development_test.dart',
              platform: Platform.ios,
            );
            expect(failedIntegrationTests, 0);
          },
          tags: ['ios'],
        );

        test(
          '--linux',
          () async {
            // Act
            final commandResult = await commandRunner.run(
              ['create', '.', '--project-name', projectName, '--linux'],
            );

            // Assert
            expect(commandResult, equals(ExitCode.success.code));

            await verifyNoAnalyzerIssues();
            // await verifyNoFormattingIssues(); TODO add later

            // TODO maybe verify that platform dir exist

            final failedIntegrationTests = await runFlutterIntegrationTest(
              cwd: appDir.path,
              pathToTests: 'integration_test/development_test.dart',
              platform: Platform.linux,
            );
            expect(failedIntegrationTests, 0);
          },
          tags: ['linux'],
        );

        test(
          '--macos',
          () async {
            // Act
            final commandResult = await commandRunner.run(
              ['create', '.', '--project-name', projectName, '--macos'],
            );

            // Assert
            expect(commandResult, equals(ExitCode.success.code));

            await verifyNoAnalyzerIssues();
            // await verifyNoFormattingIssues(); TODO add later

            // TODO maybe verify that platform dir exist

            final failedIntegrationTests = await runFlutterIntegrationTest(
              cwd: appDir.path,
              pathToTests: 'integration_test/development_test.dart',
              platform: Platform.macos,
            );
            expect(failedIntegrationTests, 0);
          },
          tags: ['macos'],
        );

        test(
          '--web',
          () async {
            // Act
            final commandResult = await commandRunner.run(
              ['create', '.', '--project-name', projectName, '--web'],
            );

            // Assert
            expect(commandResult, equals(ExitCode.success.code));

            await verifyNoAnalyzerIssues();
            // await verifyNoFormattingIssues(); TODO add later

            // TODO maybe verify that platform dir exist

            final failedIntegrationTests = await runFlutterIntegrationTest(
              cwd: appDir.path,
              pathToTests: 'integration_test/development_test.dart',
              platform: Platform.web,
            );
            expect(failedIntegrationTests, 0);
          },
          tags: ['web'],
        );

        test(
          '--windows',
          () async {
            // Act
            final commandResult = await commandRunner.run(
              ['create', '.', '--project-name', projectName, '--windows'],
            );

            // Assert
            expect(commandResult, equals(ExitCode.success.code));

            await verifyNoAnalyzerIssues();
            // await verifyNoFormattingIssues(); TODO add later

            // TODO maybe verify that platform dir exist

            final failedIntegrationTests = await runFlutterIntegrationTest(
              cwd: appDir.path,
              pathToTests: 'integration_test/development_test.dart',
              platform: Platform.windows,
            );
            // TODO fails because of https://github.com/felangel/mason/issues/676
            expect(failedIntegrationTests, 0);
          },
          tags: ['windows'],
        );
      });
    },
    timeout: const Timeout(Duration(minutes: 8)), // TODO should be lower
  );
}
