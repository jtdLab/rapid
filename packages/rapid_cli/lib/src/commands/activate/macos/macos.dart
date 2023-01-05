import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/activate/activate_sub_command.dart';
import 'package:rapid_cli/src/commands/activate/macos/macos_bundle.dart';
import 'package:rapid_cli/src/commands/core/generator_builder.dart';
import 'package:rapid_cli/src/commands/core/org_name_option.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:universal_io/io.dart';

/// {@template activate_macos_command}
/// `rapid activate macos` command adds support for macOS to an existing Rapid project.
/// {@endtemplate}
class ActivateMacosCommand extends ActivateSubCommand with OrgNameGetters {
  ActivateMacosCommand({
    Logger? logger,
    required Project project,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableMacos,
    FlutterPubGetCommand? flutterPubGetCommand,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    MelosBootstrapCommand? melosBootstrap,
    MelosCleanCommand? melosClean,
    GeneratorBuilder? generator,
  })  : _generator = generator ?? MasonGenerator.fromBundle,
        super(
          platform: Platform.macos,
          logger: logger ?? Logger(),
          project: project,
          flutterConfigEnablePlatform:
              flutterConfigEnableMacos ?? Flutter.configEnableMacos,
          flutterPubGetCommand: flutterPubGetCommand ?? Flutter.pubGet,
          flutterPubRunBuildRunnerBuildDeleteConflictingOutputs:
              flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                  Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs,
          melosBootstrap: melosBootstrap ?? Melos.bootstrap,
          melosClean: melosClean ?? Melos.clean,
        ) {
    argParser.addOrgNameOption(
      help: 'The organization for the native macOS project.',
    );
  }

  final GeneratorBuilder _generator;

  @override
  Future<List<GeneratedFile>> generate({
    required Logger logger,
    required Project project,
  }) async {
    final projectName = project.melosFile.name();

    final generator = await _generator(macosBundle);
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
