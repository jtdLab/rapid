import 'package:test/test.dart';

import '../mocks.dart';
import '../utils.dart';

const expectedUsage = [
  'Add support for a platform to a Rapid project.',
  '',
  'Usage: rapid activate <platform>',
  '-h, --help    Print this usage information.',
  '',
  'Available subcommands:',
  '  android   Add support for Android to this project.',
  '  ios       Add support for iOS to this project.',
  '  linux     Add support for Linux to this project.',
  '  macos     Add support for macOS to this project.',
  '  mobile    Add support for Mobile to this project.',
  '  web       Add support for Web to this project.',
  '  windows   Add support for Windows to this project.',
  '',
  'Run "rapid help" to see global options.',
];

void main() {
  setUpAll(registerFallbackValues);

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
