import 'dart:async';

import 'package:rapid_cli/src/project/platform.dart';

import '../util/language_option.dart';
import '../util/org_name_option.dart';
import 'platform.dart';

/// {@template activate_macos_command}
/// `rapid activate macos` command adds support for macOS to an existing Rapid project.
/// {@endtemplate}
class ActivateMacosCommand extends ActivatePlatformCommand
    with OrgNameGetter, LanguageGetter {
  /// {@macro activate_macos_command}
  ActivateMacosCommand(super.project)
      : super(
          platform: Platform.macos,
        ) {
    argParser
      ..addOrgNameOption(
        help: 'The organization for the native macOS project.',
      )
      ..addLanguageOption(
        help: 'The default language for macOS',
      );
  }

  @override
  Future<void> run() {
    final orgName = super.orgName;
    final language = super.language;

    return rapid.activateMacos(
      orgName: orgName,
      language: language,
    );
  }
}
