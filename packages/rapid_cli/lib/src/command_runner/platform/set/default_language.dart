import '../../../project/platform.dart';
import '../../../utils.dart';
import '../../base.dart';
import '../../util/language_rest.dart';

/// {@template platform_set_default_language_command}
/// `rapid <platform> set default_language` set the default language of the platform part of a Rapid project.
/// {@endtemplate}
class PlatformSetDefaultLanguageCommand extends RapidLeafCommand
    with LanguageGetter {
  /// {@macro platform_set_default_language_command}
  PlatformSetDefaultLanguageCommand(
    this.platform,
    super.project,
  );

  final Platform platform;

  @override
  String get name => 'default_language';

  @override
  List<String> get aliases => ['default_lang'];

  @override
  String get invocation =>
      'rapid ${platform.name} set default_language <language>';

  @override
  String get description =>
      'Set the default language of the ${platform.prettyName} part of a Rapid project.';

  @override
  Future<void> run() {
    final language = super.language;

    return rapid.platformSetDefaultLanguage(
      platform,
      language: language,
    );
  }
}
