import 'package:test/test.dart';

import '../mocks.dart';
import '../utils.dart';

const expectedUsage = [
  'Work with the UI part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid ui <subcommand>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Available subcommands:\n'
      '  add       Add components to the platform independent UI part of an existing Rapid project.\n'
      '  android   Work with the Android UI part of an existing Rapid project.\n'
      '  ios       Work with the iOS UI part of an existing Rapid project.\n'
      '  linux     Work with the Linux UI part of an existing Rapid project.\n'
      '  macos     Work with the macOS UI part of an existing Rapid project.\n'
      '  mobile    Work with the Mobile UI part of an existing Rapid project.\n'
      '  remove    Remove components from the platform independent UI part of an existing Rapid project.\n'
      '  web       Work with the Web UI part of an existing Rapid project.\n'
      '  windows   Work with the Windows UI part of an existing Rapid project.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  setUpAll(registerFallbackValues);

  group('ui', () {
    test(
      'help',
      overridePrint((printLogs) async {
        final commandRunner = getCommandRunner();

        await commandRunner.run(['ui', '--help']);
        expect(printLogs, equals(expectedUsage));

        printLogs.clear();

        await commandRunner.run(['ui', '-h']);
        expect(printLogs, equals(expectedUsage));
      }),
    );
  });
}
