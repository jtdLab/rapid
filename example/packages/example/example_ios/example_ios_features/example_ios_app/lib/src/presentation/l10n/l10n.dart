// coverage:ignore-file
import 'package:flutter/widgets.dart';

import 'example_ios_app_localizations.dart';

export 'example_ios_app_localizations.dart';

extension ExampleIosAppLocalizationsX on BuildContext {
  /// The l10n object which holds all localized strings.
  ExampleIosAppLocalizations get l10n => ExampleIosAppLocalizations.of(this);
}
