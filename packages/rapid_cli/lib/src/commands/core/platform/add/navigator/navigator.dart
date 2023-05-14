import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/android/add/navigator/navigator.dart';
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/logger_x.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/core/feature_option.dart';
import 'package:rapid_cli/src/commands/core/platform_x.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/ios/add/navigator/navigator.dart';
import 'package:rapid_cli/src/commands/linux/add/navigator/navigator.dart';
import 'package:rapid_cli/src/commands/macos/add/navigator/navigator.dart';
import 'package:rapid_cli/src/commands/web/add/navigator/navigator.dart';
import 'package:rapid_cli/src/commands/windows/add/navigator/navigator.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template platform_add_navigator_command}
/// Base class for:
///
///  * [AndroidAddNavigatorCommand]
///
///  * [IosAddNavigatorCommand]
///
///  * [LinuxAddNavigatorCommand]
///
///  * [MacosAddNavigatorCommand]
///
///  * [WebAddNavigatorCommand]
///
///  * [WindowsAddNavigatorCommand]
/// {@endtemplate}
abstract class PlatformAddNavigatorCommand extends RapidRootCommand
    with FeatureGetter, GroupableMixin, CodeGenMixin {
  /// {@macro platform_add_navigator_command}
  PlatformAddNavigatorCommand({
    required Platform platform,
    super.logger,
    super.project,
    FlutterPubGetCommand? flutterPubGet,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    DartFormatFixCommand? dartFormatFix,
  })  : _platform = platform,
        flutterPubGet = flutterPubGet ?? Flutter.pubGet,
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs,
        _dartFormatFix = dartFormatFix ?? Dart.formatFix {
    argParser
      ..addSeparator('')
      // TODO add hint that its a dart package nameish string but not the full name of the related package
      ..addFeatureOption(
        help: 'The name of the feature this new navigator is related to.\n'
            'This must be the name of an existing ${_platform.prettyName} feature.',
      );
  }

  final Platform _platform;
  @override
  final FlutterPubGetCommand flutterPubGet;
  @override
  final FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
      flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;
  final DartFormatFixCommand _dartFormatFix;

  @override
  String get name => 'navigator';

  @override
  List<String> get aliases => ['nav'];

  @override
  String get invocation => 'rapid ${_platform.name} add navigator [arguments]';

  @override
  String get description =>
      'Add a navigator to the ${_platform.prettyName} part of an existing Rapid project.';

  @override
  Future<int> run() => runWhen(
        [
          projectExistsAll(project),
          platformIsActivated(
            _platform,
            project,
            '${_platform.prettyName} is not activated.',
          ),
        ],
        logger,
        () async {
          final feature = super.feature;

          logger.commandTitle(
            'Adding Navigator for Feature "$feature" (${_platform.prettyName})',
          );

          final platformDirectory =
              project.platformDirectory(platform: _platform);
          final featuresDirectory = platformDirectory.featuresDirectory;
          final featurePackage =
              featuresDirectory.featurePackage(name: feature);
          if (featurePackage.exists()) {
            final navigationPackage = platformDirectory.navigationPackage;
            final navigator =
                navigationPackage.navigator(name: feature.pascalCase);

            if (!navigator.existsAny()) {
              await navigator.create();
              navigationPackage.barrelFile.addExport(
                'src/i_${feature.snakeCase}_navigator.dart',
              );

              // TODO check if the impl is already available
              final navigatorImplementation =
                  featurePackage.navigatorImplementation;
              await navigatorImplementation.create();

              await codeGen(packages: [featurePackage], logger: logger);

              await _dartFormatFix(cwd: project.path, logger: logger);

              logger.commandSuccess();

              return ExitCode.success.code;
            }

            logger.commandError(
              'The Navigator "I${feature.pascalCase}Navigator" does already exist on ${_platform.prettyName}.',
            );

            return ExitCode.config.code;
          } else {
            // TODO test
            logger.commandError(
              'The Feature "$feature" does not exist on ${_platform.prettyName}.',
            );

            return ExitCode.config.code;
          }
        },
      );
}
