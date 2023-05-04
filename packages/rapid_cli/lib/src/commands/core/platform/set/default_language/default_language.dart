import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/android/set/default_language/default_language.dart';
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/language_rest.dart';
import 'package:rapid_cli/src/commands/core/platform/core/platform_feature_packages_x.dart';
import 'package:rapid_cli/src/commands/core/platform_x.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/ios/set/default_language/default_language.dart';
import 'package:rapid_cli/src/commands/linux/set/default_language/default_language.dart';
import 'package:rapid_cli/src/commands/macos/set/default_language/default_language.dart';
import 'package:rapid_cli/src/commands/web/set/default_language/default_language.dart';
import 'package:rapid_cli/src/commands/windows/set/default_language/default_language.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template platform_set_default_language_command}
/// Base class for:
///
///  * [AndroidSetDefaultLanguageCommand]
///
///  * [IosSetDefaultLanguageCommand]
///
///  * [LinuxSetDefaultLanguageCommand]
///
///  * [MacosSetDefaultLanguageCommand]
///
///  * [WebSetDefaultLanguageCommand]
///
///  * [WindowsSetDefaultLanguageCommand]
/// {@endtemplate}
abstract class PlatformSetDefaultLanguageCommand extends RapidRootCommand
    with LanguageGetter {
  /// {@macro platform_set_default_language_command}
  PlatformSetDefaultLanguageCommand({
    required Platform platform,
    super.logger,
    super.project,
    FlutterGenl10nCommand? flutterGenl10n,
    DartFormatFixCommand? dartFormatFix,
  })  : _platform = platform,
        _flutterGenl10n = flutterGenl10n ?? Flutter.genl10n,
        _dartFormatFix = dartFormatFix ?? Dart.formatFix;

  final Platform _platform;
  final FlutterGenl10nCommand _flutterGenl10n;
  final DartFormatFixCommand _dartFormatFix;

  @override
  String get name => 'default_language';

  @override
  List<String> get aliases => ['default_lang'];

  @override
  String get invocation =>
      'rapid ${_platform.name} set default_language <language>';

  @override
  String get description =>
      'Set the default language of the ${_platform.prettyName} part of an existing Rapid project.';

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
          final language = super.language;

          logger.info('Setting default language ...');

          final platformDirectory =
              project.platformDirectory(platform: _platform);
          final featurePackages =
              platformDirectory.featuresDirectory.featurePackages();

          if (featurePackages.isEmpty) {
            logger
              ..info('')
              ..err(
                'No ${_platform.prettyName} features found!\n'
                'Run "rapid ${_platform.name} add feature" to add your first ${_platform.prettyName} feature.',
              );

            return ExitCode.config.code;
          }

          if (!featurePackages.supportSameLanguages()) {
            logger
              ..info('')
              ..err(
                  'The ${_platform.prettyName} part of your project is corrupted.\n'
                  'Because not all features support the same languages.\n\n'
                  'Run "rapid doctor" to see which features are affected.');

            return ExitCode.config.code;
          }

          if (!featurePackages.haveSameDefaultLanguage()) {
            logger
              ..info('')
              ..err(
                  'The ${_platform.prettyName} part of your project is corrupted.\n'
                  'Because not all features have the same default language.\n\n'
                  'Run "rapid doctor" to see which features are affected.');

            return ExitCode.config.code;
          }

          if (!featurePackages.supportLanguage(language)) {
            // TODO better hint
            logger
              ..info('')
              ..err('The language "$language" is not present.');

            return ExitCode.config.code;
          }

          if (featurePackages.first.defaultLanguage() == language) {
            logger
              ..info('')
              ..err(
                'The language "$language" already is the default language.',
              );

            return ExitCode.config.code;
          }

          for (final featurePackage in featurePackages) {
            await featurePackage.setDefaultLanguage(language);
            await _flutterGenl10n(cwd: featurePackage.path, logger: logger);
          }
          await _dartFormatFix(cwd: project.path, logger: logger);

          // TODO add hint how to work with localization
          logger
            ..info('')
            ..success(
              'Set $language as the default language of the ${_platform.prettyName} part of your project.',
            );

          return ExitCode.success.code;
          // TODO Share error messages
        },
      );
}
