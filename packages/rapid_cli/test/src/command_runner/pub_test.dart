import 'package:test/test.dart';

import '../mocks.dart';
import '../utils.dart';

const expectedUsage = [
  'Work with packages in a Rapid environment.\n'
      '\n'
      'Usage: rapid pub <subcommand>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Available subcommands:\n'
      '  add      Add dependencies to `pubspec.yaml` in a Rapid project.\n'
      '  get      Get packages in a Rapid environment.\n'
      '  remove   Remove packages in a Rapid environment.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('pub', () {
    test(
      'help',
      overridePrint((printLogs) async {
        final commandRunner = getCommandRunner();

        await commandRunner.run(['pub', '--help']);
        expect(printLogs, equals(expectedUsage));

        printLogs.clear();

        await commandRunner.run(['pub', '-h']);
        expect(printLogs, equals(expectedUsage));
      }),
    );
  });
}
