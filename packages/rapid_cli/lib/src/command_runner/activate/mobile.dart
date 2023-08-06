import 'dart:async';

import '../../project/platform.dart';
import '../util/description_option.dart';
import '../util/language_option.dart';
import '../util/org_name_option.dart';
import 'platform.dart';

const _defaultDescription = 'A Rapid app.';

/// {@template activate_mobile_command}
/// `rapid activate mobile` command adds support for Mobile to an existing Rapid project.
/// {@endtemplate}
class ActivateMobileCommand extends ActivatePlatformCommand
    with DescriptionGetter, OrgNameGetter, LanguageGetter {
  /// {@macro activate_mobile_command}
  ActivateMobileCommand(
    super.project,
  ) : super(
          platform: Platform.mobile,
        ) {
    argParser
      ..addDescriptionOption(
        help: 'The description for the native Android project.',
        defaultsTo: _defaultDescription,
      )
      ..addOrgNameOption(
        help: 'The organization for the native Mobile projects.',
      )
      ..addLanguageOption(
        help: 'The default language for Mobile',
      );
  }

  @override
  Future<void> run() {
    final description = super.desc;
    final orgName = super.orgName;
    final language = super.language;

    return rapid.activateMobile(
      description: description ?? _defaultDescription,
      orgName: orgName,
      language: language,
    );
  }
}
