import '../../project/platform.dart';
import '../../utils.dart';
import '../base.dart';
import 'add/feature.dart';
import 'add/language.dart';
import 'add/navigator.dart';

// TODO better description

/// {@template platform_add_command}
/// `rapid <platform> add` add features or languages to the platform part of a Rapid project.
/// {@endtemplate}
class PlatformAddCommand extends RapidBranchCommand {
  /// {@macro platform_add_command}
  PlatformAddCommand(this.platform, super.project) {
    addSubcommand(PlatformAddFeatureCommand(platform, project));
    addSubcommand(PlatformAddLanguageCommand(platform, project));
    addSubcommand(PlatformAddNavigatorCommand(platform, project));
  }

  final Platform platform;

  @override
  String get name => 'add';

  @override
  String get invocation => 'rapid ${platform.name} add <subcommand>';

  @override
  String get description =>
      'Add features or languages to the ${platform.prettyName} part of a Rapid project.';
}
