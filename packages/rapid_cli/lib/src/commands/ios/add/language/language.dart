import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/platform/add/language/language.dart';
import 'package:rapid_cli/src/commands/core/platform/core/platform_feature_packages_x.dart';
import 'package:rapid_cli/src/commands/core/platform_x.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_directory.dart';

/// {@template ios_add_language_command}
/// `rapid ios add language` command adds a language to the iOS part of an existing Rapid project.
/// {@endtemplate}
class IosAddLanguageCommand extends PlatformAddLanguageCommand {
  /// {@macro ios_add_language_command}
  IosAddLanguageCommand({
    super.logger,
    super.project,
    super.flutterGenl10n,
    super.dartFormatFix,
  }) : super(
          platform: Platform.ios,
        );

  @override
  Future<int> run() => runWhen(
        [
          projectExistsAll(project),
          platformIsActivated(
            platform,
            project,
            '${platform.prettyName} is not activated.',
          ),
        ],
        logger,
        () async {
          final language = super.language;

          logger.info('Adding Language ...');

          final platformDirectory =
              project.platformDirectory<IosDirectory>(platform: platform);
          final featuresDirectory = platformDirectory.featuresDirectory;
          final featurePackages = featuresDirectory.featurePackages();

          if (featurePackages.isEmpty) {
            logger
              ..info('')
              ..err(
                'No ${platform.prettyName} features found!\n'
                'Run "rapid ${platform.name} add feature" to add your first ${platform.prettyName} feature.',
              );

            return ExitCode.config.code;
          }

          if (!featurePackages.supportSameLanguages()) {
            logger
              ..info('')
              ..err(
                'The ${platform.prettyName} part of your project is corrupted.\n'
                'Because not all features support the same languages.\n\n'
                'Run "rapid doctor" to see which features are affected.',
              );

            return ExitCode.config.code;
          }

          if (!featurePackages.haveSameDefaultLanguage()) {
            logger
              ..info('')
              ..err(
                'The ${platform.prettyName} part of your project is corrupted.\n'
                'Because not all features have the same default language.\n\n'
                'Run "rapid doctor" to see which features are affected.',
              );

            return ExitCode.config.code;
          }

          if (featurePackages.supportLanguage(language)) {
            logger
              ..info('')
              ..err('The language "$language" is already present.');

            return ExitCode.config.code;
          }

          final rootPackage = platformDirectory.rootPackage;
          await rootPackage.addLanguage(language);

          for (final featurePackage in featurePackages) {
            await featurePackage.addLanguage(language);
            await flutterGenl10n(cwd: featurePackage.path, logger: logger);
          }
          await dartFormatFix(cwd: project.path, logger: logger);

          // TODO add hint how to work with localization
          logger
            ..info('')
            ..success(
              'Added $language to the ${platform.prettyName} part of your project.',
            );

          return ExitCode.success.code;
        },
      );
}
