import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/activate/core/platform.dart';
import 'package:rapid_cli/src/commands/core/org_name_option.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template activate_windows_command}
/// `rapid activate windows` command adds support for Windows to an existing Rapid project.
/// {@endtemplate}
class ActivateWindowsCommand extends ActivatePlatformCommand
    with OrgNameGetter {
  /// {@macro activate_windows_command}
  ActivateWindowsCommand({
    super.logger,
    required super.project,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableWindows,
  }) : super(
          platform: Platform.windows,
          flutterConfigEnablePlatform:
              flutterConfigEnableWindows ?? Flutter.configEnableWindows,
        ) {
    argParser.addOrgNameOption(
      help: 'The organization for the native Windows project.',
    );
  }

  @override
  Future<void> activatePlatform({
    required Project project,
    required Logger logger,
  }) =>
      project.activatePlatform(
        Platform.windows,
        orgName: orgName,
        logger: logger,
      );
}
