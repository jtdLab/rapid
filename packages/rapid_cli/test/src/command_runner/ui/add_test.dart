import 'package:test/test.dart';

import '../../mocks.dart';
import '../../utils.dart';

const expectedUsage = [
  'Add components to the platform independent UI part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid ui add <subcommand>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Available subcommands:\n'
      '  widget   Add a widget to the platform independent UI part of an existing Rapid project.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  setUpAll(registerFallbackValues);

  group('ui add', () {
    test(
      'help',
      overridePrint((printLogs) async {
        final commandRunner = getCommandRunner();

        await commandRunner.run(['ui', 'add', '--help']);
        expect(printLogs, equals(expectedUsage));

        printLogs.clear();

        await commandRunner.run(['ui', 'add', '-h']);
        expect(printLogs, equals(expectedUsage));
      }),
    );
  });
}
