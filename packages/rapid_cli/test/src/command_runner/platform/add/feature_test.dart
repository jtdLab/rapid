import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import '../../../common.dart';
import '../../../mocks.dart';

List<String> expectedUsage(Platform platform) {
  return [
    'Add features to the ${platform.prettyName} part of an existing Rapid project.\n'
        '\n'
        'Usage: rapid ${platform.name} add feature <type>\n'
        '-h, --help    Print this usage information.\n'
        '\n'
        'Available subcommands:\n'
        '  flow     Add a flow feature to the ${platform.prettyName} part of an existing Rapid project.\n'
        '  page     Add a page feature to the ${platform.prettyName} part of an existing Rapid project.\n'
        '  widget   Add a widget feature to the ${platform.prettyName} part of an existing Rapid project.\n'
        '\n'
        'Run "rapid help" to see global options.'
  ];
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  for (final platform in Platform.values) {
    group('${platform.name} remove', () {
      test(
        'help',
        withRunner((commandRunner, _, __, printLogs) async {
          await commandRunner.run([platform.name, 'add', 'feature', '--help']);
          expect(printLogs, equals(expectedUsage(platform)));

          printLogs.clear();

          await commandRunner.run([platform.name, 'add', 'feature', '-h']);
          expect(printLogs, equals(expectedUsage(platform)));
        }),
      );
    });
  }
}
