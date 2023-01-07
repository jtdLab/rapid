import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/activate/core/platform.dart';
import 'package:rapid_cli/src/commands/core/org_name_option.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:universal_io/io.dart';

import 'linux_bundle.dart';

/// {@template activate_linux_command}
/// `rapid activate linux` command adds support for Linux to an existing Rapid project.
/// {@endtemplate}
class ActivateLinuxCommand extends ActivatePlatformCommand with OrgNameGetters {
  /// {@macro activate_linux_command}
  ActivateLinuxCommand({
    super.logger,
    required super.project,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableLinux,
    super.flutterPubGetCommand,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    super.melosBootstrap,
    super.melosClean,
    super.flutterFormatFix,
    super.generator,
  }) : super(
          platform: Platform.linux,
          platformBundle: linuxBundle,
          flutterConfigEnablePlatform: flutterConfigEnableLinux,
        ) {
    argParser.addOrgNameOption(
      help: 'The organization for the native Linux project.',
    );
  }

  @override
  Future<List<GeneratedFile>> generate({
    required MasonGenerator generator,
    required Logger logger,
    required Project project,
  }) async {
    final projectName = project.melosFile.name();

    return generator.generate(
      DirectoryGeneratorTarget(Directory('.')),
      vars: {
        'project_name': projectName,
        'org_name': orgName,
      },
      logger: logger,
    );
  }
}
