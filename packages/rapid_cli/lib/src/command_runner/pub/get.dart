import '../base.dart';
import '../util/package_option.dart';

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
    final packageName = super.package;

    return rapid.pubGet(packageName: packageName);
  }
}
