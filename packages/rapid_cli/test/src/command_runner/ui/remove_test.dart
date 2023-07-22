import 'package:test/test.dart';

import '../../common.dart';
import '../../mocks.dart';
import '../../utils.dart';

const expectedUsage = [
  'Remove components from the platform independent UI part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid ui remove <subcommand>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Available subcommands:\n'
      '  widget   Remove a widget to the platform independent UI part of an existing Rapid project.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('ui remove', () {
    test(
      'help',
      overridePrint((printLogs) async {
        final commandRunner = getCommandRunner();

        await commandRunner.run(['ui', 'remove', '--help']);
        expect(printLogs, equals(expectedUsage));

        printLogs.clear();

        await commandRunner.run(['ui', 'remove', '-h']);
        expect(printLogs, equals(expectedUsage));
      }),
    );
  });
}
