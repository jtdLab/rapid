@Tags(['e2e'])
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/core/platform.dart';
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
        'linux remove feature (fast)',
        () async {
          // Arrange
          const featureName = 'home_page';
          await setupProjectWithPlatform(Platform.linux);

          // Act
          final commandResult = await commandRunner.run(
            ['linux', 'remove', 'feature', featureName],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyHasAnalyzerIssues(8);
          await verifyNoFormattingIssues();

          final platformDependentDirs = platformDirs(Platform.linux);
          final featureDir = featurePackage(featureName, Platform.linux);
          verifyDoExist([
            ...platformIndependentPackages,
            ...platformDependentDirs,
          ]);
          verifyDoNotExist([featureDir]);
        },
        tags: ['fast'],
      );

      test(
        'linux remove feature',
        () async {
          // Arrange
          const featureName = 'home_page';
          await setupProjectWithPlatform(Platform.linux);

          // Act
          final commandResult = await commandRunner.run(
            ['linux', 'remove', 'feature', featureName],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyHasAnalyzerIssues(8);
          await verifyNoFormattingIssues();

          final platformDependentDirs = platformDirs(Platform.linux);
          final featureDir = featurePackage(featureName, Platform.linux);
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
