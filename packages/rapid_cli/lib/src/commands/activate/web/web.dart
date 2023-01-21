import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/activate/core/platform.dart';
import 'package:rapid_cli/src/commands/core/org_name_option.dart';
import 'package:rapid_cli/src2/cli/cli.dart';
import 'package:rapid_cli/src2/core/platform.dart';
import 'package:rapid_cli/src2/project/project.dart';

import 'web_bundle.dart';

/// {@template activate_web_command}
/// `rapid activate web` command adds support for Web to an existing Rapid project.
/// {@endtemplate}
class ActivateWebCommand extends ActivatePlatformCommand with OrgNameGetter {
  /// {@macro activate_web_command}
  ActivateWebCommand({
    super.logger,
    required super.project,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableWeb,
    super.melosBootstrap,
    super.melosClean,
    super.flutterFormatFix,
  }) : super(
          platform: Platform.web,
          flutterConfigEnablePlatform: flutterConfigEnableWeb,
        );

  @override
  Future<void> activatePlatform(
    Platform platform, {
    required Project project,
    required Logger logger,
  }) =>
      project.activatePlatform(platform,
          description: 'TODO', logger: logger); // TODO real desc here
}
