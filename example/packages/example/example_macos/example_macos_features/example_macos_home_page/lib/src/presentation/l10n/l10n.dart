// coverage:ignore-file
import 'package:flutter/widgets.dart';

import 'example_macos_home_page_localizations.dart';

export 'example_macos_home_page_localizations.dart';

extension ExampleMacosHomePageLocalizationsX on BuildContext {
  /// The l10n object which holds all localized strings.
  ExampleMacosHomePageLocalizations get l10n =>
      ExampleMacosHomePageLocalizations.of(this);
}
