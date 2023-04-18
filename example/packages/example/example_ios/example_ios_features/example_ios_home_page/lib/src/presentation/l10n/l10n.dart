// coverage:ignore-file
import 'package:flutter/widgets.dart';

import 'example_ios_home_page_localizations.dart';

export 'example_ios_home_page_localizations.dart';

extension ExampleIosHomePageLocalizationsX on BuildContext {
  /// The l10n object which holds all localized strings.
  ExampleIosHomePageLocalizations get l10n =>
      ExampleIosHomePageLocalizations.of(this);
}
