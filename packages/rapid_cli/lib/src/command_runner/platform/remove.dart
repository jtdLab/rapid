import '../../utils.dart';
import '../base.dart';
import 'remove/feature.dart';
import 'remove/language.dart';
import 'remove/navigator.dart';

// TODO(jtdLab): better description

/// {@template platform_remove_command}
/// `rapid <platform> remove` remove features or languages from the platform
/// part of a Rapid project.
/// {@endtemplate}
class PlatformRemoveCommand extends RapidPlatformBranchCommand {
  /// {@macro platform_remove_command}
  PlatformRemoveCommand(super.project, {required super.platform}) {
    addSubcommand(PlatformRemoveFeatureCommand(project, platform: platform));
    addSubcommand(PlatformRemoveLanguageCommand(project, platform: platform));
    addSubcommand(PlatformRemoveNavigatorCommand(project, platform: platform));
  }

  @override
  String get name => 'remove';

  @override
  String get invocation => 'rapid ${platform.name} remove <subcommand>';

  @override
  String get description =>
      'Remove features or languages from the ${platform.prettyName} part of a '
      'Rapid project.';
}
