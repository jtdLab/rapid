import 'package:test/test.dart';

import '../common.dart';
import '../mocks.dart';

const expectedUsage = [
  'Work with packages in a Rapid environment.\n'
      '\n'
      'Usage: rapid pub <subcommand>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Available subcommands:\n'
      '  add      Add packages in a Rapid environment.\n'
      '  get      Get packages in a Rapid environment.\n'
      '  remove   Remove packages in a Rapid environment.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('pub', () {
    setUpAll(() {
      registerFallbackValues();
    });

    test(
      'help',
      withRunner((commandRunner, _, __, printLogs) async {
        await commandRunner.run(['pub', '--help']);
        expect(printLogs, equals(expectedUsage));

        printLogs.clear();

        await commandRunner.run(['pub', '-h']);
        expect(printLogs, equals(expectedUsage));
      }),
    );
  });
}
