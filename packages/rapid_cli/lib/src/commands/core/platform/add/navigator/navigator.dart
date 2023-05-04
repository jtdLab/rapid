import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/android/add/navigator/navigator.dart';
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/core/feature_option.dart';
import 'package:rapid_cli/src/commands/core/platform_x.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/ios/add/navigator/navigator.dart';
import 'package:rapid_cli/src/commands/linux/add/navigator/navigator.dart';
import 'package:rapid_cli/src/commands/macos/add/navigator/navigator.dart';
import 'package:rapid_cli/src/commands/web/add/navigator/navigator.dart';
import 'package:rapid_cli/src/commands/windows/add/navigator/navigator.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

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
        help: 'The name of the feature this new navigator is related to.\n'
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
  String get invocation => 'rapid ${_platform.name} add navigator [arguments]';

  @override
  String get description =>
      'Add a navigator to the ${_platform.prettyName} part of an existing Rapid project.';

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

          _logger.info('Adding Navigator ...');

          final platformDirectory =
              _project.platformDirectory(platform: _platform);
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

              await _dartFormatFix(cwd: _project.path, logger: _logger);

              _logger
                ..info('')
                ..success(
                  'Added ${_platform.prettyName} navigator "I${feature.pascalCase}Navigator".',
                );

              return ExitCode.success.code;
            }

            _logger
              ..info('')
              ..err(
                'The navigator "I${feature.pascalCase}Navigator" does already exist on ${_platform.prettyName}.',
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
