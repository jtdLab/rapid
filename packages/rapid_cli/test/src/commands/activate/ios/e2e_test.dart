@Tags(['e2e'])
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../helpers/e2e_helper.dart';

void main() {
  group(
    'E2E',
    () {
      cwd = Directory.current;

      late RapidCommandRunner commandRunner;

      setUp(() {
        Directory.current = Directory.systemTemp.createTempSync();

        commandRunner = RapidCommandRunner();
      });

      tearDown(() {
        Directory.current = cwd;
      });

      test(
        'activate ios (fast)',
        () async {
          // Arrange
          await setupProjectNoPlatforms();

          // Act
          final commandResult = await commandRunner.run(
            ['activate', 'ios'],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final platformDependentDirs = platformDirs('ios');
          verifyDoExist(platformIndependentDirs);
          verifyDoExist(platformDependentDirs);

          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentDirs,
            ...platformDependentDirs,
          ]);
        },
      );

      test(
        'activate ios',
        () async {
          // Arrange
          await setupProjectNoPlatforms();

          // Act
          final commandResult = await commandRunner.run(
            ['activate', 'ios'],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final platformDependentDirs = platformDirs('ios');
          verifyDoExist(platformIndependentDirs);
          verifyDoExist(platformDependentDirs);

          await verifyTestsPassWith100PercentCoverage([
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
    },
    timeout: const Timeout(Duration(minutes: 8)), // TODO should be lower
  );
}
