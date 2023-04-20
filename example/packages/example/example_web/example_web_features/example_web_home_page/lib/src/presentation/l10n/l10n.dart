// coverage:ignore-file
import 'package:flutter/widgets.dart';

import 'example_web_home_page_localizations.dart';

export 'example_web_home_page_localizations.dart';

extension ExampleWebHomePageLocalizationsX on BuildContext {
  /// The l10n object which holds all localized strings.
  ExampleWebHomePageLocalizations get l10n =>
      ExampleWebHomePageLocalizations.of(this);
}
