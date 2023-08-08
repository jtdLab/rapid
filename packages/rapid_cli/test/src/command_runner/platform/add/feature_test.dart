import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import '../../../mocks.dart';
import '../../../utils.dart';

List<String> expectedUsage(Platform platform) {
  return [
    'Add a feature to the ${platform.prettyName} part of a Rapid project.',
    '',
    'Usage: rapid ${platform.name} add feature <type>',
    '-h, --help    Print this usage information.',
    '',
    'Available subcommands:',
    '''  flow       Add a flow feature to the ${platform.prettyName} part of a Rapid project.''',
    '''  page       Add a page feature to the ${platform.prettyName} part of a Rapid project.''',
    '''  tab_flow   Add a tab flow feature to the ${platform.prettyName} part of a Rapid project.''',
    '''  widget     Add a widget feature to the ${platform.prettyName} part of a Rapid project.''',
    '',
    'Run "rapid help" to see global options.'
  ];
}

void main() {
  setUpAll(registerFallbackValues);

  for (final platform in Platform.values) {
    group('${platform.name} remove', () {
      test(
        'help',
        overridePrint((printLogs) async {
          final commandRunner = getCommandRunner();

          await commandRunner.run([platform.name, 'add', 'feature', '--help']);
          expect(printLogs, equals(expectedUsage(platform)));

          printLogs.clear();

          await commandRunner.run([platform.name, 'add', 'feature', '-h']);
          expect(printLogs, equals(expectedUsage(platform)));
        }),
      );
    });
  }
}
