import 'dart:async';

import 'package:rapid_cli/src/project/platform.dart';

import '../util/language_option.dart';
import '../util/org_name_option.dart';
import 'platform.dart';

/// {@template activate_windows_command}
/// `rapid activate windows` command adds support for Windows to an existing Rapid project.
/// {@endtemplate}
class ActivateWindowsCommand extends ActivatePlatformCommand
    with OrgNameGetter, LanguageGetter {
  /// {@macro activate_windows_command}
  ActivateWindowsCommand(super.project)
      : super(
          platform: Platform.windows,
        ) {
    argParser
      ..addOrgNameOption(
        help: 'The organization for the native Windows project.',
      )
      ..addLanguageOption(
        help: 'The default language for Windows',
      );
  }

  @override
  Future<void> run() {
    final orgName = super.orgName;
    final language = super.language;

    return rapid.activateWindows(
      orgName: orgName,
      language: language,
    );
  }
}
