import 'dart:async';

import 'package:rapid_cli/src/command_runner/util/description_option.dart';
import 'package:rapid_cli/src/core/platform.dart';

import '../util/language_option.dart';
import '../util/org_name_option.dart';
import 'platform.dart';

/// {@template activate_web_command}
/// `rapid activate web` command adds support for Web to an existing Rapid project.
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
      description: description,
      language: language,
    );
  }
}
