import '../../utils.dart';
import '../base.dart';
import 'add/feature.dart';
import 'add/language.dart';
import 'add/navigator.dart';

// TODO(jtdLab): better description

/// {@template platform_add_command}
/// `rapid <platform> add` add features or languages to the platform part
/// of a Rapid project.
/// {@endtemplate}
class PlatformAddCommand extends RapidPlatformBranchCommand {
  /// {@macro platform_add_command}
  PlatformAddCommand(super.project, {required super.platform}) {
    addSubcommand(PlatformAddFeatureCommand(project, platform: platform));
    addSubcommand(PlatformAddLanguageCommand(project, platform: platform));
    addSubcommand(PlatformAddNavigatorCommand(project, platform: platform));
  }

  @override
  String get name => 'add';

  @override
  String get invocation => 'rapid ${platform.name} add <subcommand>';

  @override
  String get description =>
      'Add features or languages to the ${platform.prettyName} part '
      'of a Rapid project.';
}
