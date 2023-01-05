import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/run_when_cwd_has_melos.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template rapid_doctor}
/// `rapid doctor` command shows information about an existing Rapid project.
/// {@endtemplate}
class DoctorCommand extends Command<int> {
  /// {@macro rapid_doctor}
  DoctorCommand({
    Logger? logger,
    required Project project,
  })  : _logger = logger ?? Logger(),
        _project = project;

  final Logger _logger;
  final Project _project;

  @override
  String get name => 'doctor';

  @override
  String get invocation => 'rapid doctor';

  @override
  String get description =>
      'Shows information about an existing Rapid project.';

  @override
  Future<int> run() => runWhenCwdHasMelos(_project, _logger, () async {
        final platformDirectories = Platform.values
            .where((e) => _project.isActivated(e))
            .map((e) => _project.platformDirectory(e));

        for (final platformDirectory in platformDirectories) {
          final platformName = platformDirectory.platform.prettyName;
          final features =
              platformDirectory.getFeatures(exclude: {'app', 'routing'});

          if (features.isNotEmpty) {
            _logger.alert('$platformName:');
            _logger.info('');
            _logger.success('Found ${features.length} feature(s)');
            _logger.info('');
            for (final feature in features) {
              final featureName = feature.name;
              final defaultLanguage = feature.defaultLanguage();
              final languagesWithoutDefaultLanguage = feature
                  .supportedLanguages()
                  .where((e) => e != defaultLanguage);

              _logger.info(
                '[$featureName] ($defaultLanguage (default)${languagesWithoutDefaultLanguage.isEmpty ? '' : languagesWithoutDefaultLanguage.enumerate()})',
              );
            }

            _logger.info('');
            _logger.info('');
          }
        }

        return ExitCode.success.code;
      });
}

extension on Iterable<String> {
  String enumerate() {
    final buffer = StringBuffer();
    for (final item in this) {
      buffer.write(', $item');
    }

    return buffer.toString();
  }
}
