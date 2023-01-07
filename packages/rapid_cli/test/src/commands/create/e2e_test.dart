@Tags(['e2e'])
import 'package:mason/mason.dart';
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

      late RapidCommandRunner commandRunner;

      setUp(() {
        Directory.current = Directory.systemTemp.createTempSync();

        commandRunner = RapidCommandRunner();
      });

      tearDown(() {
        Directory.current = cwd;
      });

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
          await verifyNoFormattingIssues();

          // TODO maybe verify that no platform dir exists

          verifyTestsPassWith100PercentCoverage(platformIndependentDirs);
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
            await verifyNoFormattingIssues();

            // TODO maybe verify that platform dir exist

            final platformDependentDirs = platformDirs('android');
            verifyTestsPassWith100PercentCoverage([
              ...platformIndependentDirs,
              ...platformDependentDirs,
            ]);

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
            await verifyNoFormattingIssues();

            // TODO maybe verify that platform dir exist

            final platformDependentDirs = platformDirs('ios');
            verifyTestsPassWith100PercentCoverage([
              ...platformIndependentDirs,
              ...platformDependentDirs,
            ]);

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
            await verifyNoFormattingIssues();

            // TODO maybe verify that platform dir exist

            final platformDependentDirs = platformDirs('linux');
            verifyTestsPassWith100PercentCoverage([
              ...platformIndependentDirs,
              ...platformDependentDirs,
            ]);

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
            await verifyNoFormattingIssues();

            // TODO maybe verify that platform dir exist

            final platformDependentDirs = platformDirs('macos');
            verifyTestsPassWith100PercentCoverage([
              ...platformIndependentDirs,
              ...platformDependentDirs,
            ]);

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
            await verifyNoFormattingIssues();

            // TODO maybe verify that platform dir exist

            final platformDependentDirs = platformDirs('web');
            verifyTestsPassWith100PercentCoverage([
              ...platformIndependentDirs,
              ...platformDependentDirs,
            ]);

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
            await verifyNoFormattingIssues();

            // TODO maybe verify that platform dir exist

            final platformDependentDirs = platformDirs('windows');
            verifyTestsPassWith100PercentCoverage([
              ...platformIndependentDirs,
              ...platformDependentDirs,
            ]);

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
