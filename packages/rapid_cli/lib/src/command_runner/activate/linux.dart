import 'dart:async';

import '../../project/platform.dart';
import '../util/language_option.dart';
import '../util/org_name_option.dart';
import 'platform.dart';

/// {@template activate_linux_command}
/// `rapid activate linux` adds support for Linux to a Rapid project.
/// {@endtemplate}
class ActivateLinuxCommand extends ActivatePlatformCommand
    with OrgNameGetter, LanguageGetter {
  /// {@macro activate_linux_command}
  ActivateLinuxCommand(super.project)
      : super(
          platform: Platform.linux,
        ) {
    argParser
      ..addOrgNameOption(
        help: 'The organization for the native Linux project.',
      )
      ..addLanguageOption(
        help: 'The default language for Linux',
      );
  }

  @override
  Future<void> run() {
    final orgName = super.orgName;
    final language = super.language;

    return rapid.activateLinux(
      orgName: orgName,
      language: language,
    );
  }
}
