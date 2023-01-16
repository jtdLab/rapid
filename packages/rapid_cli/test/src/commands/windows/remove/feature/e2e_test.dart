void main() {
  // TODO impl
}

/* @Tags(['e2e'])
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../../helpers/e2e_helper.dart';

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
        'windows remove feature (fast)',
        () async {
          // Arrange
          const featureName = 'home_page';
          await setupProjectWithPlatform('windows');

          // Act
          final commandResult = await commandRunner.run(
            ['windows', 'remove', 'feature', featureName],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final platformDependentDirs = platformDirs('windows');
          final featureDir = featurePackage(featureName, 'windows');
          verifyDoExist([
            ...platformIndependentPackages,
            ...platformDependentDirs,
          ]);
          verifyDoNotExist([featureDir]);

          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentPackages,
            ...platformDependentDirs,
          ]);
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
 */
