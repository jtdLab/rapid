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

        // TODO add mock logger here to prevent logging to stdout while running tests
        commandRunner = RapidCommandRunner();
      });

      tearDown(() {
        Directory.current = cwd;
      });

      test(
        'activate web (fast)',
        () async {
          // Arrange
          await setupProjectNoPlatforms();

          // Act
          final commandResult = await commandRunner.run(
            ['activate', 'web'],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final platformDependentDirs = platformDirs('web');
          verifyDoExist(platformIndependentDirs);
          verifyDoExist(platformDependentDirs);

          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentDirs,
            ...platformDependentDirs,
          ]);
        },
      );

      test(
        'activate web',
        () async {
          // Arrange
          await setupProjectNoPlatforms();

          // Act
          final commandResult = await commandRunner.run(
            ['activate', 'web'],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final platformDependentDirs = platformDirs('web');
          verifyDoExist(platformIndependentDirs);
          verifyDoExist(platformDependentDirs);

          await verifyTestsPassWith100PercentCoverage([
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
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );
}
