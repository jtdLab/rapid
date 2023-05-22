import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/platform/add/add.dart';
import 'package:rapid_cli/src/commands/mobile/add/feature/feature.dart';
import 'package:rapid_cli/src/commands/mobile/add/language/language.dart';
import 'package:rapid_cli/src/commands/mobile/add/navigator/navigator.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template mobile_add_command}
/// `rapid mobile add` command work with the Mobile part of an existing Rapid project.
/// {@endtemplate}
class MobileAddCommand extends PlatformAddCommand {
  /// {@macro mobile_add_command}
  MobileAddCommand({
    Logger? logger,
    Project? project,
  }) : super(
          platform: Platform.mobile,
          featureCommand:
              MobileAddFeatureCommand(logger: logger, project: project),
          languageCommand:
              MobileAddLanguageCommand(logger: logger, project: project),
          navigatorCommand:
              MobileAddNavigatorCommand(logger: logger, project: project),
        );
}
