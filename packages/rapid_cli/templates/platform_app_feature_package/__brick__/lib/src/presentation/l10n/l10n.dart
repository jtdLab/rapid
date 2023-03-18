{{#android}}// coverage:ignore-file
import 'package:flutter/widgets.dart';

import '{{project_name}}_android_app_localizations.dart';

export '{{project_name}}_android_app_localizations.dart';

extension {{project_name.pascalCase()}}AndroidAppLocalizationsX on BuildContext {
  /// The l10n object which holds all localized strings.
  {{project_name.pascalCase()}}AndroidAppLocalizations get l10n =>
      {{project_name.pascalCase()}}AndroidAppLocalizations.of(this);
}
{{/android}}{{#ios}}// coverage:ignore-file
import 'package:flutter/widgets.dart';

import '{{project_name}}_ios_app_localizations.dart';

export '{{project_name}}_ios_app_localizations.dart';

extension {{project_name.pascalCase()}}IosAppLocalizationsX on BuildContext {
  /// The l10n object which holds all localized strings.
  {{project_name.pascalCase()}}IosAppLocalizations get l10n =>
      {{project_name.pascalCase()}}IosAppLocalizations.of(this);
}
{{/ios}}{{#linux}}// coverage:ignore-file
import 'package:flutter/widgets.dart';

import '{{project_name}}_linux_app_localizations.dart';

export '{{project_name}}_linux_app_localizations.dart';

extension {{project_name.pascalCase()}}LinuxAppLocalizationsX on BuildContext {
  /// The l10n object which holds all localized strings.
  {{project_name.pascalCase()}}LinuxAppLocalizations get l10n =>
      {{project_name.pascalCase()}}LinuxAppLocalizations.of(this);
}
{{/linux}}{{#macos}}// coverage:ignore-file
import 'package:flutter/widgets.dart';

import '{{project_name}}_macos_app_localizations.dart';

export '{{project_name}}_macos_app_localizations.dart';

extension {{project_name.pascalCase()}}MacosAppLocalizationsX on BuildContext {
  /// The l10n object which holds all localized strings.
  {{project_name.pascalCase()}}MacosAppLocalizations get l10n =>
      {{project_name.pascalCase()}}MacosAppLocalizations.of(this);
}
{{/macos}}{{#web}}// coverage:ignore-file
import 'package:flutter/widgets.dart';

import '{{project_name}}_web_app_localizations.dart';

export '{{project_name}}_web_app_localizations.dart';

extension {{project_name.pascalCase()}}WebAppLocalizationsX on BuildContext {
  /// The l10n object which holds all localized strings.
  {{project_name.pascalCase()}}WebAppLocalizations get l10n =>
      {{project_name.pascalCase()}}WebAppLocalizations.of(this);
}
{{/web}}{{#windows}}// coverage:ignore-file
import 'package:flutter/widgets.dart';

import '{{project_name}}_windows_app_localizations.dart';

export '{{project_name}}_windows_app_localizations.dart';

extension {{project_name.pascalCase()}}WindowsAppLocalizationsX on BuildContext {
  /// The l10n object which holds all localized strings.
  {{project_name.pascalCase()}}WindowsAppLocalizations get l10n =>
      {{project_name.pascalCase()}}WindowsAppLocalizations.of(this);
}
{{/windows}}