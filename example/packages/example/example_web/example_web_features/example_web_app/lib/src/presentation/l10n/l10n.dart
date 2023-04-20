// coverage:ignore-file
import 'package:flutter/widgets.dart';

import 'example_web_app_localizations.dart';

export 'example_web_app_localizations.dart';

extension ExampleWebAppLocalizationsX on BuildContext {
  /// The l10n object which holds all localized strings.
  ExampleWebAppLocalizations get l10n => ExampleWebAppLocalizations.of(this);
}
