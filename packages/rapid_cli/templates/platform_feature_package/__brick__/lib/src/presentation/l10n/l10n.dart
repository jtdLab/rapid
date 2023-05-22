{{#android}}// coverage:ignore-file
import 'package:flutter/widgets.dart';

import '{{project_name}}_android_{{name}}_localizations.dart';

export '{{project_name}}_android_{{name}}_localizations.dart';

extension {{project_name.pascalCase()}}Android{{name.pascalCase()}}LocalizationsX on BuildContext {
  /// The l10n object which holds all localized strings.
  {{project_name.pascalCase()}}Android{{name.pascalCase()}}Localizations get l10n =>
      {{project_name.pascalCase()}}Android{{name.pascalCase()}}Localizations.of(this);
}
{{/android}}{{#ios}}// coverage:ignore-file
import 'package:flutter/widgets.dart';

import '{{project_name}}_ios_{{name}}_localizations.dart';

export '{{project_name}}_ios_{{name}}_localizations.dart';

extension {{project_name.pascalCase()}}Ios{{name.pascalCase()}}LocalizationsX on BuildContext {
  /// The l10n object which holds all localized strings.
  {{project_name.pascalCase()}}Ios{{name.pascalCase()}}Localizations get l10n =>
      {{project_name.pascalCase()}}Ios{{name.pascalCase()}}Localizations.of(this);
}
{{/ios}}{{#linux}}// coverage:ignore-file
import 'package:flutter/widgets.dart';

import '{{project_name}}_linux_{{name}}_localizations.dart';

export '{{project_name}}_linux_{{name}}_localizations.dart';

extension {{project_name.pascalCase()}}Linux{{name.pascalCase()}}LocalizationsX on BuildContext {
  /// The l10n object which holds all localized strings.
  {{project_name.pascalCase()}}Linux{{name.pascalCase()}}Localizations get l10n =>
      {{project_name.pascalCase()}}Linux{{name.pascalCase()}}Localizations.of(this);
}
{{/linux}}{{#macos}}// coverage:ignore-file
import 'package:flutter/widgets.dart';

import '{{project_name}}_macos_{{name}}_localizations.dart';

export '{{project_name}}_macos_{{name}}_localizations.dart';

extension {{project_name.pascalCase()}}Macos{{name.pascalCase()}}LocalizationsX on BuildContext {
  /// The l10n object which holds all localized strings.
  {{project_name.pascalCase()}}Macos{{name.pascalCase()}}Localizations get l10n =>
      {{project_name.pascalCase()}}Macos{{name.pascalCase()}}Localizations.of(this);
}
{{/macos}}{{#web}}// coverage:ignore-file
import 'package:flutter/widgets.dart';

import '{{project_name}}_web_{{name}}_localizations.dart';

export '{{project_name}}_web_{{name}}_localizations.dart';

extension {{project_name.pascalCase()}}Web{{name.pascalCase()}}LocalizationsX on BuildContext {
  /// The l10n object which holds all localized strings.
  {{project_name.pascalCase()}}Web{{name.pascalCase()}}Localizations get l10n =>
      {{project_name.pascalCase()}}Web{{name.pascalCase()}}Localizations.of(this);
}
{{/web}}{{#windows}}// coverage:ignore-file
import 'package:flutter/widgets.dart';

import '{{project_name}}_windows_{{name}}_localizations.dart';

export '{{project_name}}_windows_{{name}}_localizations.dart';

extension {{project_name.pascalCase()}}Windows{{name.pascalCase()}}LocalizationsX on BuildContext {
  /// The l10n object which holds all localized strings.
  {{project_name.pascalCase()}}Windows{{name.pascalCase()}}Localizations get l10n =>
      {{project_name.pascalCase()}}Windows{{name.pascalCase()}}Localizations.of(this);
}
{{/windows}}{{#mobile}}// coverage:ignore-file
import 'package:flutter/widgets.dart';

import '{{project_name}}_mobile_{{name}}_localizations.dart';

export '{{project_name}}_mobile_{{name}}_localizations.dart';

extension {{project_name.pascalCase()}}Mobile{{name.pascalCase()}}LocalizationsX on BuildContext {
  /// The l10n object which holds all localized strings.
  {{project_name.pascalCase()}}Mobile{{name.pascalCase()}}Localizations get l10n =>
      {{project_name.pascalCase()}}Mobile{{name.pascalCase()}}Localizations.of(this);
}
{{/mobile}}