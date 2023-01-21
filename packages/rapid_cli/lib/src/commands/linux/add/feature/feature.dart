import 'package:rapid_cli/src/commands/core/platform/add/feature/feature.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template linux_add_feature_command}
/// `rapid linux add feature` command adds a feature to the Linux part of an existing Rapid project.
/// {@endtemplate}
class LinuxAddFeatureCommand extends PlatformAddFeatureCommand {
  /// {@macro linux_add_feature_command}
  LinuxAddFeatureCommand({
    super.logger,
    required super.project,
    super.melosBootstrap,
    super.melosClean,
    super.flutterFormatFix,
  }) : super(
          platform: Platform.linux,
        );
}
