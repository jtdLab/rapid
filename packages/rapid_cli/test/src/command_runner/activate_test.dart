import 'package:test/test.dart';

import '../common.dart';
import '../mocks.dart';
import '../utils.dart';

const expectedUsage = [
  'Add support for a platform to an existing Rapid project.\n'
      '\n'
      'Usage: rapid activate <platform>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Available subcommands:\n'
      '  android   Adds support for Android to this project.\n'
      '  ios       Adds support for iOS to this project.\n'
      '  linux     Adds support for Linux to this project.\n'
      '  macos     Adds support for macOS to this project.\n'
      '  mobile    Adds support for Mobile to this project.\n'
      '  web       Adds support for Web to this project.\n'
      '  windows   Adds support for Windows to this project.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('activate', () {
    test(
      'help',
      overridePrint((printLogs) async {
        final commandRunner = getCommandRunner();

        await commandRunner.run(['activate', '--help']);
        expect(printLogs, equals(expectedUsage));

        printLogs.clear();

        await commandRunner.run(['activate', '-h']);
        expect(printLogs, equals(expectedUsage));
      }),
    );
  });
}
