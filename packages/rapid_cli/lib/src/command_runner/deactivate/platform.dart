import '../../project/platform.dart';
import '../../utils.dart';
import '../base.dart';

/// {@template deactivate_command}
/// `rapid deactivate` removes support for a platform from a Rapid project.
/// {@endtemplate}
class DeactivatePlatformCommand extends RapidLeafCommand {
  /// {@macro deactivate_command}
  DeactivatePlatformCommand(this.platform, super.project);

  final Platform platform;

  @override
  String get name => platform.name;

  @override
  List<String> get aliases => platform.aliases;

  @override
  String get invocation => 'rapid deactivate ${platform.name}';

  @override
  String get description =>
      'Remove support for ${platform.prettyName} from this project.';

  @override
  Future<void> run() async {
    return rapid.deactivatePlatform(platform);
  }
}
