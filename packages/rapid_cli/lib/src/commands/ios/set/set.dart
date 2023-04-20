import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/platform/set/set.dart';
import 'package:rapid_cli/src/commands/ios/set/default_language/default_language.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template ios_set_command}
/// `rapid ios set` command sets properties of features from the iOS part of an existing Rapid project.
/// {@endtemplate}
class IosSetCommand extends PlatformSetCommand {
  /// {@macro ios_set_command}
  IosSetCommand({
    Logger? logger,
    Project? project,
  }) : super(
          platform: Platform.ios,
          defaultLanguageCommand: IosSetDefaultLanguageCommand(
            logger: logger,
            project: project,
          ),
        );
}
