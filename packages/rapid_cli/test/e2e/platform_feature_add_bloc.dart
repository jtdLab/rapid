import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'common.dart';

Future<void> performTest({
  required Platform platform,
  String? outputDir,
  required double expectedCoverage,
  TestType type = TestType.normal,
  required RapidCommandRunner commandRunner,
}) async {
  // Arrange
  final name = 'FooBar';
  final featureName = 'home_page';

  // Act
  final commandResult = await commandRunner.run([
    platform.name,
    featureName,
    'add',
    'bloc',
    name,
    if (outputDir != null) '--output-dir',
    if (outputDir != null) outputDir,
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
    ...blocFiles(
      name: name,
      featureName: featureName,
      platform: platform,
      outputDir: outputDir,
    ),
  });
  await verifyTestsPassWith100PercentCoverage([
    ...platformIndependentPackagesWithTests,
    ...platformDependentPackagesWithTests(platform),
    appFeaturePackage,
  ]);
  // TODO
  await verifyTestsPass(feature, expectedCoverage: expectedCoverage);
}
