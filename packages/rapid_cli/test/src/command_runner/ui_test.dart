import 'package:test/test.dart';

import '../mocks.dart';
import '../utils.dart';

const expectedUsage = [
  'Work with the UI part of a Rapid project.',
  '',
  'Usage: rapid ui <subcommand>',
  '-h, --help    Print this usage information.',
  '',
  'Available subcommands:',
  '  add       Add a component to the platform independent UI part of a Rapid project.',
  '  android   Work with the Android UI part of a Rapid project.',
  '  ios       Work with the iOS UI part of a Rapid project.',
  '  linux     Work with the Linux UI part of a Rapid project.',
  '  macos     Work with the macOS UI part of a Rapid project.',
  '  mobile    Work with the Mobile UI part of a Rapid project.',
  '  remove    Remove a component from the platform independent UI part of a Rapid project.',
  '  web       Work with the Web UI part of a Rapid project.',
  '  windows   Work with the Windows UI part of a Rapid project.',
  '',
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
