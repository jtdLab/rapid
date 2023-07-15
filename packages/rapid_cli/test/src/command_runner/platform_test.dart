import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import '../common.dart';
import '../mocks.dart';
import '../utils.dart';

List<String> expectedUsage(
  List<FakePlatformFeaturePackage> featurePackages, {
  required Platform platform,
}) {
  return [
    'Work with the ${platform.prettyName} part of an existing Rapid project.\n'
        '\n'
        'Usage: rapid ${platform.name} <subcommand>\n'
        '-h, --help    Print this usage information.\n'
        '\n'
        'Available subcommands:\n'
        '  add         Add features or languages to the ${platform.prettyName} part of an existing Rapid project.\n'
        '${featurePackages.map((e) => '  ${e.name}   Work with ${e.name} of the ${platform.prettyName} part of an existing Rapid project.\n').join()}'
        '  remove      Removes features or languages from the ${platform.prettyName} part of an existing Rapid project.\n'
        '  set         Set properties of features from the ${platform.prettyName} part of an existing Rapid project.\n'
        '\n'
        'Run "rapid help" to see global options.'
  ];
}

void main() {
  for (final platform in Platform.values) {
    group(platform.name, () {
      test(
        'help',
        overridePrint(
          (printLogs) async {
            final featurePackages = [
              FakePlatformFeaturePackage(name: 'package_a'),
              FakePlatformFeaturePackage(name: 'package_b'),
            ];
            final project = getProject(featurePackages: featurePackages);
            final commandRunner = getCommandRunner(project: project);

            await commandRunner.run([platform.name, '--help']);
            expect(
              printLogs,
              equals(expectedUsage(featurePackages, platform: platform)),
            );

            printLogs.clear();

            await commandRunner.run([platform.name, '-h']);
            expect(
              printLogs,
              equals(expectedUsage(featurePackages, platform: platform)),
            );
          },
        ),
      );
    });
  }
}
