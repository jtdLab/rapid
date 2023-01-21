import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/activate/core/platform.dart';
import 'package:rapid_cli/src/commands/core/org_name_option.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template activate_macos_command}
/// `rapid activate macos` command adds support for macOS to an existing Rapid project.
/// {@endtemplate}
class ActivateMacosCommand extends ActivatePlatformCommand with OrgNameGetter {
  /// {@macro activate_macos_command}
  ActivateMacosCommand({
    super.logger,
    required super.project,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableMacos,
    super.melosBootstrap,
    super.melosClean,
    super.flutterFormatFix,
  }) : super(
          platform: Platform.macos,
          flutterConfigEnablePlatform: flutterConfigEnableMacos,
        ) {
    argParser.addOrgNameOption(
      help: 'The organization for the native macOS project.',
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
