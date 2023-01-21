import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/activate/core/platform.dart';
import 'package:rapid_cli/src/commands/core/org_name_option.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template activate_linux_command}
/// `rapid activate linux` command adds support for Linux to an existing Rapid project.
/// {@endtemplate}
class ActivateLinuxCommand extends ActivatePlatformCommand with OrgNameGetter {
  /// {@macro activate_linux_command}
  ActivateLinuxCommand({
    super.logger,
    required super.project,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableLinux,
  }) : super(
          platform: Platform.linux,
          flutterConfigEnablePlatform:
              flutterConfigEnableLinux ?? Flutter.configEnableLinux,
        ) {
    argParser.addOrgNameOption(
      help: 'The organization for the native Linux project.',
    );
  }

  @override
  Future<void> activatePlatform({
    required Project project,
    required Logger logger,
  }) =>
      project.activatePlatform(
        Platform.linux,
        orgName: orgName,
        logger: logger,
      );
}
