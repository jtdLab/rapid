import 'package:test/test.dart';

import '../common.dart';
import '../mocks.dart';
import '../utils.dart';

const expectedUsage = [
  'Remove support for a platform from an existing Rapid project.\n'
      '\n'
      'Usage: rapid deactivate <platform>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Available subcommands:\n'
      '  android   Removes support for Android from this project.\n'
      '  ios       Removes support for iOS from this project.\n'
      '  linux     Removes support for Linux from this project.\n'
      '  macos     Removes support for macOS from this project.\n'
      '  mobile    Removes support for Mobile from this project.\n'
      '  web       Removes support for Web from this project.\n'
      '  windows   Removes support for Windows from this project.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('deactivate', () {
    test(
      'help',
      overridePrint((printLogs) async {
        final commandRunner = getCommandRunner();

        await commandRunner.run(['deactivate', '--help']);
        expect(printLogs, equals(expectedUsage));

        printLogs.clear();

        await commandRunner.run(['deactivate', '-h']);
        expect(printLogs, equals(expectedUsage));
      }),
    );
  });
}
