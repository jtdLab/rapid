import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import '../../mocks.dart';
import '../../utils.dart';

List<String> expectedUsage(Platform platform) {
  return [
    '''Remove features or languages from the ${platform.prettyName} part of a Rapid project.''',
    '',
    'Usage: rapid ${platform.name} remove <subcommand>',
    '-h, --help    Print this usage information.',
    '',
    'Available subcommands:',
    '''  feature     Remove a feature from the ${platform.prettyName} part of a Rapid project.''',
    '''  language    Remove a language from the ${platform.prettyName} part of a Rapid project.''',
    '''  navigator   Remove a navigator from the ${platform.prettyName} part of a Rapid project.''',
    '',
    'Run "rapid help" to see global options.',
  ];
}

void main() {
  setUpAll(registerFallbackValues);

  for (final platform in Platform.values) {
    group('${platform.name} remove', () {
      test(
        'help',
        overridePrint((printLogs) async {
          final commandRunner = getCommandRunner();

          await commandRunner.run([platform.name, 'remove', '--help']);
          expect(printLogs, equals(expectedUsage(platform)));

          printLogs.clear();

          await commandRunner.run([platform.name, 'remove', '-h']);
          expect(printLogs, equals(expectedUsage(platform)));
        }),
      );
    });
  }
}
