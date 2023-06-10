import '../base.dart';
import '../util/package_option.dart';

// TODO impl cleaner + e2e test

/// {@template pub_get_command}
/// `rapid pub get` command get packages in a Rapid environment.
/// {@endtemplate}
class PubGetCommand extends RapidLeafCommand with PackageGetter {
  /// {@macro pub_get_command}
  PubGetCommand(super.project) {
    argParser.addPackageOption(
      help: 'The package where the command is run.',
    );
  }

  @override
  String get name => 'get';

  @override
  String get invocation => 'rapid pub get';

  @override
  String get description => 'Get packages in a Rapid environment.';

  @override
  Future<void> run() {
    // TODO should not be nullable
    final packageName = super.package!;

    return rapid.pubGet(packageName: packageName);
  }
}
