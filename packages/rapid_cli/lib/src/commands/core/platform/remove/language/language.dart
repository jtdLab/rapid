import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/android/remove/language/language.dart';
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/language_rest.dart';
import 'package:rapid_cli/src/commands/core/logger_x.dart';
import 'package:rapid_cli/src/commands/core/platform/core/platform_feature_packages_x.dart';
import 'package:rapid_cli/src/commands/core/platform_x.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/ios/remove/language/language.dart';
import 'package:rapid_cli/src/commands/linux/remove/language/language.dart';
import 'package:rapid_cli/src/commands/macos/remove/language/language.dart';
import 'package:rapid_cli/src/commands/web/remove/language/language.dart';
import 'package:rapid_cli/src/commands/windows/remove/language/language.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template platform_remove_language_command}
/// Base class for:
///
///  * [AndroidRemoveLanguageCommand]
///
///  * [IosRemoveLanguageCommand]
///
///  * [LinuxRemoveLanguageCommand]
///
///  * [MacosRemoveLanguageCommand]
///
///  * [WebRemoveLanguageCommand]
///
///  * [WindowsRemoveLanguageCommand]
/// {@endtemplate}
abstract class PlatformRemoveLanguageCommand extends RapidRootCommand
    with LanguageGetter {
  /// {@macro platform_remove_language_command}
  PlatformRemoveLanguageCommand({
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
  String get name => 'language';

  @override
  List<String> get aliases => ['lang'];

  @override
  String get invocation => 'rapid ${_platform.name} remove language <language>';

  @override
  String get description =>
      'Removes a language from the ${_platform.prettyName} part of an existing Rapid project.';

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

          logger.commandTitle(
            'Removing Language "$language" (${_platform.prettyName}) ...',
          );

          final platformDirectory =
              project.platformDirectory(platform: _platform);
          final featurePackages =
              platformDirectory.featuresDirectory.featurePackages();

          if (featurePackages.isEmpty) {
            logger.commandError(
              'No ${_platform.prettyName} features found!\n'
              'Run "rapid ${_platform.name} add feature" to add your first ${_platform.prettyName} feature.',
            );

            return ExitCode.config.code;
          }

          if (!featurePackages.supportSameLanguages()) {
            logger.commandError(
              'The ${_platform.prettyName} part of your project is corrupted.\n'
              'Because not all features support the same languages.\n\n'
              'Run "rapid doctor" to see which features are affected.',
            );

            return ExitCode.config.code;
          }

          if (!featurePackages.haveSameDefaultLanguage()) {
            logger.commandError(
              'The ${_platform.prettyName} part of your project is corrupted.\n'
              'Because not all features have the same default language.\n\n'
              'Run "rapid doctor" to see which features are affected.',
            );

            return ExitCode.config.code;
          }

          if (!featurePackages.supportLanguage(language)) {
            // TODO better hint
            logger.commandError('The language "$language" is not present.');

            return ExitCode.config.code;
          }

          if (featurePackages.first.defaultLanguage() == language) {
            // TODO add hint how to change default language
            logger.commandError(
              'Can not remove language "$language" because it is the default language.',
            );

            return ExitCode.config.code;
          }

          final rootPackage = platformDirectory.rootPackage;
          await rootPackage.removeLanguage(language);

          for (final featurePackage in featurePackages) {
            await featurePackage.removeLanguage(language);
            await _flutterGenl10n(cwd: featurePackage.path, logger: logger);
          }
          await _dartFormatFix(cwd: project.path, logger: logger);

          logger.commandSuccess();

          return ExitCode.success.code;
        },
      );
}
