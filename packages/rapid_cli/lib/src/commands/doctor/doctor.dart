import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
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
  String get description => 'Show information about an existing Rapid project.';

  // TODO refactor
  /*  @override
  Future<int> run() => runWhen(
        [projectExistsAll(_project)],
        _logger,
        () async {
          final platformDirectories = Platform.values
              .where((e) => _project.platformIsActivated(e))
              .map((e) => _project.platformDirectory(platform: e))
              .toList();

          var totalIssues = 0;
          var totalPlatformsWithIssues = 0;
          for (final platformDirectory in platformDirectories) {
            final features = platformDirectory.customFeaturePackages();

            if (features.isNotEmpty) {
              final allFeaturesHaveSameLanguages =
                  platformDirectory.allFeaturesHaveSameLanguages();
              final allFeaturesHaveSameDefaultLanguage =
                  platformDirectory.allFeaturesHaveSameDefaultLanguage();
              final platformName = platformDirectory.platform.prettyName;

              _logger.info(
                '${allFeaturesHaveSameLanguages && allFeaturesHaveSameDefaultLanguage ? '${green.wrap('[✓]')}' : '${yellow.wrap('[!]')}'}'
                ' $platformName (${features.length} feature(s))',
              );

              final data = <List<dynamic>>[
                [
                  '#',
                  'Name',
                  'Package Name',
                  'Languages',
                  'Default Language',
                  'Location'
                ],
              ];

              int index = 1;
              for (final feature in features) {
                data.add([
                  index,
                  feature.name,
                  feature.packageName(),
                  feature.supportedLanguages().enumerate(),
                  feature.defaultLanguage(),
                  feature.path
                ]);
                index++;
              }
              _logger.info('\n${tabular(data)}'.replaceAll('\n', '\n    '));
              _logger.info('');

              if (!allFeaturesHaveSameLanguages) {
                totalIssues++;
                _logger.info(
                  '    ${red.wrap('✗')} Some features do not support the same languages.',
                );
              }

              if (!allFeaturesHaveSameDefaultLanguage) {
                totalIssues++;
                _logger.info(
                  '    ${red.wrap('✗')} Some features do not have the same default language.',
                );
              }

              if (!allFeaturesHaveSameLanguages ||
                  !allFeaturesHaveSameDefaultLanguage) {
                totalPlatformsWithIssues++;
                _logger.info('');
              }
            }
          }

          if (totalIssues == 0) {
            _logger.info('No issues found.');
          } else {
            _logger.info(
              '${yellow.wrap('!')} Found $totalIssues issue(s) on $totalPlatformsWithIssues platform(s).',
            );
          }

          return ExitCode.success.code;
        },
      );
 */
}

extension on Iterable<String> {
  String enumerate() {
    final buffer = StringBuffer();
    for (final item in this) {
      if (item == last) {
        buffer.write(item);
        continue;
      }

      buffer.write('$item, ');
    }

    return buffer.toString();
  }
}
