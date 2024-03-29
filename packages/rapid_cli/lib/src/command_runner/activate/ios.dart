import 'dart:async';

import '../../project/platform.dart';
import '../util/language_option.dart';
import '../util/org_name_option.dart';
import 'platform.dart';

/// {@template activate_ios_command}
/// `rapid activate ios` adds support for iOS to a Rapid project.
/// {@endtemplate}
class ActivateIosCommand extends ActivatePlatformCommand
    with OrgNameGetter, LanguageGetter {
  /// {@macro activate_ios_command}
  ActivateIosCommand(super.project)
      : super(
          platform: Platform.ios,
        ) {
    argParser
      ..addOrgNameOption(
        help: 'The organization for the native iOS project.',
      )
      ..addLanguageOption(
        help: 'The default language for iOS',
      );
  }

  @override
  Future<void> run() {
    final orgName = super.orgName;
    final language = super.language;

    return rapid.activateIos(
      orgName: orgName,
      language: language,
    );
  }
}
