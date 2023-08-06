import '../../project/platform.dart';
import '../../utils.dart';
import '../base.dart';
import 'remove/feature.dart';
import 'remove/language.dart';
import 'remove/navigator.dart';

// TODO: better description

/// {@template platform_remove_command}
/// `rapid <platform> remove` remove features or languages from the platform part of a Rapid project.
/// {@endtemplate}
class PlatformRemoveCommand extends RapidBranchCommand {
  /// {@macro platform_remove_command}
  PlatformRemoveCommand(this.platform, super.project) {
    addSubcommand(PlatformRemoveFeatureCommand(platform, project));
    addSubcommand(PlatformRemoveLanguageCommand(platform, project));
    addSubcommand(PlatformRemoveNavigatorCommand(platform, project));
  }

  final Platform platform;

  @override
  String get name => 'remove';

  @override
  String get invocation => 'rapid ${platform.name} remove <subcommand>';

  @override
  String get description =>
      'Remove features or languages from the ${platform.prettyName} part of a Rapid project.';
}
