import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/ios/add/feature/feature.dart';
import 'package:rapid_cli/src/commands/ios/add/language/language.dart';
import 'package:rapid_cli/src/commands/core/platform/add/add.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template ios_add_command}
/// `rapid ios add` command work with the iOS part of an existing Rapid project.
/// {@endtemplate}
class IosAddCommand extends PlatformAddCommand {
  /// {@macro ios_add_command}
  IosAddCommand({
    Logger? logger,
    required Project project,
  }) : super(
          platform: Platform.ios,
          featureCommand:
              IosAddFeatureCommand(logger: logger, project: project),
          languageCommand:
              IosAddLanguageCommand(logger: logger, project: project),
        );
}
