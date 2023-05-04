import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/android/add/language/language.dart';
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/language_rest.dart';
import 'package:rapid_cli/src/commands/core/platform/core/platform_feature_packages_x.dart';
import 'package:rapid_cli/src/commands/core/platform_x.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/ios/add/language/language.dart';
import 'package:rapid_cli/src/commands/linux/add/language/language.dart';
import 'package:rapid_cli/src/commands/macos/add/language/language.dart';
import 'package:rapid_cli/src/commands/web/add/language/language.dart';
import 'package:rapid_cli/src/commands/windows/add/language/language.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

// TODO share code with the remove lang command

/// {@template platform_add_language_command}
/// Base class for:
///
///  * [AndroidAddLanguageCommand]
///
///  * [IosAddLanguageCommand]
///
///  * [LinuxAddLanguageCommand]
///
///  * [MacosAddLanguageCommand]
///
///  * [WebAddLanguageCommand]
///
///  * [WindowsAddLanguageCommand]
/// {@endtemplate}
abstract class PlatformAddLanguageCommand extends RapidRootCommand
    with LanguageGetter {
  /// {@macro platform_add_language_command}
  PlatformAddLanguageCommand({
    required this.platform,
    Logger? logger,
    Project? project,
    FlutterGenl10nCommand? flutterGenl10n,
    DartFormatFixCommand? dartFormatFix,
  })  : logger = logger ?? Logger(),
        project = project ?? Project(),
        flutterGenl10n = flutterGenl10n ?? Flutter.genl10n,
        dartFormatFix = dartFormatFix ?? Dart.formatFix;

  final Platform platform;
  final Logger logger;
  final Project project;
  final FlutterGenl10nCommand flutterGenl10n;
  final DartFormatFixCommand dartFormatFix;

  @override
  String get name => 'language';

  @override
  List<String> get aliases => ['lang'];

  @override
  String get invocation => 'rapid ${platform.name} add language <language>';

  @override
  String get description =>
      'Add a language to the ${platform.prettyName} part of an existing Rapid project.';

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
              project.platformDirectory(platform: platform);
          final featurePackages =
              platformDirectory.featuresDirectory.featurePackages();

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
