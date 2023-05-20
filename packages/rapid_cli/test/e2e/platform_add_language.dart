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
  const language = 'fr';
  await setupProject(platform);

  // Act
  final commandResult = await commandRunner.run([
    platform.name,
    'add',
    'language',
    language,
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
    ...languageFiles('home_page', platform, ['en', language]),
  ]);
  await verifyTestsPassWith100PercentCoverage([
    ...platformIndependentPackagesWithTests,
    ...platformDependentPackagesWithTests(platform),
    ...featurePackages,
  ]);
}
