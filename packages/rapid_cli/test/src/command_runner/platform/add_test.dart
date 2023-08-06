import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import '../../mocks.dart';
import '../../utils.dart';

List<String> expectedUsage(Platform platform) {
  return [
    'Add features or languages to the ${platform.prettyName} part of a Rapid project.',
    '',
    'Usage: rapid ${platform.name} add <subcommand>',
    '-h, --help    Print this usage information.',
    '',
    'Available subcommands:',
    '  feature     Add a feature to the ${platform.prettyName} part of a Rapid project.',
    '  language    Add a language to the ${platform.prettyName} part of a Rapid project.',
    '  navigator   Add a navigator to the ${platform.prettyName} part of a Rapid project.',
    '',
    'Run "rapid help" to see global options.'
  ];
}

void main() {
  setUpAll(registerFallbackValues);

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
