import 'package:rapid_cli/src/commands/core/platform/remove/feature/feature.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template windows_remove_feature_command}
/// `rapid windows remove feature` command removes a feature from the Windows part of an existing Rapid project.
/// {@endtemplate}
class WindowsRemoveFeatureCommand extends PlatformRemoveFeatureCommand {
  /// {@macro windows_remove_feature_command}
  WindowsRemoveFeatureCommand({
    super.logger,
    required super.project,
    super.melosBootstrap,
    super.melosClean,
  }) : super(
          platform: Platform.windows,
        );
}
