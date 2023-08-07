import '../../../utils.dart';
import '../../base.dart';
import '../../util/language_rest.dart';

/// {@template platform_remove_language_command}
/// `rapid <platform> remove language` remove a language from the platform part of a Rapid project.
/// {@endtemplate}
class PlatformRemoveLanguageCommand extends RapidPlatformLeafCommand
    with LanguageGetter {
  /// {@macro platform_remove_language_command}
  PlatformRemoveLanguageCommand(super.project, {required super.platform});

  @override
  String get name => 'language';

  @override
  List<String> get aliases => ['lang'];

  @override
  String get invocation => 'rapid ${platform.name} remove language <language>';

  @override
  String get description =>
      'Remove a language from the ${platform.prettyName} part of a Rapid project.';

  @override
  Future<void> run() {
    final language = super.language;

    return rapid.platformRemoveLanguage(
      platform,
      language: language,
    );
  }
}
