import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/pub/add.dart';
import 'package:test/test.dart';

import '../../common.dart';
import '../../mocks.dart';
import '../../utils.dart';

const expectedUsage = [
  'Add dependencies to `pubspec.yaml` in a Rapid project.\n'
      '\n'
      'This command works similiar to `dart pub add` or `flutter pub add` but takes care of\n'
      'dependent packages and updates their transitiv dependencies accordingly.\n'
      '\n'
      'Invoking `rapid pub add foo bar` will add `foo` and `bar` to `pubspec.yaml`\n'
      'with a default constraint derived from latest compatible version.\n'
      '\n'
      'IMPORTANT:\n'
      '\n'
      'Invoking `rapid pub add foo: bar:` will add `foo:` and `bar:` to `pubspec.yaml`\n'
      'with a empty constraint. In most cases this is used to add locale packages which\n'
      'are linked using `melos`.\n'
      '\n'
      'Add to dev_dependencies by prefixing with "dev:".\n'
      '\n'
      'Make dependency overrides by prefixing with "override:".\n'
      '\n'
      'Add packages with specific constraints or other sources by giving a descriptor\n'
      'after a colon.\n'
      '\n'
      'For example:\n'
      '  * Add a hosted dependency at newest compatible stable version:\n'
      '    `flutter pub add foo`\n'
      '  * Add a hosted dev dependency at newest compatible stable version:\n'
      '    `flutter pub add dev:foo`\n'
      '  * Add a hosted dependency with the given constraint\n'
      '    `flutter pub add foo:^1.2.3`\n'
      '  * Add multiple dependencies:\n'
      '    `flutter pub add foo dev:bar`\n'
      '  * Add a path dependency:\n'
      '    `flutter pub add \'foo:{"path":"../foo"}\'`\n'
      '  * Add a hosted dependency:\n'
      '    `flutter pub add \'foo:{"hosted":"my-pub.dev"}\'`\n'
      '  * Add an sdk dependency:\n'
      '    `flutter pub add \'foo:{"sdk":"flutter"}\'`\n'
      '  * Add a git dependency:\n'
      '    `flutter pub add \'foo:{"git":"https://github.com/foo/foo"}\'`\n'
      '  * Add a dependency override:\n'
      '    `flutter pub add \'override:foo:1.0.0\'`\n'
      '  * Add a git dependency with a path and ref specified:\n'
      '    `flutter pub add \\\n'
      '      \'foo:{"git":{"url":"../foo.git","ref":"<branch>","path":"<subdir>"}}\'`\n'
      '\n'
      'Usage: rapid pub add [<section>:]<package>[:[descriptor]] [<section>:]<package2>[:[descriptor]] ...]\n'
      '-h, --help       Print this usage information.\n'
      '-p, --package    The package where the command is run.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

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
