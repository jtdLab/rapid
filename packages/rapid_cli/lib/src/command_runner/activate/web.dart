import 'dart:async';

import '../../project/platform.dart';
import '../util/description_option.dart';
import '../util/language_option.dart';
import '../util/org_name_option.dart';
import 'platform.dart';

const _defaultDescription = 'A Rapid app.';

/// {@template activate_web_command}
/// `rapid activate web` adds support for Web to a Rapid project.
/// {@endtemplate}
class ActivateWebCommand extends ActivatePlatformCommand
    with DescriptionGetter, OrgNameGetter, LanguageGetter {
  /// {@macro activate_web_command}
  ActivateWebCommand(super.project)
      : super(
          platform: Platform.web,
        ) {
    argParser
      ..addDescriptionOption(
        help: 'The description for the native Web project.',
        defaultsTo: _defaultDescription,
      )
      ..addLanguageOption(
        help: 'The default language for Web',
      );
  }

  @override
  Future<void> run() {
    final description = super.desc;
    final language = super.language;

    return rapid.activateWeb(
      description: description ?? _defaultDescription,
      language: language,
    );
  }
}
