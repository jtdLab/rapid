import '../../project/platform.dart';
import '../base.dart';
import '../util/platform_x.dart';
import 'remove/feature.dart';
import 'remove/language.dart';
import 'remove/navigator.dart';

class PlatformRemoveCommand extends RapidBranchCommand {
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
      'Removes features or languages from the ${platform.prettyName} part of an existing Rapid project.';
}
