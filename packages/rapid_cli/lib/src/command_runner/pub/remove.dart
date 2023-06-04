import '../base.dart';
import '../util/package_option.dart';

// TODO impl cleaner + e2e test

/// {@template pub_remove_command}
/// `rapid pub remove` command remove packages in a Rapid environment.
/// {@endtemplate}
class PubRemoveCommand extends RapidLeafCommand with PackageGetter {
  /// {@macro pub_remove_command}
  PubRemoveCommand(super.project) {
    argParser.addPackageOption(
      help: 'The package where the command is run in.',
    );
  }

  @override
  String get name => 'remove';

  @override
  String get invocation => 'rapid pub remove [packages]';

  @override
  String get description => 'Remove packages in a Rapid environment.';

  @override
  Future<void> run() {
    // TODO should not be nullable
    final packageName = super.package!;
    final packages = argResults.rest;

    return rapid.pubRemove(packageName: packageName, packages: packages);
  }
}