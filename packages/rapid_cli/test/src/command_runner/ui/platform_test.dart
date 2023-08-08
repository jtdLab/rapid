import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import '../../mocks.dart';
import '../../utils.dart';

List<String> expectedUsage(Platform platform) {
  return [
    'Work with the ${platform.prettyName} UI part of a Rapid project.',
    '',
    'Usage: rapid ui ${platform.name} <subcommand>',
    '-h, --help    Print this usage information.',
    '',
    'Available subcommands:',
    '''  add      Add a component to the ${platform.prettyName} UI part of a Rapid project.''',
    '''  remove   Remove a component from the ${platform.prettyName} UI part of a Rapid project.''',
    '',
    'Run "rapid help" to see global options.'
  ];
}

void main() {
  setUpAll(registerFallbackValues);

  group('ui', () {
    for (final platform in Platform.values) {
      group(platform.name, () {
        test(
          'help',
          overridePrint((printLogs) async {
            final commandRunner = getCommandRunner();

            await commandRunner.run(['ui', platform.name, '--help']);
            expect(printLogs, equals(expectedUsage(platform)));

            printLogs.clear();

            await commandRunner.run(['ui', platform.name, '-h']);
            expect(printLogs, equals(expectedUsage(platform)));
          }),
        );
      });
    }
  });
}
