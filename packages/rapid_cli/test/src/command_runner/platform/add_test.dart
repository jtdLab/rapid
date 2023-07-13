import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import '../../common.dart';
import '../../utils.dart';

List<String> expectedUsage(Platform platform) {
  return [
    'Add features or languages to the ${platform.prettyName} part of an existing Rapid project.\n'
        '\n'
        'Usage: rapid ${platform.name} add <subcommand>\n'
        '-h, --help    Print this usage information.\n'
        '\n'
        'Available subcommands:\n'
        '  feature     Add features to the ${platform.prettyName} part of an existing Rapid project.\n'
        '  language    Add a language to the ${platform.prettyName} part of an existing Rapid project.\n'
        '  navigator   Add a navigator to the ${platform.prettyName} part of an existing Rapid project.\n'
        '\n'
        'Run "rapid help" to see global options.'
  ];
}

void main() {
  for (final platform in Platform.values) {
    group('${platform.name} add', () {
      test(
        'help',
        overridePrint((printLogs) async {
          final commandRunner = getCommandRunner();

          await commandRunner.run([platform.name, 'add', '--help']);
          expect(printLogs, equals(expectedUsage(platform)));

          printLogs.clear();

          await commandRunner.run([platform.name, 'add', '-h']);
          expect(printLogs, equals(expectedUsage(platform)));
        }),
      );
    });
  }
}
