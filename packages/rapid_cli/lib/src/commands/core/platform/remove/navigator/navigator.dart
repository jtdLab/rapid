import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/android/remove/navigator/navigator.dart';
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/core/feature_option.dart';
import 'package:rapid_cli/src/commands/core/platform_x.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/ios/remove/navigator/navigator.dart';
import 'package:rapid_cli/src/commands/linux/remove/navigator/navigator.dart';
import 'package:rapid_cli/src/commands/macos/remove/navigator/navigator.dart';
import 'package:rapid_cli/src/commands/web/remove/navigator/navigator.dart';
import 'package:rapid_cli/src/commands/windows/remove/navigator/navigator.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template platform_remove_navigator_command}
/// Base class for:
///
///  * [AndroidRemoveNavigatorCommand]
///
///  * [IosRemoveNavigatorCommand]
///
///  * [LinuxRemoveNavigatorCommand]
///
///  * [MacosRemoveNavigatorCommand]
///
///  * [WebRemoveNavigatorCommand]
///
///  * [WindowsRemoveNavigatorCommand]
/// {@endtemplate}
abstract class PlatformRemoveNavigatorCommand extends RapidRootCommand
    with FeatureGetter, GroupableMixin, CodeGenMixin {
  /// {@macro platform_remove_navigator_command}
  PlatformRemoveNavigatorCommand({
    required Platform platform,
    Logger? logger,
    Project? project,
    FlutterPubGetCommand? flutterPubGet,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    DartFormatFixCommand? dartFormatFix,
  })  : _platform = platform,
        _logger = logger ?? Logger(),
        _project = project ?? Project(),
        flutterPubGet = flutterPubGet ?? Flutter.pubGet,
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs,
        _dartFormatFix = dartFormatFix ?? Dart.formatFix {
    argParser
      ..addSeparator('')
      // TODO add hint that its a dart package nameish string but not the full name of the related package
      ..addFeatureOption(
        help: 'The name of the feature the navigator is related to.\n'
            'This must be the name of an existing ${_platform.prettyName} feature.',
      );
  }

  final Platform _platform;
  final Logger _logger;
  final Project _project;
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
  String get invocation =>
      'rapid ${_platform.name} remove navigator [arguments]';

  @override
  String get description =>
      'Remove a navigator from the ${_platform.prettyName} part of an existing Rapid project.';

  @override
  Future<int> run() => runWhen(
        [
          projectExistsAll(_project),
          platformIsActivated(
            _platform,
            _project,
            '${_platform.prettyName} is not activated.',
          ),
        ],
        _logger,
        () async {
          final feature = super.feature;

          _logger.info('Removing Navigator ...');

          final platformDirectory =
              _project.platformDirectory(platform: _platform);
          final featuresDirectory = platformDirectory.featuresDirectory;
          final featurePackage =
              featuresDirectory.featurePackage(name: feature);
          if (featurePackage.exists()) {
            final navigationPackage = platformDirectory.navigationPackage;
            final navigator =
                navigationPackage.navigator(name: feature.pascalCase);

            if (navigator.existsAny()) {
              navigator.delete();
              navigationPackage.barrelFile.removeExport(
                'src/i_${feature.snakeCase}_navigator.dart',
              );

              // TODO check if the impl is already available
              final navigatorImplementation =
                  featurePackage.navigatorImplementation;
              navigatorImplementation.delete();

              await codeGen(packages: [featurePackage], logger: logger);

              await _dartFormatFix(cwd: _project.path, logger: _logger);

              _logger
                ..info('')
                ..success(
                  'Removed ${_platform.prettyName} navigator "I${feature.pascalCase}Navigator".',
                );

              return ExitCode.success.code;
            }

            _logger
              ..info('')
              ..err(
                'The navigator "I${feature.pascalCase}Navigator" does not exist on ${_platform.prettyName}.',
              );

            return ExitCode.config.code;
          } else {
            // TODO test
            _logger
              ..info('')
              ..err(
                'The feature "$feature" does not exist on ${_platform.prettyName}.',
              );

            return ExitCode.config.code;
          }
        },
      );
}
