import 'package:test/test.dart';

import '../../mocks.dart';
import '../../utils.dart';

const expectedUsage = [
  '''Remove a component from the platform independent UI part of a Rapid project.''',
  '',
  'Usage: rapid ui remove <component>',
  '-h, --help    Print this usage information.',
  '',
  'Available subcommands:',
  '''  widget   Remove a widget from the platform independent UI part of a Rapid project.''',
  '',
  'Run "rapid help" to see global options.'
];

void main() {
  setUpAll(registerFallbackValues);

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
