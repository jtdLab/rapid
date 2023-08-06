import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/pub/add.dart';
import 'package:test/test.dart';

import '../../mocks.dart';
import '../../utils.dart';

const expectedUsage = [
  'Add dependencies to `pubspec.yaml` in a Rapid project.',
  '',
  'This command works similiar to `dart pub add` or `flutter pub add` but takes care of',
  'dependent packages and updates their transitiv dependencies accordingly.',
  '',
  'Invoking `rapid pub add foo bar` will add `foo` and `bar` to `pubspec.yaml`',
  'with a default constraint derived from latest compatible version.',
  '',
  'IMPORTANT:',
  '',
  'Invoking `rapid pub add foo: bar:` will add `foo:` and `bar:` to `pubspec.yaml`',
  'with a empty constraint. In most cases this is used to add locale packages which',
  'are linked using `melos`.',
  '',
  'Add to dev_dependencies by prefixing with "dev:".',
  '',
  'Make dependency overrides by prefixing with "override:".',
  '',
  'Add packages with specific constraints or other sources by giving a descriptor',
  'after a colon.',
  '',
  'For example:',
  '  * Add a hosted dependency at newest compatible stable version:',
  '    `dart pub add foo`',
  '  * Add a hosted dev dependency at newest compatible stable version:',
  '    `dart pub add dev:foo`',
  '  * Add a hosted dependency with the given constraint',
  '    `dart pub add foo:^1.2.3`',
  '  * Add multiple dependencies:',
  '    `dart pub add foo dev:bar`',
  '  * Add a path dependency:',
  '    `dart pub add \'foo:{"path":"../foo"}\'`',
  '  * Add a hosted dependency:',
  '    `dart pub add \'foo:{"hosted":"my-pub.dev"}\'`',
  '  * Add an sdk dependency:',
  '    `dart pub add \'foo:{"sdk":"flutter"}\'`',
  '  * Add a git dependency:',
  '    `dart pub add \'foo:{"git":"https://github.com/foo/foo"}\'`',
  '  * Add a dependency override:',
  "    `dart pub add 'override:foo:1.0.0'`",
  '  * Add a git dependency with a path and ref specified:',
  r'    `dart pub add \',
  '      \'foo:{"git":{"url":"../foo.git","ref":"<branch>","path":"<subdir>"}}\'`',
  '',
  'Usage: rapid pub add [<section>:]<package>[:[descriptor]] [<section>:]<package2>[:[descriptor]] ...]',
  '-h, --help       Print this usage information.',
  '-p, --package    The package where the command is run.',
  '',
  'Run "rapid help" to see global options.'
];

void main() {
  setUpAll(registerFallbackValues);

  group('pub add', () {
    test(
      'help',
      overridePrint((printLogs) async {
        final commandRunner = getCommandRunner();

        await commandRunner.run(['pub', 'add', '--help']);
        expect(printLogs, equals(expectedUsage));

        printLogs.clear();

        await commandRunner.run(['pub', 'add', '-h']);
        expect(printLogs, equals(expectedUsage));
      }),
    );

    test('completes', () async {
      final rapid = MockRapid();
      final argResults = MockArgResults();
      when(() => argResults['package']).thenReturn('foo');
      when(() => argResults.rest).thenReturn(['a: ^1.0.0', 'b:']);
      final command = PubAddCommand(null)
        ..argResultOverrides = argResults
        ..rapidOverrides = rapid;

      await command.run();

      verify(
        () => rapid.pubAdd(packageName: 'foo', packages: ['a: ^1.0.0', 'b:']),
      ).called(1);
    });
  });
}
