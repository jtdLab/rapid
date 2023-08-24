import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import '../../../mocks.dart';
import '../../../utils.dart';

List<String> expectedUsage(
  String featurePackage, {
  required Platform platform,
}) {
  return [
    '''Add a component to $featurePackage of the ${platform.prettyName} part of a Rapid project.''',
    '',
    'Usage: rapid ${platform.name} $featurePackage add <component>',
    '-h, --help    Print this usage information.',
    '',
    'Available subcommands:',
    '''  bloc    Add a bloc to $featurePackage of the ${platform.prettyName} part of a Rapid project.''',
    '''  cubit   Add a cubit to $featurePackage of the ${platform.prettyName} part of a Rapid project.''',
    '',
    'Run "rapid help" to see global options.',
  ];
}

void main() {
  setUpAll(registerFallbackValues);

  for (final platform in Platform.values) {
    group('${platform.name} <feature> add', () {
      test(
        'help',
        overridePrint((printLogs) async {
          final project = setupProjectWithPlatformFeaturePackage('package_a');
          final commandRunner = getCommandRunner(project: project);

          await commandRunner
              .run([platform.name, 'package_a', 'add', '--help']);
          expect(
            printLogs,
            equals(expectedUsage('package_a', platform: platform)),
          );

          printLogs.clear();

          await commandRunner.run([platform.name, 'package_a', 'add', '-h']);
          expect(
            printLogs,
            equals(expectedUsage('package_a', platform: platform)),
          );
        }),
      );
    });
  }
}
