import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/generator_builder.dart';
import 'package:rapid_cli/src/commands/core/platform/add/language/language.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template android_add_language_command}
/// `rapid android add language` command adds a language to the Android part of an existing Rapid project.
/// {@endtemplate}
class LanguageCommand extends PlatformAddLanguageCommand {
  /// {@macro android_add_language_command}
  LanguageCommand({
    Logger? logger,
    required super.project,
    FlutterGenl10nCommand? flutterGenl10n,
    GeneratorBuilder? generator,
  }) : super(
          platform: Platform.android,
          logger: logger ?? Logger(),
          flutterGenl10n: flutterGenl10n ?? Flutter.genl10n,
          generator: generator ?? MasonGenerator.fromBundle,
        );
}
