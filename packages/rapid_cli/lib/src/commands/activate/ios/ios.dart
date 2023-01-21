import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/activate/core/platform.dart';
import 'package:rapid_cli/src/commands/core/org_name_option.dart';
import 'package:rapid_cli/src2/cli/cli.dart';
import 'package:rapid_cli/src2/core/platform.dart';
import 'package:rapid_cli/src2/project/project.dart';

/// {@template activate_ios_command}
/// `rapid activate ios` command adds support for iOS to an existing Rapid project.
/// {@endtemplate}
class ActivateIosCommand extends ActivatePlatformCommand with OrgNameGetter {
  /// {@macro activate_ios_command}
  ActivateIosCommand({
    super.logger,
    required super.project,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableIos,
    super.melosBootstrap,
    super.melosClean,
    super.flutterFormatFix,
  }) : super(
          platform: Platform.ios,
          flutterConfigEnablePlatform: flutterConfigEnableIos,
        ) {
    argParser.addOrgNameOption(
      help: 'The organization for the native iOS project.',
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
