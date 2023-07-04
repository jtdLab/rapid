import 'package:rapid_cli/src/command_runner/util/platform_x.dart';
import 'package:rapid_cli/src/project/platform.dart';

import '../base.dart';
import 'set/default_language.dart';

class PlatformSetCommand extends RapidBranchCommand {
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
      'Set properties of features from the ${platform.prettyName} part of an existing Rapid project.';
}
