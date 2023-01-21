import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/activate/core/platform.dart';
import 'package:rapid_cli/src/commands/core/org_name_option.dart';
import 'package:rapid_cli/src2/cli/cli.dart';
import 'package:rapid_cli/src2/core/platform.dart';
import 'package:rapid_cli/src2/project/project.dart';

/// {@template activate_linux_command}
/// `rapid activate linux` command adds support for Linux to an existing Rapid project.
/// {@endtemplate}
class ActivateLinuxCommand extends ActivatePlatformCommand with OrgNameGetter {
  /// {@macro activate_linux_command}
  ActivateLinuxCommand({
    super.logger,
    required super.project,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableLinux,
    super.melosBootstrap,
    super.melosClean,
    super.flutterFormatFix,
  }) : super(
          platform: Platform.linux,
          flutterConfigEnablePlatform: flutterConfigEnableLinux,
        ) {
    argParser.addOrgNameOption(
      help: 'The organization for the native Linux project.',
    );
  }

  @override
  Future<void> activatePlatform(
    Platform platform, {
    required Project project,
    required Logger logger,
  }) =>
      project.activatePlatform(platform, orgName: orgName, logger: logger);
}
