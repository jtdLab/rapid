import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/activate/activate_sub_command.dart';
import 'package:rapid_cli/src/commands/activate/linux/linux_bundle.dart';
import 'package:rapid_cli/src/commands/core/generator_builder.dart';
import 'package:rapid_cli/src/commands/core/org_name_option.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:universal_io/io.dart';

/// {@template activate_linux_command}
/// `rapid activate linux` command adds support for Linux to an existing Rapid project.
/// {@endtemplate}
class ActivateLinuxCommand extends ActivateSubCommand with OrgNameGetters {
  ActivateLinuxCommand({
    Logger? logger,
    required Project project,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableLinux,
    FlutterPubGetCommand? flutterPubGetCommand,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    MelosBootstrapCommand? melosBootstrap,
    MelosCleanCommand? melosClean,
    GeneratorBuilder? generator,
  })  : _generator = generator ?? MasonGenerator.fromBundle,
        super(
          platform: Platform.linux,
          logger: logger ?? Logger(),
          project: project,
          flutterConfigEnablePlatform:
              flutterConfigEnableLinux ?? Flutter.configEnableLinux,
          flutterPubGetCommand: flutterPubGetCommand ?? Flutter.pubGet,
          flutterPubRunBuildRunnerBuildDeleteConflictingOutputs:
              flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                  Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs,
          melosBootstrap: melosBootstrap ?? Melos.bootstrap,
          melosClean: melosClean ?? Melos.clean,
        ) {
    argParser.addOrgNameOption(
      help: 'The organization for the native Linux project.',
    );
  }

  final GeneratorBuilder _generator;

  @override
  Future<List<GeneratedFile>> generate({
    required Logger logger,
    required Project project,
  }) async {
    final projectName = project.melosFile.name();

    final generator = await _generator(linuxBundle);
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
