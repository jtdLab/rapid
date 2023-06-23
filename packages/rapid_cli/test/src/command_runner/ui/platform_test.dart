import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import '../../common.dart';
import '../../mocks.dart';

List<String> expectedUsage(Platform platform) {
  return [
    'Work with the ${platform.prettyName} UI part of an existing Rapid project.\n'
        '\n'
        'Usage: rapid ui ${platform.name} <subcommand>\n'
        '-h, --help    Print this usage information.\n'
        '\n'
        'Available subcommands:\n'
        '  add      Add components to the ${platform.prettyName} UI part of an existing Rapid project.\n'
        '  remove   Remove components from the ${platform.prettyName} UI part of an existing Rapid project.\n'
        '\n'
        'Run "rapid help" to see global options.'
  ];
}

void main() {
  group('ui', () {
    setUpAll(() {
      registerFallbackValues();
    });

    for (final platform in Platform.values) {
      group(platform.name, () {
        test(
          'help',
          withRunner((commandRunner, _, __, printLogs) async {
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
