import 'dart:async';

import 'package:rapid_cli/src/command_runner/util/description_option.dart';
import 'package:rapid_cli/src/project/platform.dart';

import '../util/language_option.dart';
import '../util/org_name_option.dart';
import 'platform.dart';

/// The default description.
const _defaultDescription = 'A Rapid app.';

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
        defaultsTo: _defaultDescription,
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
      description: description ?? _defaultDescription,
      orgName: orgName,
      language: language,
    );
  }
}
