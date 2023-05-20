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
  await setupProject(platform);
  final featureName = 'home_page';
  await commandRunner.run([
    platform.name,
    'add',
    'navigator',
    '-f',
    featureName,
  ]);

  // Act
  final commandResult = await commandRunner.run([
    platform.name,
    'remove',
    'navigator',
    '-f',
    featureName,
  ]);

  // Assert
  expect(commandResult, equals(ExitCode.success.code));
  await verifyNoAnalyzerIssues();
  await verifyNoFormattingIssues();
  final appFeaturePackage = featurePackage('app', platform);
  final feature = featurePackage(featureName, platform);
  verifyDoExist({
    ...platformIndependentPackages,
    ...platformDependentPackages([platform]),
    appFeaturePackage,
    feature,
  });
  verifyDoNotExist({
    ...navigatorFiles(
      featureName: featureName,
      platform: platform,
    ),
    ...navigatorImplementationFiles(
      featureName: featureName,
      platform: platform,
    ),
  });
  await verifyTestsPassWith100PercentCoverage([
    ...platformIndependentPackagesWithTests,
    ...platformDependentPackagesWithTests(platform),
    appFeaturePackage,
  ]);
  // TODO
  await verifyTestsPass(feature, expectedCoverage: 100.0);
}
