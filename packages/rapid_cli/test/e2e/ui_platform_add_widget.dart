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
  final name = 'FooBar';

  // Act
  final commandResult = await commandRunner.run([
    'ui',
    platform.name,
    'add',
    'widget',
    name,
  ]);

  // Assert
  expect(commandResult, equals(ExitCode.success.code));
  await verifyNoAnalyzerIssues();
  await verifyNoFormattingIssues();
  verifyDoExist({
    ...platformIndependentPackages,
    ...widgetFiles(name: name, platform: platform),
  });
  if (type != TestType.fast) {
    await verifyTestsPassWith100PercentCoverage({
      platformUiPackage(platform),
    });
  }
}
