import 'package:rapid_cli/src/commands/core/platform/remove/feature/feature.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template ios_remove_feature_command}
/// `rapid ios remove feature` command removes a feature from the iOS part of an existing Rapid project.
/// {@endtemplate}
class IosRemoveFeatureCommand extends PlatformRemoveFeatureCommand {
  /// {@macro ios_remove_feature_command}
  IosRemoveFeatureCommand({
    super.logger,
    required super.project,
    super.melosBootstrap,
    super.melosClean,
  }) : super(
          platform: Platform.ios,
        );
}
