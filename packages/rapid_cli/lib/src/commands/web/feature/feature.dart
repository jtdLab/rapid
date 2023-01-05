import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/web/feature/add/add.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/feature.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template web_feature_command}
/// `rapid web feature` command work with features of the Web part of an existing Rapid project.
/// {@endtemplate}
class WebFeatureCommand extends PlatformFeatureCommand {
  /// {@macro web_feature_command}
  WebFeatureCommand({
    Logger? logger,
    required Project project,
  }) : super(
          platform: Platform.web,
          addCommand: WebFeatureAddCommand(logger: logger, project: project),
        );
}
