@Tags(['e2e'])
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
        'web add feature (fast)',
        () async {
          // Arrange
          const featureName = 'my_feature';
          await setupProjectWithPlatform('web');

          // Act
          final commandResult = await commandRunner.run(
            ['web', 'add', 'feature', featureName],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final platformDependentDirs = platformDirs('web');
          final featureDir = featureDirectory(featureName, 'web');
          verifyDoExist([
            ...platformIndependentDirs,
            ...platformDependentDirs,
            featureDir,
          ]);

          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentDirs,
            ...platformDependentDirs,
            featureDir,
          ]);
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
