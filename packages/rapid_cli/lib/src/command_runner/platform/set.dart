import '../../utils.dart';
import '../base.dart';
import 'set/default_language.dart';

/// {@template platform_set_command}
/// `rapid <platform> set` set properties of the platform part of a Rapid project.
/// {@endtemplate}
class PlatformSetCommand extends RapidPlatformBranchCommand {
  /// {@macro platform_set_command}
  PlatformSetCommand(super.project, {required super.platform}) {
    addSubcommand(
      PlatformSetDefaultLanguageCommand(project, platform: platform),
    );
  }

  @override
  String get name => 'set';

  @override
  String get invocation => 'rapid ${platform.name} set <subcommand>';

  @override
  String get description =>
      'Set properties of the ${platform.prettyName} part of a Rapid project.';
}
