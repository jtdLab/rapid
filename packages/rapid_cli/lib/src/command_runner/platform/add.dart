import 'package:rapid_cli/src/command_runner/util/platform_x.dart';
import 'package:rapid_cli/src/core/platform.dart';

import '../base.dart';
import 'add/feature.dart';
import 'add/language.dart';
import 'add/navigator.dart';

class PlatformAddCommand extends RapidBranchCommand {
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
      'Add features or languages to the ${platform.prettyName} part of an existing Rapid project.';
}
