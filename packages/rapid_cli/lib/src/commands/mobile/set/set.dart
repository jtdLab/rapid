import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/platform/set/set.dart';
import 'package:rapid_cli/src/commands/mobile/set/default_language/default_language.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template mobile_set_command}
/// `rapid mobile set` command sets properties of features from the Mobile part of an existing Rapid project.
/// {@endtemplate}
class MobileSetCommand extends PlatformSetCommand {
  /// {@macro mobile_set_command}
  MobileSetCommand({
    Logger? logger,
    Project? project,
  }) : super(
          platform: Platform.mobile,
          defaultLanguageCommand: MobileSetDefaultLanguageCommand(
            logger: logger,
            project: project,
          ),
        );
}
