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
  const featureName = 'foo_bar';
  await setupProject(platform);
  await commandRunner.run([
    platform.name,
    'add',
    'feature',
    featureName,
  ]);

  // Act
  final commandResult = await commandRunner.run([
    platform.name,
    'remove',
    'feature',
    featureName,
  ]);

  // Assert
  expect(commandResult, equals(ExitCode.success.code));
  await verifyNoAnalyzerIssues();
  await verifyNoFormattingIssues();
  final featurePackages = [
    featurePackage('app', platform),
    featurePackage('home_page', platform),
  ];
  verifyDoExist([
    ...platformIndependentPackages,
    ...platformDependentPackages([platform]),
    ...featurePackages,
  ]);
  verifyDoNotExist([
    featurePackage(featureName, platform),
  ]);
  await verifyTestsPassWith100PercentCoverage([
    ...platformIndependentPackagesWithTests,
    ...platformDependentPackagesWithTests(platform),
    ...featurePackages,
  ]);
}
