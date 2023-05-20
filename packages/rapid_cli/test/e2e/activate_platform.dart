import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'common.dart';

Future<void> performTest({
  required Platform platform,
  TestType type = TestType.normal,
  required RapidCommandRunner commandRunner,
}) async {
  // Arrange
  await setupProject();

  // Act
  final commandResult = await commandRunner.run([
    'activate',
    platform.name,
  ]);

  // Assert
  expect(commandResult, equals(ExitCode.success.code));
  await verifyNoAnalyzerIssues();
  await verifyNoFormattingIssues();
  final platformPackages = platformDependentPackages([platform]);
  final featurePackages = [
    featurePackage('app', platform),
    featurePackage('home_page', platform),
  ];
  verifyDoExist([
    ...platformIndependentPackages,
    ...platformPackages,
    ...featurePackages,
  ]);
  verifyDoNotExist(
    allPlatformDependentPackages.without(platformPackages),
  );
  if (type != TestType.fast) {
    verifyDoNotHaveTests([
      ...platformIndependentPackagesWithoutTests,
      ...platformDependentPackagesWithoutTests(platform)
    ]);
    await verifyTestsPassWith100PercentCoverage([
      ...platformIndependentPackagesWithTests,
      ...platformDependentPackagesWithTests(platform),
      ...featurePackages,
    ]);
  }

  if (type == TestType.slow) {
    final failedIntegrationTests = await runFlutterIntegrationTest(
      platformRootPackage(platform),
      pathToTests: 'integration_test/development_test.dart',
      platform: platform,
    );
    expect(failedIntegrationTests, 0);
  }
}
