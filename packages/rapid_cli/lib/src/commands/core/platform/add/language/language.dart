import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/generator_builder.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when_cwd_has_melos.dart';
import 'package:rapid_cli/src/commands/core/validate_language.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:universal_io/io.dart';

import 'language_bundle.dart';

/// {@template platform_add_language_command}
/// Base class for TODO
/// {@endtemplate}
abstract class PlatformAddLanguageCommand extends Command<int>
    with OverridableArgResults {
  /// {@macro platform_add_language_command}
  PlatformAddLanguageCommand({
    required Platform platform,
    required Logger logger,
    required Project project,
    required FlutterGenl10nCommand flutterGenl10n,
    required GeneratorBuilder generator,
  })  : _platform = platform,
        _logger = logger,
        _project = project,
        _flutterGenl10n = flutterGenl10n,
        _generator = generator;

  final Logger _logger;
  final Platform _platform;
  final Project _project;
  final FlutterGenl10nCommand _flutterGenl10n;
  final GeneratorBuilder _generator;

  @override
  String get name => 'language';

  @override
  String get description =>
      'Adds a language to the ${_platform.prettyName} part of an existing Rapid project.';

  @override
  List<String> get aliases => ['lang'];

  @override
  String get invocation => 'rapid ${_platform.name} add language <language>';

  @override
  Future<int> run() => runWhenCwdHasMelos(_project, _logger, () async {
        final platformIsActivated = _project.isActivated(_platform);

        if (platformIsActivated) {
          final language = _language;
          final platformDirectory = _project.platformDirectory(_platform);
          final features =
              platformDirectory.getFeatures(exclude: {'app', 'routing'});

          for (final feature in features) {
            if (!feature.supportsLanguage(language)) {
              final generator = await _generator(languageBundle);
              await generator.generate(
                DirectoryGeneratorTarget(Directory(feature.path)),
                vars: <String, dynamic>{
                  'feature_name': feature.name,
                  'language': language,
                },
                logger: _logger,
              );

              await _flutterGenl10n(cwd: feature.path);
            }
          }

          // TODO add hint how to work with localization
          return ExitCode.success.code;
        } else {
          _logger.err('${_platform.prettyName} is not activated.');

          return ExitCode.config.code;
        }
      });

  String get _language => _validateLanguageArg(argResults.rest);

  /// Validates whether [language] is valid language.
  ///
  /// Returns [language] when valid.
  String _validateLanguageArg(List<String> args) {
    if (args.isEmpty) {
      throw UsageException(
        'No option specified for the language.',
        usage,
      );
    }

    if (args.length > 1) {
      throw UsageException('Multiple languages specified.', usage);
    }

    final language = args.first;
    final isValid = validateLanguage(language);
    if (!isValid) {
      throw UsageException(
        '"$language" is not a valid language.\n\n'
        'See https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry for more information.',
        usage,
      );
    }

    return language;
  }
}
