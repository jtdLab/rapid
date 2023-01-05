import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/activate/core/activate_platform_command.dart';
import 'package:rapid_cli/src/commands/core/org_name_option.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:universal_io/io.dart';

import 'web_bundle.dart';

/// {@template activate_web_command}
/// `rapid activate web` command adds support for Web to an existing Rapid project.
/// {@endtemplate}
class ActivateWebCommand extends ActivatePlatformCommand with OrgNameGetters {
  /// {@macro activate_web_command}
  ActivateWebCommand({
    super.logger,
    required super.project,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableWeb,
    super.flutterPubGetCommand,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    super.melosBootstrap,
    super.melosClean,
    super.generator,
  }) : super(
          platform: Platform.web,
          platformBundle: webBundle,
          flutterConfigEnablePlatform: flutterConfigEnableWeb,
        );

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
      },
      logger: logger,
    );
  }
}
