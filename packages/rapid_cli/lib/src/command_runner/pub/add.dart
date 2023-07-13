import '../base.dart';
import '../util/package_option.dart';

// TODO impl cleaner + e2e test
// TODO consider adding options of `dart pub add`
// TODO description synced with other pub commands

/// {@template pub_add_command}
/// `rapid pub add` command add packages in a Rapid environment.
/// {@endtemplate}
class PubAddCommand extends RapidLeafCommand with PackageGetter {
  /// {@macro pub_add_command}
  PubAddCommand(super.project) {
    argParser.addPackageOption(
      help: 'The package where the command is run.',
    );
  }

  @override
  String get name => 'add';

  @override
  String get invocation =>
      'rapid pub add [<section>:]<package>[:[descriptor]] [<section>:]<package2>[:[descriptor]] ...]';

  @override
  String get description =>
      '''Add dependencies to `pubspec.yaml` in a Rapid project.

This command works similiar to `dart pub add` or `flutter pub add` but takes care of
dependent packages and updates their transitiv dependencies accordingly.

Invoking `rapid pub add foo bar` will add `foo` and `bar` to `pubspec.yaml`
with a default constraint derived from latest compatible version.

IMPORTANT:

Invoking `rapid pub add foo: bar:` will add `foo:` and `bar:` to `pubspec.yaml`
with a empty constraint. In most cases this is used to add locale packages which
are linked using `melos`.

Add to dev_dependencies by prefixing with "dev:".

Make dependency overrides by prefixing with "override:". 

Add packages with specific constraints or other sources by giving a descriptor
after a colon.

For example:
  * Add a hosted dependency at newest compatible stable version:
    `flutter pub add foo`
  * Add a hosted dev dependency at newest compatible stable version:
    `flutter pub add dev:foo`
  * Add a hosted dependency with the given constraint
    `flutter pub add foo:^1.2.3`
  * Add multiple dependencies:
    `flutter pub add foo dev:bar`
  * Add a path dependency:
    `flutter pub add 'foo:{"path":"../foo"}'`
  * Add a hosted dependency:
    `flutter pub add 'foo:{"hosted":"my-pub.dev"}'`
  * Add an sdk dependency:
    `flutter pub add 'foo:{"sdk":"flutter"}'`
  * Add a git dependency:
    `flutter pub add 'foo:{"git":"https://github.com/foo/foo"}'`
  * Add a dependency override:
    `flutter pub add 'override:foo:1.0.0'`
  * Add a git dependency with a path and ref specified:
    `flutter pub add \\
      'foo:{"git":{"url":"../foo.git","ref":"<branch>","path":"<subdir>"}}'`''';

  @override
  Future<void> run() {
    final packageName = super.package;
    final packages = argResults.rest;

    return rapid.pubAdd(packageName: packageName, packages: packages);
  }
}
