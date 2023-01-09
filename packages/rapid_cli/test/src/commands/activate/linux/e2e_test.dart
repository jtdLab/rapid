@Tags(['e2e', 'linux'])
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(
    'E2E',
    () {
      cwd = Directory.current;

      late RapidCommandRunner commandRunner;

      setUp(() {
        Directory.current = Directory.systemTemp.createTempSync();

        // TODO add mock logger here to prevent logging to stdout while running tests
        commandRunner = RapidCommandRunner();
      });

      test(
        'activate linux',
        () async {
          // Arrange
          await setupProjectNoPlatforms();

          // Act
          final commandResult = await commandRunner.run(
            ['activate', 'linux'],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final platformDependentDirs = platformDirs('linux');
          verifyDoExist(platformIndependentDirs);
          verifyDoExist(platformDependentDirs);

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
      );
    },
    timeout: const Timeout(Duration(minutes: 8)), // TODO should be lower
  );
}
