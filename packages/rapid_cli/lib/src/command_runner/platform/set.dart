import '../../project/platform.dart';
import '../../utils.dart';
import '../base.dart';
import 'set/default_language.dart';

/// {@template platform_set_command}
/// `rapid <platform> set` set properties of the platform part of a Rapid project.
/// {@endtemplate}
class PlatformSetCommand extends RapidBranchCommand {
  /// {@macro platform_set_command}
  PlatformSetCommand(this.platform, super.project) {
    addSubcommand(PlatformSetDefaultLanguageCommand(platform, project));
  }

  final Platform platform;

  @override
  String get name => 'set';

  @override
  String get invocation => 'rapid ${platform.name} set <subcommand>';

  @override
  String get description =>
      'Set properties of the ${platform.prettyName} part of a Rapid project.';
}
