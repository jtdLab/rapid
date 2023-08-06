import 'package:test/test.dart';

import '../mocks.dart';
import '../utils.dart';

const expectedUsage = [
  'Remove support for a platform from a Rapid project.',
  '',
  'Usage: rapid deactivate <platform>',
  '-h, --help    Print this usage information.',
  '',
  'Available subcommands:',
  '  android   Remove support for Android from this project.',
  '  ios       Remove support for iOS from this project.',
  '  linux     Remove support for Linux from this project.',
  '  macos     Remove support for macOS from this project.',
  '  mobile    Remove support for Mobile from this project.',
  '  web       Remove support for Web from this project.',
  '  windows   Remove support for Windows from this project.',
  '',
  'Run "rapid help" to see global options.'
];

void main() {
  setUpAll(registerFallbackValues);

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
