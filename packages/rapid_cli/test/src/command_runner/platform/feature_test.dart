import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import '../../common.dart';
import '../../mocks.dart';
import '../../utils.dart';

List<String> expectedUsage(
  String featurePackage, {
  required Platform platform,
}) {
  return [
    'Work with $featurePackage of the ${platform.prettyName} part of an existing Rapid project.\n'
        '\n'
        'Usage: rapid ${platform.name} $featurePackage <subcommand>\n'
        '-h, --help    Print this usage information.\n'
        '\n'
        'Available subcommands:\n'
        '  add      Add components to $featurePackage of the ${platform.prettyName} part of an existing Rapid project.\n'
        '  remove   Remove components from $featurePackage of the ${platform.prettyName} part of an existing Rapid project.\n'
        '\n'
        'Run "rapid help" to see global options.'
  ];
}

void main() {
  for (final platform in Platform.values) {
    group('${platform.name} <feature>', () {
      test(
        'help',
        overridePrint((printLogs) async {
          final featurePackage = FakePlatformFeaturePackage(name: 'package_a');
          final project = getProject(featurePackages: [featurePackage]);
          final commandRunner = getCommandRunner(project: project);

          await commandRunner.run([platform.name, 'package_a', '--help']);
          expect(
            printLogs,
            equals(expectedUsage('package_a', platform: platform)),
          );

          printLogs.clear();

          await commandRunner.run([platform.name, 'package_a', '-h']);
          expect(
            printLogs,
            equals(expectedUsage('package_a', platform: platform)),
          );
        }),
      );
    });
  }
}
