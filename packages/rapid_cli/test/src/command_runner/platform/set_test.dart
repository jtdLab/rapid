import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import '../../mocks.dart';
import '../../utils.dart';

List<String> expectedUsage(Platform platform) {
  return [
    'Set properties of features from the ${platform.prettyName} part of an existing Rapid project.\n'
        '\n'
        'Usage: rapid ${platform.name} set <subcommand>\n'
        '-h, --help    Print this usage information.\n'
        '\n'
        'Available subcommands:\n'
        '  default_language   Set the default language of the ${platform.prettyName} part of an existing Rapid project.\n'
        '\n'
        'Run "rapid help" to see global options.'
  ];
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  for (final platform in Platform.values) {
    group('${platform.name} set', () {
      test(
        'help',
        overridePrint((printLogs) async {
          final commandRunner = getCommandRunner();

          await commandRunner.run([platform.name, 'set', '--help']);
          expect(printLogs, equals(expectedUsage(platform)));

          printLogs.clear();

          await commandRunner.run([platform.name, 'set', '-h']);
          expect(printLogs, equals(expectedUsage(platform)));
        }),
      );
    });
  }
}
