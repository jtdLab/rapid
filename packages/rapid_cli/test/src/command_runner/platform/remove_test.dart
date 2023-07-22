import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import '../../common.dart';
import '../../mocks.dart';
import '../../utils.dart';

List<String> expectedUsage(Platform platform) {
  return [
    'Removes features or languages from the ${platform.prettyName} part of an existing Rapid project.\n'
        '\n'
        'Usage: rapid ${platform.name} remove <subcommand>\n'
        '-h, --help    Print this usage information.\n'
        '\n'
        'Available subcommands:\n'
        '  feature     Removes a feature from the ${platform.prettyName} part of an existing Rapid project.\n'
        '  language    Removes a language from the ${platform.prettyName} part of an existing Rapid project.\n'
        '  navigator   Remove a navigator from the ${platform.prettyName} part of an existing Rapid project.\n'
        '\n'
        'Run "rapid help" to see global options.'
  ];
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  for (final platform in Platform.values) {
    group('${platform.name} remove', () {
      test(
        'help',
        overridePrint((printLogs) async {
          final commandRunner = getCommandRunner();

          await commandRunner.run([platform.name, 'remove', '--help']);
          expect(printLogs, equals(expectedUsage(platform)));

          printLogs.clear();

          await commandRunner.run([platform.name, 'remove', '-h']);
          expect(printLogs, equals(expectedUsage(platform)));
        }),
      );
    });
  }
}
