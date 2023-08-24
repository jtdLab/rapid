import 'package:test/test.dart';

import '../../mocks.dart';
import '../../utils.dart';

const expectedUsage = [
  'Add a component to the platform independent UI part of a Rapid project.',
  '',
  'Usage: rapid ui add <component>',
  '-h, --help    Print this usage information.',
  '',
  'Available subcommands:',
  '''  widget   Add a widget to the platform independent UI part of a Rapid project.''',
  '',
  'Run "rapid help" to see global options.',
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
