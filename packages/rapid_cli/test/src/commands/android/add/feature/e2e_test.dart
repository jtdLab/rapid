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
        'android add feature (fast)',
        () async {
          // Arrange
          const featureName = 'my_feature';
          await setupProjectWithPlatform(Platform.android);

          // Act
          final commandResult = await commandRunner.run(
            ['android', 'add', 'feature', featureName],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final platformDependentDirs = platformDirs(Platform.android);
          final featureDir = featurePackage(featureName, Platform.android);
          verifyDoExist([
            ...platformIndependentPackages,
            ...platformDependentDirs,
            featureDir,
          ]);
        },
        tags: ['fast'],
      );

      test(
        'android add feature',
        () async {
          // Arrange
          const featureName = 'my_feature';
          await setupProjectWithPlatform(Platform.android);

          // Act
          final commandResult = await commandRunner.run(
            ['android', 'add', 'feature', featureName],
          );

          // Assert
          expect(commandResult, equals(ExitCode.success.code));

          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();

          final platformDependentDirs = platformDirs(Platform.android);
          final featureDir = featurePackage(featureName, Platform.android);
          verifyDoExist([
            ...platformIndependentPackages,
            ...platformDependentDirs,
            featureDir,
          ]);

          await verifyTestsPassWith100PercentCoverage([
            ...platformIndependentPackages,
            ...platformDependentDirs,
            featureDir,
          ]);
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
