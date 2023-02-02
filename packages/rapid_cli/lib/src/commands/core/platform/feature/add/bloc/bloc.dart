import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/android/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/core/class_name_arg.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/core/validate_dart_package_name.dart';
import 'package:rapid_cli/src/commands/ios/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/linux/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/macos/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/web/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/windows/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

// TODO share code with add cubit command

/// {@template platform_feature_add_bloc_command}
/// Base class for:
///
///  * [AndroidFeatureAddBlocCommand]
///
///  * [IosFeatureAddBlocCommand]
///
///  * [LinuxFeatureAddBlocCommand]
///
///  * [MacosFeatureAddBlocCommand]
///
///  * [WebFeatureAddBlocCommand]
///
///  * [WindowsFeatureAddBlocCommand]
/// {@endtemplate}
abstract class PlatformFeatureAddBlocCommand extends Command<int>
    with OverridableArgResults, ClassNameGetter {
  /// {@macro platform_feature_add_bloc_command}
  PlatformFeatureAddBlocCommand({
    required Platform platform,
    Logger? logger,
    required Project project,
  })  : _platform = platform,
        _logger = logger ?? Logger(),
        _project = project {
    argParser
      ..addSeparator('')
      // TODO add hint that its a dart package nameish string but not the full name of the related package
      ..addOption(
        'feature-name',
        help: 'The name of the feature this new bloc will be added to.\n'
            'This must be the name of an existing ${_platform.prettyName} feature.',
      );
  }

  final Platform _platform;
  final Logger _logger;
  final Project _project;

  @override
  String get name => 'bloc';

  @override
  String get invocation =>
      'rapid ${_platform.name} feature add bloc <name> [arguments]';

  @override
  String get description =>
      'Adds a bloc to a feature of the ${_platform.prettyName} part of an existing Rapid project.';

  @override
  Future<int> run() => runWhen(
        [
          projectExists(_project),
          platformIsActivated(
            _platform,
            _project,
            '${_platform.prettyName} is not activated.',
          ),
        ],
        _logger,
        () async {
          final featureName = _featureName;
          final name = super.className;

          _logger.info('Adding Bloc ...');

          try {
            await _project.addBloc(
              name: name,
              featureName: featureName,
              platform: _platform,
              logger: _logger,
            );

            _logger
              ..info('')
              ..success(
                'Added ${name.pascalCase}Bloc to ${_platform.prettyName} feature $featureName.',
              );

            return ExitCode.success.code;
          } on FeatureDoesNotExist {
            _logger
              ..info('')
              ..err(
                'The feature $featureName does not exist on ${_platform.prettyName}.',
              );

            return ExitCode.config.code;
          } on BlocAlreadyExists {
            _logger
              ..info('')
              ..err(
                'The bloc $name does already exist in $featureName on ${_platform.prettyName}.',
              );

            return ExitCode.config.code;
          }
        },
      );

  /// Gets the name the feature the bloc should be added to.
  String get _featureName {
    final raw = argResults['feature-name'] as String?;

    if (raw == null) {
      throw UsageException(
        'No option specified for the feature name.',
        usage,
      );
    }

    final isValid = isValidPackageName(raw);
    if (!isValid) {
      throw UsageException(
        '"$raw" is not a valid package name.\n\n'
        'See https://dart.dev/tools/pub/pubspec#name for more information.',
        usage,
      );
    }

    return raw;
  }
}
