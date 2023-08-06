import '../../../project/platform.dart';
import '../../base.dart';
import '../../util/language_rest.dart';
import '../../util/platform_x.dart';

class PlatformSetDefaultLanguageCommand extends RapidLeafCommand
    with LanguageGetter {
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
      'Set the default language of the ${platform.prettyName} part of an existing Rapid project.';

  @override
  Future<void> run() {
    final language = super.language;

    return rapid.platformSetDefaultLanguage(
      platform,
      language: language,
    );
  }
}
