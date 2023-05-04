import 'package:rapid_cli/src/commands/core/command.dart';

/// {@template rapid_doctor}
/// `rapid doctor` command shows information about an existing Rapid project.
/// {@endtemplate}
class DoctorCommand extends RapidRootCommand {
  /// {@macro rapid_doctor}
  DoctorCommand({
    super.logger,
    super.project,
  });

  @override
  String get name => 'doctor';

  @override
  String get invocation => 'rapid doctor';

  @override
  String get description => 'Show information about an existing Rapid project.';

  // TODO refactor
  /*  @override
  Future<int> run() => runWhen(
        [projectExistsAll(project)],
        logger,
        () async {
          final platformDirectories = Platform.values
              .where((e) => project.platformIsActivated(e))
              .map((e) => project.platformDirectory(platform: e))
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

              logger.info(
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
              logger.info('\n${tabular(data)}'.replaceAll('\n', '\n    '));
              logger.info('');

              if (!allFeaturesHaveSameLanguages) {
                totalIssues++;
                logger.info(
                  '    ${red.wrap('✗')} Some features do not support the same languages.',
                );
              }

              if (!allFeaturesHaveSameDefaultLanguage) {
                totalIssues++;
                logger.info(
                  '    ${red.wrap('✗')} Some features do not have the same default language.',
                );
              }

              if (!allFeaturesHaveSameLanguages ||
                  !allFeaturesHaveSameDefaultLanguage) {
                totalPlatformsWithIssues++;
                logger.info('');
              }
            }
          }

          if (totalIssues == 0) {
            logger.info('No issues found.');
          } else {
            logger.info(
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
