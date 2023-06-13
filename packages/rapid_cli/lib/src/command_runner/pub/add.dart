import '../base.dart';
import '../util/package_option.dart';

// TODO impl cleaner + e2e test

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
      'rapid pub add [dev:]<package>[:descriptor] [[dev:]<package>[:descriptor] ...]';

  @override
  String get description => 'Add packages in a Rapid environment.';

  @override
  Future<void> run() {
    final packageName = super.package;
    final packages = argResults.rest;

    return rapid.pubAdd(packageName: packageName, packages: packages);
  }
}
