import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import '../../../mocks.dart';
import '../../../utils.dart';

List<String> expectedUsage(Platform platform) {
  return [
    'Add components to the ${platform.prettyName} UI part of an existing Rapid project.\n'
        '\n'
        'Usage: rapid ui ${platform.name} add <subcommand>\n'
        '-h, --help    Print this usage information.\n'
        '\n'
        'Available subcommands:\n'
        '  widget   Add a widget to the ${platform.prettyName} UI part of an existing Rapid project.\n'
        '\n'
        'Run "rapid help" to see global options.'
  ];
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('ui', () {
    for (final platform in Platform.values) {
      group('${platform.name} add', () {
        test(
          'help',
          overridePrint((printLogs) async {
            final commandRunner = getCommandRunner();

            await commandRunner.run(['ui', platform.name, 'add', '--help']);
            expect(printLogs, equals(expectedUsage(platform)));

            printLogs.clear();

            await commandRunner.run(['ui', platform.name, 'add', '-h']);
            expect(printLogs, equals(expectedUsage(platform)));
          }),
        );
      });
    }
  });
}
