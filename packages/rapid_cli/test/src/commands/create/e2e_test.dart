@Tags(['e2e'])
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../helpers/e2e_helper.dart';

void main() {
  group(
    'E2E',
    () {
      final cwd = Directory.current;

      late RapidCommandRunner commandRunner;

      setUpAll(() {
        projectName = 'test_app';
      });

      setUp(() {
        Directory.current = Directory.systemTemp.createTempSync();

        commandRunner = RapidCommandRunner();
      });

      tearDown(() {
        Directory.current = cwd;
      });

      test(
        'create',
        () async {
          // Act
          final commandResult = await commandRunner.run(
            ['create', projectName],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          // TODO maybe verify that no platform dir exists

          await verifyTestsPassWith100PercentCoverage(
            platformIndependentDirs
              ..remove(domainDir)
              ..remove(infraDir),
          );
        },
      );

      group('create', () {
        test(
          '--android (fast)',
          () async {
            // Act
            final commandResult = await commandRunner.run(
              ['create', projectName, '--android'],
            );

            // Assert
            expect(commandResult, equals(ExitCode.success.code));

            await verifyNoAnalyzerIssues();
            await verifyNoFormattingIssues();

            // TODO maybe verify that platform dir exist

            final platformDependentDirs = platformDirs('android');
            await verifyTestsPassWith100PercentCoverage([
              ...platformIndependentDirs
                ..remove(domainDir)
                ..remove(infraDir),
              ...platformDependentDirs,
            ]);
          },
        );

        test(
          '--android',
          () async {
            // Act
            final commandResult = await commandRunner.run(
              ['create', projectName, '--android'],
            );

            // Assert
            expect(commandResult, equals(ExitCode.success.code));

            await verifyNoAnalyzerIssues();
            await verifyNoFormattingIssues();

            // TODO maybe verify that platform dir exist

            final platformDependentDirs = platformDirs('android');
            await verifyTestsPassWith100PercentCoverage([
              ...platformIndependentDirs
                ..remove(domainDir)
                ..remove(infraDir),
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
          '--ios (fast)',
          () async {
            // Act
            final commandResult = await commandRunner.run(
              ['create', projectName, '--ios'],
            );

            // Assert
            expect(commandResult, equals(ExitCode.success.code));

            await verifyNoAnalyzerIssues();
            await verifyNoFormattingIssues();

            // TODO maybe verify that platform dir exist

            final platformDependentDirs = platformDirs('ios');
            await verifyTestsPassWith100PercentCoverage([
              ...platformIndependentDirs
                ..remove(domainDir)
                ..remove(infraDir),
              ...platformDependentDirs,
            ]);
          },
        );

        test(
          '--ios',
          () async {
            // Act
            final commandResult = await commandRunner.run(
              ['create', projectName, '--ios'],
            );

            // Assert
            expect(commandResult, equals(ExitCode.success.code));

            await verifyNoAnalyzerIssues();
            await verifyNoFormattingIssues();

            // TODO maybe verify that platform dir exist

            final platformDependentDirs = platformDirs('ios');
            await verifyTestsPassWith100PercentCoverage([
              ...platformIndependentDirs
                ..remove(domainDir)
                ..remove(infraDir),
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
          '--linux (fast)',
          () async {
            // Act
            final commandResult = await commandRunner.run(
              ['create', projectName, '--linux'],
            );

            // Assert
            expect(commandResult, equals(ExitCode.success.code));

            await verifyNoAnalyzerIssues();
            await verifyNoFormattingIssues();

            // TODO maybe verify that platform dir exist

            final platformDependentDirs = platformDirs('linux');
            await verifyTestsPassWith100PercentCoverage([
              ...platformIndependentDirs
                ..remove(domainDir)
                ..remove(infraDir),
              ...platformDependentDirs,
            ]);
          },
        );

        test(
          '--linux',
          () async {
            // Act
            final commandResult = await commandRunner.run(
              ['create', projectName, '--linux'],
            );

            // Assert
            expect(commandResult, equals(ExitCode.success.code));

            await verifyNoAnalyzerIssues();
            await verifyNoFormattingIssues();

            // TODO maybe verify that platform dir exist

            final platformDependentDirs = platformDirs('linux');
            await verifyTestsPassWith100PercentCoverage([
              ...platformIndependentDirs
                ..remove(domainDir)
                ..remove(infraDir),
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
          '--macos (fast)',
          () async {
            // Act
            final commandResult = await commandRunner.run(
              ['create', projectName, '--macos'],
            );

            // Assert
            expect(commandResult, equals(ExitCode.success.code));

            await verifyNoAnalyzerIssues();
            await verifyNoFormattingIssues();

            // TODO maybe verify that platform dir exist

            final platformDependentDirs = platformDirs('macos');
            await verifyTestsPassWith100PercentCoverage([
              ...platformIndependentDirs
                ..remove(domainDir)
                ..remove(infraDir),
              ...platformDependentDirs,
            ]);
          },
        );

        test(
          '--macos',
          () async {
            // Act
            final commandResult = await commandRunner.run(
              ['create', projectName, '--macos'],
            );

            // Assert
            expect(commandResult, equals(ExitCode.success.code));

            await verifyNoAnalyzerIssues();
            await verifyNoFormattingIssues();

            // TODO maybe verify that platform dir exist

            final platformDependentDirs = platformDirs('macos');
            await verifyTestsPassWith100PercentCoverage([
              ...platformIndependentDirs
                ..remove(domainDir)
                ..remove(infraDir),
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
          '--web (fast)',
          () async {
            // Act
            final commandResult = await commandRunner.run(
              ['create', projectName, '--web'],
            );

            // Assert
            expect(commandResult, equals(ExitCode.success.code));

            await verifyNoAnalyzerIssues();
            await verifyNoFormattingIssues();

            // TODO maybe verify that platform dir exist

            final platformDependentDirs = platformDirs('web');
            await verifyTestsPassWith100PercentCoverage([
              ...platformIndependentDirs
                ..remove(domainDir)
                ..remove(infraDir),
              ...platformDependentDirs,
            ]);
          },
        );

        test(
          '--web',
          () async {
            // Act
            final commandResult = await commandRunner.run(
              ['create', projectName, '--web'],
            );

            // Assert
            expect(commandResult, equals(ExitCode.success.code));

            await verifyNoAnalyzerIssues();
            await verifyNoFormattingIssues();

            // TODO maybe verify that platform dir exist

            final platformDependentDirs = platformDirs('web');
            await verifyTestsPassWith100PercentCoverage([
              ...platformIndependentDirs
                ..remove(domainDir)
                ..remove(infraDir),
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
          '--windows (fast)',
          () async {
            // Act
            final commandResult = await commandRunner.run(
              ['create', projectName, '--windows'],
            );

            // Assert
            expect(commandResult, equals(ExitCode.success.code));

            await verifyNoAnalyzerIssues();
            await verifyNoFormattingIssues();

            // TODO maybe verify that platform dir exist

            final platformDependentDirs = platformDirs('windows');
            await verifyTestsPassWith100PercentCoverage([
              ...platformIndependentDirs
                ..remove(domainDir)
                ..remove(infraDir),
              ...platformDependentDirs,
            ]);
          },
        );

        test(
          '--windows',
          () async {
            // Act
            final commandResult = await commandRunner.run(
              ['create', projectName, '--windows'],
            );

            // Assert
            expect(commandResult, equals(ExitCode.success.code));

            await verifyNoAnalyzerIssues();
            await verifyNoFormattingIssues();

            // TODO maybe verify that platform dir exist

            final platformDependentDirs = platformDirs('windows');
            await verifyTestsPassWith100PercentCoverage([
              ...platformIndependentDirs
                ..remove(domainDir)
                ..remove(infraDir),
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
    timeout: const Timeout(Duration(minutes: 6)),
  );
}
