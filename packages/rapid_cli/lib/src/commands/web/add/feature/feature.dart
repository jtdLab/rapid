import 'package:rapid_cli/src/commands/core/platform/add/feature/feature.dart';
import 'package:rapid_cli/src2/core/platform.dart';

/// {@template web_add_feature_command}
/// `rapid web add feature` command adds a feature to the Web part of an existing Rapid project.
/// {@endtemplate}
class WebAddFeatureCommand extends PlatformAddFeatureCommand {
  /// {@macro web_add_feature_command}
  WebAddFeatureCommand({
    super.logger,
    required super.project,
    super.melosBootstrap,
    super.melosClean,
    super.flutterFormatFix,
  }) : super(
          platform: Platform.web,
        );
}
