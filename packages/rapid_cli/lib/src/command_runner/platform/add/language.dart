import 'package:rapid_cli/src/command_runner/util/platform_x.dart';
import 'package:rapid_cli/src/project/platform.dart';

import '../../base.dart';
import '../../util/language_rest.dart';

class PlatformAddLanguageCommand extends RapidLeafCommand with LanguageGetter {
  PlatformAddLanguageCommand(this.platform, super.project);

  final Platform platform;

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
  Future<void> run() {
    final language = super.language;

    return rapid.platformAddLanguage(
      platform,
      language: language,
    );
  }
}
