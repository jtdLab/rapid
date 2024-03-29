import 'dart:async';

import '../../project/platform.dart';
import '../util/description_option.dart';
import '../util/language_option.dart';
import '../util/org_name_option.dart';
import 'platform.dart';

const _defaultDescription = 'A Rapid app.';

/// {@template activate_android_command}
/// `rapid activate android` adds support for Android to a Rapid project.
/// {@endtemplate}
class ActivateAndroidCommand extends ActivatePlatformCommand
    with DescriptionGetter, OrgNameGetter, LanguageGetter {
  /// {@macro activate_android_command}
  ActivateAndroidCommand(super.project)
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
