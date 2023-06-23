import 'dart:async';

import 'package:rapid_cli/src/command_runner/util/description_option.dart';
import 'package:rapid_cli/src/core/platform.dart';

import '../util/language_option.dart';
import '../util/org_name_option.dart';
import 'platform.dart';

/// {@template activate_android_command}
/// `rapid activate android` command adds support for Android to an existing Rapid project.
/// {@endtemplate}
class ActivateAndroidCommand extends ActivatePlatformCommand
    with DescriptionGetter, OrgNameGetter, LanguageGetter {
  /// {@macro activate_android_command}
  ActivateAndroidCommand(super.project) // TODO not nullable
      : super(
          platform: Platform.android,
        ) {
    argParser
      ..addDescriptionOption(
        help: 'The description for the native Android project.',
      )
      ..addOrgNameOption(
        help: 'The organization for the native Android project.',
      )
      ..addLanguageOption(
        help: 'The default language for Android',
      );
  }

  @override
  Future<void> run() {
    final description = super.desc;
    final orgName = super.orgName;
    final language = super.language;

    return rapid.activateAndroid(
      description: description,
      orgName: orgName,
      language: language,
    );
  }
}
